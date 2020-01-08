terraform {
  required_version = "0.12.13"
}

provider "google" {
  credentials = file(var.path_for_credentials_file)

  version = "~> 2.18.0"

  project = var.project_id
  region  = var.region
}
