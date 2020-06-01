provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
  version    = "~>2.43.0"
}

resource "aws_key_pair" "aws-key" {
  key_name   = "aws_key"
  public_key = var.key
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20200430"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "web-1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = var.aws_key_name
  associate_public_ip_address = true
  source_dest_check           = false
  tags = {
    Name = "Backend"
  }

  user_data = data.template_file.init.rendered

}

resource "aws_db_instance" "default" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "11.5"
  instance_class    = "db.t2.micro"
  name              = var.dbname
  username          = var.login
  password          = var.password

  deletion_protection = false
  skip_final_snapshot = true
  tags = {
    Name = "DB"
  }
}

data "template_file" "init" {
  template = file("${path.module}/db.sh")
  vars = {
    login = "${var.login}"
    password = var.password
    address = aws_db_instance.default.address
    dbname = var.dbname
  }
}