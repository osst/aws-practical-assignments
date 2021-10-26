#!/bin/bash

export AWS_DEFAULT_REGION=us-west-2

aws dynamodb list-tables

aws dynamodb put-item --table-name "Cars" --item '{ "VIN": {"S": "DJF345"}, "Make": {"S": "Skoda"} }'

aws dynamodb get-item --table-name "Cars" --key  '{ "VIN": {"S": "DJF345"} }'


