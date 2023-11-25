#!/bin/bash

server_cfg_file="${SERVER_DIR}/bms/cfg/server.cfg"

echo "Starting Black Mesa Co-Op server \"$GAME_NAME\""
echo "hostname \"${GAME_NAME}\"" >> $server_cfg_file

if [[ $GAME_PASSWORD != "" ]]; then
    echo "Password protection enabled"
    echo "sv_password \"${GAME_PASSWORD}\"" >> $server_cfg_file
fi

cd ${SERVER_DIR}
${SERVER_DIR}/srcds_run -game bms ${GAME_PARAMS}
