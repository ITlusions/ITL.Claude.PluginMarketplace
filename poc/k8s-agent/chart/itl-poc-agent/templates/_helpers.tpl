{{- define "itl-poc-agent.name" -}}{{ .Release.Name }}-{{ .Chart.Name }}{{- end -}}
{{- define "itl-poc-agent.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
