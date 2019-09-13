# Package Repositories
sudo apt-add-repository ppa:deadsnakes/ppa -y
sudo apt-add-repository ppa:ansible/ansible

sudo apt-get update
sudo apt-get install -y ansible \
                        python3.7 \
                        python-pip

# Currently, cqlsh only supports python 2
# Since Python by default uses v2, regardless of installed version,
# be careful when changing version for Python to use
pip install cqlsh -v
