# Args:
# - addtl: (optional) map of annotations to add
{{- define "strongdm.annotations" -}}
{{- range $k, $v := .Values.global.annotations }}
{{ $k }}: {{ $v }}
{{- end }}
{{- range $k, $v := .addtl }}
{{ $k }}: {{ $v }}
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
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.global.addDateLabel }}
date: {{ now | htmlDate }}
{{- end }}
{{- range $k, $v := .Values.global.labels }}
{{ $k }}: {{ $v }}
{{- end }}
{{- range $k, $v := .addtl }}
{{ $k }}: {{ $v }}
{{- end }}
{{- end }}

{{- define "strongdm.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
{{ include "strongdm.componentLabel" . }}
{{- end }}

{{- define "strongdm.envFrom" -}}
envFrom:
  - configMapRef:
      name: {{ .Release.Name }}-config
  {{- if .Values.strongdm.config.configMapName }}
  - configMapRef:
      name: {{ .Values.strongdm.config.configMapName }}
  {{- end}}
  {{- if .Values.strongdm.config.secretName }}
  - secretRef:
      name: {{ .Values.strongdm.config.secretName }}
  {{- end}}
  {{- if .Values.strongdm.auth.tokenSecret }}
  - name: SDM_RELAY_TOKEN
    valueFrom:
      secretKeyRef:
        name: {{ .Values.strongdm.auth.tokenSecret }}
  {{- end }}
  {{- if .Values.strongdm.auth.adminTokenSecret }}
  - name: SDM_ADMIN_TOKEN
    valueFrom:
      secretKeyRef:
        name: {{ .Values.strongdm.auth.adminTokenSecret }}
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
# - name: (optional) image tag
# - digest: (optional) image digest
{{- define "strongdm.imageURI" -}}
{{- if .digest -}}
{{ printf "%s@sha256:%s" (.repository | default (printf "public.ecr.aws/strongdm/%s" .name)) .digest }}
{{- else -}}
{{ printf "%s:%s" (.repository | default (printf "public.ecr.aws/strongdm/%s" .name)) .tag }}
{{- end -}}
{{- end }}
