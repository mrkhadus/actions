terraform {
  required_version = ">= 1.5.0"
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
  name               = "demo-tflint"
  visibility         = "private" # added 2 intentionally for tflint to find out - there's no official plugin for azure devops for tf lint can't
  version_control    = "Git"
  work_item_template = "Agile"
  description        = "Managed by Terraform"
  features = {
    testplans = "disabled"
    artifacts = "disabled"
  }
}

resource "azuredevops_git_repository" "repo" {
  project_id = azuredevops_project.test.id
  name       = "demo-repo"
  initialization {
    init_type = "Clean"
  }
}

# Branch policy enforcing pull requests with minimum 1 reviewer on main branch, blocking direct pushes
resource "azuredevops_branch_policy_min_reviewers" "block_direct_push_main" {
  project_id = azuredevops_project.test.id

  enabled  = true
  blocking = true

  settings {
    reviewer_count     = 1
    submitter_can_vote = false

    scope {
      repository_id  = azuredevops_git_repository.repo.id
      repository_ref = "refs/heads/main"
      match_type     = "Exact"
    }
  }
}

