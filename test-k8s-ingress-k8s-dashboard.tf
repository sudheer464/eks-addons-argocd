# resource "kubernetes_ingress_v1" "ingress2" {
#   wait_for_load_balancer = true
  
#   metadata {
#     name = "simple-fanout-ingress2"
#     namespace = "kubernetes-dashboard"
#     labels = {
#       "app.kubernetes.io/name" = "kubernetes-dashboard"
#     }
#     annotations = {
#        "nginx.ingress.kubernetes.io/force-ssl-redirect": "true"
#        "nginx.ingress.kubernetes.io/backend-protocol": "HTTP"
#     }
#   }

#   spec {
#     ingress_class_name = "nginx"

#     rule {
#       host = "ad9ed3cd74d0e427db1392d19a434535-b0c8e2e043e09312.elb.us-east-1.amazonaws.com"
#       http {
#         path {
#           backend {
#             service {
#               name = "kubernetes-dashboard"
#               port {
#                 number = 80
#               }
#             }
          
#           }
#         path = "/"
#         }
#       }
      
#      }
#     }

#   }


