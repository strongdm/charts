{{- define "strongdm.name" -}}
{{- default .Release.Name .Values.strongdm.nameOverride }}
{{- end }}
{{- define "strongdm.namespace" -}}
{{- default .Release.Namespace .Values.strongdm.namespaceOverride }}
{{- end }}

{{- define "strongdm.appDomain" -}}
{{- default (printf "app.%s" .Values.strongdm.config.domain) .Values.strongdm.config.appDomain }}
{{- end }}

{{- define "strongdm.serviceAccountName" -}}
{{ .Values.strongdm.serviceAccount.create | ternary (include "strongdm.name" .) .Values.strongdm.serviceAccount.name }}
{{- end }}

# Args:
# - addtl: (optional) map of annotations to add
{{- define "strongdm.annotations" -}}
{{- range $k, $v := .Values.global.annotations }}
{{ $k }}: {{ $v | quote }}
{{- end }}
{{- range $k, $v := .addtl }}
{{ $k }}: {{ $v | quote }}
{{- end }}
{{- end }}

{{- define "strongdm.componentLabel" -}}
app.kubernetes.io/component: {{ .Values.strongdm.gateway.enabled | ternary "gateway" "relay" }}
{{- end }}

# Args:
# - addtl: (optional) map of labels to add
{{- define "strongdm.labels" -}}
{{ include "strongdm.selectorLabels" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
helm.sh/release: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- range $k, $v := .Values.global.labels }}
{{ $k }}: {{ $v | quote }}
{{- end }}
{{- range $k, $v := .addtl }}
{{ $k }}: {{ $v | quote }}
{{- end }}
{{- end }}

{{- define "strongdm.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{ include "strongdm.componentLabel" . }}
{{- range $k, $v := .Values.strongdm.gateway.service.selectorLabels }}
{{ $k }}: {{ $v | quote }}
{{- end }}
{{- end }}

# Args:
# - resources: map of limits and requests
{{- define "strongdm.resources" -}}
resources:
  requests:
    {{- range $k, $v := .resources.requests }}
    {{ $k }}: {{ $v }}
    {{- end }}
  limits:
    {{- range $k, $v := .resources.limits }}
    {{ $k }}: {{ $v }}
    {{- end }}
{{- end }}

# Args:
# - digest: (optional) image digest
{{- define "strongdm.imageURI" -}}
{{- if .Values.strongdm.image.digest -}}
{{ printf "%s@sha256:%s" .Values.strongdm.image.repository .Values.strongdm.image.digest }}
{{- else -}}
{{ printf "%s:%s" .Values.strongdm.image.repository .Values.strongdm.image.tag }}
{{- end -}}
{{- end }}

{{- define "strongdm.autoRegisterClusterArgs" -}}
--healthcheck-namespace {{ .Values.strongdm.healthcheckNamespace }} \
{{ if .Values.strongdm.discoveryUsername -}}
--discovery-enabled \
{{- end }}
{{- with .Values.strongdm.autoRegisterCluster }}
{{ if (or .identitySet .identitySetName) -}}
--identity-alias-healthcheck-username {{ $.Values.strongdm.healthcheckUsername }} \
{{ if $.Values.strongdm.discoveryUsername -}}
--discovery-username {{ $.Values.strongdm.discoveryUsername }} \
{{- end -}}
{{ if .identitySet -}}
--identity-set {{ .identitySet }}
{{- else if .identitySetName -}}
--identity-set-name {{ .identitySetName }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end }}
