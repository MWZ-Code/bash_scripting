#!/bin/bash

export TZ="Asia/Singapore"
# Change to the desired directory
cd ~/ceremonyclient/node

# Log the current time
echo "Log Time: $(date)" >> ~/ceremonyclient/node/turbo.log

# Execute the command and append the output to the log file
turbostat --Summary --num_iterations 1 >> ~/ceremonyclient/node/turbo.log 2>&1

echo "____LINE__BREAK____" >> ~/ceremonyclient/node/turbo.log 2>&1