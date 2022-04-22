# Dockercoins

This is the demo application originally used in Jérôme Petazzoni's [orchestration workshop](https://github.com/jpetazzo/container.training).

[Kubernetes Hands-on Workshop](https://training.play-with-kubernetes.com/kubernetes-workshop/)
```
rng = web service generating random bytes
hasher = web service computing hash of POSTed data
worker = background process using rng and hasher
webui = web interface to watch progress
```

```
The ultimate result (Webui service)
```

<img width="404" alt="Result" src="https://user-images.githubusercontent.com/57577628/164680453-28d07882-a76f-4692-b8d4-c841e1afa40f.PNG">

```
Infrastructure
```
Terraform used to create the infrastracture.
There are 2 type of infrastructure:
k8s: this one is working correctly, the k8s is based on Azure as AKS and there is an ACR as Docker images repositories.
For monitoring, i used Prometheus, Grafana and Thanos, they are configured, for example Prometheus already configured to scrape metrics from my nodes and more, there are also an existing dashboards on Grafana, Thanos is configured also to store data on an existing azure account storage.

App services: this one is uncomplete, i created this it juste to do a POC and practice my knowldege by deploying microservice app as app services and Azure Functions, it lacks of a private network for the backend services to work correctly.
rng = App service
hasher = Azure Function
worker = App service
webui = App service

```
Pipelines
```
![image](https://user-images.githubusercontent.com/57577628/164688316-fcdd655c-0587-4a32-814a-2a7c62981b27.png)


```
Coninues intégration
```

Tool used for the CI/CD: Azure DevOps.

![image](https://user-images.githubusercontent.com/57577628/164684698-40d87f06-e700-4ed7-a9c2-f6036154cf7e.png)

During the continuos integration, i build the docker images and push them to the ACR, i also tested RNG code by adding test task, then the tests results are pushed to the Azure DevOps pipeline :

![image](https://user-images.githubusercontent.com/57577628/164685758-34251c6d-a1ad-4acd-9253-c7c100a2779f.png)

SonarCloud is used to do static scan for our microservice app, and you need to create an account to attach it with Azure DevOps

```
Coninues deployment
```

I deploy the AKS deployment objects, services and ingress controller to acces to my Webui front service from outside the world

