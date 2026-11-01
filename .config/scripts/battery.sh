#!/bin/bash

# Battery monitoring script with desktop notifications
BATTERY="BAT0"
CAPACITY_FILE="/sys/class/power_supply/$BATTERY/capacity"
STATUS_FILE="/sys/class/power_supply/$BATTERY/status"

if [ ! -f "$CAPACITY_FILE" ]; then
    exit 0
fi

PREV_LEVEL=100

while true; do
    read -r CURRENT_LEVEL < "$CAPACITY_FILE" 2>/dev/null || CURRENT_LEVEL=100
    read -r STATUS < "$STATUS_FILE" 2>/dev/null || STATUS="Discharging"

    THRESHOLD=$(( (CURRENT_LEVEL / 10) * 10 ))

    if [ "$CURRENT_LEVEL" -le "$PREV_LEVEL" ] && [ "$THRESHOLD" -lt "$PREV_LEVEL" ] && [ "$STATUS" != "Charging" ]; then
        if [ "$CURRENT_LEVEL" -le 10 ]; then
            notify-send -u critical -e -h string:x-canonical-private-synchronous:battery \
                        -h "int:value:$CURRENT_LEVEL" -t 4000 "Low Battery: ${CURRENT_LEVEL}%" "Please connect your charger now!"
        elif [ "$CURRENT_LEVEL" -le 20 ]; then
            notify-send -u normal -e -h string:x-canonical-private-synchronous:battery \
                        -h "int:value:$CURRENT_LEVEL" -t 3000 "Battery: ${CURRENT_LEVEL}%" "Battery level is low"
        else
            notify-send -u low -e -h string:x-canonical-private-synchronous:battery \
                        -h "int:value:$CURRENT_LEVEL" -t 2000 "Battery: ${CURRENT_LEVEL}%"
        fi
        PREV_LEVEL=$THRESHOLD
    elif [ "$STATUS" = "Charging" ]; then
        PREV_LEVEL=100
    fi

    sleep 60
done
