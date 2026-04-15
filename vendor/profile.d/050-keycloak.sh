#!/usr/bin/env bash

if [ -n "${SCALINGO_POSTGRESQL_URL}" ]; then
	host="$( cut -d "@" -f2 <<< "${SCALINGO_POSTGRESQL_URL}" | cut -d ":" -f1 )"
	port="$( cut -d ":" -f4 <<< "${SCALINGO_POSTGRESQL_URL}" | cut -d "/" -f1 )"
	username="$( cut -d "/" -f3 <<< "${SCALINGO_POSTGRESQL_URL}" | cut -d ":" -f1 )"
	password="$( cut -d "@" -f1 <<< "${SCALINGO_POSTGRESQL_URL}" | cut -d ":" -f3 )"
	database="$( cut -d "?" -f1 <<< "${SCALINGO_POSTGRESQL_URL}" | cut -d "/" -f4 )"
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
fi
