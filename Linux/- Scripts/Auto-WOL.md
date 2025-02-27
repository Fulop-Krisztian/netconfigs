# Auto-WOL
created: 2025-02-27 18:45
tags: #script #automation #ipv4 

This is a custom (systemd) daemon that in short wakes up Krissssz-PC when my phone connects to the network during a specific time period of the day. No cron is used, because it would be too hard to configure cron to my liking.

GPT helped a lot, it’s 50/50 human/AI:

> [!info]  
>  
> [https://chat.openai.com/share/19654f18-0e07-4140-908d-b4f2180f34f1](https://chat.openai.com/share/19654f18-0e07-4140-908d-b4f2180f34f1)  

```Bash
#!/bin/bash

# Define the MAC address of the device you want to wake up
MAC_TO_WAKE="B4:2E:99:6A:D8:A7"
IP_TO_WAKE="192.168.0.150"

# Define the MAC address of the device whose connection triggers the WoL
TRIGGER_DEVICE_MAC="58:20:59:B9:A9:68"

# Define the start and end times in 24-hour format (HH:MM)
START_TIME="12:00"
END_TIME="19:00"

# Function to get the next start time from now
get_start_time() { 

    if [[ "$(date +"%H:%M")" < "$START_TIME" ]]; then
        printf "%d\n" $(( $(date -d "today $START_TIME" +%s) - $(date +%s) ))
    else
        printf "%d\n" $(( $(date -d "tomorrow $START_TIME" +%s) - $(date +%s) ))
    fi
}

while true; do
    CURRENT_TIME=$(date +"%H:%M")

    # Check if the current time is within the specified time range
    if [[ "$CURRENT_TIME" > "$START_TIME" && "$CURRENT_TIME" < "$END_TIME" ]]; then

        # Check if the trigger device is connected to the network
        if arp-scan --interface=eth0 --localnet | grep -i "$TRIGGER_DEVICE_MAC" &> /dev/null; then
            echo "Trigger device connected. Checking if target device is reachable..."

        # Try to wake WOL device if not pingable 4 times
        for ((i=0; i<5; i++)); do
            # Check if the WoL device is reachable (responds to ping)
            if ping -c 1 "$IP_TO_WAKE" &> /dev/null; then
                echo "Target device is awake and reachable. Sleeping until $START_TIME... ($(get_start_time) seconds)"
                sleep $(get_start_time)
                break
            else
                echo "Target device is not reachable. Sending WOL packet. Rechecking every 10 seconds..."
                wakeonlan "$MAC_TO_WAKE"
                sleep 10

            fi

            if [[ "$i" == "4" ]]; then
                echo "Target device is could not be reached. retrying in one minute"
                sleep 60
            fi
        done
        else
            # Look for the trigger device again in 5 seconds
            echo "Waiting for trigger device to connect..."
            sleep 5
        fi

    else
        echo "Outside the specified time range. Sleeping until $START_TIME... ($(get_start_time) seconds)"
        sleep $(get_start_time)
    fi
done
```