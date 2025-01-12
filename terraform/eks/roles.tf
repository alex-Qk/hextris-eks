module "aws_load_balancer_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.52.2"

  role_name = "AmazonEKSLoadBalancerControllerRole"

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  role_policy_arns = {
    alb-ingress = module.aws_load_balancer_controller_policy.arn
  }

  tags = local.tags
}

module "aws_ebs_csi_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.52.2"

  role_name = "aws-ebs-csi-role-${var.name}"

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  role_policy_arns = {
    ebs-csi = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  }

  tags = local.tags
}

module "cluster_autoscaler_role" {
  source     = "terraform-aws-modules/iam/aws//modules/iam-eks-role"
  version    = "5.52.2"
  depends_on = [module.eks]

  role_name = "cluster-autoscaler-${var.name}"

  cluster_service_accounts = {
    (var.name) = ["kube-system:cluster-autoscaler"]
  }

  role_policy_arns = {
    cluster-autoscaler = module.cluster_autoscaler_policy.arn
  }
}
