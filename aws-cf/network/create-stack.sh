#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Enter stack-name to create"
    exit 0
fi

aws cloudformation create-stack --stack-name $1 --template-body file://network.json --parameters file://network-parameters.json --capabilities CAPABILITY_IAM
