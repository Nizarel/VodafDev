variable "resource_group_name" {
    type        = string
    description = "RG name in Azure"
}

variable "resource_group_location" {
    type        = string
    description = "RG location in Azure"
}

variable "apim_name" {
  type        = string
  description = "API Management Name"
  }

variable "api_name" {
  type        = string
  description = "Default API Name"
  }

variable "api_path" {
  type        = string
  description = "Default API Path"
  }

variable "api_url" {
  type        = string
  description = "Default API URL"
  }