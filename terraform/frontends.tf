### Variables
variable db_name {
  default = "training42"
}

variable front_instance_number {
  default = "2"
}

variable front_ami {
  default = "ami-fcc4db98" # Ubuntu 16.04
}

variable front_instance_type {
  default = "t2.micro"
}

variable front_elb_port {
  default = "80"
}

variable front_elb_protocol {
  default = "http"
}

### Resources
resource "aws_key_pair" "front" {
  key_name   = "${var.project_name}-front"
  public_key = "${file("~/.ssh/id_rsa.42.pub")}"
}

data "template_file" "userdata" {
  template = "${file("files/userdata.sh")}"

  vars {
    DBHOST     = "${aws_db_instance.mysql.address}"
    DATABASE   = "${var.db_name}"
    DBUSER     = "${var.db_user}"
    DBPASSWORD = "${var.db_password}"
  }
}

resource "aws_instance" "front" {
  # TO DO
  # see https://www.terraform.io/docs/providers/aws/r/instance.html
  count                  = "${var.front_instance_number}"
  ami                    = "${var.front_ami}"
  instance_type          = "${var.front_instance_type}"
  key_name               = "${var.project_name}-front"
  subnet_id              = "${element(aws_subnet.public.*.id, count.index % length(aws_subnet.public.*.id))}"
  vpc_security_group_ids = ["${aws_security_group.front.id}"]
  user_data              = "${data.template_file.userdata.rendered}"

  tags {
    Name = "front${count.index}"
  }
}

resource "aws_elb" "front" {
  # TO DO
  # see https://www.terraform.io/docs/providers/aws/r/elb.html
  name            = "${var.project_name}-elb"
  subnets         = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    target              = "HTTP:8080/"
    interval            = 5
  }
  instances = ["${aws_instance.front.*.id}"]
}

### Outputs
output "elb_endpoint" {
  # TO DO
  # see https://www.terraform.io/intro/getting-started/outputs.html
  value = "${aws_elb.front.dns_name}"
}

output "instance_ip" {
  value = "${aws_instance.front.*.public_ip}"
}
