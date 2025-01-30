{{- define "sdm.labels" }}
generator: helm
{{- if (default true .Values.global.addDateLabel ) }}
date: {{ now | htmlDate }}
{{- end }}
chart: {{ .Chart.Name }}
version: {{ .Chart.Version }}
{{- end }}

{{- define "sdm.extraEnvironmentVars" -}}
{{- if .extraEnvironmentVars -}}
{{- range $key, $value := .extraEnvironmentVars }}
- name: {{ printf "%s" $key | replace "." "_" | upper | quote }}
  value: {{ $value | quote }}
{{- end }}
{{- end -}}
{{- end -}}

{{- define "sdm.imageURI" -}}
{{- if .digest -}}
{{ printf "%s@sha256:%s" (.repository | default (printf "public.ecr.aws/strongdm/%s" .name)) .digest }}
{{- else -}}
{{ printf "%s:%s" (.repository | default (printf "public.ecr.aws/strongdm/%s" .name)) .tag }}
{{- end -}}
{{- end }}
