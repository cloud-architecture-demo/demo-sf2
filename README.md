# Demo SF-2

This repo contains reference architecture expressed with infrastructure/configuration as code to observe BizDevOps workflows, in a cloud native environment.

The architecture in this demo utilizes [Google Cloud Platform](https://cloud.google.com/) [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/) as the **Core Infrastructure Layer**.


For the **Infrastructure Application Layer**, we will be utilizing [Anthos Config Management](https://cloud.google.com/anthos/config-management/), which requires that the ACM [ConfigSync Operator](https://cloud.google.com/anthos-config-management/docs/config-sync-overview) to be installed in the cluster. 
Additionally, the [Jenkins Kubernetes Operator](https://github.com/jenkinsci/kubernetes-operator) and the [Configuration as Code plugin](https://github.com/jenkinsci/configuration-as-code-plugin) are used to automate the configuration of each CI/CD Pipeline.

Finally, in the **Business Application Layer**, we are using the [sock-shop demo, from Weaveworks](https://microservices-demo.github.io/).

<br>

<br>

---

<br>

##### Dependencies:

For this guide you will need to install the following dependencies:

1. git: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
2. Terraform: https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started
3. gcloud cli: https://cloud.google.com/sdk/docs/install
4. kubectl: https://kubernetes.io/docs/tasks/tools/
5. If you are using Windows, it is suggested to install git for windows instead: https://gitforwindows.org/

   > Don't forget to make sure that the path to your git, terraform, aws and kubectl binaries are in the $PATH. i.e. `export PATH=$PATH:/path/to/binaries/`


<br>


##### Deploy:
Step 1: Clone the demo code:
```
git clone https://github.com/cloud-architecture-demo/demo-sf2.git
```

<br>

Step 2: Change directories into the code directory.
```
cd ./demo-sf2
```

<br>

Step 3. You will need to copy the file `secrets.tfvars.example` and name it `secrets.tfvars`. Be sure to replace the default values with those relevant to you.

```
## GKE architecture demo sf2 secrets
billing_account = "012ABC-345DEF-678GHI"
```
> Change the value of **_billing_account_** to match your own Google Cloud Platform Billing Account ID.
>> If you aren't sure what your Google Cloud Platform Billing Account ID is, you can run the following gcloud command to display it:
>> ```
>> gcloud beta billing accounts list
>> ```

<br>

Step 4: Authenticate your local gcloud client with Google Cloud Platform APIs.

>Follow the official documentation to set this up, here:
> https://cloud.google.com/sdk/gcloud/reference/auth/login

<br>


Step 5: Deploy demo-sf2 to Google Cloud Platform

Run the following commands in the order listed, one at a time.
```
terraform init .
terraform plan -var-file secrets.tfvars
terraform apply -var-file secrets.tfvars
```
> Enter "yes" when prompted.

<br>

Step 6: Use gcloud cli to update kubeconfig with the new GKE control Plane credentials for this cluster.
```
gcloud container clusters get-credentials demo-sf2 --region us-central1 --project=<GCP_PROJECT_ID>
```
> NOTE: 
>
> Change the value of **_<GCP_PROJECT_ID>_** to match your own Google GCP **_Project ID_**.
> 
>> If you aren't sure what your GCP Project ID is, you can run the following gcloud command to display it:
>> ```
>> gcloud projects list | grep demosf2 | awk -F ' ' '{ print $1 }'
>> ```

<br>


Step 7: Use kubectl to display the IP address of the sock-shop's front-end loadbalancer.
```
kubectl -n sock-shop get service front-end
```
> Once the address is displayed, you can copy it into a browser window and observe the sock-shop UI on port `80`.
>

<br>


Step 8: Use kubectl to display the IP address of the Jenkins CI/CD Server's loadbalancer.
```
kubectl get service jenkins-operator-http-prod-jenkins
```
> Once the address is displayed, you can copy it into a browser window and observe the Jenkins CI/CD Server's UI on port `8080`.
>

<br>


Step 9: Use kubectl to display the `jenkins-operator` user's password to log into the Jenkins CI/CD Server.
```
kubectl get service jenkins-operator-http-prod-jenkins
```


<br>

At this point, your demo should be deployed and the access information displayed on your terminal screen. Congrats!

> NOTE: 
>
> When deploying Jenkins or the Sock Shop app, please be patient while the automation stands them up, they might not yet be ready to start accepting connections. If you are browsing for them and the application doesn't seem to be available, wait a minute for the containers to deploy fully, then refresh your browser page.

<br>

> NOTE: 
>
> Container build pipelines in the Jenkins CICD server are configured to publish images to the docker **Artifact Registry** that was created by terraform, in the `demosf2` GCP project.
>> 
>> You should be able to list the details about the Sock Shop docker registry by running the following gcloud command:
>> ```
>> gcloud artifacts repositories list --project $(gcloud projects list | grep demosf2 | awk -F ' ' '{ print $1 }')
>> ```

<br>

##### Destroy:
Step 1: Change directories into the code directory.
```
cd ./demo-sf2
```

<br>


Step 2: Authenticate your local gcloud client with Google Cloud Platform APIs.

>Follow the official documentation to set this up, here:
> https://cloud.google.com/sdk/gcloud/reference/auth/login

<br>

Step 3: Destroy demo-sf2.
```
terraform destroy -var-file secrets.tfvars
```

<br>

<br>

---

<br>


##### Additional Resources:

- [Anthos Config Management](https://cloud.google.com/anthos/config-management)
- [Get started with Anthos Config Management](https://cloud.google.com/anthos-config-management/docs/tutorials/get-started)
- [Config Sync overview](https://cloud.google.com/anthos-config-management/docs/config-sync-overview)
- [Install Config Sync](https://cloud.google.com/anthos-config-management/docs/how-to/installing-config-sync)

##### Videos:
- [What is Anthos?](https://youtu.be/Qtwt7QcW4J8)
- [An introduction to Anthos (Google Cloud Community Day ‘19)](https://youtu.be/42RmVrM7B7E)
<br>

<br>

---

<br>