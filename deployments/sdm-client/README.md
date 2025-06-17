# [![StrongDM](../../sdm_icon.png)](https://strongdm.com/)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Docs](https://img.shields.io/badge/docs-current-brightgreen.svg)](https://strongdm.com/docs)
[![Twitter](https://img.shields.io/twitter/follow/strongdm.svg?style=social)](https://twitter.com/intent/follow?screen_name=strongdm)

## StrongDM Client

This repo provides an implementation of a StrongDM relay or gateway inside Kubernetes using Helm.

## Prerequisites

* A Kubernetes Cluster v1.16+
* Helm 3.0+
* Git
* A [StrongDM Service Token](https://www.strongdm.com/docs/admin-ui-guide/access/service-accounts)

## Installing the Chart

```shell
helm repo add strongdm https://helm.strongdm.com/stable/
helm install [RELEASE_NAME] strongdm/sdm-client -f values.yaml
helm status [RELEASE_NAME]
```

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Upgrading the Chart

```shell
helm upgrade [RELEASE_NAME] strongdm/sdm-client
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

Provide `SDM_SERVICE_TOKEN` directly to create this node during installation:
```yaml
strongdm:
  auth:
    serviceToken: foo.bar.baz # take care when setting this value directly
```

Use an existing secret that contains `SDM_SERVICE_TOKEN`:
```yaml
strongdm:
  auth:
    secretName: my-service-token-secret
```
