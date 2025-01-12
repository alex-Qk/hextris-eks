locals {

  eks_managed_node_groups = {
    common = merge(
      {
        for index, subnet_id in data.terraform_remote_state.vpc.outputs.private_subnets :
        "core-${index}" => {
          min_size       = 1
          max_size       = 2
          desired_size   = 1
          key_name       = aws_key_pair.kubernetes.key_name
          instance_types = ["t2.medium"]
          capacity_type  = "SPOT"
          metadata_options = {
            "http_endpoint" : "enabled",
            "http_put_response_hop_limit" : 1,
            "http_tokens" : "optional"
          }
          labels = {
            "cluster"   = var.name
            "dedicated" = "core"
          }
          subnet_ids = [subnet_id]
        }
      },
      {
        "hextris" = {
          min_size       = 1
          max_size       = 2
          desired_size   = 1
          key_name       = aws_key_pair.kubernetes.key_name
          instance_types = ["t2.medium"]
          capacity_type  = "SPOT"
          metadata_options = {
            "http_endpoint" : "enabled",
            "http_put_response_hop_limit" : 1,
            "http_tokens" : "optional"
          }
          labels = {
            "cluster" = var.name
            "service" = "hextris"
          }
          taints = {
            dedicated = {
              key    = "dedicated"
              value  = "hextris"
              effect = "NO_SCHEDULE"
            }
          }
          subnet_ids = [data.terraform_remote_state.vpc.outputs.private_subnets[0]]
        }
      }
    )
  }

  tags = {
    ManagedBy = "Terraform"
  }

  #-------- ASG TAGS ----------------

  cluster_autoscaler_label_tags = merge([
    for name, group in module.eks.eks_managed_node_groups : {
      for label_name, label_value in coalesce(group.node_group_labels, {}) : "${name}|label|${label_name}" => {
        autoscaling_group   = group.node_group_autoscaling_group_names[0],
        key                 = "k8s.io/cluster-autoscaler/node-template/label/${label_name}",
        value               = label_value,
        propagate_at_launch = false
      }
    }
  ]...)

  cluster_autoscaler_taint_tags = merge([
    for name, group in module.eks.eks_managed_node_groups : {
      for taint in coalesce(group.node_group_taints, []) : "${name}|taint|${taint.key}" => {
        autoscaling_group   = group.node_group_autoscaling_group_names[0],
        key                 = "k8s.io/cluster-autoscaler/node-template/taint/${taint.key}"
        value               = "${taint.value}:${taint.effect}",
        propagate_at_launch = false
      }
    }
  ]...)

  asg_default_tags = merge([
    for name, group in module.eks.eks_managed_node_groups : {
      for key, val in local.tags : "${name}|tag|${key}" => {
        autoscaling_group   = group.node_group_autoscaling_group_names[0],
        key                 = key
        value               = val,
        propagate_at_launch = true
      }
    }
  ]...)

  cluster_autoscaler_asg_tags = merge(
    local.cluster_autoscaler_label_tags,
    local.cluster_autoscaler_taint_tags,
    local.asg_default_tags
  )

}
