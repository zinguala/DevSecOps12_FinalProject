# DevSecOps12_FinalProject
Welcome to our Final project at DevSecops course:
IN THIS PROJECT WE WILL BUILD A PYTHON FLASK APP WITH A PING-PONG FUNCTION A PING PONG FUNCTION IS A GET FUNCTION THAT RECEIVES THE GET REQUEST AS A SERVER
THE BODY OF THIS REQUEST IS A JSON WITH A CONTENT PING THE FLAK APP SHROUD RETURNS A 200 RESPONSE WITH A PONG JSON BUILD AN IMAGE THAT RUNS THE APPLICATION IN PORT 5005
WE WILL BUILD A CLUSTER IN MINIKUBE TO RUN 4 INSTANCES OF THIS CONTAINER
 THE INSTANCE WILL BE A DEPLOYMENT WITH A 4 REPLICAS
USING ANSIBILE WE WILL BUILD A CRON JOB IN JENKINS TO ADD 2 REPLICAS AT 8:‎00 AND DELETE 2 REPLICAS AT 13:00

# here are the instructions to get it all working:

# create ubuntu Web machine that will run the minikube cluster:

1) first we will add the user for ansible ssh connection:

- “sudo adduser username”
  
- sudo visudo : add the user under  # User privilege specification – “username ALL=(ALL:ALL) ALL”
  
- add username to sudoers group: “sudo usermod -aG sudo username”

- check group of username : 'groups username' 


2) installation of the minikube cluster:

- sign in to the ansible user
   
- install open-ssh-server: “sudo apt install openssh-server”

- install docker: “sudo apt install docker.io”

- to run docker without sudo: “sudo usermod -aG docker $USER && newgrp docker”

- install minikube: https://minikube.sigs.k8s.io/docs/start/

- install kubectl: “sudo snap install kubectl --classic”

- start the minikube: “minkube start”


3) Next install nginx for port forward from our web-machine-ip:5005 to our deployment’s loadbalancer nodeport:
   
- sudo apt update

- sudo apt install nginx

- First check the minikube ip: “minikube ip”

- Config nginx.conf file, make it transform traffic without dealing the SSL and certs:
- “sudo nano /etc/nginx/nginx.conf”
- Add the following config and save the file  
--------------------------------------------------  

stream {  
  server {  
      listen 192.168.1.10(vm-ip):5005;  
      #TCP traffic will be forwarded to the specified server  
      proxy_pass 192.168.39.50(minikube-ip):30002;         
  }  
}  

----------------------------------------------------  

- Check Nginx config: “sudo nginx -t”
  
- Restart the Nginx: “sudo systemctl restart nginx”
  
- Open the port on the firewall: “sudo ufw allow 5005”
  
- Check ufw status: “sudo ufw status”


# Create ubuntu Jenkins + ansible machine:

4) install and config ansible and jenkins:
   
- Install Jenkins:   https://www.jenkins.io/doc/book/installing/linux/

- Install GIT: "sudo apt install git" 

- install ansible: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

- install open ssh client: “sudo apt install openssh-client”

- create private key for secured ssh connection: “sudo ssh-keygen”

- copy to privet key for web machine host connection- use the username and password created for ansible at the web machine:
   “ssh-copy-id -i /root/.ssh/id_rsa username@webmachine-ip-address”

- create inventory file called "inventory" in /etc/ansible/inventory directory : “sudo mkdir -p /etc/ansible/inventory”
  
- "nano /etc/ansible/inventory/inventory":
--------------------------------------------------
[web]  
hostname ansible_host=vm-ip ansible_user=username

[vars:all]    
ansible_ssh_private_key_file=/root/.ssh/id_rsa

--------------------------------------------------

5) add Jenkins permission so we can run sudo without password:
   
- sudo su
  
- visudo
  
- then add this line to the file:

jenkins ALL=(ALL) NOPASSWD: ALL

6) create the pipelines with cron jobs:

# Creating the first job of running the cluster with 4 replicas at 13:00 every day:

- from the jenkins dashboard choose a new item 

- enter the item name, choose pipeline, and hit "ok".

- optionally can add a description

- in the build triggers section choose buil periodically as shown below add the time period:  0 13 * * *
  
![image](https://github.com/zinguala/DevSecOps12_FinalProject/assets/34973070/e1f6b8e5-a61a-4551-8bc2-053d9684cdc8)

- now move the pipeline section and in the definition choose pipeline script from SCM

- SCM: Git

- Repository URL: "https://github.com/zinguala/DevSecOps12_FinalProject.git"

- Branches to build: Branch Specifier (blank for 'any'): "jenkins"

- Script Path:"Jenkinsfile_4_replicas"
![image](https://github.com/zinguala/DevSecOps12_FinalProject/assets/34973070/6f7339f7-1ec6-4c5e-9145-eb6772797d89)

- at the end hit save

# Creating the second job of running the cluster with 6 replicas at 8:00 every day:

- from the jenkins dashboard choose a new item 

- enter the item name, choose pipeline, and hit "ok".

- optionally can add a description

- in the build triggers section choose buil periodically as shown below add the time period:  0 8 * * *

![image](https://github.com/zinguala/DevSecOps12_FinalProject/assets/34973070/1230c1fb-623e-4b16-8b5b-64991461616e)

- now move the pipeline section and in the definition choose pipeline script from SCM

- SCM: Git

- Repository URL: "https://github.com/zinguala/DevSecOps12_FinalProject.git"

- Branches to build: Branch Specifier (blank for 'any'): "jenkins"

- Script Path:"Jenkinsfile_6_replicas"
  
![image](https://github.com/zinguala/DevSecOps12_FinalProject/assets/34973070/be2eb371-cb88-4967-83c7-6c032f28e7a5)

# installtion finished!!! now its time to test the cluster:

- create vm and install postman: 



   







