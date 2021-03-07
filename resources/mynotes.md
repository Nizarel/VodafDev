Configure a GitHub action to push contqiner to ACR

   1- Create service principal for Azure authentication
       
         groupId=$(az group show --name <resource-group-name> --query id --output tsv) 

      Use az ad sp create-for-rbac to create the service principal:
         az ad sp create-for-rbac --scope $groupId --role Contributor --sdk-auth

    Save the JSON output because it is used in a later step. Also, take note of the clientId, which you need to update the service principal in the next section.

   2- Update service principal for registry authentication

         registryId=$(az acr show --name <resource-group-name> --query id --output tsv)
         
         Assign the AcrPush role, which gives push and pull access to the registry.
           az role assignment create --assignee <ClientId> --scope $registryId --role AcrPush
    
   3- Save credentials to GitHub repo

        In the GitHub UI, navigate to your forked repository and select Settings > Secrets.

        Select Add a new secret to add the following secrets:

            Save credentials to GitHub repo
            Secret 	Value
            AZURE_CREDENTIALS 	The entire JSON output from the service principal creation step
            REGISTRY_LOGIN_SERVER 	The login server name of your registry (all lowercase). Example: myregistry.azurecr.io
            REGISTRY_USERNAME 	The clientId from the JSON output from the service principal creation
            REGISTRY_PASSWORD 	The clientSecret from the JSON output from the service principal creation
            RESOURCE_GROUP 	The name of the resource group you used to scope the service principal
      
