
module "kubernetes-addons" {
   source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"
   eks_cluster_id = module.eks_blueprints.eks_cluster_id
   enable_kubernetes_dashboard = true
   enable_ingress_nginx = true
   ingress_nginx_helm_config = {
    name          = "ingress-nginx"
    chart_version = "4.1.4"
    repository    = "https://kubernetes.github.io/ingress-nginx"
    namespace     = "ingress-nginx"
    values        = [templatefile("values.yml", {})]
  }
  # enable_aws_load_balancer_controller = true
    # ArgoCD addon
  #  enable_argocd         = true
  #  argocd_applications = {
  #    workloads  = {
  #      repo_url = "https://github.com/askulkarni2/eks-blueprints-workloads.git"
  #      path = "envs/dev"
  #      values = {
  #        spec = {
  #          ingress = {
  #            host = module.eks_blueprints.eks_cluster_endpoint
  #          }
  #        }
  #      }
  #    }
  #  }
  # argocd_manage_add_ons = true


  # argocd_helm_config = {
  #   set = [
  #     {
  #       name  = "server.service.type"
  #       value = "LoadBalancer"
  #     }
  #   ]
  # }

}

module "eks_blueprints_addons" {
 
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0" #ensure to update this to the latest/desired version


  cluster_name      = module.eks_blueprints.eks_cluster_id
  cluster_endpoint  = module.eks_blueprints.eks_cluster_endpoint
  cluster_version   = module.eks_blueprints.eks_cluster_version
  oidc_provider_arn = module.eks_blueprints.eks_oidc_provider_arn

  # enable_aws_load_balancer_controller = true

  enable_metrics_server = true
  enable_cert_manager   = true
  enable_karpenter = true
  enable_argocd = true
  # enable_ingress_nginx =  true

 
}

provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks_blueprints.eks_cluster_id]
    }
  }

 }


