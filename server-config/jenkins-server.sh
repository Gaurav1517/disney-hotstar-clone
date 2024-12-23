#!/bin/bash

echo "## **Main Server Setup: Jenkins, Java, Docker, Git, Ansible, Trivy**"

### **1. Install Jenkins**  
echo "Updating the system and installing Java..."
sudo yum update -y
sudo yum install -y curl tar gzip wget vim 

# JDK 17 installation
echo "Installing Amazon Corretto JDK 17..."
sudo rpm --import https://yum.corretto.aws/corretto.key
sudo curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
sudo yum install -y java-17-amazon-corretto

# Setting up JDK environment variables
echo "Configuring Java environment variables..."
echo "export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto" | sudo tee -a /etc/profile
echo "export PATH=\$PATH:\$JAVA_HOME/bin" | sudo tee -a /etc/profile
source /etc/profile
java -version

# Add Jenkins repository and key
echo "Adding Jenkins repository and key..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

# Install Jenkins
echo "Installing Jenkins..."
sudo yum upgrade -y
sudo yum install -y jenkins
sudo systemctl enable jenkins --now

---

### **2. Install Docker**
echo "Installing Docker..."
sudo yum update -y
sudo yum install -y docker
sudo systemctl enable docker --now

# Add Jenkins user to the Docker group
sudo usermod -aG docker jenkins
sudo chmod 666 /var/run/docker.sock
sudo systemctl restart jenkins
sudo systemctl status jenkins

### **4. Git Installation**
echo "Installing Git..."
sudo yum install -y git* || sudo yum install -y git* --skip-broken

### **5. Install Trivy**
echo "Installing Trivy..."
cat << EOF | sudo tee /etc/yum.repos.d/trivy.repo
[trivy]
name=Trivy repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
EOF
sudo yum -y update
sudo yum -y install trivy
trivy --version

### **6. Install Ansible and Dependencies**
echo "Installing Ansible and dependencies..."
sudo yum install -y python3 python3-devel python3-pip openssl
sudo amazon-linux-extras install ansible2 -y
python3 --version
pip3 --version
ansible --version

### **SSH Key Setup for Ansible**
echo "Setting up SSH keys for Ansible..."
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
echo "Copying SSH key to Kubernetes server..."
ssh-copy-id user@k8s-server

### **Verify Ansible Connectivity**
echo "Testing Ansible connection to Kubernetes server..."
ansible k8s-server -m ping

echo "## **MAIN MACHINE CONFIGURED SUCCESSFULLY!!**"
