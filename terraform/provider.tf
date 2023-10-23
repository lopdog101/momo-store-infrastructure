# Провайдер это инструмент, который превращает наши terraform файлы (.tf кстати) в инструкции для конкретного облачного сервиса. 
#Для инициализации провайдера может понадобится VPN.

provider "yandex" {
  cloud_id  = "b1glnhfo1pb5aqli71pj"
  folder_id = "b1g8tnrko4q1emhf9mqk"
  zone      = "ru-central1-a"
 }
 
 