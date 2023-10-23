# Описание версии Terraform и версии провайдера yandex-cloud/yandex, необходимых для root модуля 

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.13"
    }
  }

# Описание бэкенда хранения состояния
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terraform-state-sergeylysyuk"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = "YCAJEHPIMhhF5jfsUWwxh3bgx"
    secret_key = "YCNNB-ji8UORnn6yMymMiqCRxkYSn0-3cPiwupZL"

    skip_region_validation      = true
    skip_credentials_validation = true
  }

}