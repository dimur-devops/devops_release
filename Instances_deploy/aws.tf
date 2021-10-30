terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
 region = "eu-central-1"
}

resource "aws_instance" "Builder" {
 ami = "ami-05f7491af5eef733a"
 instance_type = "t2.micro"
 key_name = "grad_work_key"
 security_groups = ["AllowAllGroup"]
# associate_public_ip_address = true
 tags = {
    Name = "BuilderBoxFuse"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    agent       = false
    private_key = "${file("~/.ssh/grad_work_key.pem")}"
    host        = aws_instance.Builder.public_ip
  }

  provisioner "remote-exec" {
    inline = [
         "sudo apt update",
         "sudo apt install -y ansible git",
         "git clone https://github.com/dimur-devops/devops_release.git /tmp/devops_release",
         "sudo ansible-playbook /tmp/devops_release/builder/playbook_builder_boxfuse.yml"
    ]
 }
}
