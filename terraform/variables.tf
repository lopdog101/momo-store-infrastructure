variable "cloud_id" {
  type        = string
  description = "virtual cloud id"
  nullable    = false
}

variable "folder_id" {
  type        = string
  description = "id of the folder in cloud"
  nullable    = false
}

variable "zone" {
  type        = string
  description = "geo zone id"
  nullable    = false
}