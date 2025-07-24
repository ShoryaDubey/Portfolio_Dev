data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  
}

data "vault_generic_secret" "example" {
  path = "ssh_ip/dev_ssh_ips"
}

resource "aws_security_group" "instance_sg" {
  name_prefix = "instance-sg"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  from_port   = var.ssh_port
  to_port     = var.ssh_port
  protocol    = "tcp"
  cidr_blocks = [data.vault_generic_secret.example.data["dev"]]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                         = "ami-0cbbe2c6a1bb2ad63"
  instance_type               = "t2.micro"
  key_name                    = "testing-key" 
  monitoring                  = true
  associate_public_ip_address = true

  vpc_security_group_ids      = [aws_security_group.instance_sg.id] 

  tags = {
    Name = "MyWebInstance"
  }

 connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("~/.ssh/testing-key.pem")
    host     = self.public_ip
  }

  provisioner "file" {
    source = "flask-app"
    destination = "/home/ubuntu/flask-app/"
  }

  provisioner "remote-exec" {
    inline = [ 
      "sudo apt update",
      "sudo apt install -y python3-flask",
      "sudo apt install -y gunicorn",
      "gunicorn app:app --bind 0.0.0.0:8000"
     ]
  }
}
