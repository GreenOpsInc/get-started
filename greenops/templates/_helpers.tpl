{{/* vim: set filetype=mustache: */}}

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
