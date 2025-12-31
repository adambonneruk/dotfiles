#!/bin/bash

####################################################################################
# clear the screen
clear

####################################################################################
# print a logo (if applicable)
ARTFILE=~/.bash/art/$(hostname)

if [ -f "$ARTFILE" ]; then
    cat "$ARTFILE"
fi

# rainbow banner text
FIGLET_TEXT=$(figlet $(hostname))
WIDTH=$(echo "$FIGLET_TEXT" | awk '{ if (length > w) w=length } END {print w}')

TEXT="Linux/Containers by Adam Bonner"
PADDING=$(( (WIDTH - ${#TEXT}) / 2 ))
[ $PADDING -lt 0 ] && PADDING=0
CENTERED_TEXT="$(printf "%*s%s\n" $PADDING "" "$TEXT")"

printf "$FIGLET_TEXT\n$CENTERED_TEXT\n" | lolcat

####################################################################################

# machine
echo -e "\n\e[1mMachine\e[0m"
echo -e "hardware: \t $(cat /sys/class/dmi/id/sys_vendor) $(cat /sys/class/dmi/id/product_name)"

CPU_MODEL=$(grep -m 1 "model name" /proc/cpuinfo | cut -d: -f2 | sed 's/^ //')
CPU_CORES=$(grep -c "^processor" /proc/cpuinfo)
echo -e "cpu: \t\t $CPU_MODEL ($CPU_CORES cores)"

if [ -e /sys/class/thermal/thermal_zone0/temp ]; then
    CPU_TEMP=$(awk 'NR==1 {print $1/1000 "°C"}' /sys/class/thermal/thermal_zone0/temp)
else
    CPU_TEMP="N/A"
fi

echo -e "cpu temp: \t $CPU_TEMP"


#echo -e "cpu temp: \t $(paste <(cat /sys/class/thermal/thermal_zone*/type) <(cat /sys/class/thermal/thermal_zone*/temp) | column -s $'\t' -t | sed 's/\(.\)..$/.\1°C/' | sed -n '3 p' | grep -oP '[\d.]+')°C"

if command -v nvidia-smi >/dev/null 2>&1; then
    GPU=$(nvidia-smi --query-gpu=name --format=csv,noheader)
else
    #GPU=$(lspci | grep -i 'vga\|3d\|display' | awk -F: '{print $3}')
    GPU=$(lspci | grep -i 'vga\|3d\|display' | awk -F: '{gsub(/^ +| +$/,"",$3); print $3}')

fi
echo -e "gpu: \t\t $GPU"

#echo -e "uptime: \t $(uptime -p)"
echo -e "uptime: \t $(uptime -p | sed 's/^up //')"

# operating system
echo -e "\n\e[1mOperating System\e[0m"

. /etc/os-release
echo -e "distro: \t $PRETTY_NAME"
echo -e "version: \t $(cat /etc/debian_version)"
echo -e "linux: \t\t $(uname -r)"

# software / containers
echo -e "\n\e[1mSoftware/Containers\e[0m"

# Apt packages
APT_COUNT=$(dpkg-query -f '${Status}\n' -W | awk '/install ok installed/ {c++} END{print c}')
echo -e "apt packages: \t $APT_COUNT"

# Docker version
if command -v docker >/dev/null 2>&1; then
    DOCKER_VER=$(docker --version | awk '{print $3}' | tr -d ',')
else
    DOCKER_VER="N/A"
fi
echo -e "docker ver: \t $DOCKER_VER"

# Compose version (docker-compose or docker plugin)
if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_VER=$(docker-compose version --short 2>/dev/null || echo "unknown")
elif docker compose version >/dev/null 2>&1; then
    COMPOSE_VER=$(docker compose version --short 2>/dev/null)
else
    COMPOSE_VER="N/A"
fi
echo -e "compose ver: \t $COMPOSE_VER"

# Container count
if command -v docker >/dev/null 2>&1; then
    CONTAINERS=$(docker container ls -q 2>/dev/null | wc -l)
else
    CONTAINERS="N/A"
fi
echo -e "containers: \t $CONTAINERS"


# disk
echo -e "\n\e[1mDisk\e[0m"
read SIZE USED AVAIL PERCENT <<< $(df -BG / | awk 'NR==2 {print $2, $3, $4, $5}')

# Insert a space before GiB
SIZE="${SIZE/G/ GiB}"
USED="${USED/G/ GiB}"
AVAIL="${AVAIL/G/ GiB}"

echo -e "disk size: \t ${SIZE}"
echo -e "disk used: \t ${USED}"
echo -e "disk free: \t ${AVAIL}"
echo -e "disk usage: \t $PERCENT"

# network
echo -e "\n\e[1mNetwork\e[0m"
echo -e "host+domain: \t $(hostname)@$(hostname -d)"
echo -e "ipv4: \t\t $(hostname -I | awk '{print $1}')"

