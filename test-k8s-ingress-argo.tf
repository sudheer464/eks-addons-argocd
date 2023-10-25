resource "kubernetes_ingress_v1" "ingress1" {
  wait_for_load_balancer = true
  
  metadata {
    name = "simple-fanout-ingress1"
    namespace = "argocd"
    annotations = {
       "cert-manager.io/cluster-issuer": "argocd-issuer-argocd-letsencrypt"
       "kubernetes.io/tls-acme": "true"
       "nginx.ingress.kubernetes.io/ssl-passthrough": "true"
       "nginx.ingress.kubernetes.io/backend-protocol": "HTTPS"
     #  "nginx.ingress.kubernetes.io/rewrite-target": "/argocd"
       #"nginx.ingress.kubernetes.io/use-regex": "true"
       # "nginx.ingress.kubernetes.io/app-root": "/argo"
   

    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = "ad9ed3cd74d0e427db1392d19a434535-b0c8e2e043e09312.elb.us-east-1.amazonaws.com"
      http {
        path {
          backend {
            service {
              name = "argo-cd-argocd-server"
              port {
                number = 443
              }
            }
          }


          path = "/"
        }
        }
      }
    #   tls {
    #   secret_name = "argocd-secret"
    # #  hosts = ["ad9ed3cd74d0e427db1392d19a434535-b0c8e2e043e09312.elb.us-east-1.amazonaws.com"]
      
    # }
    }

  }
