provider "google" {
  credentials = file(var.credentials)  
  project     = var.project  
  region      = var.region  
}

resource "google_storage_bucket" "zoomcamp-bucket" {
  name          = var.bucket_name
  location      = var.location
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "de2025" {
  dataset_id = var.bigquery_dataset
  location   = var.location
}