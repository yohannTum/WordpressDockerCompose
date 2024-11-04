<h1 align="center"> Local WordPress Docker Compose (WP Migrate) </h1>

[![wordpress](https://img.shields.io/badge/Wordpress-21759B?style=for-the-badge&logo=wordpress&logoColor=white)](https://wordpress.org/)
[![docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![wordpress](https://img.shields.io/badge/Plugin-WP--Migrate-21759B?style=for-the-badge&logo=wordpress&logoColor=white)](https://wordpress.org/plugins/wp-migrate-db/)
[![php](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white)](https://www.php.net/)
[![apache2](https://img.shields.io/badge/Apache-D22128?style=for-the-badge&logo=Apache&logoColor=white)](https://httpd.apache.org/)
[![mysql](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
![bash](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=shields)](http://makeapullrequest.com)

Easily set up a local development environment that mirrors your existing WordPress site exported with the [wp migrate](https://wordpress.org/plugins/wp-migrate-db/) plugin using Docker and Docker Compose.

Quick links: [Features](#features) &#124; [Installation](#installation) &#124; [Usage](#usage) &#124; [Contributing](#contributing) &#124; [Credits](#credits) &#124; [Roadmap](#roadmap)

## Table of contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
  - [Stop your running containers](#stop-your-running-containers)
  - [Start from original database](#start-from-original-database)
  - [Cleaning build files](#cleaning-build-files)
  - [Debugging](#debugging)
- [Contributing](#contributing)
- [Credits](#credits)
- [Roadmap](#roadmap)

## Features
- Docker and Docker compose
- WP-Cli support
- Easy setup with [wp-migrate-db](https://wordpress.org/plugins/wp-migrate-db/) plugin
- Wordpress and PHP versions and wp cli are installed manually (you can install specific versions if you can't find the correct tag at [wordpress docker hub](https://hub.docker.com/_/wordpress/tags)). You only need to set it up in the `.env` file
- Custom wordpress entrypoint script (with wp-cli commands)
- Apache2 for wordpress setup
- Mysql for database setup
- phpmyadmin and adminer interface to interact with your database

## Prerequisites
Make sure you have the latest versions of Docker and Docker Compose installed on your machine.
- Docker and Docker Compose installed
- make
- zip/unzip
- git

## Installation
1. Install on your wordpress website the plugin named 'wp migrate lite' and export your website
2. Clone/Download the project
3. Place the zip file in the `zip/` folder
4. Copy the example environment into `.env`
```sh
cp .env.example .env
```
5. Edit the `.env` file to change the default environment variables
6. A `Makefile` will help you to place files at the right place in your project
```sh
make
```

## Usage
Open a terminal and `cd` to the folder in which `docker-compose.yml` is saved and run :

```sh
docker compose up # use option '-d' for daemon mode
```
You can now access your site at [`http://localhost:3000`](http://localhost:3000) and the admin panel at [`http://localhost:3000/wp-admin`](http://localhost:3000/wp-admin) (port 3000 by default in env).

To access your database, you can use `adminer` at [`http://localhost:8080`](http://localhost:8080) or `phpmyadmin` at [`http://localhost:8081`](http://localhost:8081).

### Stop your running containers
```sh
docker compose down
```

### Start from original database
Your wordpress database is persistent even after shutting down your containers, if you want to start from the original database you exported from wp migrate plugin, you need to delete the `database` folder and restart your docker containers with docker compose.
```sh
sudo rm -r database
```

### Cleaning build files
```sh
make clean
```

### Debugging
To see the build process in plain text for a specific image :
```sh
BUILDKIT_PROGRESS=plain docker compose up -d --no-deps --build wordpress
```

Inspecting your running db container health command (requires jq program ):
```sh
docker inspect db | jq '.[0].State.Health'
```

## Contributing
Feel free to open an issue in this github repository if you have any questions or want to see a feature implemented first.

## Credits
- Project based on : https://github.com/lugosidomotor/DockerLocalWordPress

## Roadmap
The idea of this project would be to make it a general docker-compose for wordpress, extend other configurations (nginx, mariadb...) and support other wordpress plugins that helps you migrate/backup your website for a local development environment with docker.
- Export db dump script
- Support nginx configuration
- Support mariadb (healthcheck, Dockerfile...)
- Redis cache?
- Https for local development (ssl certification)
- Add wp-cli bash completion, run wp-cli without root
- Themes development + update
- Custom php config (php.ini)
- Start as a new wordpress project
- Git wordpress versionning?
- WP Migrate : load docker compose config from `wpmigrate-export.json`?
