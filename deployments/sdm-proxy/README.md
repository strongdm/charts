# [![StrongDM](../../sdm_icon.png)](https://strongdm.com/)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Docs](https://img.shields.io/badge/docs-current-brightgreen.svg)](https://strongdm.com/docs)
[![Twitter](https://img.shields.io/twitter/follow/strongdm.svg?style=social)](https://twitter.com/intent/follow?screen_name=strongdm)

## StrongDM Proxy

This repo provides an implementation of a StrongDM proxy service inside Kubernetes using Helm.

## Prerequisites

* A Kubernetes Cluster v1.16+

* Helm 3.0+

* Git

* If you are going to use [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/), then you will need to manually patch your [services to allow TCP and UDP traffic](https://kubernetes.github.io/ingress-nginx/user-guide/exposing-tcp-udp-services/)

## Installing the Chart

1. Create a Proxy Cluster via the StrongDM Admin UI. Fill in a placeholder address for now.
2. Create a Proxy Cluster Key and save it for the next step.
3. Run these commands:
    ```shell
    helm repo add strongdm https://helm.strongdm.com/stable/
    kubectl create secret generic proxy-cluster-key --from-literal=SDM_PROXY_CLUSTER_ACCESS_KEY=$accessKey --from-literal=SDM_PROXY_CLUSTER_SECRET_KEY=$secretKey
    helm install [RELEASE_NAME] strongdm/sdm-proxy -f values.yaml
    helm status [RELEASE_NAME]
    ```
4. Run this to determine the external IP of the load balancer you created:
    ```shell
    kubectl get svc
    ```
5. Back in the StrongDM Admin UI, update the proxy cluster address to match the external address of the load balancer. For example:
    ```
    k8s-default-blueorig-45be6b0a0b-b71d249c2de23bc3.elb.us-west-2.amazonaws.com:443
    ```

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Upgrading the Chart

```shell
helm upgrade [RELEASE_NAME] strongdm/sdm-proxy --install
```

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

## Uninstalling the Chart

```shell
helm uninstall [RELEASE_NAME]
```

The command removes all the Kubernetes components associated with the release and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Configuration

The following table lists the configurable parameters of the StrongDM proxy chart and their default values.


| Parameter                                | Description                                                                                      | Default                         | Required |
|------------------------------------------|--------------------------------------------------------------------------------------------------|---------------------------------|----------|
| .proxyClusterKeySecretRef                | Name of a Kubernetes secret containing the proxy cluster access key and secret key.              | None                            | &#9745;  |
| .resources.limits.cpu                    | CPU limit for each proxy container.                                                              | None                            | &#9745;  |
| .resources.limits.memory                 | Memory limit for each proxy container.                                                           | None                            | &#9745;  |
| .resources.requests.cpu                  | CPU requested for each proxy container.                                                          | None                            | &#9745;  |
| .resources.requests.memory               | Memory requested for each proxy container.                                                       | None                            | &#9745;  |
| .service.type                            | The kind of service you'd like to run for the proxy. E.G. `NodePort` or `LoadBalancer`           | `LoadBalancer`                  | &#9744;  |
| .service.loadBalancerIP                  | When service is set to `LoadBalancer` and you'd like to assign the IP Address of an existing LB. | None                            | &#9744;  |
| .service.annotations                     | Annotations to configure the `LoadBalancer`.                                                     | None                            | &#9744;  |
| .service.port                            | The port you'd like to have the service listening on.                                            | 443                             | &#9744;  |
| .service.replicas                        | Number of proxies you'd like to run in the cluster.                                              | 2                               | &#9744;  |
| .deployment.repository                   | The image you'd like to use for the StrongDM proxy.                                              | `public.ecr.aws/strongdm/relay` | &#9744;  |
| .deployment.tag                          | The tag for the image you'd like to use for the StrongDM proxy.                                  | `latest`                        | &#9744;  |
| .deployment.imagePullPolicy              | The policy for pulling a new image from the repo.                                                | `Always`                        | &#9744;  |
| .deployment.envFrom                      | Extra secretRefs and configMapRefs to load into the proxy container environment.                 | None                            | &#9744;  |
| .deployment.env                          | Inject extra environment vars in the format key:value, if provided                               | None                            | &#9744;  |
| .deployment.env.SDM_DOMAIN               | Domain of the control plane which the proxy should connect to.                                   | `strongdm.com`                  | &#9744;  |
| .deployment.env.SDM_RELAY_LOG_STORAGE    | Control where query logs are stored.                                                             |                                 | &#9744;  |
| .deployment.env.SDM_RELAY_LOG_FORMAT     | Change the format of locally stored query logs.                                                  |                                 | &#9744;  |
| .deployment.env.SDM_RELAY_LOG_ENCRYPTION | Change the encryption of locally stored query logs.                                              |                                 | &#9744;  |
