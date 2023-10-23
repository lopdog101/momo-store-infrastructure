#variable "token" {
#  description = "user token"
#  sensitive = true
#  nullable  = false
#}

variable "cloud_id" {
  type        = string
  description = "virtual cloud id"
  default     = "b1glnhfo1pb5aqli71pj"
  nullable    = false
}

variable "folder_id" {
  type        = string
  description = "id of the folder in cloud"
  default     = "b1g8tnrko4q1emhf9mqk"
  nullable    = false
}

variable "zone" {
  type        = string
  description = "geo zone id"
  default     = "ru-central1-a"
  nullable    = false
}