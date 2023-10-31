{{/*
Returns custom hostname
*/}}
{{- define "janus-idp.hostname" -}}
    {{- if .Values.global.host -}}
        {{- .Values.global.host -}}
    {{- else if .Values.global.clusterRouterBase -}}
        {{- print .Release.Name "-" .Release.Namespace "." .Values.global.clusterRouterBase -}}
    {{- else -}}
        {{ fail "Unable to generate hostname" }}
    {{- end -}}
{{- end -}}

{{- define "resource-exists" -}}
    {{- $api := index . 0 -}}
    {{- $kind := index . 1 -}}
    {{- $namespace := index . 2 -}}
    {{- $name := index . 3 -}}
    {{- $existingResource := lookup $api $kind $namespace $name }}
    {{- if empty $existingResource }}
        {{- "false" -}}
    {{- else }}
        {{- "true" -}}
    {{- end }}
{{- end }}

{{- define "unmanaged-resource-exists" -}}
    {{- $api := index . 0 -}}
    {{- $kind := index . 1 -}}
    {{- $namespace := index . 2 -}}
    {{- $name := index . 3 -}}
    {{- $releaseName := index . 4 -}}
    {{- $unmanagedSubscriptionExists := "true" -}}
    {{- $existingOperator := lookup $api $kind $namespace $name -}}
    {{- if empty $existingOperator -}}
        {{- "false" -}}
    {{- else -}}
        {{- $isManagedResource := include "is-managed-resource" (list $existingOperator $releaseName) -}}
        {{- if eq $isManagedResource "true" -}}
            {{- "false" -}}
        {{- else -}}
            {{- "true" -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{- define "is-managed-resource" -}}
    {{- $resource := index . 0 -}}
    {{- $releaseName := index . 1 -}}
    {{- $resourceReleaseName := dig "metadata" "annotations" (dict "meta.helm.sh/release-name" "NA") $resource -}}
    {{- if eq (get $resourceReleaseName "meta.helm.sh/release-name") $releaseName -}}
        {{- "true" -}}
    {{- else -}}
        {{- "false" -}}
    {{- end -}}
{{- end -}}

{{- define "is-resource-installed" -}}
    {{- $api := index . 0 -}}
    {{- $kind := index . 1 -}}
    {{- $namespace := index . 2 -}}
    {{- $name := index . 3 -}}
    {{- $releaseName := index . 4 -}}
    {{- $unmanagedResourceExists := include "unmanaged-resource-exists" (list $api $kind $namespace $name $releaseName) -}}
    {{- if eq $unmanagedResourceExists "false" -}}
        {{- "YES" -}}
    {{- else -}}
        {{- "NO" -}}
    {{- end -}}
{{- end -}}

{{- define "is-openshift" -}}
    {{- if .Capabilities.APIVersions.Has "route.openshift.io/v1" -}}
        {{- "true" -}}
    {{- else -}}
        {{- "false" -}}
    {{- end -}}
{{- end -}}

{{- define "get-default-catalogsource-name" -}}
    {{- if .Capabilities.APIVersions.Has "route.openshift.io/v1" -}}
        {{- "community-operators" -}}
    {{- else -}}
        {{- "operatorhubio-catalog" -}}
    {{- end -}}
{{- end -}}

{{- define "get-default-catalogsource-namespace" -}}
    {{- if .Capabilities.APIVersions.Has "route.openshift.io/v1" -}}
        {{- "openshift-marketplace" -}}
    {{- else -}}
        {{- "olm" -}}
    {{- end -}}
{{- end -}}

{{- define "get-default-coperator-namespace" -}}
    {{- if .Capabilities.APIVersions.Has "route.openshift.io/v1" -}}
        {{- "openshift-operators" -}}
    {{- else -}}
        {{- "operators" -}}
    {{- end -}}
{{- end -}}

{{- define "operator-group-exists" -}}
    {{- $namespace := index . 0 -}}
    {{- $existingOperatorGroup := lookup "operators.coreos.com/v1" "OperatorGroup" $namespace "" -}}
    {{- if empty $existingOperatorGroup -}}
        {{- "false" -}}
    {{- else }}
        {{- "true" -}}
    {{- end -}}
{{- end -}}

{{- define "get-postgres-secret-name" -}}
    {{- if .Values.postgres.existingSecret -}}
        {{- .Values.postgres.existingSecret -}}
    {{- else }}
        {{- "orchestrator-postgresql" -}}
    {{- end -}}
{{- end -}}

{{- define "get-postgres-host" -}}
    {{- if .Values.postgres.externalPostgresDBHost -}}
        {{- .Values.postgres.externalPostgresDBHost -}}
    {{- else }}
        {{- print "postgres-db-service." .Values.orchestrator.namespace ".svc.cluster.local" -}}
    {{- end -}}
{{- end -}}    
{{- define "get-postgres-jdbc-url" -}}
    {{- print "jdbc:postgresql://" (include "get-postgres-host" .) ":" .Values.postgres.port "/" .Values.postgres.database -}}
{{- end -}}
{{- define "get-postgres-reactive-url" -}}
    {{- print "postgresql://" (include "get-postgres-host" .) ":" .Values.postgres.port  "/" .Values.postgres.database -}}
{{- end -}}