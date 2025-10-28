# Localhost Dev Tools by Shettimax

A collection of smart, bash-powered scripts for managing local development environments on Linux. Built for speed, clarity, and control — no fluff, just clean automation.

##  What's Included

- `customdomain.sh`  
  Interactive wizard to assign custom local domains to Apache virtual hosts. Features:
  - Folder selection from `/var/www`
  - Domain conflict detection
  - `/etc/hosts` update
  - Apache virtual host creation
  - Color-coded output for clarity

- `localhost.sh`  
  Lightweight service manager for Apache, MySQL, and SSH. Features:
  - Start, stop, restart, and status commands
  - Clean output with color formatting
  - Process cleanup for lingering services

##  Requirements

- Ubuntu or Debian-based Linux
- Apache2 (`sudo apt install apache2`)
- Bash shell
- Root privileges for system-level changes

##  Usage

Make scripts executable:
```bash
chmod +x customdomain.sh
chmod +x localhost.sh
Run them as
./customdomain.sh
./localhost.sh
##  Command-Line Arguments
the customdomainscript has none
but for localhost services script
Run the script with one of the following arguments:

| Command   | Description                          |
|-----------|--------------------------------------|
| `start`   | Starts all configured services       |
| `stop`    | Stops all services and cleans up     |
| `restart` | Restarts all services                |
| `status`  | Shows the current status of services |

### Example usage:
```bash
./localhost.sh start
./localhost.sh status
./localhost.sh stop
./localhost.sh restart


