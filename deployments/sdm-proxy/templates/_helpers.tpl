{{- define "strongdm.name" -}}
{{- default .Release.Name .Values.strongdm.nameOverride }}
{{- end }}
{{- define "strongdm.namespace" -}}
{{- default .Release.Namespace .Values.strongdm.namespaceOverride }}
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

# Args:
# - addtl: (optional) map of labels to add
{{- define "strongdm.labels" -}}
{{ include "strongdm.selectorLabels" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
helm.sh/release: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.global.addDateLabel }}
date: {{ now | htmlDate }}
{{- end }}
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
app.kubernetes.io/component: proxy
{{- range $k, $v := .Values.strongdm.service.selectorLabels }}
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
{{ printf "%s@sha256:%s" (default "public.ecr.aws/strongdm/relay" .repository) .Values.strongdm.image.digest }}
{{- else -}}
{{ printf "%s:%s" (default "public.ecr.aws/strongdm/relay" .repository) .Values.strongdm.image.tag }}
{{- end -}}
{{- end }}
