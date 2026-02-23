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

{{- /* Password validation helper functions */ -}}
{{- define "fdp.validatePassword" -}}
{{- /* Check if password contains problematic special characters */ -}}
{{- $password := .password | default "" -}}
{{- $strict := .strict | default false -}}
{{- $problematicChars := .problematicChars | default (list "%" "\\" "\"" "$" "'") -}}
{{- $hasProblematic := false -}}
{{- $problematicFound := list -}}

{{- /* Check each problematic character */ -}}
{{- range $char := $problematicChars -}}
{{- if contains $char $password -}}
{{- $hasProblematic = true -}}
{{- $problematicFound = append $problematicFound $char -}}
{{- end -}}
{{- end -}}

{{- /* Return validation result */ -}}
{{- if and $hasProblematic $strict -}}
{{- fail (printf "Password contains problematic special characters that may break MongoDB connection: %s. Please use a different password." (join ", " $problematicFound)) -}}
{{- else if $hasProblematic -}}
{{- printf "WARNING: Password contains special characters (%s) that may cause issues with MongoDB. Consider using a different password.\n" (join ", " $problematicFound) -}}
{{- end -}}
{{- end -}}

{{- define "fdp.generateSafePassword" -}}
{{- /* Generate a random safe password of specified length (default: 32 chars) */ -}}
{{- $length := .length | default 32 -}}
{{- $safeChars := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.!@#^&*()+=<>?[]{}|~`" -}}
{{- $password := "" -}}
{{- range $i := until $length -}}
{{- $randomIndex := randNumeric (len $safeChars) -}}
{{- $password = printf "%s%s" $password (index $safeChars $randomIndex) -}}
{{- end -}}
{{- $password -}}
{{- end -}}

{{- define "fdp.safePassword" -}}
{{- /* Get a safe password - either validated existing or generated new */ -}}
{{- $password := .password | default "" -}}
{{- $strict := .strict | default false -}}
{{- $generateIfEmpty := .generateIfEmpty | default true -}}

{{- if and (empty $password) $generateIfEmpty -}}
{{- include "fdp.generateSafePassword" (dict "length" 32) -}}
{{- else if not (empty $password) -}}
{{- include "fdp.validatePassword" (dict "password" $password "strict" $strict) -}}
{{- $password -}}
{{- else -}}
{{- "" -}}
{{- end -}}
{{- end -}}