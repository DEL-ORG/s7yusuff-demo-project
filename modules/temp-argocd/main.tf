provider "kubernetes" {
  config_path = pathexpand("~/.kube/config")
}
provider "helm" {
  kubernetes {
    config_path = pathexpand("~/.kube/config")
  }
}

resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  set {
    name  = "clusterName"
    value = "dev-jurist-blueops-control-plane"
  }
}

# Install ArgoCD
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true
}

resource "kubernetes_ingress_v1" "argocd_ingress" {
  metadata {
    name      = "argocd-ingress"
    namespace = "argocd"
annotations = {
  "alb.ingress.kubernetes.io/scheme" = "internet-facing"
  "alb.ingress.kubernetes.io/group.name" = "argocd-ingress"
  "alb.ingress.kubernetes.io/target-type" = "ip"
  "alb.ingress.kubernetes.io/healthcheck-path" = "/"
  "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\":80},{\"HTTPS\":443}]"
  "alb.ingress.kubernetes.io/ssl-redirect" = "true"
  "external-dns.alpha.kubernetes.io/hostname" = "argocd.thejurist.org.uk"
  "kubernetes.io/ingress.class" = "alb"
}

  }
  spec {
    ingress_class_name = "alb"
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
                number = 443
              }
            }
          }
        }
      }
    }
  }
}

resource "aws_route53_record" "argocd_dns" {
  zone_id = "Z10133933QJB0LVB8X0ER"  
  name    = "argocd.thejurist.org.uk"
  type    = "CNAME"
  ttl     = 300
  records = ["dev-jurist-blueops-alb-312631591.us-east-2.elb.amazonaws.com"]
}
