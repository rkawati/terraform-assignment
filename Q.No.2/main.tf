resource "aws_instance" "project_user" {
  ami           = var.ami
  instance_type = var.type

  tags = {

    Name = "user"
  }
}
resource "aws_eip" "eip_user" {
  instance = aws_instance.project_user.id
  domain   = "vpc"
}
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.project_user.id
  allocation_id = aws_eip.eip_user.id
}