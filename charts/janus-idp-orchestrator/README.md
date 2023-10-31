# janus-idp-orchestrator

![Version: 0.1.2](https://img.shields.io/badge/Version-0.1.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.1](https://img.shields.io/badge/AppVersion-0.0.1-informational?style=flat-square)

A Helm chart to deploy Janus IDP Orchestrator Solution on Kubernetes

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://janus-idp.github.io/helm-backstage | backstage | 2.4.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backstage.upstream.backstage.appConfig.orchestrator.catalog.environment | string | `"development"` |  |
| backstage.upstream.backstage.appConfig.orchestrator.sonataFlowService.baseUrl | string | `"http://devmode.{{ .Release.Namespace }}.svc.cluster.local"` |  |
| backstage.upstream.backstage.appConfig.orchestrator.sonataFlowService.path | string | `"/"` |  |
| backstage.upstream.backstage.appConfig.orchestrator.sonataFlowService.port | int | `80` |  |
| backstage.upstream.backstage.appConfig.orchestrator.sonataFlowService.workflowsSource.gitRepositoryUrl | string | `"https://github.com/tiagodolphine/backstage-orchestrator-work"` |  |
| backstage.upstream.backstage.appConfig.orchestrator.sonataFlowService.workflowsSource.localPath | string | `"/tmp"` |  |
| backstage.upstream.backstage.image.repository | string | `"rgolangh/orchestrator"` |  |
| includeCustomResources | bool | `false` |  |
| postgres.dataDir | string | `"/var/lib/postgresql/data/dbfiles"` |  |
| postgres.database | string | `"sonataflow"` |  |
| postgres.existingSecret | string | `""` |  |
| postgres.externalPostgresDBHost | string | `""` |  |
| postgres.password | string | `"postgres"` |  |
| postgres.port | int | `5432` |  |
| postgres.secretKeys.userPasswordKey | string | `"password"` |  |
| postgres.storage | string | `"2Gi"` |  |
| postgres.username | string | `"postgres"` |  |
| serverlessOperator.enabled | bool | `true` |  |
| serverlessOperator.subscription.channel | string | `"stable"` |  |
| serverlessOperator.subscription.installPlanApproval | string | `"Automatic"` |  |
| serverlessOperator.subscription.namespace | string | `"openshift-serverless"` |  |
| serverlessOperator.subscription.pkgName | string | `"serverless-operator"` |  |
| sonataFlowOperator.enabled | bool | `true` |  |
| sonataFlowOperator.subscription.channel | string | `"alpha"` |  |
| sonataFlowOperator.subscription.installPlanApproval | string | `"Automatic"` |  |
| sonataFlowOperator.subscription.namespace | string | `"openshift-operators"` |  |
| sonataFlowOperator.subscription.pkgName | string | `"sonataflow-operator"` |  |
| sonataFlowOperator.subscription.source | string | `"sonataflow-operator"` |  |
| sonataFlowOperator.subscription.sourceImage | string | `"quay.io/jianrzha/kogito-serverless-operator-catalog:v2.0.0"` |  |
| orchestrator.dataindex.port | int | `8080` |  |
| orchestrator.jobsservice.port | int | `8080` |  |
| orchestrator.namespace | string | `"sonataflow-infra"` |  |
| orchestrator.sonataPlatform.resources.limits.cpu | string | `"500m"` |  |
| orchestrator.sonataPlatform.resources.limits.memory | string | `"1Gi"` |  |
| orchestrator.sonataPlatform.resources.requests.cpu | string | `"250m"` |  |
| orchestrator.sonataPlatform.resources.requests.memory | string | `"64Mi"` |  |
| orchestrator.sonataflows[0].description | string | `"Event timeout example on k8s!"` |  |
| orchestrator.sonataflows[0].name | string | `"event-timeout"` |  |
| orchestrator.sonataflows[0].profile | string | `"prod"` |  |
| orchestrator.sonataflows[0].propsConfigData | string | `""` |  |
| orchestrator.sonataflows[0].serviceTargetPort | int | `8080` |  |
| orchestrator.sonataflows[0].spec | string | `"flow:\n  start: PrintStartMessage\n  events:\n    - name: event1\n      source: ''\n      type: event1_event_type\n    - name: event2\n      source: ''\n      type: event2_event_type\n  functions:\n    - name: systemOut\n      type: custom\n      operation: sysout\n  timeouts:\n    eventTimeout: PT60S\n  states:\n    - name: PrintStartMessage\n      type: operation\n      actions:\n        - name: printSystemOut\n          functionRef:\n            refName: systemOut\n            arguments:\n              message: \"${\\\"event-state-timeouts: \\\" + $WORKFLOW.instanceId + \\\" has started.\\\"}\"\n      transition: WaitForEvent1\n    - name: WaitForEvent1\n      type: event\n      onEvents:\n        - eventRefs: [ event1 ]\n          eventDataFilter:\n            data: \"${ \\\"The event1 was received.\\\" }\"\n            toStateData: \"${ .exitMessage1 }\"\n          actions:\n            - name: printAfterEvent1\n              functionRef:\n                refName: systemOut\n                arguments:\n                  message: \"${\\\"event-state-timeouts: \\\" + $WORKFLOW.instanceId + \\\" executing actions for event1.\\\"}\"\n\n      transition: WaitForEvent2\n    - name: WaitForEvent2\n      type: event\n      onEvents:\n        - eventRefs: [ event2 ]\n          eventDataFilter:\n            data: \"${ \\\"The event2 was received.\\\" }\"\n            toStateData: \"${ .exitMessage2 }\"\n          actions:\n            - name: printAfterEvent2\n              functionRef:\n                refName: systemOut\n                arguments:\n                  message: \"${\\\"event-state-timeouts: \\\" + $WORKFLOW.instanceId + \\\" executing actions for event2.\\\"}\"\n      transition: PrintExitMessage\n    - name: PrintExitMessage\n      type: operation\n      actions:\n        - name: printSystemOut\n          functionRef:\n            refName: systemOut\n            arguments:\n              message: \"${\\\"event-state-timeouts: \\\" + $WORKFLOW.instanceId + \\\" has finalized. \\\" + if .exitMessage1 != null then .exitMessage1 else \\\"The event state did not receive event1, and the timeout has overdue\\\" end + \\\" -- \\\" + if .exitMessage2 != null then .exitMessage2 else \\\"The event state did not receive event2, and the timeout has overdue\\\" end }\"\n      end: true"` |  |
| orchestrator.sonataflows[0].version | string | `"0.0.1"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.3](https://github.com/norwoodj/helm-docs/releases/v1.11.3)
