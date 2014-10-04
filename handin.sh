#!/bin/bash

# Mr. Anderson's Web Handin-friendly Makefile Accompaniment
# Clemson University
# ama2@clemson.edu
# https://gist.github.com/ProtractorNinja/9e72377b349a19ec6ed7
#
# This script generates a handin repo SSH URL similar to the following:
# ssh://handin@handin.cs.clemson.edu/1401/cpsc3600-001/assignments/DNSQ/ama2
# ...given appropriate settings. By default it's set up for Dr. Malloy's
# CPSC 4160 and Dr. Sorber's CPSC 3600.
# 
# To add a new class, go to web handin and copy the first and second URL
# subdirectories (in the example above: `1401/cpsc3600-001`) into a new
# array entry like the ones in lines 21 - 22.

# Creates an associative array (like a map) for current classes.
declare -A classes
classes[sorber]="1408/cpsc3220-001"

# Bad argument count? Print out usage instructions.
if [[ ! $# -eq 3 ]]; then
    echo "Usage: $0 <username> <class> <project name>"
    echo "Available classes are: "
    for k in "${!classes[@]}"; do
        echo -e "\t$k"
    done
    exit 1
fi

# Variable-ize arguments in case of future
username=$1
class=$2
project=$3

# Assert your class argument is actually in the array
if [[ -z "${classes[${class}]}" ]]; then
    echo "You need to add ${class} to the classes array first."
    exit 1
fi 

# And finally print
url="ssh://handin@handin.cs.clemson.edu"
echo $url/${classes[${class}]}/assignments/${project}/${username}
