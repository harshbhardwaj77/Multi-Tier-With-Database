variable "project_id" {
  description = "solutions-engineering-312710"
  type        = string
}

variable "service_account_key_file" {
  description = "Path to the service account key file"
  type        = string
}


variable "region" {
  description = "The region for GCP resources"
  type        = string
}

variable "zone" {
  description = "The zone for GCP resources"
  type        = string
}

variable "sonar-zone" {
  description = "The zone for GCP resources"
  type        = string
}


variable "k8s_location" {
  description = "The zone for GCP resources"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the instance"
  type        = string
}

