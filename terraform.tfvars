region = "us-east-1"
availability_zone = "a"
vpc_cidr="10.0.0.0/16"
subnet_cidr="10.0.1.0/24"
keypair="sumademo"


sles = {
    count = 3
    ami = "ami-04625ec1368bfcad1"
}

ubuntu = {
    count = 2
    ami = "ami-04505e74c0741db8d"
}
