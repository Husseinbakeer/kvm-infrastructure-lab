cat << 'EOF' > README.md
# Enterprise KVM/QEMU Virtualization Lab & Cockpit Management

![Linux](https://img.shields.io/badge/OS-Ubuntu%20%7C%20RHEL-orange?style=flat-square&logo=linux)
![Hypervisor](https://img.shields.io/badge/Hypervisor-KVM%2FQEMU-blue?style=flat-square)
![Management](https://img.shields.io/badge/Management-Cockpit-red?style=flat-square)
![Networking](https://img.shields.io/badge/Network-Isolated%20NAT-green?style=flat-square)

## Overview
Engineered a multi-OS virtualized infrastructure environment using **KVM/QEMU** and **libvirt** on Ubuntu Linux. Implemented custom storage pooling with thin-provisioned `.qcow2` images, isolated NAT network bridging with persistent DHCP reservations, and integrated **Cockpit Web Console** for web-based guest administration.

---

## Architecture Diagram

+-------------------------------------------------------------------------------+
|                            Ubuntu Linux Hypervisor                            |
|                                                                               |
|   +-----------------------------------------------------------------------+   |
|   |                       Cockpit Web Admin (:9090)                       |   |
|   +-----------------------------------+-----------------------------------+   |
|                                       |                                       |
|   +-----------------------------------v-----------------------------------+   |
|   |                 Virtual Network Bridge: virbr-lab                     |   |
|   |                      Subnet: 192.168.100.0/24                        |   |
|   +-------------------+-------------------------------+-------------------+   |
|                       |                               |                       |
|        +--------------v--------------+ +--------------v--------------+        |
|        |       ubuntu-server         | |        rocky-linux          |        |
|        | IP:   192.168.100.11        | | IP:   192.168.100.12        |        |
|        | MAC:  52:54:00:aa:bb:01     | | MAC:  52:54:00:aa:bb:02     |        |
|        | RAM:  2048 MB | vCPU: 2     | | RAM:  2048 MB | vCPU: 2     |        |
|        | Storage: 12 GB (qcow2)      | | Storage: 12 GB (qcow2)      |        |
|        +-----------------------------+ +-----------------------------+        |
+-------------------------------------------------------------------------------+


---

## Key Features & Architecture

* **Storage Segmentation:** Dedicated storage pools separating operating system ISOs from thin-provisioned guest disk images (`/mnt/kvm-storage`).
* **Network Isolation:** Custom XML-defined virtual bridge (`labnet`) enforcing static MAC-to-IP DHCP bindings.
* **Remote Web Management:** Integrated Cockpit web console (`cockpit-machines`), enabling browser-based VNC/Serial access and host resource monitoring.
* **Infrastructure-as-Code (IaC):** Bash deployment and teardown scripts for repeatable lab provisioning.

---

## Directory Structure

```text
.
├── configs/
│   └── labnet.xml          # Libvirt network bridge definition
├── scripts/
│   ├── deploy.sh           # Deployment automation script
│   └── teardown.sh         # Cleanup script
├── docs/
│   └── images/             # Documentation assets
└── README.md
