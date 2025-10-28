#!/bin/bash
# Author: SHETTIMAX
# Description: Linux localh0st service manager for Apache, MySQL, SSH

# === Color codes ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# === Services to manage ===
SERVICES=("apache2" "mysql" "ssh")

# === Start services ===
start_services() {
    echo -e "${CYAN}Starting services...${NC}"
    for service in "${SERVICES[@]}"; do
        echo -ne "Starting ${YELLOW}$service${NC}... "
        if sudo systemctl start "$service" 2>/dev/null; then
            echo -e "${GREEN}OK${NC}"
        else
            echo -e "${RED}FAILED${NC}"
        fi
    done
    echo -e "${GREEN}Startup process complete.${NC}"
}

# === Show service status ===
status_services() {
    echo -e "${CYAN}Service status:${NC}"
    for service in "${SERVICES[@]}"; do
        echo -e "${YELLOW}$service:${NC}"
        sudo systemctl status "$service" --no-pager | grep -E "Active|Loaded"
        echo "-----------------------------"
    done
}

# === Stop services ===
stop_services() {
    echo -e "${CYAN}Stopping services...${NC}"
    for service in "${SERVICES[@]}"; do
        echo -e "Stopping ${YELLOW}$service${NC}..."
        sudo systemctl stop "$service"
    done
    echo -e "${YELLOW}Cleaning up leftover processes...${NC}"
    sudo pkill apache2 2>/dev/null
    sudo pkill mysql 2>/dev/null
    sudo pkill sshd 2>/dev/null
    echo -e "${GREEN}All services stopped and cleaned.${NC}"
}

# === Restart services ===
restart_services() {
    echo -e "${CYAN}Restarting services...${NC}"
    for service in "${SERVICES[@]}"; do
        echo -e "Restarting ${YELLOW}$service${NC}..."
        sudo systemctl restart "$service"
    done
    echo -e "${GREEN}All services restarted successfully.${NC}"
}

# === Main logic ===
case "$1" in
    start)
        start_services
        ;;
    status)
        status_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    *)
        echo -e "${RED}Usage: $0 {start|status|stop|restart}${NC}"
        exit 1
        ;;
esac
