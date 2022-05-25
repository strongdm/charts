# [![strongDM](https://assets-global.website-files.com/5ecfe3add0194393eabdf182/5ecfebb04752d36bdbe9bdbf_dark.svg)](https://strongdm.com/)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Docs](https://img.shields.io/badge/docs-current-brightgreen.svg)](https://strongdm.com/docs)
[![Twitter](https://img.shields.io/twitter/follow/strongdm.svg?style=social)](https://twitter.com/intent/follow?screen_name=strongdm)

## Helm Charts

This repo contains packaged Helm charts provided by strongDM:

* strongDM Relay/Gateway

## strongDM Relay/Gateway

### Prerequisites

* A Kubernetes Cluster v1.16+

* Helm 3.0+

* Git

* If you are going to use [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/), then you will need to manually patch your [services to allow TCP and UDP traffic](https://kubernetes.github.io/ingress-nginx/user-guide/exposing-tcp-udp-services/)

* [A strongDM Gateway/Relay Token](https://www.strongdm.com/docs/admin-ui-guide/network/gateways)

_**Note: In order to get a Gateway Token you'll need an external address to register. This is external address is immutable after creation.**_

### Installing the Chart

```shell
helm repo add strongdm https://helm.strongdm.com/stable/
helm install [RELEASE_NAME] strongdm/sdm-relay -f values.yaml
helm status [RELEASE_NAME]
```

_See [configuration](deployments/sdm-relay/README.md#configuration) options._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

### Upgrading the Chart

```shell
helm upgrade [RELEASE_NAME] strongdm/sdm-relay --install
```

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

### Uninstalling the Chart

```shell
helm uninstall [RELEASE_NAME]
```

The command removes all the Kubernetes components associated with the release and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._
