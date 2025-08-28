FROM openanalytics/shinyproxy:3.2.0

# run as root to access /var/run/docker.sock
USER root

# config
COPY application.yml /opt/shinyproxy/application.yml

# entrypoint that ensures network is present & attached on each boot
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
