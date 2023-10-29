terraform {
  required_version = ">= 1.3"
  required_providers {
    yandex = {
      version = ">= 0.85"
      source  = "yandex-cloud/yandex"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terraform-state-momo"
    region     = "ru-central1"
    key        = "terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
  
}