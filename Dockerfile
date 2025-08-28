FROM openanalytics/shinyproxy:3.2.0

# Run as root to access /var/run/docker.sock
USER root

# Config
COPY application.yml /opt/shinyproxy/application.yml

# Entrypoint that ensures network is present & attached on each boot
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh \
    && sed -i 's/\r$//' /usr/local/bin/entrypoint.sh  # normalize CRLF->LF

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
