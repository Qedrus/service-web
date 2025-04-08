resource "aws_key_pair" "eks_keypair" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "local_file" "private_key" {
  filename = "${path.module}/${var.key_name}.pem"
  content  = file(var.private_key_path)
}
