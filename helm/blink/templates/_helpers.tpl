{{/*
Expand the name of the chart.
*/}}
{{- define "blink.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "blink.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "blink.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels (immutable after first deploy).
*/}}
{{- define "blink.selectorLabels" -}}
app.kubernetes.io/name: {{ include "blink.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "blink.labels" -}}
helm.sh/chart: {{ include "blink.chart" . }}
{{ include "blink.selectorLabels" . }}
app.kubernetes.io/part-of: {{ include "blink.name" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Container image with tag.
*/}}
{{- define "blink.image" -}}
{{- if and (eq .Values.blink.image.tag "") (eq .Chart.AppVersion "0.1.0") -}}
{{ fail "You must set blink.image.tag when installing directly from git." }}
{{- end -}}
{{ .Values.blink.image.repo }}:{{ .Values.blink.image.tag | default .Chart.AppVersion }}
{{- end }}

{{/*
Service account name.
*/}}
{{- define "blink.serviceAccountName" -}}
{{- if .Values.blink.serviceAccount.name }}
{{- .Values.blink.serviceAccount.name }}
{{- else }}
{{- include "blink.fullname" . }}
{{- end }}
{{- end }}

{{/*
Ingress wildcard host — normalize to *.domain format.
*/}}
{{- define "blink.ingressWildcardHost" -}}
{{- regexReplaceAll "\\*[^.]*(\\..*)" .Values.blink.ingress.wildcardHost "*${1}" -}}
{{- end }}
