cd terraform
mkdir -p ~/.ssh
echo $id_rsa > ~/.ssh/id_rsa.42.pub
terraform init
terraform taint 'aws_instance.front.0'
terraform apply -auto-approve
terraform taint 'aws_instance.front.1'
terraform apply -auto-approve

