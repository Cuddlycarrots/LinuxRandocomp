#!/bin/bash
# Target: iron (Ubuntu) and redstone (Rocky)

# Define all required baseline users + root
USERS=("root" "steve" "alex" "enderman" "creeper" "villager" "zombie" "enderdragon" "irongolem" "chickenjockey" "ghast")
OUTPUT_FILE="linux_new_passwords.txt"

echo "CCDC Password Randomizer - $(hostname)" > $OUTPUT_FILE
echo "----------------------------------------" >> $OUTPUT_FILE

for USER in "${USERS[@]}"; do
    # Check if the user actually exists on this system before attempting change
    if id "$USER" &>/dev/null; then
        # Generate a 16-character random password (alphanumeric + safe symbols)
        NEW_PASS=$(tr -dc 'A-Za-z0-9!@#%^&*' < /dev/urandom | head -c 16)
        
        # Apply the new password
        echo "$USER:$NEW_PASS" | chpasswd
        
        # Log to terminal and output file
        echo "[+] Changed $USER -> $NEW_PASS"
        echo "$USER : $NEW_PASS" >> $OUTPUT_FILE
    else
        echo "[-] User $USER does not exist on this box, skipping..."
    fi
done

echo ""
echo "SUCCESS: All changed passwords saved to $OUTPUT_FILE."
echo "ACTION REQUIRED: Copy these to your local machine and submit your PCRs immediately!"