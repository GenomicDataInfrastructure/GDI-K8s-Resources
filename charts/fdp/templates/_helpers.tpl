{{- define "fdp.fullname" -}}
{{- if .Values.global.nameOverride -}}
{{- .Values.global.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "fdp.labels" -}}
app.kubernetes.io/name: {{ include "fdp.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/component: {{ .Values.component | default "fdp" }}
{{- if .Values.global.environment }}
app.kubernetes.io/environment: {{ .Values.global.environment }}
{{- end }}
{{- with .Values.global.labels }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end -}}

{{- define "fdp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fdp.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}