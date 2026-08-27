# Cisco Network Automation

Ansible-based network automation project for managing Cisco IOS routers
running in GNS3.

## Architecture

```text
NetworkAutomation-1
        |
      Ansible
        |
 inventory/hosts.ini
        |
 +------+------+------+
 |      |      |      |
R1     R2     R3     R5
```
