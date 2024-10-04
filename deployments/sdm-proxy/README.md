# [![strongDM](../../sdm_icon.png)](https://strongdm.com/)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Docs](https://img.shields.io/badge/docs-current-brightgreen.svg)](https://strongdm.com/docs)
[![Twitter](https://img.shields.io/twitter/follow/strongdm.svg?style=social)](https://twitter.com/intent/follow?screen_name=strongdm)

## strongDM Relay

This repo provides an implementation of a strongDM proxy service inside Kubernetes using Helm.

## Prerequisites

* A Kubernetes Cluster v1.16+

* Helm 3.0+

* Git

* If you are going to use [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/), then you will need to manually patch your [services to allow TCP and UDP traffic](https://kubernetes.github.io/ingress-nginx/user-guide/exposing-tcp-udp-services/)

## Installing the Chart

```shell
helm repo add strongdm https://helm.strongdm.com/stable/
helm install [RELEASE_NAME] strongdm/sdm-proxy -f values.yaml
helm status [RELEASE_NAME]
```

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Example of installing a proxy.
```shell
helm install my-sdm-proxy strongdm/sdm-proxy --set global.secret.accessKey=$accessKey --set global.secret.secretKey=$secretKey
```

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

The following table lists the configurable parameters of the strongDM proxy chart and their default values.


| Parameter                                | Description                                                                                      | Default                         | Required |
|------------------------------------------|--------------------------------------------------------------------------------------------------|---------------------------------|----------|
| .secret                                  | Inject sensitive environment variables in the format key:value                                   | None                            | &#9745;  |
| .secret.SDM_PROXY_CLUSTER_ACCESS_KEY     | The ID of the proxy cluster key generated in the Admin UI or CLI.                                | None                            | &#9745;  |
| .secret.SDM_PROXY_CLUSTER_SECRET_KEY     | The secret portion of the proxy cluster key generated in the Admin UI or CLI.                    | None                            | &#9745;  |
| .resources.limits.cpu                    | CPU limit for each proxy container.                                                              | None                            | &#9745;  |
| .resources.limits.memory                 | Memory limit for each proxy container.                                                           | None                            | &#9745;  |
| .resources.requests.cpu                  | CPU requested for each proxy container.                                                          | None                            | &#9745;  |
| .resources.requests.memory               | Memory requested for each proxy container.                                                       | None                            | &#9745;  |
| .service.type                            | The kind of service you'd like to run for the proxy. E.G. `NodePort` or `LoadBalancer`           | `LoadBalancer`                  | &#9744;  |
| .service.loadBalancerIP                  | When service is set to `LoadBalancer` and you'd like to assign the IP Address of an existing LB. | None                            | &#9744;  |
| .service.annotations                     | Annotations to configure the `LoadBalancer`.                                                     | None                            | &#9744;  |
| .service.port                            | The port you'd like to have the service listening on.                                            | 443                             | &#9744;  |
| .service.replicas                        | Number of proxies you'd like to run in the cluster.                                              | 2                               | &#9744;  |
| .deployment.repository                   | The image you'd like to use for the strongDM proxy.                                              | `public.ecr.aws/strongdm/relay` | &#9744;  |
| .deployment.tag                          | The tag for the image you'd like to use for the strongDM proxy.                                  | `latest`                        | &#9744;  |
| .deployment.imagePullPolicy              | The policy for pulling a new image from the repo.                                                | `Always`                        | &#9744;  |
| .deployment.env                          | Inject extra environment vars in the format key:value, if provided                               | None                            | &#9744;  |
| .deployment.env.SDM_DOMAIN               | Domain of the control plane which the proxy should connect to.                                   | `strongdm.com`                  | &#9744;  |
| .deployment.env.SDM_RELAY_LOG_STORAGE    | Control where query logs are stored.                                                             |                                 | &#9744;  |
| .deployment.env.SDM_RELAY_LOG_FORMAT     | Change the format of locally stored query logs.                                                  |                                 | &#9744;  |
| .deployment.env.SDM_RELAY_LOG_ENCRYPTION | Change the encryption of locally stored query logs.                                              |                                 | &#9744;  |
