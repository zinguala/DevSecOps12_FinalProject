sudo apt-get update
sudo apt install snap -y
sudo apt install curl -y
sudo apt-get install python3.6
sudo apt install openssh-server -y
sudo apt install docker.io -y
sudo apt install git -y
sudo apt install openjdk-17-jre -y
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
sudo apt install git -y
sudo apt install pipx -y
pipx install --include-deps ansible
sudo apt install openssh-client
sudo ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa <<<y >/dev/null 2>&1
vm_ip=$(hostname -I | grep -Eo '^[^ ]+')
echo "enter the user name from the web machine and press enter:/n"
read web_user
echo "enter the IP from the web machine and press enter:/n"
read web_IP
sudo ssh-copy-id -i /root/.ssh/id_rsa $web_user@$web_IP
sudo mkdir -p /etc/ansible/inventory
sudo touch /etc/ansible/inventory/inventory
sudo chmod 777 /etc/ansible/inventory/inventory
sudo echo -e "[web]\nhostname ansible_host=$vm-ip ansible_user=$USER\n\n[vars:all]\nansible_ssh_private_key_file=/root/.ssh/id_rsa" | cat >> /etc/ansible/inventory/inventory
sudo chmod 644 /etc/ansible/inventory/inventory
