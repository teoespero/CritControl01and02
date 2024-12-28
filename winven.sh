# -------------------------------------------------------------------------
# name: winven.sh
# description: 
#   Critical Control 1/2 - Inventory Listing
#   This script will explore the host's critical controls 1 and 2 - hardware
#   and software inventory.
# author:   Teo Espero
# date written: 12/29/2024
# version: 1.0.12292024
# execution:
#   sudo bash ./winven.sh
#---------------------------------------------------------------------------

# - file start
echo -n "Basic System Inventory for Hostname: "
uname -n
#
echo ======================================================================
dmidecode | sed -n '/System Information/,+2p' | sed 's/\x09//'
dmesg | grep Hypervisor
dmidecode | grep "Serial Number" | grep -v "Not Specified" | grep -v None
#
echo ======================================================================
echo "OS Information:"
uname -o -r
if [ -f /etc/redhat-release ]; then
    echo -n " "
    cat /etc/redhat-release
fi
if [ -f /etc/issue ]; then
    cat /etc/issue
fi
#
echo ======================================================================
echo "IP Information: "
ip ad | grep inet | grep -v "127.0.0.1" | grep -v "::1/128" | tr -s " " | cut -d " " -f 3
echo ======================================================================
echo "CPU Information; "
echo -n "Model name: "
cat /proc/cpuinfo | grep "model name" | cut -d ":" -f 2 | uniq 
echo -n "Vendor name: "
cat /proc/cpuinfo | grep "vendor_id" | cut -d ":" -f 2 | uniq 
echo -n "Socket count (Total): "
cat /proc/cpuinfo | grep processor | wc -l
echo -n "Core Count (Total): "
cat /proc/cpuinfo | grep cores | cut -d ":" -f 2 | awk '{sum+=1} END {print sum}'
#
echo ======================================================================
echo "Memory Information: "
grep MemTotal /proc/meminfo | awk '{print $2,$3}'
#
echo ======================================================================
echo "Disk Information: "
fdisk -l | grep Disk | grep dev
# - file end