sudo apt install snap -y
sudo snap install curl
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
sudo ssh-keygen
sudo ssh-copy-id -i /root/.ssh