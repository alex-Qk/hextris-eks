module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.6"

  cluster_name                    = var.name
  cluster_version                 = var.cluster_version
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false
  authentication_mode             = "API"

  #   access_entries = {
  #     example = {
  #       kubernetes_groups = []
  #       principal_arn     = "arn:aws:iam::123456789012:role/something"

  #       policy_associations = {
  #         example = {
  #           policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  #           access_scope = {
  #             namespaces = ["default"]
  #             type       = "namespace"
  #           }
  #         }
  #       }
  #     }
  #   }

  cloudwatch_log_group_retention_in_days = 14
  cluster_enabled_log_types = [
    "audit",
    "authenticator"
  ]

  create_kms_key = true

  cluster_service_ipv4_cidr = "172.30.0.0/16"
  vpc_id                    = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids                = data.terraform_remote_state.vpc.outputs.private_subnets
  control_plane_subnet_ids  = data.terraform_remote_state.vpc.outputs.intra_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
    block_device_mappings = [
      {
        device_name = "/dev/xvdb"
        ebs = {
          volume_size           = 40
          volume_type           = "gp3"
          throughput            = 125
          encrypted             = true
          delete_on_termination = true
        }
      }
    ]
    iam_role_additional_policies = {
      additional = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
    create_launch_template     = true
    iam_role_attach_cni_policy = true
    launch_template_name       = ""
    platform                   = "linux"
    update_config = {
      max_unavailable = 1
    }
  }

  node_security_group_additional_rules = {
    all_node_to_node_ingress = {
      description = "Allow node-to-node ingress"
      protocol    = "tcp"
      from_port   = 0
      to_port     = 65535
      type        = "ingress"
      self        = true
    },
    local_network_ingress = {
      description = "Local network ingress"
      protocol    = "tcp"
      from_port   = 0
      to_port     = 65535
      type        = "ingress"
      cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
    }
  }

  eks_managed_node_groups = local.eks_managed_node_groups["common"]

  #   cluster_addons = {
  #     aws-ebs-csi-driver = {
  #       resolve_conflicts        = "OVERWRITE"
  #       service_account_role_arn = module.aws_ebs_csi_role.iam_role_arn
  #     }
  #   }

  tags = local.tags
}

resource "aws_autoscaling_group_tag" "cluster_autoscaler_label_tags" {
  for_each = local.cluster_autoscaler_asg_tags

  autoscaling_group_name = each.value.autoscaling_group

  tag {
    key                 = each.value.key
    value               = each.value.value
    propagate_at_launch = each.value.propagate_at_launch
  }
}
