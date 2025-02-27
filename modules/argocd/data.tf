# data "kubernetes_secret" "argocd_admin" {
#   metadata {
#     name      = "argocd-initial-admin-secret"
#     namespace = kubernetes_namespace.argocd.metadata[0].name
#   }

#   depends_on = [helm_release.argocd] 
# }
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}
data "aws_lb" "alb" {
  name = "dev-jurist-blueops-alb" 
}