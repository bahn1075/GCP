terraform {
  backend "gcs" {
    bucket = "cozy-gcp-s2s-terraform-state"
    prefix = "terraform/state"
  }
}