terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

# This tells Terraform how to talk to your k3d cluster
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# This is the actual "Resource" we want to create
resource "kubernetes_namespace" "staging" {
  metadata {
    name = "hyderabad-staging"
    labels = {
      env = "staging"
      owner = "ganesh"
    }
  }
}