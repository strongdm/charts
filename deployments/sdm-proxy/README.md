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
* A StrongDM Proxy Cluster key and secret.

> [!NOTE]
> To get a Proxy Cluster key and secret, you'll need an external address to register. If you don't have such an address during installation of this chart, you may create a cluster in the Admin UI with a placeholder name. You may change that value after creation with the StrongDM CLI.

## Installing the Chart

```shell
helm repo add strongdm https://helm.strongdm.com/stable/
helm install [RELEASE_NAME] strongdm/sdm-proxy -f values.yaml
helm status [RELEASE_NAME]
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

Please view [values.yaml](./values.yaml) for descriptions on supported Helm values.

## Examples

Use an `SDM_ADMIN_TOKEN` to register this k8s cluster in StrongDM:
```yaml
strongdm:
  auth:
    # take care when setting these values directly
    clusterKey: foo.bar.baz
    clusterSecret: foo.bar.baz
    adminToken: foo.bar.baz
  autoRegisterCluster:
    enabled: true
```

Use an existing secret that contains `SDM_ADMIN_TOKEN`, `SDM_PROXY_CLUSTER_ACCESS_KEY` and `SDM_PROXY_CLUSTER_SECRET_KEY`:
```yaml
strongdm:
  auth:
    secretName: my-secret
```
