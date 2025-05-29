FROM ghcr.io/hassio-addons/debian-base/amd64:latest

ENV LANG C.UTF-8

# Install Python, pip, AppDaemon & MySQL connector
RUN \
  apt-get update && \
  apt-get install -y python3 python3-pip mariadb-client gcc python3-dev libmariadb-dev && \
  pip3 install appdaemon pymysql && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy files
COPY run.sh /run.sh
COPY sensorstats/ /config/sensorstats/

RUN chmod a+x /run.sh

CMD ["/run.sh"]