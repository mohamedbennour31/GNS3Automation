# Cisco Network Automation

An Ansible-based network automation toolkit for managing Cisco IOS routers in a GNS3 lab environment.

The project provides a centralized way to test connectivity, execute operational show commands, collect information, troubleshoot routing/VPN issues, and back up router configurations.

---

````

The automation server connects to the Cisco IOS routers using Ansible's `network_cli` connection plugin.

---

## Managed Routers

| Router | Management IP |
| ------ | ------------- |
| R1     | `10.1.68.50`  |
| R2     | `10.1.254.2`  |
| R3     | `10.1.66.50`  |
| R5     | `10.1.66.51`  |

> **Note:** R4 is currently not included in the Ansible inventory.

---

## Technologies

* **Ansible** — Network automation and orchestration
* **Cisco IOS** — Router operating system
* **network_cli** — Ansible network connection method
* **GNS3** — Network simulation/emulation environment
* **Linux** — Automation server
* **Bash** — Interactive automation menu
* **Cisco IOS Ansible Collection** — Cisco IOS modules and plugins

---

## Requirements

Before running the automation, make sure the following are available:

* Linux automation server
* Ansible
* Cisco IOS Ansible collection
* Cisco IOS routers
* GNS3 topology
* Network connectivity between the automation server and routers
* SSH access to the routers

---

## Installation

### Install Ansible

Install Ansible using your Linux distribution's package manager or Python environment.

Verify the installation:

```bash
ansible --version
```

### Install the Cisco IOS Collection

Install the official Cisco IOS Ansible collection:

```bash
ansible-galaxy collection install cisco.ios
```

Verify the collection:

```bash
ansible-galaxy collection list | grep cisco.ios
```

---

## Router Authentication

The routers use a local Ansible account with privilege level 15:

```text
username: student
privilege: 15
```

The router password is **intentionally not stored in this repository**.

Credentials should be provided using a secure method such as:

* Ansible Vault
* Environment variables
* A secrets manager
* Another secure credential-management solution

Never commit router passwords or other credentials to Git.

---

## Inventory

Router management addresses are defined in:

```text
inventory/hosts.ini
```

Current inventory:

```text
R1    10.1.68.50
R2    10.1.254.2
R3    10.1.66.50
R5    10.1.66.51
```

Example inventory structure:

```ini
[routers]
r1
r2
r3
r5

[routers:vars]
ansible_connection=ansible.netcommon.network_cli
ansible_network_os=cisco.ios.ios
```

---

## Connectivity Test

The recommended first step when troubleshooting the automation environment is:

```bash
ansible-playbook playbooks/test.yml
```

The test playbook executes:

```text
show ip interface brief
```

against all managed routers.

A successful run should report all four routers as reachable:

```text
r1 ok
r2 ok
r3 ok
r5 ok
```

The final result should contain:

```text
failed=0
unreachable=0
```

If a router is unreachable, verify:

1. The router is running in GNS3.
2. The management IP is correct.
3. The automation server has network connectivity to the router.
4. SSH is enabled on the router.
5. The Ansible username is correct.
6. The credentials are correct.
7. `ansible_connection` and `ansible_network_os` are configured correctly.

---

# Available Playbooks

The project contains playbooks for common Cisco IOS operational and troubleshooting tasks.

| Playbook                     | Purpose                                          |
| ---------------------------- | ------------------------------------------------ |
| `test.yml`                   | Test Ansible connectivity                        |
| `show_interfaces.yml`        | Show IP interface brief                          |
| `show_routes.yml`            | Show routing table                               |
| `show_running_config.yml`    | Show running configuration                       |
| `show_ip_protocols.yml`      | Show IP routing protocols                        |
| `show_neighbors.yml`         | Show CDP neighbors                               |
| `show_arp.yml`               | Show ARP table                                   |
| `show_interfaces_status.yml` | Show interface status                            |
| `show_version.yml`           | Show IOS version                                 |
| `show_ip_interfaces.yml`     | Show detailed IP interface information           |
| `backup_configs.yml`         | Back up running configurations                   |
| `ping_test.yml`              | Test connectivity to an upstream/default gateway |
| `show_crypto.yml`            | Show ISAKMP/IPsec status                         |
| `show_eigrp_neighbors.yml`   | Show EIGRP neighbors                             |
| `show_eigrp_routes.yml`      | Show EIGRP routes                                |
| `show_ntp.yml`               | Show NTP status                                  |
| `show_logging.yml`           | Show router logging                              |
| `show_interface_errors.yml`  | Show interface information/errors                |
| `show_route_summary.yml`     | Show route summary                               |

### Example

Run the interface information playbook:

```bash
ansible-playbook playbooks/show_interfaces.yml
```

Run the routing table playbook:

```bash
ansible-playbook playbooks/show_routes.yml
```

Run the version check:

```bash
ansible-playbook playbooks/show_version.yml
```

---

# Interactive Automation Menu

The project includes an interactive Bash menu that provides access to the operational playbooks.

Run:

```bash
./scripts/automation_menu.sh
```

If necessary, make the script executable first:

