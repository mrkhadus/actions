terraform {
  required_version = ">= 1.15.0"  
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "1.16.0"
    }
  }
}

provider "azuredevops" {
  org_service_url = "https://dev.azure.com/hrishikeshdherange"
}


resource "azuredevops_project" "test" {
  name = "demo-tflint"
  visibility         = "private2" # added 2 intentionally for tflint to find out
  version_control    = "Git"
  work_item_template = "Agile"
  description        = "Managed by Terraform"
  features = {
    testplans = "disabled"
    artifacts = "disabled"
  }
}
