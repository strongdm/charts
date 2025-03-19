# [![StrongDM](../../sdm_icon.png)](https://strongdm.com/)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Docs](https://img.shields.io/badge/docs-current-brightgreen.svg)](https://strongdm.com/docs)
[![Twitter](https://img.shields.io/twitter/follow/strongdm.svg?style=social)](https://twitter.com/intent/follow?screen_name=strongdm)

## StrongDM Relay

This repo provides an implementation of a StrongDM relay or gateway inside Kubernetes using Helm.

[Learn more about deploying StrongDM inside Kubernetes on our docs site.](https://www.strongdm.com/docs/installation/install-your-gateway/kubernetes-gateways)

## Prerequisites

* A Kubernetes Cluster v1.16+
* Helm 3.0+
* Git
* If you are going to use [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/), then you will need to manually patch your [services to allow TCP and UDP traffic](https://kubernetes.github.io/ingress-nginx/user-guide/exposing-tcp-udp-services/)
* A [StrongDM Gateway/Relay Token](https://www.strongdm.com/docs/admin-ui-guide/network/gateways)

> [!NOTE]
> To get a Gateway token, you'll need an external address to register. If you don't have such an address during installation of this chart, you may create a Gateway in the Admin UI with a placeholder name. You may change that value after creation with the StrongDM CLI.

## Installing the Chart

```shell
helm repo add strongdm https://helm.strongdm.com/stable/
helm install [RELEASE_NAME] strongdm/sdm-relay -f values.yaml
helm status [RELEASE_NAME]
```

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Upgrading the Chart

```shell
helm upgrade [RELEASE_NAME] strongdm/sdm-relay --install
```

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

## Uninstalling the Chart

```shell
helm uninstall [RELEASE_NAME]
```

The command removes all the Kubernetes components associated with the release and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Running Multiple Gateways

A single `SDM_RELAY_TOKEN` token can't be reused between nodes. To prevent conflicts during updates, this deployment hard-codes a `replicaCount` of 1 and a deployment strategy of `Recreate`.

This also implies that running multiple nodes requires multiple installations of this Helm chart. The [SDM proxy](../sdm-proxy) Helm chart supports multiple replicas with a single installation, should this functionality be desired.

## Configuration

Please view [values.yaml](./values.yaml) for descriptions on supported Helm values.

## Examples

Provide `SDM_ADMIN_TOKEN` directly to create this node during installation:
```yaml
strongdm:
  auth:
    adminToken: foo.bar.baz # take care when setting this value directly
```

Use an existing secret that contains `SDM_ADMIN_TOKEN`, create this node during installation, and also register this cluster in StrongDM:
```yaml
strongdm:
  auth:
    secretName: my-admin-token-secret
  autoRegisterCluster:
    enabled: true
```

Provide `SDM_RELAY_TOKEN` directly:
```yaml
strongdm:
  auth:
    relayToken: my-relay-token # take care when setting this value directly
  autoCreateNode:
    enabled: false
```
