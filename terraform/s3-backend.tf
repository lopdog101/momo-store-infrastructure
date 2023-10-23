
terraform {
  # Описание бэкенда хранения состояния
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terraform-state-momo"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = "YCAJERbpbZyDr2fESZfSrzscG"
    secret_key = "YCOlu-KsNCE5eI-YVCqwIKYPiRIVihd2_5R0dpls"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
