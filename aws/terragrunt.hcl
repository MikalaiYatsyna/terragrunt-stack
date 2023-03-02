locals {
  stack       = get_env("STACK")
  root_domain = get_env("ROOT_DOMAIN")
  region      = get_env("AWS_REGION")
  domain      = "${local.stack}.${local.root_domain}"
  create_ingress = true

  kubernetes = {
    cluster = {
      source  = "app.terraform.io/logistic/eks/aws"
      version = "0.0.5"
    }
    namespace = {
      source  = "app.terraform.io/logistic/eks-ns/aws"
      version = "0.0.2"
    }
    tools = {
      autoscaler = {
        source  = "/lablabs/eks-cluster-autoscaler/aws"
        version = "2.0.0"
      }
      ingress = {
        source  = "app.terraform.io/logistic/eks-ingress/aws"
        version = "0.0.4"
      }
      consul = {
        source  = "tfr://app.terraform.io/logistic/consul/aws"
        version = "0.0.3"
      }
      vault = {
        source  = "tfr://app.terraform.io/logistic/vault/aws"
        version = "0.0.3"
      }
    }
  }
  network = {
    vpc = {
      source  = "app.terraform.io/logistic/vpc/aws"
      version = "0.0.3"
    }
    zone = {
      source  = "app.terraform.io/logistic/route53/aws"
      version = "0.0.1"
    }
    cloudflare_dns_record = {
      source  = "app.terraform.io/logistic/dns-records/cloudflare"
      version = "0.0.2"
    }
    cloudflare_origin_ca = {
      source  = "app.terraform.io/logistic/origin-ca/cloudflare"
      version = "0.0.1"
    }
  }
}

remote_state {
  backend = "s3"
  config  = {
    region         = local.region
    bucket         = "mikalai-yatsyna-tf-state"
    key            = "${local.stack}/${path_relative_to_include()}.tfstate"
    dynamodb_table = "tf_state_lock"
    encrypt        = true
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
