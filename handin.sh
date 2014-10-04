#!/bin/bash

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
