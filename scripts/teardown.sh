cat << 'EOF' > scripts/teardown.sh
#!/usr/bin/env bash
# Automated KVM Lab Environment Cleanup Script

echo "[-] Destroying virtual machines..."
sudo virsh destroy ubuntu-server 2>/dev/null || true
sudo virsh undefine ubuntu-server --remove-all-storage 2>/dev/null || true

sudo virsh destroy rocky-linux 2>/dev/null || true
sudo virsh undefine rocky-linux --remove-all-storage 2>/dev/null || true

echo "[-] Stopping virtual network..."
sudo virsh net-destroy labnet 2>/dev/null || true
sudo virsh net-undefine labnet 2>/dev/null || true

echo "[SUCCESS] Environment reset complete."
EOF
