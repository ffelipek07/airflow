resource "tls_private_key" "ec2_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
module "key_pair" {
  source     = "terraform-aws-modules/key-pair/aws"
  key_name   = "ec2_${basename(path.cwd)}_access_user_key"
  public_key = tls_private_key.ec2_private_key.public_key_openssh
}