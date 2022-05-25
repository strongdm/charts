# [![strongDM](https://assets-global.website-files.com/5ecfe3add0194393eabdf182/5ecfebb04752d36bdbe9bdbf_dark.svg)](https://strongdm.com)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Docs](https://img.shields.io/badge/docs-current-brightgreen.svg)](https://strongdm.com/docs)
[![Twitter](https://img.shields.io/twitter/follow/strongdm.svg?style=social)](https://twitter.com/intent/follow?screen_name=strongdm)

## strongDM Relay

This repo provides an implementation of a strongDM relay or gateway inside Kubernetes using Helm.

[Learn more about deploying strongDM inside Kubernetes on our docs site.](https://www.strongdm.com/docs/installation/install-your-gateway/kubernetes-gateways)

## Prerequisites

* A Kubernetes Cluster v1.16+

* Helm 3.0+

* Git

* If you are going to use [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/), then you will need to manually patch your [services to allow TCP and UDP traffic](https://kubernetes.github.io/ingress-nginx/user-guide/exposing-tcp-udp-services/)

* [A strongDM Gateway/Relay Token](https://www.strongdm.com/docs/admin-ui-guide/network/gateways)

_**Note: In order to get a Gateway Token you'll need an external address to register. This is external address is immutable after creation.**_

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

If you are running multiple strongDM Gateways it is recommended having multiple points of ingress rather than using the same ingress point with different points. Our recommendation is using a one to one ratio with Loadbalancer to Gateway.

_Also note that tokens can't be reused between Gateways and a replicaset of 1 is set by default to ensure a new Gateway will be deployed, but won't cause any token conflicts._

## Configuration

The following table lists the configurable parameters of the strongDM relay/gateway chart and their default values.

| Parameter | Description | Default | Required |
| --- | --- | --- | --- |
| .global.gateway.enabled | This is to enable the strongDM relay to accept incoming traffic when using a Gateway Token. | false | &#9744; |
| .global.gateway.service.type | The kind of service you'd like to run for the gateway. E.G. `NodePort` or `Loadbalancer` | `NodePort` | &#9745; |
| .global.gateway.service.nodePort | When service is set to `NodePort` this port needs to match what was set in the Admin UI. | 30001 | &#9744; |
| .global.gateway.service.port | The port you'd like to have the service listening on. If using NodePort this can be different then the port set in the Admin UI. | 30001 | &#9745; |
| .global.secret.token | The `base64` encoded value of the relay or gateway token generated in the Admin UI. | None | &#9745; |
| .global.deployment.repository | The image you'd like to use for the strongDM gateway/relay. | quay.io/sdmrepo/relay | &#9745; |
| .global.deployment.tag | The tag for the image you'd like to use for the strongDM gateway/relay. | latest | &#9745; |
| .global.deployment.imagePullPolicy | The policy for pulling a new image from the repo. | Always | &#9745; |
| .configmap.SDM_ORCHESTRATOR_PROBES | If you'd like to have a liveliness probe for the strongDM gateway/relay. | 9090 | &#9744; |
| .configmap.SDM_DOCKERIZED | Setting this will automatically send logs to STDOUT overriding settings in AdminUI. | true | &#9744; |
| .configmap.SDM_RELAY_LOG_FORMAT | Format for the logs when stored locally. | json | &#9744; |
| .configmap.SDM_RELAY_LOG_STORAGE | If storing SDM Activites slowly you can change where they are stored. | stdout | &#9744; |
| .configmap.SDM_RELAY_LOG_ENCRYPTION | Change the encryption of the logs. | plaintext | &#9744; |
