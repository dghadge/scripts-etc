#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Enter stack-name to create"
    exit 0
fi

aws cloudformation create-stack --stack-name $1 --template-body file://codebuild-cpl-cd-cc.json --parameters file://codebuild-cpl-cd-cc-parameters.json --region us-east-1 --capabilities="CAPABILITY_IAM"
