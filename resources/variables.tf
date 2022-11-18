variable "project_id" {
  type = string
  description = "GCP project ID"
}

variable "cluter_name" {
  type = string
  description = "GKE cluster name"
}

variable "region" {
  type = string
  description = "GKE cluster region"
}

variable "availability_zones" {
  type = list
  description = "List of availability zones"
}

variable "network" {
  type = string
  description = "GKE cluster network"
}

variable "subnetwork" {
  type = string
  description = "GKE cluster subnetwork"
}

variable "ip_range_pods_name" {
  type = string
  description = "GKE cluster ip range pods"
}

variable "ip_range_services_name" {
  type = string
  description = "GKE cluster ip range services"
}

variable "airflow_username" {
  type = string
  description = "Airflow username"
}

variable "airflow_password" {
  type = string
  description = "Airflow password"
}
