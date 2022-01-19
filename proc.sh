#!/bin/bash

# A
number_of_processes="${1}"
# whoami returns the username that invoked the script
curr_user=$(whoami)
echo "I'm ${curr_user}"

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

# B
curr_process=0
proccesses_list=()
while [[ ${curr_process} -lt ${number_of_processes} ]]; do
       sleep 3600 &
       processes_list+=($!)
       curr_process=$(( ${curr_process} + 1 ))
done

# C
processes_from_ps=$(ps axo comm,pid,user | grep "^sleep.*${curr_user}" | awk '{print $2}')

# Calculate the diff between two arrays
echo ${processes_list[@]} ${processes_from_ps[@]} | tr ' ' '\n' | sort | uniq -u
echo "Killing processes ${processes_list[@]}"
kill -9 ${processes_list}

# Bonus D
adduser linuxtestuser --gecos "" --disabled-password &>/dev/null || true
curr_process=0
while [[ ${curr_process} -lt ${number_of_processes} ]]; do
       su linuxtestuser -c "echo 'this is a test'"
       curr_process=$(( ${curr_process} + 1 ))
       echo ${curr_process}
done

echo "Done"
