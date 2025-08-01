#!/bin/bash

# --- USER CONFIGURATION ---
# The only section you need to edit.
# Ensure this value is the SAME as in start_vpn.sh
INTERNAL_IP_RANGE=" "
# --- END OF CONFIGURATION ---


# --- SCRIPT MAIN LOGIC ---
echo "Shutting down VPN tunnel and cleaning up..."

# Find ALL containers created from any easyconnect image to be extra safe
CONTAINER_IDS=$(docker ps -a -q --filter "ancestor=hagb/docker-easyconnect")

if [ -n "$CONTAINER_IDS" ]; then
    echo "Stopping all running EasyConnect containers..."
    docker stop $CONTAINER_IDS > /dev/null
else
    echo "No running EasyConnect containers found."
fi

echo "Removing network route for $INTERNAL_IP_RANGE..."
# The 2>/dev/null suppresses error messages if the route doesn't exist
sudo ip route del $INTERNAL_IP_RANGE 2>/dev/null || echo "No route to remove or already removed."

echo "Cleanup complete!"

