# Rails + Inertia.js + Vue 3

Aplicación web con Ruby on Rails 8, Inertia.js, Vue 3 y Vuetify.

## Requisitos

- Ruby 3.4.7
- Node.js/Bun
- SQLite3

## Instalación

```bash
# Instalar dependencias
bundle install
bun install  # o npm install

# Configurar base de datos
bin/rails db:setup

# Instalar navegadores para tests
bunx playwright install firefox
