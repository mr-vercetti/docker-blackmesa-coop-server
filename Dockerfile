FROM mrvercetti/steamcmd as builder

# Download Black Mesa via SteamCMD
RUN ${STEAMCMD_DIR}/steamcmd.sh +login anonymous +force_install_dir ${OUTPUT_DIR} +app_update 346680 validate +quit

# Fresh start
FROM debian:stable-slim
LABEL maintainer="mr-vercetti"

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y \
        ca-certificates lib32gcc-s1 libtinfo5:i386 libstdc++6:i386 locales locales-all tmux unzip && \
    apt-get clean && \
    echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# General variables
ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8
ENV SERVER_DIR="/blackmesa-server"
ENV OUTPUT_DIR="/output"
# Startup variables
ENV GAME_PARAMS="+map bm_c0a0a +mp_teamplay 1 +maxplayers 2 -port 27015 -console -debug;"

# Set up Enviornment
RUN useradd --home ${SERVER_DIR} --gid root --system abc && \
    mkdir -p ${SERVER_DIR} && \
    chown -R abc:root ${SERVER_DIR}

USER abc

# Link steamclient.so to prevent srcds_run errors
RUN mkdir -p ${SERVER_DIR}/.steam/sdk32 && \
    ln -s ${SERVER_DIR}/bin/steamclient.so ${SERVER_DIR}/.steam/sdk32/steamclient.so

# Copy files
COPY --chown=abc:root --from=builder ${OUTPUT_DIR} ${SERVER_DIR}
COPY --chown=abc:root --chmod=755 /scripts/start.sh /

# Download and extract mods
WORKDIR ${SERVER_DIR}/bms

ADD --chown=abc:root --chmod=774 https://sm.alliedmods.net/smdrop/1.11/sourcemod-1.11.0-git6936-linux.tar.gz .
ADD --chown=abc:root --chmod=774 https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1148-linux.tar.gz .
ADD --chown=abc:root --chmod=774 https://github.com/ampreeT/SourceCoop/releases/download/v1.2/sourcecoop-1.2.zip .

RUN tar -xf sourcemod-1.11.0-git6936-linux.tar.gz && \
    tar -xf mmsource-1.11.0-git1148-linux.tar.gz && \
    unzip sourcecoop-1.2.zip && \
    rm -f sourcemod-1.11.0-git6936-linux.tar.gz mmsource-1.11.0-git1148-linux.tar.gz sourcecoop-1.2.zip

WORKDIR ${SERVER_DIR}

ONBUILD USER root

ENTRYPOINT ["/start.sh"]
