terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "datadog_agent_not_running_in_kubernetes_cluster" {
  source    = "./modules/datadog_agent_not_running_in_kubernetes_cluster"

  providers = {
    shoreline = shoreline
  }
}