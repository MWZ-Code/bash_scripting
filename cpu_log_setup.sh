#!/bin/bash
wget -O ~/ceremonyclient/node/turbo_log.sh "https://raw.githubusercontent.com/Mak-Wei-Zheng/bash_scripting/main/turbo_log.sh"

chmod +x ~/ceremonyclient/node/turbo_log.sh

# Define the cron job line
cron_job="0 * * * * ~/ceremonyclient/node/turbo_log.sh"

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
