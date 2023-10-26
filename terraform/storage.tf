/*
resource "yandex_iam_service_account" "sa-storage" {
  name = "sa-storage"
  description = "Service account for S3 storage. Terraform created"
}

resource "yandex_resourcemanager_folder_iam_binding" "storage-admin" {
  folder_id = "b1g8tnrko4q1emhf9mqk"
  role = "storage.admin"
  members = [ "serviceAccount:${yandex_iam_service_account.sa-storage.id}" ]
}

resource "yandex_iam_service_account_static_access_key" "sa-storage-static-key" {
  service_account_id = yandex_iam_service_account.sa-storage.id
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "momo-store" {
  access_key = yandex_iam_service_account_static_access_key.sa-storage-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-storage-static-key.secret_key
  bucket = "momo-store-static"
  anonymous_access_flags {
    read = true
    list = false
  }
  max_size = 52428800

}

resource "yandex_storage_object" "image" {
  access_key = yandex_iam_service_account_static_access_key.sa-storage-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-storage-static-key.secret_key
  count = 14
  bucket = "momo-store-static"
  key    = "${count.index + 1}.jpg"
  source = "images/${count.index + 1}.jpg"
}

*/