resource "aws_iam_role" "nodes" {
  name = format("%s-%s-%s-nodegroup-role", var.common_tags["environment"], var.common_tags["owner"], var.common_tags["project"])

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_policy" "node-group-ClusterAutoscalerPolicy" {
  name = format("%s-%s-%s-cluster-auto-scaler-policy", var.common_tags["environment"], var.common_tags["owner"], var.common_tags["project"])

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ClusterAutoscalerPolicy" {
  policy_arn = aws_iam_policy.node-group-ClusterAutoscalerPolicy.arn
  role       = aws_iam_role.nodes.name
}
resource "aws_iam_policy" "external_dns_policy" {
  name = format("%s-%s-%s-external-dns-policy", var.common_tags["environment"], var.common_tags["owner"], var.common_tags["project"])
  

  policy = jsonencode({
    Version = "2012-10-17"
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets"
        ],
        "Resource" : [
          "arn:aws:route53:::hostedzone/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "dns" {
  policy_arn = aws_iam_policy.external_dns_policy.arn
  role       = aws_iam_role.nodes.name
}
resource "aws_iam_policy" "acm_policy" {
  name = format("%s-%s-%s-acm-policy", var.common_tags["environment"], var.common_tags["owner"], var.common_tags["project"])

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "acm:ListCertificates",
          "acm:DescribeCertificate",
          "acm:GetCertificate"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "acm" {
  policy_arn = aws_iam_policy.acm_policy.arn
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  policy_arn = "arn:aws:iam::494597675232:policy/AWSLoadBalancerControllerIAMPolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "elb" {
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
  role       = aws_iam_role.nodes.name
}
# resource "aws_iam_policy" "alb_additional_permissions" {
#   name        = "ALBAdditionalPermissions"
#   description = "Additional permissions for ALB"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "ec2:DescribeAvailabilityZones",
#           "ec2:DescribeSubnets",
#           "elasticloadbalancing:DescribeLoadBalancers",
#           "elasticloadbalancing:DescribeTargetGroupAttributes",
#           "elasticloadbalancing:DescribeListeners",
#           "elasticloadbalancing:DescribeRules",
#           "elasticloadbalancing:DescribeTags"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }
# resource "aws_iam_role_policy_attachment" "alb_additional" {
#   policy_arn = aws_iam_policy.alb_additional_permissions.arn
#   role       = aws_iam_role.nodes.name
# }
# resource "aws_iam_role_policy_attachment" "ec2_describe_access" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
#   role       = aws_iam_role.nodes.name
# }
