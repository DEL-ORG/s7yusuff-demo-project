
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config" 
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }
    set {
    name  = "installCRDs"
    value = "true"
  }

  # set {
  #   name  = "fullnameOverride"
  #   value = "argocd"
  # }

  set {
    name  = "crds.keep"
    value = "false"
  }
}

resource "kubernetes_ingress_v1" "argocd" {
  metadata {
    name      = "argocd-ingress"
    namespace = helm_release.argocd.namespace
    annotations = {
      "kubernetes.io/ingress.class" = "alb"
      "alb.ingress.kubernetes.io/group.name" = "argocd" 
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
      "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
    }
  }

  spec {
    ingress_class_name = "alb"  
    default_backend {
      service {
        name = "argocd-server"
        port {
          number = 80 
        }
      }
    }
    rule {
      host = "argocd.thejurist.org.uk"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}


provider "kubernetes" {
  config_path = pathexpand("~/.kube/config")
}

# # provider "helm" {
# #   kubernetes {
# #     config_path = pathexpand("~/.kube/config")
# #   }
# # }
# provider "helm" {
#   kubernetes {
#     host                   = data.aws_eks_cluster.cluster.endpoint
#     token                  = data.aws_eks_cluster_auth.cluster.token
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
#   }
# }

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   token                  = data.aws_eks_cluster_auth.cluster.token
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
# }
# resource "kubernetes_namespace" "argocd" {
#   metadata {
#     # name = "argocd-${var.env}"
#     name = "argocd"
#   }
# }

# resource "helm_release" "argocd" {
#   namespace  = kubernetes_namespace.argocd.metadata[0].name
#   depends_on = [kubernetes_namespace.argocd, helm_release.aws_lb_controller]
#   name       = var.name
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"
#   version    = "5.51.4"
#   create_namespace = true

#   set {
#     name  = "installCRDs"
#     value = "true"
#   }

#   set {
#     name  = "fullnameOverride"
#     value = "argocd"
#   }

#   set {
#     name  = "crds.keep"
#     value = "false"
#   }

#   values = [
#     <<EOF
# server:
#   ingress:
#     enabled: true
#     annotations:
#       kubernetes.io/ingress.class: "alb"
#       alb.ingress.kubernetes.io/scheme: "internet-facing"
#       alb.ingress.kubernetes.io/target-type: "ip"
#       alb.ingress.kubernetes.io/group.name: "argocd"
#       alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
#       alb.ingress.kubernetes.io/ssl-redirect: "443"
#       alb.ingress.kubernetes.io/lb: "dev-jurist-blueops-alb-20441255.us-east-2.elb.amazonaws.com"

#     host: "argocd.thejurist.org.uk"
#     path: "/"
#     pathType: Prefix
#     backend:
#       service:
#         name: argocd-server
#         port:
#           number: 443
# EOF
#   ]

# }


# # resource "kubernetes_manifest" "argocd_app" {
# #   depends_on = [helm_release.argocd]
# #   manifest = yamldecode(file("${path.module}/manifest/app.yml"))
# # }

# # resource "kubernetes_manifest" "argocd_ingress" {
# #   depends_on = [helm_release.argocd]
# #   manifest = yamldecode(file("${path.module}/manifest/argocd-ingress.yml"))
# # }

# # resource "helm_release" "kube_prometheus_stack" {
# #   name       = "kube-prometheus-stack-lts"
# #   repository = "https://prometheus-community.github.io/helm-charts"
# #   chart      = "kube-prometheus-stack"
# #   namespace  = "monitoring"
# #   create_namespace = true
# #     set {
# #     name  = "alertmanager.enabled"
# #     value = "true"
# #   }

# #   set {
# #     name  = "alertmanager.configMapOverrideName"
# #     value = "alertmanager-config"
# #   }
# # }













# # resource "null_resource" "password" {
# #   provisioner "local-exec" {
# #     working_dir = "./argocd"
# #     command     = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d > argocd-login.txt"
# #   }
# # }

# # resource "null_resource" "delete-passwd" {
# #   depends_on = [null_resource.password]
# #   provisioner "local-exec" {
# #     command = "kubectl -n argocd delete secret argocd-initial-admin-secret"
# #   }
# # }


