module "aws_load_balancer_controller_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.52.2"

  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("${path.module}/aws_load_balancer_controller_policy.json")
  tags   = local.tags
}

module "cluster_autoscaler_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.52.2"

  name   = "cluster-autoscaler-${var.name}"
  policy = data.aws_iam_policy_document.cluster_autoscaler_policy.json
  tags   = local.tags
}

data "aws_iam_policy_document" "cluster_autoscaler_policy" {
  statement {
    sid = "AutoscalingRead"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeTags",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions"
    ]
    resources = ["*"]
  }

  statement {
    sid = "AutoscalingModify"
    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeImages",
      "ec2:GetInstanceTypesFromInstanceRequirements",
      "eks:DescribeNodegroup"
    ]
    resources = ["*"]
  }
}
