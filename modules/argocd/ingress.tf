

# resource "kubernetes_ingress_v1" "argocd" {
#   metadata {
#     name      = "argocd-ingress"
#     namespace = helm_release.argocd.namespace
#     annotations = {
#       "kubernetes.io/ingress.class" = "alb"
#       "alb.ingress.kubernetes.io/group.name" = data.aws_lb.alb.dns_name  
#       "alb.ingress.kubernetes.io/scheme" = "internet-facing"
#       "alb.ingress.kubernetes.io/target-type" = "ip"
#     }
#   }

#   spec {
#     rule {
#       host = "argocd.${var.domain_name}"
#       http {
#         path {
#           path     = "/"
#           path_type = "Prefix"
#           backend {
#             service {
#               name = "argocd-server"
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }



# resource "kubernetes_ingress_v1" "argocd" {
#   metadata {
#     name      = "argocd"
#     namespace = "argocd"
#     annotations = {
#       "kubernetes.io/ingress.class" = "alb"
#       "alb.ingress.kubernetes.io/scheme" = "internet-facing"
#       "alb.ingress.kubernetes.io/target-type" = "ip"
#       "alb.ingress.kubernetes.io/group.name" = "argocd"
#       "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
#       "alb.ingress.kubernetes.io/ssl-redirect" = "443"
#       "alb.ingress.kubernetes.io/lb" = data.aws_lb.alb.dns_name
#     }
#   }

#   spec {
#     rule {
#       host = "argocd.${var.domain_name}"
#       http {
#         path {
#           path = "/"
#           path_type = "Prefix"  # Required for AWS ALB
#           backend {
#             service {
#               name = "argocd-server"
#               port {
#                 number = 443  # Ensure HTTPS traffic
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }


# Ingress for Grafana
# resource "kubernetes_ingress_v1" "grafana" {
#   metadata {
#     name      = "grafana"
#     namespace = "monitoring"
#     annotations = {
#       "kubernetes.io/ingress.class" = "alb"
#       "alb.ingress.kubernetes.io/scheme" = "internet-facing"
#       "alb.ingress.kubernetes.io/target-type" = "ip"
#       "alb.ingress.kubernetes.io/group.name" = "monitoring"
#       "alb.ingress.kubernetes.io/load-balancer-name" = data.aws_lb.alb.dns_name
#     }
#   }

#   spec {
#     rule {
#       host = "grafana.${var.domain_name}"
#       http {
#         path {
#           path = "/"
#           backend {
#             service {
#               name = "prometheus-grafana"
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }
