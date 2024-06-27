#!/bin/bash

# Set timezone to Europe/Rome
export TZ="Asia/Singapore"

# Script version
SCRIPT_VERSION="0.0.0"

version="1.4.20"

# Function to fetch node binary and set NODE_BINARY variable
fetch_node_binary() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        release_os="linux"
        release_arch=$(uname -m)
        if [[ "$release_arch" == "aarch64" ]]; then
            release_arch="arm64"
        else
            release_arch="amd64"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        release_os="darwin"
        release_arch="arm64"
    else
        echo "Unsupported OS for releases, please build from source"
        exit 1
    fi

    NODE_BINARY=node-$version-$release_os-$release_arch
    echo "$NODE_BINARY"
}

# Function to get the unclaimed balance
get_unclaimed_balance() {
    local node_directory="$HOME/ceremonyclient/node"
    local NODE_BINARY
    NODE_BINARY=$(fetch_node_binary)
    # echo "Identified Node binary: $NODE_BINARY"
    local node_command="./$NODE_BINARY -balance"
    
    local output
    output=$(cd "$node_directory" && $node_command 2>&1)
    
    local balance
    balance=$(echo "$output" | grep "Unclaimed balance" | awk '{print $3}' | sed 's/[^0-9.]//g')
    
    if [[ "$balance" =~ ^[0-9.]+$ ]]; then
        # Ensure the balance has two decimal places
        balance=$(printf "%.5f" "$balance")
        echo "$balance"
    else
        echo "❌ Error: Failed to retrieve balance."
        exit 1
    fi
}

# Function to write data to CSV file
write_to_csv() {
    local filename="$HOME/ceremonyclient/node/balance.log"
    local data="$1"

    if [ ! -f "$filename" ] || [ ! -s "$filename" ]; then
        echo "\"time\",\"balance\"" > "$filename"
    fi

    # Split the data into time and balance
    local time=$(echo "$data" | cut -d',' -f1)
    local balance=$(echo "$data" | cut -d',' -f2)

    # Replace dot with comma in balance for correct CSV formatting
    balance=$(echo "$balance" | sed 's/\./,/')

    # Format the data with quotes
    local formatted_data="\"$time\",\"$balance\""

    echo "$formatted_data" >> "$filename"
}


# Main function
main() {
    local current_time
    current_time=$(date +'%d/%m/%Y %H:%M')
    
    local balance
    balance=$(get_unclaimed_balance)
    # echo $balance
    
    if [ -n "$balance" ]; then
        local filename="$HOME/ceremonyclient/node/balance.log"
        
        local data_to_write="$current_time,$balance"
        
        write_to_csv "$data_to_write"
    fi
}

# Run main function
main
