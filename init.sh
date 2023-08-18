#!/bin/sh
sudo apt update
sudo apt upgrade -y
sudo apt-get install python3.6
sudo apt install 
sudo apt install openssh-server -y
sudo apt install docker.io -y
sudo usermod -aG docker $USER && newgrp docker
sudo apt install snap -y
sudo snap install curl
echo -e "select cpu Architecture:\n"
select cpu in x86-64 arm64 armv7 ppc64 s390x; do
	case $cpu in
		x86-64)
			echo "x86-64"
			curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
			sudo install minikube-linux-amd64 /usr/local/bin/minikube
			break
			;;
		arm64)
			echo "ARM64"
			curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
			sudo install minikube-linux-arm64 /usr/local/bin/minikube
			break
			;;
		armv7)
			echo "ARMv7"
			curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm
			sudo install minikube-linux-arm /usr/local/bin/minikube
			break
			;;
		ppc64)
			echo "ppc64"
			curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-ppc64le
			sudo install minikube-linux-ppc64le /usr/local/bin/minikube
			/home/hai/Desktop/test/init.shbreak
			;;
		s390x)
			echo "S390x"
			curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-s390x
			sudo install minikube-linux-s390x /usr/local/bin/minikube
			break
			;;
		*)
			echo "invalid input, select cpu architecture:"
			;;
		esac
	done
sudo snap install kubectl --classic
minkube start
sudo apt install nginxs
sudo systemctl enable nginx.service
origin="After=network.target nss-lookup.target"
new="After=network-online.target nss-lookup.target"
file="/lib/systemd/system/nginx.service"
sudo chmod 777 $file
sudo sed -i "s/$origin/$new/" $file
sudo chmod 644 $file
kube_ip=$(minikube ip)
vm_ip=$(hostname -I | grep -Eo '^[^ ]+')
sudo chmod 777 /etc/nginx/nginx.conf
sudo echo -e "\nstream {\n\tserver {\n\t\tlisten $vm_ip:5005;\n\t\t#TCP traffic will be forwarded to the specific server\n\t\tproxy_pass $kube_ip:30002;\n\t}\n}" >> /etc/nginx/nginx.conf
sudo chmod 644 /etc/nginx/nginx.conf
sudo systemctl restart nginx
sudo ufw allow 5005
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
