### Variables
variable db_storage {
  default = "20"
}

variable db_engine {
  default = "mariadb"
}

variable db_instance_type {
  default = "db.t2.micro"
}

variable db_user {
  default = "admin"
}

variable db_password {
  default = "crimson42"
}

# The name of the database is already in the snapshot
variable db_snapshot {
  default = "arn:aws:rds:eu-west-2:235960612000:snapshot:training42-final-snapshot"
}

### Resources
resource "aws_db_subnet_group" "mysql" {
  # TO DO
  # see https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html
  name       = "dbsngcrashcourse"
  subnet_ids = ["${aws_subnet.private.*.id}"]

  tags {
    Name = "dbsngcrashcourse"
  }
}

resource "aws_db_instance" "mysql" {
  # TO DO
  # see https://www.terraform.io/docs/providers/aws/r/db_instance.html
  #llocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "${var.db_engine}"
  engine_version         = "10.1.26"
  instance_class         = "${var.db_instance_type}"
  name                   = "training42"
  username               = "${var.db_user}"
  password               = "${var.db_password}"
  db_subnet_group_name   = "${aws_db_subnet_group.mysql.id}"
  snapshot_identifier    = "${var.db_snapshot}"
  vpc_security_group_ids = ["${aws_security_group.mysql.id}"]
}

### Outputs
output "mysql_host" {
  value = "${aws_db_instance.mysql.address}"
}

output "mysql_db" {
  value = "${aws_db_instance.mysql.address}"
}

output "mysql_user" {
  value = "${var.db_user}"
}

output "mysql_password" {
  value = "${var.db_password}"
}
