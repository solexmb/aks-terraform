### Provision AKS with Terraform

#### Configure environment - Prerequisite
* Azure subscription
* Azure CLI
* Configure Terraform
* Clone the git repo 

#### Create a service principle account 
* https://docs.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure#create-a-service-principal

Ensure to run the following command from Azure CLI and make note of the appId, display_name, password, and tenant.
```
 $ az ad sp create-for-rbac --name <service_principal_name> --role Contributor --scopes /subscriptions/<subscription_id>
```

 replace the <service-principal-name> and <subscription_id>

Service principal object ID -- Run the following command to get the object ID of the service principal:
Replace <display_name> with the service principal name
```
 $ az ad sp list --display-name "<display_name>" --query "[].{\"Object ID\":objectId}" --output table
```
#### Configure Azure storage to store Terraform state
* https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-cli 
 ```
 $ az group create --name storage-resource-group-tf --location eastus

 $ az storage account create --name <account-name> --resource-group storage-resource-group-tf --location eastus --sku Standard_RAGRS --kind StorageV2
```
* Browse to the Azure portal

* Under Azure services, select Storage accounts. (If the Storage accounts option isn't visible on the main page, select More services to locate the option.)

* On the Storage accounts page, select the storage account where Terraform will store the state information.

* On the Storage account page, in the left menu, in the Security + networking section, select Access keys.

* On the Access keys page, select Show keys to display the key values.

* Locate the key1 key on the page and select the icon to its right to copy the key value to the clipboard.
 From a command line prompt, run az storage container create. This command creates a container in your Azure storage account. Replace the placeholders with the appropriate values for your Azure storage account.
 ```
 $ az storage container create -n tfstate --account-name <storage_account_name> --account-key <storage_account_key>
```
* When the command successfully completes, it displays a JSON block with a key of "created" and a value of true. You can also run az storage container list to verify the container was successfully created.
```
 $ az storage container list --account-name <storage_account_name> --account-key <storage_account_key>
```
Set "aks_service_principal_app_id", "aks_service_principal_client_secret", "azure_subscription_id" and "azure_subscription_tenant_id" as environmental variable in bash

Edit the ~/.bashrc file by adding the following environment variables.
```
 $ vim ~/.bashrc

export TF_VAR_ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export TF_VAR_ARM_TENANT_ID="<azure_subscription_tenant_id>"
export TF_VAR_ARM_CLIENT_ID="<service_principal_appid>"
export TF_VAR_ARM_CLIENT_SECRET="<service_principal_password>"
```
To execute the ~/.bashrc script, run source ~/.bashrc (or its abbreviated equivalent . ~/.bashrc). 
 ```
 $ source ~/.bashrc
```
Verify the configured environmental variable
 ```
 $ printenv | grep ^TF_VAR_*
```
Change directory into the cloned repo
``` 
 $ terraform init
 $ terraform plan
 $ terraform apply
```
Get the resource group name.
``` 
 $ echo "$(terraform output resource_group_name)"
```
Get the Kubernetes configuration from the Terraform state and store it in a file that kubectl can read
``` 
 $ echo "$(terraform output kube_config)" > ./azurek8s
```
Edit the content of azurek8s and remove the << EOT at the beginning and EOT at the end

Set an environment variable so that kubectl picks up the correct config.
``` 
 $ export KUBECONFIG=./azurek8s
```
or copy/move the content of azurek8s to .kube/config

