#!/bin/bash

# Kubernetes Setup Script for Secondary Machine

echo "### Updating System ###"
sudo yum update -y

echo "### Installing Docker ###"
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo chmod 777 /var/run/docker.sock

echo "### Configuring SELinux ###"
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

echo "### Adding Kubernetes Repository ###"
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/repodata/repomd.xml.key
EOF

echo "### Installing Kubernetes Components ###"
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet

echo "### Initializing Kubernetes Cluster ###"
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU,Mem

echo "### Configuring kubectl for the root user ###"
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "### Deploying Calico Network Plugin ###"
kubectl apply -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml

echo "### (Optional) Deploying Tigera Operator ###"
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml

echo "### Removing Taints from Control-Plane Node ###"
kubectl taint nodes $(hostname) node-role.kubernetes.io/control-plane:NoSchedule-

echo "### Setup Completed! ###"
echo "1. Add worker nodes using the 'kubeadm join' command provided during 'kubeadm init'."
sudo kubeadm join <master-ip>:6443 --token <token> \
   --discovery-token-ca-cert-hash sha256:<hash>
echo "2. Verify the cluster:"
echo "   - Check nodes: "
kubectl get nodes
echo "   - Ensure all pods are running: "
kubectl get pods -A
