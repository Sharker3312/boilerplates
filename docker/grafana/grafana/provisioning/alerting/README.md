# TodoMercado Alerts (Errors Panel -> Telegram)

Provisioning solo para alertar logs de error del panel `Errors` del dashboard:

- dashboard UID: `tm-lambdas-overview`
- panel ID: `7`

## Archivos

- `tm-contact-points.yml`: contact point Telegram.
- `tm-notification-templates.yml`: mensaje legible para Telegram.
- `tm-errors-panel-rules.yml`: regla única basada en logs de error.

## Variables requeridas

- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_CHAT_ID`

Estas variables se inyectan al contenedor `grafana` desde `docker/grafana/docker-compose.yml`.
