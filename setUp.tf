# pull access and ecret keys from local .txt files && adjust the region
provider "aws" {
  access_key = "${file("accesskey.txt")}"
  secret_key = "${file("privatekey.txt")}"
  region     = "us-east-2"
}

# add key public and private pairs to prpgram
# resource "aws_key_pair" "masterkey" {
#   key_name   = "p2"
#   public_key = file("p2.pub")
# }

# add security group so we can ssh from any machine
resource "aws_security_group" "SSH" {
  description = "Allows ALL SSH traffic"
  name = "proj2"

  ingress {
    from_port   = 0 
    to_port     = 0
    protocol =   "-1"

    cidr_blocks =  ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# assign an static ip to the naster ec2 instance
resource "aws_eip" "ip" {
    vpc = true
    instance = aws_instance.master.id
}

#initialize master node
resource "aws_instance" "master" {
  key_name      = "myMac"
  ami           = "ami-0fc20dd1da406780b"
  instance_type = "t2.micro"
#   vpc_security_group_ids = ["sg-0486c4fafee3d49d5"]
#   subnet_id = "subnet-cb27d2a0"

# create security group to be able to ssh
  security_groups = [aws_security_group.SSH.name]

# establish ssh connection to machine + change out username to 'golorado'
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("myMac.pem")}" 
    host        = self.public_ip
  }

# script file to run inside our machine
  provisioner "file" {
    source      = "masterNode/masterSetup.sh"
    destination = "/tmp/masterSetup.sh"
  }

# terraform file for master
  provisioner "file" {
    source      = "setUp.tf"
    destination = "/home/ubuntu/terraform/setUp.tf"
  }

# save ip address of instance in a txt file to save to our machine
  provisioner "local-exec" {
    command = "echo ${aws_instance.master.public_ip} > ip_address.txt"
  }

# run these commands inside our instance
  provisioner "remote-exec" {
    inline = [
      "sudo /bin/bash /tmp/masterSetup.sh",
     
    ]
  }

}




