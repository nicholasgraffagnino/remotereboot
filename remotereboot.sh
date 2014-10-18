#!/bin/bash

# User-defined variables.
url=""
logglyUrl=""

# Internal variables.
logLength="${#logglyUrl}"
minutesBeforeReboot=1
sleepSeconds=7200

echo "RemoteReboot v1.0"

while true;
do
    # Adjust the frequency of checks, based on whether it is a business a day and business hours.
    # Get the day.
    checkDay=`date +'%a'`

    # If today is a weekday, then use more frequent checks.
    if [ $checkDay != 'Sat' ] && [ $checkDay != 'Sun' ]
    then
        # Get the hour.
        checkHour=`date +'%H'`

        # Remove any leading zero.
        checkHour=$(echo $checkHour | sed 's/^0*//')

        # If it is business hours, then use more frequent checks.
        if (( $checkHour >= 9 )) && (( $checkHour <= 18 ))
        then
            # Check every hour.
            sleepSeconds=3600
        else
            # Check every 2 hours.
            sleepSeconds=7200
        fi
    else
        # Weekend. Check every 8 hours.
        sleepSeconds=28800
    fi

    echo "Sleeping for $sleepSeconds seconds."

    # Sleep.
    sleep $sleepSeconds

    logDate=`date +'%m-%d-%Y %r'`

    # Download web page.
    content=$(wget $url -q -O -)
    if [[ $content = "1" ]]
    then
        # Time for a remote reboot.
        message="Remote reboot activated on $logDate. Rebooting in $minutesBeforeReboot minute(s). Response: $content"

        # Remove quotes and special characters.
        message="${message//[\"=&]/}"

        if (( $logLength > 0 ))
        then
            # Record log of remote reboot.
            wget -q -O- --post-data "message=$message" $logglyUrl &> /dev/null
        else
            echo "$message"
        fi

        # Remote reboot (shutdown -c to cancel).
        sudo shutdown -r $minutesBeforeReboot
    else
        # No reboot.
        message="Remote reboot check $logDate. Response: $content"

        # Remove quotes and special characters.
        message="${message//[\"=&]/}"

        if (( $logLength > 0 ))
        then
            # Log message.
            wget -q -O- --post-data "message=$message" $logglyUrl &> /dev/null
        else
            echo "$message"
        fi
    fi
done