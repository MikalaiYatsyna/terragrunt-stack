include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr://${include.root.locals.kubernetes.tools.autoscaler.source}//.?version=${include.root.locals.kubernetes.tools.autoscaler.version}"
}

dependency "cluster" {
  config_path = "${get_repo_root()}/aws/kubernetes/cluster"
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    data "aws_eks_cluster" "this" {
      name = "${dependency.cluster.outputs.cluster_name}"
    }

    data "aws_eks_cluster_auth" "this" {
      name = "${dependency.cluster.outputs.cluster_name}"
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
  cluster_name                     = dependency.cluster.outputs.cluster_name
  cluster_identity_oidc_issuer     = dependency.cluster.outputs.oidc_provider
  cluster_identity_oidc_issuer_arn = dependency.cluster.outputs.oidc_provider_arn
}
