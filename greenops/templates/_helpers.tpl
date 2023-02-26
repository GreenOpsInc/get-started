{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "dex.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "base.fullname" -}}
{{- $name := .Chart.Name -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create dex name and version as used by the chart label.
*/}}
{{- define "dex.fullname" -}}
{{- printf "%s-%s" (include "base.fullname" .) .Values.dex.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the dex service account to use
*/}}
{{- define "dex.serviceAccountName" -}}
{{- if .Values.dex.serviceAccount.create -}}
    {{ default (include "dex.fullname" .) .Values.dex.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.dex.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "greenops.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common Dex labels
*/}}
{{- define "dex.labels" -}}
helm.sh/chart: {{ include "greenops.chart" .context }}
{{ include "greenops.selectorLabels" (dict "context" .context "component" .component "name" .name) }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
app.kubernetes.io/part-of: argocd
{{- end }}

{{/*
Common GreenOps labels
*/}}
{{- define "greenops.labels" -}}
helm.sh/chart: {{ include "greenops.chart" .context }}
{{ include "greenops.selectorLabels" (dict "context" .context "component" .component "name" .name) }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
app.kubernetes.io/part-of: greenops
{{- end }}

{{/*
Selector labels
*/}}
{{- define "greenops.selectorLabels" -}}
{{- if .name -}}
app.kubernetes.io/name: {{ .name }}
{{ end -}}
app.kubernetes.io/instance: {{ .context.Release.Name }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- end }}

{{/*
Return the target Kubernetes version
*/}}
{{- define "dex.kubeVersion" -}}
  {{- .Capabilities.KubeVersion.Version  }}
{{- end -}}

{{- define "dex.defaultTag" -}}
  {{- default .Chart.AppVersion .Values.dex.initImage.tag }}
{{- end -}}
