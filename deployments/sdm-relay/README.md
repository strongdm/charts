# [![strongDM](../../sdm_icon.png)](https://strongdm.com/)

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

* Either a [strongDM Gateway/Relay Token](https://www.strongdm.com/docs/admin-ui-guide/network/gateways) or else an [Admin Token](https://www.strongdm.com/docs/admin/users/admin-tokens/) with the `relay:create` permission which will be used to generate the gateway/relay token.

_**Note: In order to get a Gateway Token you'll need an external address to register. This external address is immutable after creation.**_

## Installing the Chart

```shell
helm repo add strongdm https://helm.strongdm.com/stable/
helm install [RELEASE_NAME] strongdm/sdm-relay -f values.yaml
helm status [RELEASE_NAME]
```

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Example of using an Admin Token to install a Relay
```shell
sdm login
adminToken=$(sdm admin tokens create --type admin-token --duration 9999999 --permissions relay:create "relay-create-$(date +%s)" | awk '{print $NF}' | base64)
helm install my-sdm-relay strongdm/sdm-relay --set global.secret.adminToken=$adminToken
```

For a gateway, provide SDM_GATEWAY_LISTEN_PORT_ADDR and any other desired values on the `helm install` command line or in a `values.yaml` file.

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


| Parameter                               | Description                                                                                                                                                           | Default                       | Required |
|-----------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------|----------|
| .global.gateway.enabled                 | This is to enable the strongDM relay to accept incoming traffic when using a Gateway Token.                                                                           | false                         | &#9744;  |
| .global.gateway.service.type            | The kind of service you'd like to run for the gateway. E.G. `NodePort` or `Loadbalancer`                                                                              | `NodePort`                    | &#9745;  |
| .global.gateway.service.nodePort        | When service is set to `NodePort` this port needs to match what was set in the Admin UI.                                                                              | 30001                         | &#9744;  |
| .global.gateway.service.loadBalancerIP  | When service is set to `LoadBalancer` and you'd like to assign the IP Address of an existing LB.                                                                      | None                          | &#9744;  |
| .global.gateway.service.port            | The port you'd like to have the service listening on. If using NodePort this can be different then the port set in the Admin UI.                                      | 30001                         | &#9745;  |
| .global.secret.token                    | The `base64` encoded value of the relay or gateway token generated in the Admin UI or CLI.  Can be omitted if adminToken is provided.                                 | None                          | &#9745;  |
| .global.secret.adminToken               | The `base64` encoded value of the an admin token with relay:create permission.  Used when to generate a new relay or gateway token when there is not one already set. | None                          | &#9744;  |
| .global.deployment.repository           | The image you'd like to use for the strongDM gateway/relay.                                                                                                           | public.ecr.aws/strongdm/relay | &#9745;  |
| .global.deployment.tag                  | The tag for the image you'd like to use for the strongDM gateway/relay.                                                                                               | latest                        | &#9745;  |
| .global.deployment.imagePullPolicy      | The policy for pulling a new image from the repo.                                                                                                                     | Always                        | &#9745;  |
| .global.extraEnvironmentVars            | Inject extra environment vars in the format key:value, if populated                                                                                                   | None                          | &#9744;  |
| .configmap.SDM_ORCHESTRATOR_PROBES      | If you'd like to have a liveliness probe for the strongDM gateway/relay.                                                                                              | 9090                          | &#9744;  |
| .configmap.SDM_DOCKERIZED               | Setting this will automatically send logs to STDOUT overriding settings in AdminUI.                                                                                   | true                          | &#9744;  |
| .configmap.SDM_RELAY_LOG_FORMAT         | Format for the logs when stored locally.                                                                                                                              | json                          | &#9744;  |
| .configmap.SDM_RELAY_LOG_STORAGE        | If storing SDM Activites slowly you can change where they are stored.                                                                                                 | stdout                        | &#9744;  |
| .configmap.SDM_RELAY_LOG_ENCRYPTION     | Change the encryption of the logs.                                                                                                                                    | plaintext                     | &#9744;  |
| .configmap.SDM_RELAY_NAME               | Name to use if a new relay token is being generated. Must match any existing token name. Omit to use automatically generated name.                                    | plaintext                     | &#9744;  |
| .configmap.SDM_RELAY_TAGS               | Tags to use if a new relay token is being generated. (See sdm admin relays create -h for description)                                                                 | plaintext                     | &#9744;  |
| .configmap.SDM_RELAY_MAINTENANCE_WINDOW | Maintenance window to use if a new relay token is being generated. (See sdm admin relays create -h for description)                                                   | plaintext                     | &#9744;  |
| .configmap.SDM_GATEWAY_LISTEN_ADDR_PORT | If a gateway token is to be generated, this is the address where it will listen, and it is required.                                                                  | plaintext                     | &#9744;  |
| .configmap.SDM_GATEWAY_BIND_ADDR_PORT   | If a gateway token is to be generated, this is the address where it will bind.                                                                                        | plaintext                     | &#9744;  |


