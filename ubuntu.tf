resource "aws_network_interface" "ubuntu-nic" {
  count = var.ubuntu.count
  subnet_id       = aws_subnet.subnet1.id
  private_ips     = ["10.0.1.1${count.index}"]
  security_groups = [aws_security_group.allow_web.id]
}


resource "aws_eip" "ubuntu" {
  count = var.ubuntu.count
  vpc                       = true
  network_interface         = aws_network_interface.ubuntu-nic[count.index].id
  associate_with_private_ip = "10.0.1.1${count.index}"
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_instance" "ubuntu" {
  count = var.ubuntu.count

  ami = var.ubuntu.ami
  instance_type = "t2.micro"
  availability_zone = format("%s%s", var.region, var.availability_zone)
  key_name=var.keypair
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.ubuntu-nic[count.index].id

  }
  tags={
    Name="ubuntu-${count.index}"
  }
  
}

output "ubuntu_public_ip" {
   value = {
       for instance in aws_instance.ubuntu:
         instance.id => instance.public_ip
   }
  
}