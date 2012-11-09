#!/bin/bash
sshcommand="/usr/bin/ssh"
options=""
host=""
remotecommand=""
hostsfile="myhosts"
wasoption=0

for arg in "$@"; do
        if [ -z "$host" ]; then
                echo "$arg" | grep "^-" > /dev/null
                if [ $? -eq 0 ]; then
                        options="$options $arg"
                        wasoption=1
                else
                        if [ $wasoption -ne 0 ]; then
                                options="$options $arg"
                                wasoption=0
                        else
                                host="$arg"
                        fi
                fi
        else
                remotecommand="$remotecommand $arg"
        fi
done

echo "$host" | grep "@" > /dev/null
if [ $? -eq 0 ]; then
        user=`echo "$host" | cut -d"@" -f 1`
        host=`echo "$host" | cut -d"@" -f 2`
fi

ip=`grep -i "$host" $hostsfile | cut -d";" -f 2`
if [ -n "$ip" ]; then
        host=$ip
fi

if [ -n "$user" ]; then
        host="$user@$host"
fi

$sshcommand $options $host $remotecommand
