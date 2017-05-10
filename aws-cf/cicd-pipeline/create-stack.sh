#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Enter stack-name to create"
    exit 0
fi

aws cloudformation create-stack --stack-name $1 --template-body file://codepipeline-with-cc-cb-cd-steps.json --parameters file://codepipeline-with-cc-cb-cd-steps-parameters.json --region us-east-1 --capabilities="CAPABILITY_IAM"
