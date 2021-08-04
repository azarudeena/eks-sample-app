
resource "aws_key_pair" "deployer" {
  key_name   = var.cluster-name
  public_key = file("~/.ssh/id_rsa.pub")
}