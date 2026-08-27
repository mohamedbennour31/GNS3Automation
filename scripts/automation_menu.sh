#!/bin/bash

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR" || exit 1

while true; do
    clear

    echo "=========================================="
    echo "        NETWORK AUTOMATION MENU"
    echo "=========================================="
    echo " 1. Show interfaces"
    echo " 2. Show routes"
    echo " 3. Show running config"
    echo " 4. Show IP protocols"
    echo " 5. Show CDP neighbors"
    echo " 6. Show ARP table"
    echo " 7. Show interface status"
    echo " 8. Show version"
    echo " 9. Show IP interface details"
    echo "10. Backup configurations"
    echo "11. Ping test"
    echo "12. Show crypto/IPsec"
    echo "13. Show EIGRP neighbors"
    echo "14. Show EIGRP routes"
    echo "15. Show NTP status"
    echo "16. Show logging"
    echo "17. Show interface information"
    echo "18. Show route summary"
    echo "19. Exit"
    echo "=========================================="

    read -r -p "Select an option: " choice

    case "$choice" in
        1)  ansible-playbook playbooks/show_interfaces.yml ;;
        2)  ansible-playbook playbooks/show_routes.yml ;;
        3)  ansible-playbook playbooks/show_running_config.yml ;;
        4)  ansible-playbook playbooks/show_ip_protocols.yml ;;
        5)  ansible-playbook playbooks/show_neighbors.yml ;;
        6)  ansible-playbook playbooks/show_arp.yml ;;
        7)  ansible-playbook playbooks/show_interfaces_status.yml ;;
        8)  ansible-playbook playbooks/show_version.yml ;;
        9)  ansible-playbook playbooks/show_ip_interfaces.yml ;;
        10) ansible-playbook playbooks/backup_configs.yml ;;
        11) ansible-playbook playbooks/ping_test.yml ;;
        12) ansible-playbook playbooks/show_crypto.yml ;;
        13) ansible-playbook playbooks/show_eigrp_neighbors.yml ;;
        14) ansible-playbook playbooks/show_eigrp_routes.yml ;;
        15) ansible-playbook playbooks/show_ntp.yml ;;
        16) ansible-playbook playbooks/show_logging.yml ;;
        17) ansible-playbook playbooks/show_interface_errors.yml ;;
        18) ansible-playbook playbooks/show_route_summary.yml ;;
        19) exit 0 ;;
        *)  echo "Invalid option" ;;
    esac

    echo
    read -r -p "Press Enter to continue..."
done