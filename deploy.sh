cd terraform
terraform init
terraform taint 'aws_instance.front.0'
terraform apply -auto-approve
terraform taint 'aws_instance.front.1'
terraform apply -auto-approve

