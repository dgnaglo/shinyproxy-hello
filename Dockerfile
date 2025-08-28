FROM openanalytics/shinyproxy:3.2.0

USER root
COPY application.yml /opt/shinyproxy/application.yml

# entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh \
    && sed -i 's/\r$//' /usr/local/bin/entrypoint.sh   # <— convertit CRLF -> LF

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
