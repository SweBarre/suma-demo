resource "aws_network_interface" "sles-nic" {
  count = var.sles.count
  subnet_id       = aws_subnet.subnet1.id
  private_ips     = ["10.0.1.2${count.index}"]
  security_groups = [aws_security_group.allow_web.id]
}


resource "aws_eip" "sles" {
  count = var.sles.count
  vpc                       = true
  network_interface         = aws_network_interface.sles-nic[count.index].id
  associate_with_private_ip = "10.0.1.2${count.index}"
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_instance" "sles" {
  count = var.sles.count

  ami = var.sles.ami
  instance_type = "t2.micro"
  availability_zone = format("%s%s", var.region, var.availability_zone)
  key_name=var.keypair
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.sles-nic[count.index].id

  }
  tags={
    Name="sles-${count.index}"
  }
  
}

output "sles_public_ip" {
   value = {
       for instance in aws_instance.sles:
         instance.id => instance.public_ip
   }
  
}