#!/bin/bash
#Update the system:
echo "=====Installing update====="
sudo yum update -y

#Install java 
echo "=======Installing Java====="
sudo dnf install java-17-amazon-corretto-devel -y

#Install jenkins 
echo "=====Installing Jenkins====="
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/rpm-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2026.key
sudo yum upgrade
sudo yum install java-21-amazon-corretto -y
sudo yum install jenkins -y 
sudo systemctl start jenkins
sudo systemctl enable jenkins

#Install Docker :
echo "=====Installing Docker====="
sudo yum install docker -y
sudo systemctl start docker

#Changing the user to group :
sudo usermod -aG docker jenkins
sudo usermod -aG docker ec2-user
sudo systemctl restart jenkins

#Install git :
echo "=====Installing git====="
sudo yum install git -y

#Install maven :
echo "=====Installing Maven====="
sudo yum install maven -y

echo "=====================All packages are installed successfully======================="

# Install kubectl
echo "=====Installing Kubernets====="
curl -LO https://dl.k8s.io/release/v1.28.0/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Install Minikube (single node Kubernetes — perfect for learning)
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start Minikube
minikube start --driver=docker

# Verify it works
kubectl get nodes

# Create .kube folder for jenkins user
sudo mkdir -p /var/lib/jenkins/.kube

# Copy your kubeconfig to jenkins user
sudo cp ~/.kube/config /var/lib/jenkins/.kube/config

# Give jenkins user ownership
sudo chown -R jenkins:jenkins /var/lib/jenkins/.kube

sudo mkdir -p /var/lib/jenkins/.minikube/profiles/minikube

sudo cp ~/.minikube/ca.crt \
    /var/lib/jenkins/.minikube/ca.crt

sudo cp ~/.minikube/profiles/minikube/client.crt \
    /var/lib/jenkins/.minikube/profiles/minikube/client.crt

sudo cp ~/.minikube/profiles/minikube/client.key \
    /var/lib/jenkins/.minikube/profiles/minikube/client.key

sudo chown -R jenkins:jenkins /var/lib/jenkins/.minikube

sudo sed -i \
    's|/home/ec2-user/.minikube|/var/lib/jenkins/.minikube|g' \
    /var/lib/jenkins/.kube/config

sudo cat /var/lib/jenkins/.kube/config

echo "========= Kubectl and Minikube are installed and configured for Jenkins user successfully ==========="

#Install Terraform software :
echo "===== Installing terraform ==== "
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install terraform

#Jenkins Address link & Password :
echo "Complete installing Jenkins in EC2 instance Now access jenkins using this address 'http://$(curl ifconfig.me):8080' this is jenkins link"
echo "Admin Password:$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)"
#To restart dockers:
newgrp docker
#Checking All packages version :
echo "===java vesrion==="
java -version
echo "===maven==="
mvn -version
echo "===git vesrion==="
git --version
echo "===jenkins vesrion==="
jenkins --version
echo "===docker vesrion==="
docker --version
echo "===kubernets vesrion==="
kubectl version --client
