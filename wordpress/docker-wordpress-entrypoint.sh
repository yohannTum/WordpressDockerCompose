#!/bin/bash
set -e

# To disable plugins
# php wp-cli.phar plugin deactivate plugin1 plugin2 ...

# search-replace command to go on a local environment
php wp-cli.phar search-replace "$PRODUCTION_URL" "$WORDPRESS_HOST" \
	-n 'wp_*postmeta' 'wp_*posts' 'wp_*options' wp_blogs wp_site post_content \
	-h $WORDPRESS_DB_HOST \
	-u $WORDPRESS_DB_USER \
	-p $WORDPRESS_DB_PASSWORD \
	--url=$PRODUCTION_URL \
	--network \
	--allow-root

# Generates .htaccess file for wordpress permalinks
php wp-cli.phar rewrite flush --hard --allow-root

# You can perform some wp-cli commands like so :
# php wp-cli.phar plugin update --all --allow-root

echo "###################### DOCKER-WORDPRESS started ######################"
# https://docs.docker.com/reference/dockerfile/#entrypoint
# Run apache2
if [[ -n "$1" ]]; then
  exec "${*}"
else
  exec apache2-foreground
fi
