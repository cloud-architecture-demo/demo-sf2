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