#!/bin/bash
wget -O ~/ceremonyclient/node/node_info.sh "https://raw.githubusercontent.com/Mak-Wei-Zheng/bash_scripting/main/node_info.sh"

chmod +x ~/ceremonyclient/node/node_info.sh

# Define the cron job line
cron_job="* * * * * ~/ceremonyclient/node/node_info.sh"

# Check if the cron job already exists
crontab -l | grep -F "$cron_job" > /dev/null

# Add the cron job if it does not exist
if [ $? -ne 0 ]; then
    # Get current crontab content
    crontab -l > mycron

    # Echo new cron into cron file
    echo "$cron_job" >> mycron

    # Install new cron file
    crontab mycron

    # Remove temporary file
    rm mycron

    echo "Cron job added."
else
    echo "Cron job already exists."
fi
