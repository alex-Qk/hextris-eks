resource "aws_key_pair" "kubernetes" {
  key_name   = "kubernetes-training"
  public_key = var.kubernetes_public_key

  tags = local.tags
}
