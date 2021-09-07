provider "aws" {
  region = "us-east-1"
}

module "genpact-poc-vpc" {
  source               = "./modules/vpc/"
  vpc_cidr             = "192.168.0.0/26"
  public_subnet_cidr   = "192.168.0.0/28"
  private_subnet_cidr  = "192.168.0.16/28"
  public_subnet_cidr1  = "192.168.0.32/28"
  private_subnet_cidr1 = "192.168.0.48/28"
}
module "genpact-poc-bastion_host" {
  source          = "./modules/ec2/bastion_host/"
  depends_on = ["module.genpact-poc-sg"]
  ami_id          = "ami-087c17d1fe0178315"
  instance_type   = "t2.micro"
  SecurityGroupID = [module.genpact-poc-sg.bastionHost, module.genpact-poc-sg.InternalSG]
  subnetID        = module.genpact-poc-vpc.PublicSubnetID
  instance_name   = "PoC-BastionHost"
  BastionUser = "${file("install_userdata.sh")}"
  publicfile  = "${path.module}/credentials/Public_key.pub"
  privatefile = "${path.module}/credentials/Private_key.txt"
}
module "genpact-poc-ec2-WebSerer" {
  source          = "./modules/ec2/"
  depends_on = ["module.genpact-poc-sg"]
  ami_id          = "ami-087c17d1fe0178315"
  instance_type   = "t2.micro"
  SecurityGroupID = [module.genpact-poc-sg.WebServerSG,module.genpact-poc-sg.InternalSG]
  subnetID        = module.genpact-poc-vpc.PrivateSubnetID
  instance_name   = "PoC-WebSerer"
}
module "genpact-poc-ec2-App-Server" {
  source          = "./modules/ec2/"
  depends_on = ["module.genpact-poc-sg"]
  ami_id          = "ami-087c17d1fe0178315"
  instance_type   = "t2.micro"
  SecurityGroupID = [module.genpact-poc-sg.InternalSG]
  subnetID        = module.genpact-poc-vpc.PrivateSubnetID
  instance_name   = "PoC-AppServer"
}
module "genpact-poc-database" {
  source         = "./modules/rds/"
  rds_subnet_ids = [module.genpact-poc-vpc.PrivateSubnetID, module.genpact-poc-vpc.PrivateSubnetID, module.genpact-poc-vpc.PrivateSubnetID1, module.genpact-poc-vpc.PrivateSubnetID1]
}
module "genpact-poc-sg" {
  source         = "./modules/sg/"
  myvpcid          =  module.genpact-poc-vpc.vpcID
}
