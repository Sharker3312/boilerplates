# TodoMercado Lambdas Dashboard

Dashboard único para operar Lambdas en Loki.

## Archivo

- `docker/grafana/grafana/dashboards/lambda/todomercado-lambdas-dashboard.json`

## Variables

- `datasource`: datasource Loki.
- `stage`: lista de stages disponibles en Loki.
- `lambda_name`: lista dinámica de funciones según `stage`.
- `interval`: ventana de agregación para métricas.

Consulta usada para poblar `lambda_name`:

`label_values({job=~"lambda|.*lambda.*", stage=~"${stage:regex}"}, function)`

## Importación manual

1. Grafana -> Dashboards -> New -> Import.
2. Importa `todomercado-lambdas-dashboard.json`.
3. Selecciona datasource Loki.

## Provisioning en este stack

El provisioning apunta a:

- `/var/lib/grafana/dashboards/lambda`

Por eso, al desplegar en Coolify, este dashboard aparece automáticamente en la carpeta `Observability`.
