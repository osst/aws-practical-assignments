#!/bin/bash

aws s3 mb s3://ostasenko-training-bucket
aws s3 cp rds-script.sql s3://ostasenko-training-bucket
aws s3 cp dynamodb-script.sh s3://ostasenko-training-bucket
