# Описание версии Terraform и версии провайдера yandex-cloud/yandex, необходимых для root модуля 

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.13"
    }
  }
}
