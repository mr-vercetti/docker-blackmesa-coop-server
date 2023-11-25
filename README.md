# mr-vercetti/docker-blackmesa-coop-server
[![Build Status](https://drone.vercetti.cc/api/badges/mr-vercetti/docker-blackmesa-coop-server/status.svg)](https://drone.vercetti.cc/mr-vercetti/docker-blackmesa-coop-server)

Dedicated [Black Mesa](https://www.crowbarcollective.com/games/black-mesa) server with [SourceCoop](https://github.com/ampreeT/SourceCoop) mod installed in a Docker container.

![SourceCoop logo](https://raw.githubusercontent.com/mr-vercetti/docker-blackmesa-coop-server/master/.misc/sourcecoop-logo.jpg "SourceCoop logo")

## Usage
Examples of how you can run this container on your own machine. 

#### docker-compose
```
services:
   blackmesa-coop:
      image: mrvercetti/blackmesa-coop-server
      container_name: blackmesa-coop
      environment:
         - GAME_PARAMS=-port 27015 +maxplayers 2 +map bm_c0a0a 
         - GAME_NAME=Black Mesa Co-Op server
         - GAME_PASSWORD=123
      ports:
         - 27015:27015
         - 27015:27015/udp
      restart: unless-stopped
```

#### docker-cli
```
docker run -d \
    --name=blackmesa-coop \
    --env GAME_PARAMS=-port 27015 +maxplayers 2 +map bm_c0a0a
    --env GAME_NAME=Black Mesa Co-Op server \
    --env GAME_PASSWORD=123 \
    --port 27015:27015 \
    --port 27015:27015/udp \
    --restart unless-stopped \ 
    mrvercetti/blackmesa-coop-server
```
### Environment variables
All of them are optional. Don't quote them as this can cause weird issues.
* `GAME_PARAMS` - startup parameters for server, you can specify port, map, max number of players and much [more](https://github.com/ampreeT/SourceCoop/wiki/Features-&-Configuration).
* `GAME_NAME` - name which will be displayed in server browser.
* `GAME_PASSWORD` - if specified, you must set the password in the in-game dev console before joining with below command.
```
password "123"
```
