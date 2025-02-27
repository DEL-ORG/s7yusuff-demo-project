# resource "helm_release" "aws_lb_controller" {
#   name       = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   force_update = true
#   # replace = true
#   set {
#     name  = "clusterName"
#     value = var.cluster_name
#   }
#     set {
#     name  = "crds.keep"
#     value = "false"
#   }
#       set {
#     name  = "ingressClass"
#     value = "alb"
#   }
#   # set {
#   #   name  = "serviceAccount.create"
#   #   value = "false"
#   # }
#   # set {
#   #   name  = "serviceAccount.name"
#   #   value = "aws-load-balancer-controller"
#   # }
#   #   set {
#   #   name  = "ingressClassParams.create"
#   #   value = "false"
#   # }
# }

resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
  set {
    name  = "image.repository"
    value = var.ecr-lb
  }
  # # set {
  # #   name  = "serviceAccount.create"
  # #   value = "false"
  # # }

  # set {
  #   name  = "serviceAccount.name"
  #   value = "aws-load-balancer-controller"
  # }
}
