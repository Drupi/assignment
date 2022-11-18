# Assignment

## Terraform Spec

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.43.1 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.7.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.43.1 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.7.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.15.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcp-network"></a> [gcp-network](#module\_gcp-network) | terraform-google-modules/network/google | >= 4.0.1 |
| <a name="module_gke"></a> [gke](#module\_gke) | terraform-google-modules/kubernetes-engine/google | 23.3.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.airflow](https://registry.terraform.io/providers/hashicorp/helm/2.7.1/docs/resources/release) | resource |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/data-sources/client_config) | data source |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/data-sources/project) | data source |
| [kubernetes_service.airflow-webserver](https://registry.terraform.io/providers/hashicorp/kubernetes/2.15.0/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_airflow_password"></a> [airflow\_password](#input\_airflow\_password) | Airflow password | `string` | n/a | yes |
| <a name="input_airflow_username"></a> [airflow\_username](#input\_airflow\_username) | Airflow username | `string` | n/a | yes |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones | `list` | n/a | yes |
| <a name="input_cluter_name"></a> [cluter\_name](#input\_cluter\_name) | GKE cluster name | `string` | n/a | yes |
| <a name="input_ip_range_pods_name"></a> [ip\_range\_pods\_name](#input\_ip\_range\_pods\_name) | GKE cluster ip range pods | `string` | n/a | yes |
| <a name="input_ip_range_services_name"></a> [ip\_range\_services\_name](#input\_ip\_range\_services\_name) | GKE cluster ip range services | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | GKE cluster network | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GKE cluster region | `string` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | GKE cluster subnetwork | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_airflow_access"></a> [airflow\_access](#output\_airflow\_access) | n/a |
| <a name="output_airflow_ip"></a> [airflow\_ip](#output\_airflow\_ip) | n/a |

## How to build GKE cluster with Airflow

 0. Prerequisites

To acomplish every step in this tutorial you have to install following tools:

* helm
* jq
* terraform
* google cloud cli(gcloud)
* ansible

 1. Login to GCP

  ```text
 gcloud login
 gcloud config set project <your_project> (You can list projects using `gcloud projects list`)
 ```

 2. Create GCS bucket using the Google Cloud Deployment Manager resource. I used native GCP tool to provision resources to avoid chicken-egg paradox with terraform.

  ```text
  gcloud deployment-manager deployments create tfstate-bucket --template gcs/bucket.jinja
  ```

 3. Modify config.remote and terraform.tfvars inside config directory

  ```text
  PROJECT_ID=$(gcloud config get-value project)
  PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format=json | jq -re .projectNumber)
  #For MacOs
  sed -i'.bak' "s/__PLACEHOLDER__/statefiles-${PROJECT_NUMBER}-${PROJECT_ID}/g" config/config.remote
  sed -i'.bak' "s/__PLACEHOLDER__/${PROJECT_ID}/g" config/terraform.tfvars
  #For Linux
  sed -i "s/__PLACEHOLDER__/statefiles-${PROJECT_NUMBER}-${PROJECT_ID}/g" config/config.remote
  sed -i "s/__PLACEHOLDER__/${PROJECT_ID}/g" config/terraform.tfvars
  ```

 4. Go to resources catalog
  
  ```text
  cd resources/.
  ```

 5. Run terraform init
  
  ```text
  terraform init --backend-config=../config/config.remote
  ```

 6. Run terraform apply

  ```text
  terraform apply -var-file ../config/terraform.tfvars
  ```

 7. If everything is correct type `yes`

 8. Boom! Your resources are created. Please use URL and User/Pass from terraform output to access Airflow.

 9. Don't forget about the cleanup

 ```text
 terraform destroy -var-file ../config/terraform.tfvars
 ```


## How to execute Ansible Playbook

 1. Generate your service account and create credentials file

 ```text
 cd ansible/.
 PROJECT_ID=$(gcloud config get-value project)
 gcloud iam service-accounts create ansible-compute --description="Ansible" --display-name="ansible-compute"
 gcloud iam service-accounts keys create credentials.json --iam-account=ansible-compute@$PROJECT_ID.iam.gserviceaccount.com
 ```

 2. Add your service account to your project as Compute Admin

 ```text
 PROJECT_ID=$(gcloud config get-value project)
 gcloud projects add-iam-policy-binding $PROJECT_ID --member "serviceAccount:ansible-compute@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/compute.admin"
 ```

 3. Mody cloud-config.yaml to insert your Project ID
 
  ```text
  PROJECT_ID=$(gcloud config get-value project)
  #For MacOs
  sed -i'.bak' "s/__PLACEHOLDER__/${PROJECT_ID}/g" ./cloud-config.yaml
  #For Linux
  sed -i "s/__PLACEHOLDER__/${PROJECT_ID}/g" ./cloud-config.yaml
  ```

 4. Run ansible-playbook

 ```text
 ansible-playbook playbook.yaml
 ```