#!/usr/bin/env bash

host="$( echo "${SCALINGO_POSTGRESQL_URL}" | cut -d "@" -f2 | cut -d ":" -f1 )"
port="$( echo "${SCALINGO_POSTGRESQL_URL}" | cut -d ":" -f4 | cut -d "/" -f1 )"
username="$( echo "${SCALINGO_POSTGRESQL_URL}" | cut -d "/" -f3 | cut -d ":" -f1 )"
password="$( echo "${SCALINGO_POSTGRESQL_URL}" | cut -d "@" -f1 | cut -d ":" -f3 )"
database="$( echo "${SCALINGO_POSTGRESQL_URL}" | cut -d "?" -f1 | cut -d "/" -f4 )"
db_url="jdbc:postgresql://${host}:${port}/${database}"

KC_DB="${KC_DB:-"postgres"}"
KC_DB_USERNAME="${username}"
KC_DB_PASSWORD="${password}"
KC_DB_URL_HOST="${host}"
KC_DB_URL_PORT="${port}"
KC_DB_URL_DATABASE="${database}"
KC_DB_URL="${db_url}"
KC_CACHE_CONFIG_FILE="cache-ispn.xml"

export KC_DB
export KC_DB_USERNAME
export KC_DB_PASSWORD
export KC_DB_URL_HOST
export KC_DB_URL_PORT
export KC_DB_URL_DATABASE
export KC_DB_URL
export KC_CACHE_CONFIG_FILE