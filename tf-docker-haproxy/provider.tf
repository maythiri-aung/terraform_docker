terraform {
  required_version = ">= 1.1.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker" # provider source
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}
