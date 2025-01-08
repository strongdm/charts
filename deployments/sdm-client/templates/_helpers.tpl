{{- define "sdm.labels" }}
generator: helm
date: {{ now | htmlDate }}
chart: {{ .Chart.Name }}
version: {{ .Chart.Version }}
{{- end }}

{{- define "sdm.imageURI" -}}
{{- if .digest -}}
{{ printf "%s@sha256:%s" (.repository | default (printf "public.ecr.aws/strongdm/%s" .name)) .digest }}
{{- else -}}
{{ printf "%s:%s" (.repository | default (printf "public.ecr.aws/strongdm/%s" .name)) .tag }}
{{- end -}}
{{- end }}
