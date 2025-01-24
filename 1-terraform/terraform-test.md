1. terraform init

2. terraform apply -auto-approve

3. terraform destroy


- terraform init

```
Initializing the backend...
Initializing provider plugins...
- Reusing previous version of hashicorp/google from the dependency lock file
- Using previously-installed hashicorp/google v6.17.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
(base) dataeng@dataeng-virtual-machine:~/projects/zoomcamp/de-2025/homeworks/01
```

- terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.de2025 will be created
  + resource "google_bigquery_dataset" "de2025" {
      + creation_time              = (known after apply)
      + dataset_id                 = "de2025_id"
      + default_collation          = (known after apply)
      + delete_contents_on_destroy = false
      + effective_labels           = {
          + "goog-terraform-provisioned" = "true"
        }
      + etag                       = (known after apply)
      + id                         = (known after apply)
      + is_case_insensitive        = (known after apply)
      + last_modified_time         = (known after apply)
      + location                   = "asia-southeast2"
      + max_time_travel_hours      = (known after apply)
      + project                    = "de-zoomcamp-2025--id"
      + self_link                  = (known after apply)
      + storage_billing_model      = (known after apply)
      + terraform_labels           = {
          + "goog-terraform-provisioned" = "true"
        }

      + access (known after apply)
    }

  # google_storage_bucket.zoomcamp-bucket will be created
  + resource "google_storage_bucket" "zoomcamp-bucket" {
      + effective_labels            = {
          + "goog-terraform-provisioned" = "true"
        }
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "ASIA-SOUTHEAST2"
      + name                        = "de2025_id"
      + project                     = (known after apply)
      + project_number              = (known after apply)
      + public_access_prevention    = (known after apply)
      + rpo                         = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + terraform_labels            = {
          + "goog-terraform-provisioned" = "true"
        }
      + uniform_bucket_level_access = (known after apply)
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type          = "AbortIncompleteMultipartUpload"
                # (1 unchanged attribute hidden)
            }
          + condition {
              + age                    = 1
              + matches_prefix         = []
              + matches_storage_class  = []
              + matches_suffix         = []
              + with_state             = (known after apply)
                # (3 unchanged attributes hidden)
            }
        }

      + soft_delete_policy (known after apply)

      + versioning (known after apply)

      + website (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.
google_bigquery_dataset.de2025: Creating...
google_storage_bucket.zoomcamp-bucket: Creating...
google_storage_bucket.zoomcamp-bucket: Creation complete after 1s [id=de2025_id]
google_bigquery_dataset.de2025: Creation complete after 2s [id=projects/de-zoomcamp-2025--id/datasets/de2025_id]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

-  terraform destroy

```
google_storage_bucket.zoomcamp-bucket: Refreshing state... [id=de2025_id]
google_bigquery_dataset.de2025: Refreshing state... [id=projects/de-zoomcamp-2025--id/datasets/de2025_id]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # google_bigquery_dataset.de2025 will be destroyed
  - resource "google_bigquery_dataset" "de2025" {
      - creation_time                   = 1737712229319 -> null
      - dataset_id                      = "de2025_id" -> null
      - default_partition_expiration_ms = 0 -> null
      - default_table_expiration_ms     = 0 -> null
      - delete_contents_on_destroy      = false -> null
      - effective_labels                = {
          - "goog-terraform-provisioned" = "true"
        } -> null
      - etag                            = "A8W2DAF3jEzwPnRWDbMCqQ==" -> null
      - id                              = "projects/de-zoomcamp-2025--id/datasets/de2025_id" -> null
      - is_case_insensitive             = false -> null
      - labels                          = {} -> null
      - last_modified_time              = 1737712229319 -> null
      - location                        = "asia-southeast2" -> null
      - max_time_travel_hours           = "168" -> null
      - project                         = "de-zoomcamp-2025--id" -> null
      - resource_tags                   = {} -> null
      - self_link                       = "https://bigquery.googleapis.com/bigquery/v2/projects/de-zoomcamp-2025--id/datasets/de2025_id" -> null
      - terraform_labels                = {
          - "goog-terraform-provisioned" = "true"
        } -> null
        # (4 unchanged attributes hidden)

      - access {
          - role           = "OWNER" -> null
          - user_by_email  = "sa-de-zoomcamp-2025@de-zoomcamp-2025--id.iam.gserviceaccount.com" -> null
            # (4 unchanged attributes hidden)
        }
      - access {
          - role           = "OWNER" -> null
          - special_group  = "projectOwners" -> null
            # (4 unchanged attributes hidden)
        }
      - access {
          - role           = "READER" -> null
          - special_group  = "projectReaders" -> null
            # (4 unchanged attributes hidden)
        }
      - access {
          - role           = "WRITER" -> null
          - special_group  = "projectWriters" -> null
            # (4 unchanged attributes hidden)
        }
    }

  # google_storage_bucket.zoomcamp-bucket will be destroyed
  - resource "google_storage_bucket" "zoomcamp-bucket" {
      - default_event_based_hold    = false -> null
      - effective_labels            = {
          - "goog-terraform-provisioned" = "true"
        } -> null
      - enable_object_retention     = false -> null
      - force_destroy               = true -> null
      - id                          = "de2025_id" -> null
      - labels                      = {} -> null
      - location                    = "ASIA-SOUTHEAST2" -> null
      - name                        = "de2025_id" -> null
      - project                     = "de-zoomcamp-2025--id" -> null
      - project_number              = 549786364154 -> null
      - public_access_prevention    = "inherited" -> null
      - requester_pays              = false -> null
      - self_link                   = "https://www.googleapis.com/storage/v1/b/de2025_id" -> null
      - storage_class               = "STANDARD" -> null
      - terraform_labels            = {
          - "goog-terraform-provisioned" = "true"
        } -> null
      - uniform_bucket_level_access = false -> null
      - url                         = "gs://de2025_id" -> null

      - hierarchical_namespace {
          - enabled = false -> null
        }

      - lifecycle_rule {
          - action {
              - type          = "AbortIncompleteMultipartUpload" -> null
                # (1 unchanged attribute hidden)
            }
          - condition {
              - age                                     = 1 -> null
              - days_since_custom_time                  = 0 -> null
              - days_since_noncurrent_time              = 0 -> null
              - matches_prefix                          = [] -> null
              - matches_storage_class                   = [] -> null
              - matches_suffix                          = [] -> null
              - num_newer_versions                      = 0 -> null
              - send_age_if_zero                        = false -> null
              - send_days_since_custom_time_if_zero     = false -> null
              - send_days_since_noncurrent_time_if_zero = false -> null
              - send_num_newer_versions_if_zero         = false -> null
              - with_state                              = "ANY" -> null
                # (3 unchanged attributes hidden)
            }
        }

      - soft_delete_policy {
          - effective_time             = "2025-01-24T09:50:29.507Z" -> null
          - retention_duration_seconds = 604800 -> null
        }
    }

Plan: 0 to add, 0 to change, 2 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

google_storage_bucket.zoomcamp-bucket: Destroying... [id=de2025_id]
google_bigquery_dataset.de2025: Destroying... [id=projects/de-zoomcamp-2025--id/datasets/de2025_id]
google_storage_bucket.zoomcamp-bucket: Destruction complete after 1s
google_bigquery_dataset.de2025: Destruction complete after 3s

Destroy complete! Resources: 2 destroyed.
```
