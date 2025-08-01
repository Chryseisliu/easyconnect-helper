#!/bin/bash

# --- USER CONFIGURATION ---
# The only section you need to edit.
VPN_URL=" "
VPN_USER=" "
VPN_PASS=" "
INTERNAL_IP_RANGE=" "
# --- END OF CONFIGURATION ---


# --- SCRIPT MAIN LOGIC ---
# Do not edit below this line unless you know what you are doing.

cleanup() {
    echo ""
    echo "An error occurred or the script was interrupted. Cleaning up..."
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    if [ -f "$SCRIPT_DIR/stop_vpn.sh" ]; then
        "$SCRIPT_DIR/stop_vpn.sh"
    else
        echo "Warning: stop_vpn.sh not found. Manual cleanup might be required."
    fi
}

# Set a trap to run the cleanup function on script exit or interruption
trap cleanup EXIT

echo "Starting VPN Tunnel (Command-Line Mode)..."

# Stop any potentially leftover container from a previous run
docker stop easyconnect-vpn > /dev/null 2>&1

# Start the command-line VPN container in detached mode
docker run -d --rm --name=easyconnect-vpn --device /dev/net/tun --cap-add NET_ADMIN \
  -e EC_VER=7.6.7 \
  -e CLI_OPTS="-d $VPN_URL -u $VPN_USER -p '$VPN_PASS'" \
  hagb/docker-easyconnect:cli > /dev/null

echo "Waiting for VPN login... (approx. 15 seconds)"
sleep 15

# Check if login was successful
if ! docker logs easyconnect-vpn 2>&1 | grep -q "login successfully"; then
    echo "ERROR: VPN login failed. Please check your credentials or network."
    echo "Displaying logs for debugging:"
    docker logs easyconnect-vpn
    exit 1
fi
echo "VPN Login Successful!"

# Get container IP and set up the network route
CONTAINER_IP=$(docker inspect easyconnect-vpn | grep '"IPAddress"' | tail -n 1 | awk -F '"' '{print $4}')
if [ -z "$CONTAINER_IP" ]; then
    echo "ERROR: Could not get the VPN container's IP address."
    exit 1
fi
echo "Setting up network route for $INTERNAL_IP_RANGE via container IP: $CONTAINER_IP..."
sudo ip route add $INTERNAL_IP_RANGE via $CONTAINER_IP

# Unset the trap because we are handing over control to the user
trap - EXIT

echo ""
echo "VPN Tunnel is Ready!"
echo "You can now access your internal network resources."
echo "Press [Ctrl+C] or run ./stop_vpn.sh in another terminal to disconnect."
echo ""

wait

