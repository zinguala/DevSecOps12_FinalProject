# DevSecOps12_FinalProject
Welcome to our Final project in DevSecops course:  
IN THIS PROJECT WE WILL BUILD A PYTHON FLASK APP WITH A PING-PONG FUNCTION A PING PONG FUNCTION IS A GET FUNCTION THAT RECEIVES THE GET REQUEST AS A SERVER  
THE BODY OF THIS REQUEST IS A JSON WITH A CONTENT PING THE FLASK APP SHROUD RETURNS A 200 RESPONSE WITH A PONG JSON   
WE WILL BUILD AN IMAGE THAT RUNS THE APPLICATION IN PORT 5005  
WE WILL BUILD A CLUSTER IN MINIKUBE TO RUN 4 INSTANCES OF THIS CONTAINER  
THE INSTANCE WILL BE A DEPLOYMENT WITH A 4 REPLICAS  
USING ANSIBLE WE WILL BUILD A CRON JOB IN JENKINS TO ADD 2 REPLICAS AT 8:‎00 AND DELETE 2 REPLICAS AT 13:00  

# Here are the instructions to get it all working:  

# Create Ubuntu Web machine that will run the minikube cluster:

# 1) At first we will add the user for the Ansible ssh connection:

- “sudo adduser username”
  
- sudo visudo : add the user with those privileges:  
 “username ALL=(ALL:ALL) ALL”
  
- add the username to sudoers group: “sudo usermod -aG sudo username”

- check group of username: 'groups username' 



# 2) installation of the minikube cluster:

- Sign in to the Ansible user
   
- Install open-ssh-server: “sudo apt install openssh-server”

- Install docker: “sudo apt install docker.io”

- To run docker without sudo: “sudo usermod -aG docker $USER && newgrp docker”

- Install minikube: https://minikube.sigs.k8s.io/docs/start/

- Install kubectl: “sudo snap install kubectl --classic”

- Start the minikube: “minkube start”



# 3) Next install nginx for port forward from our web-machine-ip:5005 to our deployment’s load-balancer's nodeport:
   
- sudo apt update

- sudo apt install nginx

- Enable nginx so it will run after reboot: "sudo systemctl enable nginx.service"

- We need to change the serivce config for nginx for only start after the network  
adapter is online or otherwise the service will fail: "sudo nano /lib/systemd/system/nginx.service"

- We will need to change one line at the Unit's section:
  
from: "After=network.target nss-lookup.target"
-------------------------------------------------------------------------

[Unit]    
Description=A high performance web server and a reverse proxy server    
Documentation=man:nginx(8)    
After=network.target nss-lookup.target    

-------------------------------------------------------------------------

to: "After=network-online.target nss-lookup.target"
-------------------------------------------------------------------------

[Unit]    
Description=A high performance web server and a reverse proxy server  
Documentation=man:nginx(8)  
After=network-online.target nss-lookup.target  

-------------------------------------------------------------------------



- Now check the minikube ip: “minikube ip”

- Config nginx.conf file, make it transform traffic without dealing the SSL and certs:
- “sudo nano /etc/nginx/nginx.conf”
- Add the following config and save the file  
-------------------------------------------------------------------------  

stream {  
  server {  
      listen 192.168.1.10(vm-ip):5005;  
      #TCP traffic will be forwarded to the specified server  
      proxy_pass 192.168.49.2(minikube-ip):30002;         
  }  
}  

---------------------------------------------------------------------------  

- Check Nginx config: “sudo nginx -t”
  
- Restart the Nginx: “sudo systemctl restart nginx”
  
- Open the port on the firewall: “sudo ufw allow 5005”
  
- Check ufw status: “sudo ufw status”



# Create ubuntu Jenkins + ansible machine:

# 4) Install and config Ansible and jenkins:
   
- Install Jenkins:   https://www.jenkins.io/doc/book/installing/linux/

- Install GIT: "sudo apt install git" 

- Install ansible: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

- Install open ssh client: “sudo apt install openssh-client”

- Create a private key for a secured ssh connection: “sudo ssh-keygen”

- Copy the privet key for web machine host connection- use the username and password the used to created for Ansible at the web machine:
   “ssh-copy-id -i /root/.ssh/id_rsa username@webmachine-ip-address”

- Create an inventory file called "inventory" in /etc/ansible/inventory directory: “sudo mkdir -p /etc/ansible/inventory”  
the playbook will work only if the inventory will be called "inventory" will be in this path: /etc/ansible/inventory
  
- Creating the inventory: "nano /etc/ansible/inventory/inventory":
  Make sure the minikube host will be under group "web" as shown below (the playbook is configured to run on group "web")
--------------------------------------------------
[web]  
hostname ansible_host=vm-ip ansible_user=username

[vars:all]    
ansible_ssh_private_key_file=/root/.ssh/id_rsa

--------------------------------------------------



# 5) Add Jenkins permission so we can run sudo without a password:
   
- sudo su
  
- visudo
  
- then add this line to the file:

jenkins ALL=(ALL) NOPASSWD: ALL



# 6) Create the pipelines with cron jobs:

# Creating the first job of running the cluster with 4 replicas at 13:00 every day:

- From the jenkins dashboard choose a new item 

- Enter the item name, choose pipeline, and hit "ok".

- Optionally can add a description

- In the build triggers section choose buil periodically as shown below add the time period:  0 13 * * *
  
![image](https://github.com/zinguala/DevSecOps12_FinalProject/assets/34973070/e1f6b8e5-a61a-4551-8bc2-053d9684cdc8)

- Now move the pipeline section and in the definition choose pipeline script from SCM

- SCM: Git

- Repository URL: "https://github.com/zinguala/DevSecOps12_FinalProject.git"

- Branches to build: Branch Specifier (blank for 'any'): "jenkins"

- Script Path:"Jenkinsfile_4_replicas"
![image](https://github.com/zinguala/DevSecOps12_FinalProject/assets/34973070/6f7339f7-1ec6-4c5e-9145-eb6772797d89)

- At the end hit save

# Creating the second job of running the cluster with 6 replicas at 8:00 every day:

- From the jenkins dashboard choose a new item 

- Enter the item name, choose pipeline, and hit "ok".

- Optionally can add a description

- In the build triggers section choose buil periodically as shown below add the time period:  0 8 * * *

![image](https://github.com/zinguala/DevSecOps12_FinalProject/assets/34973070/1230c1fb-623e-4b16-8b5b-64991461616e)

- Now move the pipeline section and in the definition choose pipeline script from SCM

- SCM: Git

- Repository URL: "https://github.com/zinguala/DevSecOps12_FinalProject.git"

- Branches to build: Branch Specifier (blank for 'any'): "jenkins"

- Script Path:"Jenkinsfile_6_replicas"
  
![image](https://github.com/zinguala/DevSecOps12_FinalProject/assets/34973070/be2eb371-cb88-4967-83c7-6c032f28e7a5)

- At the end hit save

- ---------------------------------------------------------------------------------------------------------------------

# installtion finished!!! now its time to test the cluster:

- At first run one of the jenkins jobs: click on build now and wait for the build to finish.

- Create VM that can communicate with the web network and install postman: "sudo snap install postman"

- Open postman: "postman"

- Create get request to web host (runs the minikube cluster) ip:5005  
The body of the request is a raw - JSON: 
{  
"body" : "ping"  
}  

the response should be:
{  
"body" : "pong"  
}  

like this example:  
![image](https://github.com/zinguala/DevSecOps12_FinalProject/assets/34973070/fdaa3083-7be7-43f8-94a7-77f9c6f86dc6)

   







