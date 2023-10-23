terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.87.0"
    }
  }
}

provider "yandex" {
  cloud_id  = "b1g8tnrko4q1emhf9mqk"
  folder_id = "b1g10hb6v5a9qe3ut7na"
  zone      = "ru-central1-a"
 }