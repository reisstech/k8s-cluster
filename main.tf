provider "aws" {
  region  = "us-east-1"
}

resource "aws_key_pair" "k8s-key-pair" {
  key_name   = "k8s-key-pair"
  public_key = file("k8s-key-pair.pub")
}

resource "aws_security_group" "k8s-sg" {
  name        = "k8s-sg"
  description = "Allow traffic to the kubernetes cluster instances"

  ingress {
    description = "Traffic to Cluster on port 22/SSH"
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all traffic between the k8s nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "k8s-sg"
  }

}

resource "aws_instance" "k8s-workers" {
  ami                    = "ami-04505e74c0741db8d"
  instance_type          = "t3.small"
  count                  = 2
  key_name               = aws_key_pair.k8s-key-pair.key_name
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]

  tags = {
    Name = "k8s"
    Type = "worker"
  }
}

resource "aws_instance" "k8s-master" {
  ami                    = "ami-04505e74c0741db8d"
  instance_type          = "t3.small"
  key_name               = aws_key_pair.k8s-key-pair.key_name
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]

  tags = {
    Name = "k8s"
    Type = "master"
  }
}
