variable "credentials" {
  description = "My Credentials"
  default     = "./de-zoomcamp-2025--id-48710e324a17.json"
}

variable "project" {
  description = "Project"
  default     = "de-zoomcamp-2025--id"
}

variable "region" {
  description = "Region"
  default     = "ASIA"
}

variable "location" {
  description = "Project Location"
  default     = "asia-southeast2"
}

variable "bucket_name" {
  description = "Storage Bucket Name"
  default     = "de2025_id"
}

variable "gcs_storage_class" {
  description = "Backet Storage Class"
  default     = "STANDARD"
}

variable "bigquery_dataset" {
  description = "BigQuery Dataset Name"
  default     = "de2025_id"
}
