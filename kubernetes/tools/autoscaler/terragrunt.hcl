locals {
  env          = read_terragrunt_config("${get_repo_root()}/${get_env("PROVIDER")}_env.hcl")
  cluster_name = "${local.env.locals.stack}-eks"
}

terraform {
  source = "${local.env.locals.kubernetes.tools.autoscaler.source}//.?version=${local.env.locals.kubernetes.tools.autoscaler.version}"
}

dependency "kubernetes_cluster" {
  config_path = "${get_repo_root()}/kubernetes/cluster"
}

include {
  path = find_in_parent_folders()
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    data "aws_eks_cluster" "this" {
      name = "${local.env.locals.stack}-eks"
    }

    data "aws_eks_cluster_auth" "this" {
      name = "${local.env.locals.stack}-eks"
    }

    provider "helm" {
      kubernetes {
        host                   = data.aws_eks_cluster.this.endpoint
        token                  = data.aws_eks_cluster_auth.this.token
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
      }
    }
  EOF
}

inputs = {
  cluster_name                     = local.cluster_name
  cluster_identity_oidc_issuer     = dependency.kubernetes_cluster.outputs.oidc_provider
  cluster_identity_oidc_issuer_arn = dependency.kubernetes_cluster.outputs.oidc_provider_arn
}
