module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.32.1"

  cluster_name    = "sandeep-test"
  cluster_version = "1.25"
  enable_irsa     = true


  vpc_id = "vpc-0fc5e0fecca0a340a"

  private_subnet_ids = [ "subnet-0cabb1bb89f2c48e2", "subnet-02f3bbb343e0568fe" ]
  

  managed_node_groups = {
    role = {
      capacity_type   = "ON_DEMAND"
      node_group_name = "general"
      instance_types  = ["m4.xlarge"]
      desired_size    = "2"
      max_size        = "3"
      min_size        = "1"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks_blueprints.eks_cluster_id]
  }
}
