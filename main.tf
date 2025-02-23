terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "gcp-s2s"
  region  = "us-central1"
}

# 🎯 GCS 버킷 생성 (Terraform 상태 저장)
resource "google_storage_bucket" "terraform_state" {
  name          = "gcp-s2s-terraform-state"
  location      = "us-central1"
  storage_class = "STANDARD"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 90
    }
  }

  force_destroy = false
}

# 🎯 Firestore 데이터베이스 (Terraform Locking)
resource "google_firestore_database" "terraform_lock" {
  project     = "gcp-s2s"
  name        = "(default)"
  location_id = "us-central1"
  type        = "NATIVE"
}

# 🎯 Firestore 컬렉션(테이블) 생성
resource "google_firestore_document" "terraform_lock_doc" {
  project     = "gcp-s2s"
  database    = google_firestore_database.terraform_lock.name
  collection  = "terraform-lock"
  document_id = "state-lock"

  fields = <<EOT
{
  "lock": {"stringValue": ""}
}
EOT
}