```bash
chmod +x scripts/automation_menu.sh
```

The menu allows common automation tasks to be launched without manually typing every `ansible-playbook` command.

---

# Configuration Backups

Router configuration backups are stored in:

```text
backups/
```

Backups are intentionally excluded from Git because Cisco router configurations may contain sensitive information, including:

* Local usernames
* Password hashes
* VPN configuration
* IP addressing information
* Routing information
* Other security-sensitive configuration

Before committing changes, always verify that configuration backups are not staged:

```bash
git status
```

---

# Security

**Never commit sensitive information to this repository.**

Do not commit:

```text
Router passwords
Private keys
VPN pre-shared keys
Router configuration backups
.env files
Ansible Vault passwords
Credentials
API tokens
```

Use `.gitignore` and Ansible Vault where appropriate.

Before every commit, review:

```bash
git status
```

If a sensitive file has accidentally been staged:

```bash
git restore --staged <file>
```

Do not push secrets to GitHub.

---

# Important Cisco IOS Notes

Cisco commands are platform-dependent.

A command that works on a Cisco switch may not be available on a Cisco IOS router image.

For example:

```text
show vlan brief
```

may be available on Cisco switches but may not be supported by the IOS router images used in this GNS3 project.

New commands should therefore be tested against the target IOS image before being added to the automation toolkit.

---

# GNS3 / VPN Notes

The current GNS3 topology uses an upstream/cloud network reachable through:

```text
192.168.204.2
```

R1 and R2 were able to reach this upstream address during testing.

The VPN peer addresses are:

```text
172.30.100.230
172.30.100.240
```

### VPN Troubleshooting

The existence of a static route to a VPN peer does **not** by itself prove that the remote VPN peer is reachable.

When troubleshooting IPsec connectivity, compare both sides of the VPN configuration.

Check:

```text
ISAKMP policy
Pre-shared keys
Crypto-map peers
Transform sets
Interesting-traffic ACLs
Routing
```

Useful operational playbooks include:

```bash
ansible-playbook playbooks/show_crypto.yml
ansible-playbook playbooks/show_routes.yml
ansible-playbook playbooks/ping_test.yml
```

Always verify routing and reachability before changing VPN configuration.

---

# Project Structure

```text
network-automation/
│
├── README.md
├── .gitignore
├── ansible.cfg
│
├── inventory/
│   └── hosts.ini
│
├── playbooks/
│   ├── test.yml
│   ├── backup_configs.yml
│   ├── ping_test.yml
│   ├── show_arp.yml
│   ├── show_crypto.yml
│   ├── show_eigrp_neighbors.yml
│   ├── show_eigrp_routes.yml
│   ├── show_interface_errors.yml
│   ├── show_interfaces.yml
│   ├── show_interfaces_status.yml
│   ├── show_ip_interfaces.yml
│   ├── show_ip_protocols.yml
│   ├── show_logging.yml
│   ├── show_neighbors.yml
│   ├── show_ntp.yml
│   ├── show_route_summary.yml
│   ├── show_routes.yml
│   ├── show_running_config.yml
│   └── show_version.yml
│
├── scripts/
│   └── automation_menu.sh
│
└── backups/
    └── # excluded from Git
```

---

# Recommended Workflow

A typical workflow for this project is:

### 1. Verify the GNS3 topology

Make sure the routers are powered on and reachable.

### 2. Test Ansible connectivity

```bash
ansible-playbook playbooks/test.yml
```

### 3. Collect operational information

For example:

```bash
ansible-playbook playbooks/show_interfaces.yml
ansible-playbook playbooks/show_routes.yml
ansible-playbook playbooks/show_neighbors.yml
ansible-playbook playbooks/show_version.yml
```

### 4. Troubleshoot specific services

For routing:

```bash
ansible-playbook playbooks/show_eigrp_neighbors.yml
ansible-playbook playbooks/show_eigrp_routes.yml
```

For VPN:

```bash
ansible-playbook playbooks/show_crypto.yml
```

For NTP and logging:

```bash
ansible-playbook playbooks/show_ntp.yml
ansible-playbook playbooks/show_logging.yml
```

### 5. Back up configurations

```bash
ansible-playbook playbooks/backup_configs.yml
```

Backups remain local and are not committed to Git.

---

# Git Workflow

After modifying the project, review the changes:

```bash
git status
```

Then review the files before committing:

```bash
git diff
```

Stage the changes:

```bash
git add .
```

Check the staged files:

```bash
git status
```

Commit:

```bash
git commit -m "Update network automation"
```

Push to GitHub:

```bash
git push
```

---

# Project Goals

This project is designed to provide a practical foundation for Cisco network automation.

The main goals are:

* Automate repetitive Cisco IOS operational tasks
* Reduce manual CLI work
* Standardize network information gathering
* Simplify troubleshooting
* Automate configuration backups
* Practice Ansible network automation
* Integrate network automation with a GNS3 lab
* Maintain the automation code using Git and GitHub

---

## Author

**Mohamed Bennour**

Cisco Network Automation Lab
Ansible + Cisco IOS + GNS3 + Linux

