# Lambda Dashboards (TodoMercado)

Estos dashboards están listos para Loki y fueron diseñados para logs de Lambda enviados por Alloy.

## Importar dashboards

1. En Grafana, abre **Dashboards -> New -> Import**.
2. Carga cualquiera de los JSON dentro de `grafana/dashboards/lambdas/`.
3. En el prompt de importación, selecciona datasource Loki (UID esperado: `loki`).

## Datasource

- Variable requerida: `datasource`.
- Tipo esperado: Loki.
- Si tu UID no es `loki`, selecciónalo al importar o ajusta la variable `datasource` en el dashboard.

## Cambiar stage

- Usa la variable `stage` en la parte superior del dashboard.
- Valor por defecto: `All`.
- Valores detectados en Loki al momento de construir: `dev`, `unknown`.

## Nota de labels y adaptación

Labels reales detectados en Loki: `function`, `job`, `log_group`, `log_stream`, `region`, `service_name`, `source`, `stage`, `version`, `filename`.

Para evitar bloqueo por schema, las queries no dependen únicamente de `function`.
Se usa:

- `label_format lambda_ref="{{.function}} {{.log_group}} {{.service_name}}"`
- Filtro por lambda: `lambda_ref=~".*${lambda_name:regex}.*"`

Esto permite que, si `function` falta, siga funcionando con `log_group` o `service_name`.

## Mapeo dashboard -> lambda -> queries principales

| Dashboard JSON | Lambda | Invocations query (principal) | Errors query (principal) |
|---|---|---|---|
| api-lambda-dashboard.json | ApiLambda | `sum(count_over_time({job=~"lambda|.*lambda.*", stage=~"${stage:regex}"} | label_format lambda_ref="{{.function}} {{.log_group}} {{.service_name}}" | lambda_ref=~".*${lambda_name:regex}.*" |~ "(\"type\":\"platform.report\"|REPORT RequestId:)" [$interval]))` | `sum(count_over_time({job=~"lambda|.*lambda.*", stage=~"${stage:regex}"} | label_format lambda_ref="{{.function}} {{.log_group}} {{.service_name}}" | lambda_ref=~".*${lambda_name:regex}.*" |~ "(?i)(\berror\b|\bexception\b|\btraceback\b|task timed out|runtime exited)" [$interval]))` |
| pre-signup-lambda-dashboard.json | PreSignUpLambda | igual que arriba (cambia `lambda_name` por default `.*PreSignUpLambda.*`) | igual que arriba |
| post-confirmation-lambda-dashboard.json | PostConfirmationLambda | igual que arriba (cambia `lambda_name` por default `.*PostConfirmationLambda.*`) | igual que arriba |
| pre-token-generation-lambda-dashboard.json | PreTokenGenerationLambda | igual que arriba (cambia `lambda_name` por default `.*PreTokenGenerationLambda.*`) | igual que arriba |
| start-streaming-lambda-dashboard.json | StartStreamingLambda | igual que arriba (cambia `lambda_name` por default `.*StartStreamingLambda.*`) | igual que arriba |
| stop-streaming-lambda-dashboard.json | StopStreamingLambda | igual que arriba (cambia `lambda_name` por default `.*StopStreamingLambda.*`) | igual que arriba |
| ivs-event-handler-lambda-dashboard.json | IvsEventHandlerLambda | igual que arriba (cambia `lambda_name` por default `.*IvsEventHandlerLambda.*`) | igual que arriba |
| delete-channel-lambda-dashboard.json | DeleteChannelLambda | igual que arriba (cambia `lambda_name` por default `.*DeleteChannelLambda.*`) | igual que arriba |
| event-bid-lambda-dashboard.json | EventBidLambda | igual que arriba (cambia `lambda_name` por default `.*EventBidLambda.*`) | igual que arriba |
| invoicing-lambda-dashboard.json | InvoicingLambda | igual que arriba (cambia `lambda_name` por default `.*InvoicingLambda.*`) | igual que arriba |
| seed-database-lambda-dashboard.json | SeedDatabaseLambda | igual que arriba (cambia `lambda_name` por default `.*SeedDatabaseLambda.*`) | igual que arriba |
| show-reminders-lambda-dashboard.json | ShowRemindersLambda | igual que arriba (cambia `lambda_name` por default `.*ShowRemindersLambda.*`) | igual que arriba |
| migration-function-dashboard.json | MigrationFunction | igual que arriba (cambia `lambda_name` por default `.*MigrationFunction.*`) | igual que arriba |
