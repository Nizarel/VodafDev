
  

# Terraform basics

  

This repository contains an example on how to set up an Azure APIM CI/CD pipeline using Terraform.
[Blog Post](https://kub.nizare.biz/api)

### Running this example

  1. Install terraform https://learn.hashicorp.com/tutorials/terraform/install-cli

  2. Log in to Azure through the console: https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell
  
    az login
    az account set --subscription={YourSubscriptionId} # If you need to select multiple accounts

  3. Initialize terraform

    terraform init

  4. Change the apim_name under the main.tfvars to ensure you have a unique APIM name.

  5. Run a plan to check what is going to happen

    terraform plan -var-file="main.tfvars"

  6. Try to apply:

    terraform apply -var-file="main.tfvars"


**If you were setting up terraform from scratch:**

After the Terraform init:

  1. create main.tf with:

    provider "azurerm" {    
	    version = "=2.46.0"	    
	    features {}  
    }


    provider "azurerm" {
    features {}
    }

    terraform plan
    
    terraform apply
  

### Destroy the environment
    terraform destroy
  
