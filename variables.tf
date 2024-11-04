variable "acr_server" {
  description = "The Azure Container Registry server"
  type        = string
}

variable "acr_username" {
  description = "The Azure Container Registry username"
  type        = string
  sensitive   = true
}

variable "acr_password" {
  description = "The Azure Container Registry password"
  type        = string
  sensitive   = true
}