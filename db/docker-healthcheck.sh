#!/bin/sh
# https://github.com/docker-library/healthcheck/blob/master/mysql/docker-healthcheck
set -eo pipefail

if [ "$MYSQL_RANDOM_ROOT_PASSWORD" ] && [ -z "$MYSQL_USER" ] && [ -z "$MYSQL_PASSWORD" ]; then
	# there's no way we can guess what the random MySQL password was
	echo >&2 'healthcheck error: cannot determine random root password (and MYSQL_USER and MYSQL_PASSWORD were not set)'
	exit 0
fi

host="$(awk 'END{print $1}' /etc/hosts || hostname --ip-address || echo '127.0.0.1')"
user="${MYSQL_USER:-root}"
export MYSQL_PWD="${MYSQL_PASSWORD:-$MYSQL_ROOT_PASSWORD}"

args=(
	# force mysql to not use the local "mysqld.sock" (test "external" connectibility)
	-h"$host"
	-u"$user"
	--silent
)

sql="SELECT EXISTS(SELECT 1 FROM information_schema.tables where TABLE_SCHEMA = '${MYSQL_DATABASE}' AND TABLE_NAME = '${WORDPRESS_TABLE_PREFIX}options') as t;"
select="$(echo $sql | mysql "${args[@]}")"

if [ "$select" = '1' ]; then
	exit 0
fi

exit 1
