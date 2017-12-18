### Shared variables
variable project_name {
  default = "devops-crashcourse"
}

terraform {
  backend "s3" {
    bucket = "cc42-tfstate"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}

