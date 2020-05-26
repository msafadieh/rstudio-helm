{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "rstudio.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rstudio.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rstudio.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "rstudio.labels" -}}
helm.sh/chart: {{ include "rstudio.chart" . }}
{{ include "rstudio.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "rstudio.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rstudio.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "rstudio.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "rstudio.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return which PVC to use
*/}}
{{- define "rstudio.pvcname" -}}
{{- if .Values.persistence.existingClaim -}}
{{- printf "%s" .Values.persistence.existingClaim -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Values.persistence.name -}}
{{- end -}}
{{- end -}}

{{/*
Creates the bash command for the init containers used to place files and change permissions in the rstudio pods
*/}}
{{- define "rstudio.init-container-commands" -}}
cp -anrL /opt/configs/readonly/rstudio/ /home/;
chown -R rstudio:rstudio /home/rstudio
{{- end -}}

