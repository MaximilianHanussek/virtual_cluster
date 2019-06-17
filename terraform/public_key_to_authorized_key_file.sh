chmod 600 ~/.ssh/connection_key.pem
ssh-keygen -y -f ~/.ssh/connection_key.pem >> /home/centos/.ssh/authorized_keys
