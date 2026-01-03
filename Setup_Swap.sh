# 1. Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root."
   exit 1
fi

# 2. Ask user for swap size
read -p "Enter desired swap size in GB (e.g., 4, 8, 16): " SWAP_SIZE

# Validate input (must be an integer)
if ! [[ "$SWAP_SIZE" =~ ^[0-9]+$ ]]; then
    echo "Error: Please enter a valid integer."
    exit 1
fi

SWAP_FILE="/swapfile"

# 3. Check if swapfile exists and handle the resize logic
if [ -f "$SWAP_FILE" ]; then
    echo "Found existing $SWAP_FILE."
    
    # Check if it is currently active
    if grep -q "$SWAP_FILE" /proc/swaps; then
        echo "Deactivating current swap... (this may take a moment)"
        if ! swapoff "$SWAP_FILE"; then
            echo "Error: Could not turn off swap. You might be out of RAM."
            echo "Close some programs and try again."
            exit 1
        fi
    fi

    echo "Removing old swap file..."
    rm "$SWAP_FILE"
else
    echo "No existing swap file found. Creating new one..."
fi

# 4. Create the new swap file
echo "Creating ${SWAP_SIZE}GB swap file..."

# Try fallocate first (faster)
if ! fallocate -l "${SWAP_SIZE}G" "$SWAP_FILE"; then
    echo "fallocate failed, falling back to dd (this is slower)..."
    # Calculate count for dd (Size * 1024 * 1024) to get KB or just use bs=1G
    dd if=/dev/zero of="$SWAP_FILE" bs=1G count="$SWAP_SIZE" status=progress
fi

# Verify file creation
if [ ! -f "$SWAP_FILE" ]; then
    echo "Error: Failed to create swap file."
    exit 1
fi

# 5. Set Permissions and Enable
echo "Setting permissions (chmod 600)..."
chmod 600 "$SWAP_FILE"

echo "Formatting as swap..."
mkswap "$SWAP_FILE"

echo "Enabling swap..."
swapon "$SWAP_FILE"

# 6. Update /etc/fstab for persistence
# We only add the line if it doesn't already exist
if ! grep -q "$SWAP_FILE" /etc/fstab; then
    echo "Adding entry to /etc/fstab..."
    echo "$SWAP_FILE none swap sw 0 0" >> /etc/fstab
    echo "/etc/fstab updated."
else
    echo "Entry already exists in /etc/fstab. No changes needed there."
fi

# 7. Final Verification
echo "--------------------------------------------"
echo "Success! Current Swap Status:"
echo "--------------------------------------------"
swapon --show
echo ""
free -h
