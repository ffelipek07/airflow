data "aws_availability_zones" "available" {}



################################################################################
# EC2 Module
################################################################################

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.0"

  name = local.name

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small" # used to set core count below
  availability_zone      = element(module.vpc.azs, 0)
  subnet_id              = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [module.security_group.security_group_id]
#  placement_group        = aws_placement_group.web.id
  create_eip             = false
  disable_api_stop       = false

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  # only one of these can be enabled at a time
  hibernation = false
  # enclave_options_enabled = true

  #user_data_base64            = base64encode(local.user_data)
  user_data_base64            = filebase64("ec2_setup.sh")
  user_data_replace_on_change = true

  key_name = module.key_pair.key_pair_name

#  cpu_options = {
#    core_count       = 2
#    threads_per_core = 1
#  }
#  enable_volume_tags = false
#  root_block_device = [
#    {
#      encrypted   = true
#      volume_type = "gp3"
#      throughput  = 200
#      volume_size = 50
#      tags = {
#        Name = "my-root-block"
#      }
#    },
#  ]
#
#  ebs_block_device = [
#    {
#      device_name = "/dev/sdf"
#      volume_type = "gp3"
#      volume_size = 5
#      throughput  = 200
#      encrypted   = true
#      kms_key_id  = aws_kms_key.this.arn
#      tags = {
#        MountPoint = "/mnt/data"
#      }
#    }
#  ]

  tags = local.tags
}


################################################################################
# Supporting Resources
################################################################################



data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]
  name_regex  = "ubuntu"

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


resource "aws_placement_group" "web" {
  name     = local.name
  strategy = "cluster"
}
#
#resource "aws_kms_key" "this" {
#}
#
#resource "aws_network_interface" "this" {
#  subnet_id = element(module.vpc.private_subnets, 0)
#}