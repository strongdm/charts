# [![strongDM](https://assets-global.website-files.com/5ecfe3add0194393eabdf182/5ecfebb04752d36bdbe9bdbf_dark.svg)](https://strongdm.com)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Docs](https://img.shields.io/badge/docs-current-brightgreen.svg)](https://strongdm.com/docs)
[![Twitter](https://img.shields.io/twitter/follow/strongdm.svg?style=social)](https://twitter.com/intent/follow?screen_name=strongdm)

## strongDM Client

This repo provides an implementation of a strongDM Client Container inside Kubernetes using Helm.

[Learn more about deploying strongDM's cliet container inside Kubernetes on our docs site.](https://www.strongdm.com/docs/automation/containers/client-container)

## Prerequisites

* A Kubernetes Cluster v1.16+

* Helm 3.0+

* Git

* If you are going to use [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/), then you will need to manually patch your [services to allow TCP and UDP traffic](https://kubernetes.github.io/ingress-nginx/user-guide/exposing-tcp-udp-services/)

* [A strongDM Service Token](https://www.strongdm.com/docs/admin-ui-guide/access/service-accounts)

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
helm upgrade [RELEASE_NAME] strongdm/sdm-client --install
```

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

## Uninstalling the Chart

```shell
helm uninstall [RELEASE_NAME]
```

The command removes all the Kubernetes components associated with the release and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Configuration

The following table lists the configurable parameters of the strongDM relay/gateway chart and their default values.

| Parameter | Description | Default | Required |
| --- | --- | --- | --- |
| .global.service.type | The kind of service you'd like to run for the gateway. E.G. `ClusterIP` or `Loadbalancer` | `ClusterIP` | &#9744; |
| .global.secret.token | The `base64` encoded value of the relay or gateway token generated in the Admin UI. | None | &#9745; |
| .global.deployment.replicas | The number of container replicas you'd like to run for the deployment. | 1 | &#9744; |
| .global.deployment.repository | The image you'd like to use for the strongDM client. | quay.io/sdmrepo/client | &#9745; |
| .global.deployment.tag | The tag for the image you'd like to use for the strongDM client. | latest | &#9745; |
| .global.deployment.imagePullPolicy | The policy for pulling a new image from the repo. | Always | &#9745; |
| .global.deployment.ports | A list of ports you'd like to have the service listening on. The ports will coincide with the SDM port you are exposing from SDM. | None | &#9744; |
| .configmap.SDM_DOCKERIZED | Setting this will automatically send logs to STDOUT overriding settings in AdminUI. | true | &#9744; |
