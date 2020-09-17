data "aws_ami" "f5_ami" {
  most_recent = true
  owners      = ["679593333241"]
  filter {
    name   = "name"
    values = [var.f5_ami_search_name]
  }
}

resource "aws_instance" "f5-1" {
  ami           = data.aws_ami.f5_ami.id
  instance_type = "t2.medium"
  key_name = aws_key_pair.demo.key_name
  user_data                   = data.template_file.f5_init.rendered

  root_block_device { delete_on_termination = true }

  network_interface {
    network_interface_id = aws_network_interface.mgmt.id
    device_index = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.public.id
    device_index = 1
  }

  network_interface {
    network_interface_id = aws_network_interface.private.id
    device_index = 2
  }

  provisioner "local-exec" {
    command = "while [[ \"$(curl -skiu admin:${random_string.password.result} https://${self.public_ip}/mgmt/shared/appsvcs/declare | grep -Eoh \"^HTTP/1.1 204\")\" != \"HTTP/1.1 204\" ]]; do sleep 5; done"
  }

  tags = {
    Name = "day1.2-ec2"
  }
}

data "template_file" "f5_init" {
  template = file("../templates/f5_onboard.tmpl")
  vars = {
    password              = random_string.password.result
    doVersion             = "latest"
    #example version:
    #as3Version           = "3.16.0"
    as3Version            = "latest"
    tsVersion             = "latest"
    cfVersion             = "latest"
    fastVersion           = "latest"
    onboard_log           = "/var/log/onboard.log"
  }
}