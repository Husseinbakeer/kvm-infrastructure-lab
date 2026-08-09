cat << 'EOF' > scripts/deploy.sh
#!/usr/bin/env bash
# Automated KVM Multi-VM Deployment Script

set -e

echo "[+] Defining and starting libvirt storage pools..."
sudo virsh pool-define-as --name kvm-images --type dir --target /mnt/kvm-storage/images 2>/dev/null || true
sudo virsh pool-start kvm-images 2>/dev/null || true
sudo virsh pool-autostart kvm-images 2>/dev/null || true

sudo virsh pool-define-as --name kvm-isos --type dir --target /mnt/kvm-storage/isos 2>/dev/null || true
sudo virsh pool-start kvm-isos 2>/dev/null || true
sudo virsh pool-autostart kvm-isos 2>/dev/null || true

echo "[+] Defining and starting virtual network (labnet)..."
sudo virsh net-define configs/labnet.xml
sudo virsh net-start labnet
sudo virsh net-autostart labnet

echo "[+] Provisioning Ubuntu Server VM..."
sudo virt-install \
  --name ubuntu-server \
  --ram 2048 --vcpus 2 \
  --disk path=/mnt/kvm-storage/images/ubuntu-server.qcow2,size=12,format=qcow2,bus=virtio \
  --cdrom /mnt/kvm-storage/isos/ubuntu-24.04.2-live-server-amd64.iso \
  --network network=labnet,mac=52:54:00:aa:bb:01,model=virtio \
  --graphics vnc,listen=0.0.0.0 --noautoconsole --os-variant ubuntu24.04

echo "[+] Provisioning Rocky Linux VM..."
sudo virt-install \
  --name rocky-linux \
  --ram 2048 --vcpus 2 \
  --disk path=/mnt/kvm-storage/images/rocky-linux.qcow2,size=12,format=qcow2,bus=virtio \
  --cdrom /mnt/kvm-storage/isos/Rocky-9-latest-x86_64-minimal.iso \
  --network network=labnet,mac=52:54:00:aa:bb:02,model=virtio \
  --graphics vnc,listen=0.0.0.0 --noautoconsole --os-variant rhel9.0

echo "[SUCCESS] Lab deployment complete."
EOF
