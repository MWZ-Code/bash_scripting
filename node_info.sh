#!/bin/bash

export TZ="Asia/Singapore"
# Change to the desired directory
cd ~/ceremonyclient/node

# Log the current time
echo "Log Time: $(date)" >> ~/ceremonyclient/node/node_info.log

# Execute the command and append the output to the log file
./node-1.4.20-linux-amd64 --node-info >> ~/ceremonyclient/node/node_info.log 2>&1

echo "____LINE__BREAK____" >> ~/ceremonyclient/node/node_info.log 2>&1