#!/usr/bin/env bash

host="$( echo "${SCALINGO_POSTGRESQL_URL}" | cut -d "@" -f2 | cut -d ":" -f1 )"
port="$( echo "${SCALINGO_POSTGRESQL_URL}" | cut -d ":" -f4 | cut -d "/" -f1 )"
username="$( echo "${SCALINGO_POSTGRESQL_URL}" | cut -d "/" -f3 | cut -d ":" -f1 )"
password="$( echo "${SCALINGO_POSTGRESQL_URL}" | cut -d "@" -f1 | cut -d ":" -f3 )"
database="$( echo "${SCALINGO_POSTGRESQL_URL}" | cut -d "?" -f1 | cut -d "/" -f4 )"
db_url="jdbc:postgresql://${host}:${port}/${database}"

readonly host
readonly port
readonly username
readonly password
readonly database
readonly db_url

export KC_DB="${KC_DB:-"postgres"}"
export KC_DB_USERNAME="${username}"
export KC_DB_PASSWORD="${password}"
export KC_DB_URL_HOST="${host}"
export KC_DB_URL_PORT="${port}"
export KC_DB_URL_DATABASE="${database}"
export KC_DB_URL="${db_url}"
export KC_CACHE_CONFIG_FILE="cache-ispn.xml"
