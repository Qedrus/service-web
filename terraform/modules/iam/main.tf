resource "aws_iam_policy" "eks_cluster_policy" {
  name        = "EKSClusterPolicy"
  description = "Permissions pour la gestion du cluster EKS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "iam:PassRole",
          "eks:CreateCluster",
          "eks:DescribeCluster",
          "eks:DeleteCluster",
          "eks:UpdateClusterConfig"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_attach" {
  role       = "eks_cluster_role" # Utilise le nom du rôle existant
  policy_arn = aws_iam_policy.eks_cluster_policy.arn
}
