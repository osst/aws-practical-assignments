#!/bin/bash
echo "Demo file" > os-textfile.txt
aws s3 mb s3://ostasenko-training-bucket
aws s3api put-bucket-versioning --bucket ostasenko-training-bucket --versioning-configuration Status=Enabled
aws s3 cp os-textfile.txt s3://ostasenko-training-bucket

