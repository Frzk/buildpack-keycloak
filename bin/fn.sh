#!/usr/bin/env bash

STEP="----->"
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
NC="\033[0m"

info() {
    echo "       $*"
}

warn() {
    echo -e "${YELLOW} !     $*${NC}"
}

err() {
    echo -e "${RED} !!    $*${NC}" >&2
}

success() {
    echo -e "${GREEN}       Done.${NC}"
}

failure() {
    echo -e "${RED}       Failed.${NC}" >&2
    exit 1
}

start() {
    echo "${STEP} $*"
}

do_start() {
    echo -n "       $*... "
}

do_finish() {
    echo "OK."
}

do_fail() {
    echo "Failed."
}

read_env() {
    local env_dir
    local env_vars

    env_dir="${1}"
    env_vars=$( list_env_vars "${env_dir}" )

    while read -r e
    do
        local value
        value=$( cat "${env_dir}/${e}" )

        export "${e}=${value}"
    done <<< "${env_vars}"
}

list_env_vars() {
    local env_dir
    local env_vars
    local blacklist_regex

    env_dir="${1}"
    env_vars=""
    blacklist_regex="^(PATH|GIT_DIR|CPATH|CPPATH|LD_PRELOAD|LIBRARY_PATH|LD_LIBRARY_PATH)$"

    if [ -d "${env_dir}" ]
    then
        env_vars=$( ls "${env_dir}" \
                    | grep \
                        --invert-match \
                        --extended-regexp \
                        "${blacklist_regex}" )
    fi

    echo "${env_vars}"
}

check_cached_file() {
    local rc
    local cached_file
    local checksum_url
    local ref
    local checksum

    rc=1
    cached_file="${1}"
    checksum_url="${2}"

    checksum="$( shasum "${cached_file}" | cut -d \  -f 1 )"

    curl --silent --location "${checksum_url}" --output "${cached_file}.sha1"

    if [ -f "${cached_file}.sha1" ]
    then
        ref="$( cat "${cached_file}.sha1" )"

        if [ "${checksum}" == "${ref}" ]
        then
            rc=0
        else
            rm -f "${cached_file}"
        fi
    fi

    return "${rc}"
}

retrieve_github_latest_release() {
    local org
    local repo
    local base_url
    local version

    org="${1}"
    repo="${2}"
    base_url="https://api.github.com/repos/%s/%s/releases/latest"

    printf -v url "${base_url}" "${org}" "${repo}"

    version=$( curl --silent "${url}" \
                | grep \
                    --perl-regexp \
                    --only-matching \
                    '"tag_name": "\K.*?(?=")' )

    echo "${version}"
}

download() {
    local rc
    local url
    local checksum_url
    local cache_file

    rc=1
    url="${1}"
    checksum_url="${2}"
    cache_file="${3}"

    curl --silent --location "${url}" --output "${cache_file}" \
        && check_cached_file "${cache_file}" "${checksum_url}" \
        && rc=0

    return "${rc}"

}

