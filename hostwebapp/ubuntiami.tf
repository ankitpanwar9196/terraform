# in these i pick an public ami from my account ami is of ubuntu system and virtulisation is hvm
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # owner id of that ami -- you find all info in ami section
}
output "amiid" {
    value = "${data.aws_ami.ubuntu.id}"
}