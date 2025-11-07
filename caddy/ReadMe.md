# Caddy reverse proxy config

This is configuration project for caddy reverse proxy at home

## Docker image

At home caddy is running through docker and the docker image was rebuilt in order to installed
some caddy modules.
The Dockerfile used to build the image is at `./Dockerfile`. Modify the Dockerfile to install more [caddy modules](https://caddyserver.com/docs/modules/).
The docker image can be found on docker hub https://hub.docker.com/r/tomneo2004/caddyx

## Modules

Some modules were installed during this custom build image.

Installed modules:

- [caddy-json-schema](https://github.com/abiosoft/caddy-json-schema): for easy fast configuring caddy Json file with intellisense. `.vscode` folder is the setting files for visual studio code to enable intellisense when configuring caddy Json file.
- [caddy-l4](https://github.com/mholt/caddy-l4): support tcp/udp communication
- [caddy-grpc-web](https://github.com/mholt/caddy-grpc-web): bridge between grpc-web and caddy

### [caddy-json-schema](https://github.com/abiosoft/caddy-json-schema)

**Do not remove .vscode** folder as it is settings to enable intellisense for caddy Json configuration file in visual studio code.

## Usage

Open directory in editor [visual studio code](https://code.visualstudio.com/) is recommend becasue [caddy-json-schema](https://github.com/abiosoft/caddy-json-schema) module support configuring Json file with intellisense.

Pick an supported configuration file.

1. Modify configuration file.
2. Run shell script to tell caddy to reload configuration file through caddy admin api. **Make sure your caddy had exposed port 2019**, which is for caddy REST api.

### Configuration files

- Json confiugration file: `./config/caddy_config.json`
- Caddyfile configuration file: `./config/Caddyfile`

### Tell caddy to reload configuration file

Script using `curl` command so modify ip address in script accoding to remote caddy host

**You must create a file with name `.env` with following key/value pair** because
scripts are depend on this setting

```
CADDY_CONTENT_TYPE_CADDYFILE=text/caddyfile
CADDY_CONTENT_TYPE_JSON=application/json
CADDY_CONFIG_DIR=configs

# Modify to match caddy host
CADDY_HOST=<Address to your caddy server>
CADDY_API_PORT=2019
```

Run shell script to tell caddy to reload config file. Script will make a REST request to [caddy's api](https://caddyserver.com/docs/api)
to tell caddy to load the configuration.

- Script that use Json configuration: `./caddy-load-caddyjson.sh`
- Script that use Caddyfile configuration: `./caddy-load-caddyfile.sh`

## Caddy compose

A standard caddy docker compose would look like

```
services:
  caddy:
    image: tomneo2004/caddyx:latest
    container_name: caddy
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
      - "2019:2019"
    environment:
      # Use localhost:2019 only if your don't want to expose api to external machine
      CADDY_ADMIN: 0.0.0.0:2019
    volumes:
      # Either replace <Path_To_Storage> with actual path in machine or give a name to storage in docker volume
      - <Path_To_Storage>:/srv
      - <Path_To_Storage>:/data
      - <Path_To_Storage>:/config
    command: caddy run
    networks:
      # Any backend server caddy will proxy to has to be in this network
      - proxy_network

networks:
  proxy_network:
    driver: bridge
```
