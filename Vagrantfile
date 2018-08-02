Vagrant.require_version ">= 1.7.0"

plugin_dependencies = [
  "vagrant-vbguest",
  "vagrant-hostmanager"
]

needsRestart = false

# Install plugins if required
plugin_dependencies.each do |plugin_name|
  unless Vagrant.has_plugin? plugin_name
    system("vagrant plugin install #{plugin_name}")
    needsRestart = true
    puts "#{plugin_name} installed"
  end
end

# Restart vagrant if new plugins were installed
if needsRestart === true
  exec "vagrant #{ARGV.join(' ')}"
end

$vm_configs = [
  kube_master_config: {
    num_instances: 1,
    instance_name_prefix: "kube-master",
    enable_serial_logging: false,

    vm_gui: false,
    vm_memory: 4096,
    vm_cpus: 2,
    vb_cpuexecutioncap: 90,

    user_home_path: "/home/vagrant",
    forwarded_ports: [
      {
        guest_port: 8001,
        host_port: 8001
      }
    ],
    shared_folders: [
      {
        host_path: "./",
        guest_path: "/vagrant"
      }
    ]
  },

  # When adding instances here, be sure to
  # add them to inventory/hosts.yml too!
  # (And change memory/cpu configs as requried).
  kube_worker_config: {
    num_instances: 0, # single-node cluster it is!
    instance_name_prefix: "kube-worker",
    enable_serial_logging: false,

    vm_gui: false,
    vm_memory: 1024,
    vm_cpus: 1,
    vb_cpuexecutioncap: 80,

    user_home_path: "/home/vagrant",
    forwarded_ports: [],
    shared_folders: [
      {
        host_path: "./",
        guest_path: "/vagrant"
      }
    ]
  }
]

Vagrant.configure("2") do |config|
  # always use Vagrants insecure key
  config.ssh.insert_key = true
  # forward ssh agent to easily ssh into the different machines
  config.ssh.forward_agent = false

  # Hostmanager
  config.hostmanager.enabled = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false

  config.vm.box = "bento/ubuntu-16.04"
  config.vm.boot_timeout = 500

  # =============== TODO ================
  # Implement a better way of tracking/creating multiple VM instances

  # It is dynamically incremented as the VM configs are iterated
  vm_num_instances_offset = 0

  # We need to know total number of instances so we run ansible
  # only once, at last instance.
  total_instances_count = 0
  $vm_configs.each do | vm_config |
    vm_config.each do |_, vc|
      total_instances_count += vc[:num_instances]
    end
  end

  # ================= VM-specific Configurations =================

  $vm_configs.each do |vm_config|
    vm_config.each do |vm_config_name, vc|
      (1..vc[:num_instances]).each do |i|
        config.vm.define vm_name = "%s-%02d" % [vc[:instance_name_prefix], i] do |config|
          vm_num_instances_offset += 1
          config.vm.hostname = vm_name

          # Serial Logging
          if vc[:enable_serial_logging]
            logdir = File.join(File.dirname(__FILE__), "log")
            FileUtils.mkdir_p(logdir)

            serialFile = File.join(logdir, "%s-%s-serial.txt" % [vm_name, vc[:instance_name_prefix]])
            FileUtils.touch(serialFile)

            config.vm.provider :virtualbox do |vb, override|
              vb.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
              vb.customize ["modifyvm", :id, "--uartmode1", serialFile]
            end
          end

          # VM hardware resources configurations
          config.vm.provider :virtualbox do |vb|
            vb.gui = vc[:vm_gui]
            vb.memory = vc[:vm_memory]
            vb.cpus = vc[:vm_cpus]
            vb.customize [
              "modifyvm", :id,
              "--cpuexecutioncap", "#{vc[:vb_cpuexecutioncap]}"
            ]
          end

          ip = "172.17.8.#{vm_num_instances_offset + 100}"
          config.vm.network :private_network, ip: ip, auto_correct: true

          # Port Forwarding
          vc[:forwarded_ports].each do |port|
            config.vm.network :forwarded_port,
              host: port[:host_port],
              guest: port[:guest_port],
              auto_correct: true
          end

          # Shared folders
          vc[:shared_folders].each_with_index do |share, i|
            config.vm.synced_folder share[:host_path], share[:guest_path],
                mount_options: ["dmode=744"]
          end

          # ===> Shell provisioning
          config.ssh.shell = "bash"
          # Automatically set current-dir to /vagrant on vagrant ssh
          config.vm.provision :shell,
              inline: "echo 'cd /vagrant' >> #{vc[:user_home_path]}/.bashrc"

          config.vm.provision :shell,
            path: "scripts/vagrant/install_packages.sh",
            privileged: true

          # Ansible 2.6+ works only when SSH key is protected.
          # So we manually copy the SSH key and set its permissions.
          config.vm.provision :shell,
            privileged: true, inline: <<-EOF
              mkdir -p "#{vc[:user_home_path]}/.ssh"
              cp "/vagrant/.vagrant/machines/#{vm_name}/virtualbox/private_key" "#{vc[:user_home_path]}/.ssh/id_rsa"
              chmod 0400 "#{vc[:user_home_path]}/.ssh/id_rsa"
            EOF

          # Run Ansible provisioning when its last instance, so its only run once
          if vm_num_instances_offset === total_instances_count
            config.vm.provision :shell,
              inline: "cd /vagrant && ansible-playbook kubernetes.yaml -vvvv",
              privileged: true
          end
        end
      end
    end
  end
end
