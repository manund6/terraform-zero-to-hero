provider "aws" {
  region = "ap-south-1"
}

# EC2 Instance
resource "aws_instance" "app" {
  ami                    = "ami-05e00961530ae1b55"
  instance_type          = "t2.micro"
  key_name               = "gitlab"
  security_group_ids     = [my_group]
  associate_public_ip_address = true

  user_data              = file("${path.module}/../scripts/bootstrap.sh")

  tags = {
    Name = "app-instance"
  }

  provisioner "local-exec" {
    command = "sleep 120 && ansible-playbook -i ../ansible/inventory.ini ../ansible/playbook.yml"
  }
}

output "instance_ip" {
  value = aws_instance.app.public_ip
}