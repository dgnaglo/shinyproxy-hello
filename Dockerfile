FROM openanalytics/shinyproxy:3.2.0
USER root
COPY application.yml /opt/shinyproxy/application.yml
