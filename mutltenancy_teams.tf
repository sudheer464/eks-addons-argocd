module "development_team" {
  source = "aws-ia/eks-blueprints-teams/aws"

  for_each = {
    one = {
      # Add any additional variables here and update definition below to use
      users = ["arn:aws:iam::869336279370:role/test1"] 
    }
    two = {
      users = ["arn:aws:iam::869336279370:role/test2"]
    }
    three = {
      users = ["arn:aws:iam::869336279370:role/test3"]
    }
  }

  name = "${each.key}-team"

  users             = each.value.users
  cluster_arn       = module.eks_blueprints.eks_cluster_arn
  oidc_provider_arn = module.eks_blueprints.eks_oidc_provider_arn
  # Labels applied to all Kubernetes resources
  # More specific labels can be applied to individual resources under `namespaces` below
  labels = {
    team = each.key
  }

  # Annotations applied to all Kubernetes resources
  # More specific labels can be applied to individual resources under `namespaces` below
  annotations = {
    team = each.key
  }

  namespaces = {
    (each.key) = {
      labels = {
        projectName = "project-test",
      }

      resource_quota = {
        hard = {
          "requests.cpu"    = "1000m",
          "requests.memory" = "4Gi",
          "limits.cpu"      = "2000m",
          "limits.memory"   = "8Gi",
          "pods"            = "10",
          "secrets"         = "10",
          "services"        = "10"
        }
      }

      limit_range = {
        limit = [
          {
            type = "Pod"
            max = {
              cpu    = "200m"
              memory = "1Gi"
            }
          },
          {
            type = "PersistentVolumeClaim"
            min = {
              storage = "24M"
            }
          },
          {
            type = "Container"
            default = {
              cpu    = "50m"
              memory = "24Mi"
            }
          }
        ]
      }
    }
  }

  tags = {
    Environment = "dev"
  }
}