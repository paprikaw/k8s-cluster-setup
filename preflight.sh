#!/bin/bash
set -e
echo "Running preflight checking"
# Function to print the check status
print_status() {
    if [ $1 -eq 0 ]; then
        echo "PASS: $2"
    else
        echo "FAIL: $2"
    fi
}

ping -c 1 google.com &>/dev/null
print_status $? "Full network connectivity"

swap_status=$(swapon --summary | wc -l)
if [ $swap_status -eq 0 ]; then
    print_status 0 "Swap is disabled"
else
    print_status 1 "Swap is disabled"
fi

echo "Pre-flight check completed."
