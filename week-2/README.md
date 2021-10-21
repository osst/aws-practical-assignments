To create resources run:
```
terraform apply
```

To destroy resources run:
```
terraform destroy
```

To override default variable values create a `terraform.tfvars` file and specify values there:
```
s3_bucket_name = "aws-training-bucket"
ec2_ami = "ami-0c2d06d50ce30b442"
```