FROM debian:jessie-slim
LABEL maintainer="Robby O'Connor <robby.oconnor@gmail.com>"
ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/robbyoconnor/dockup.git" \
      org.label-schema.vcs-ref=$VCS_REF

ENV CRON_INTERVALS false
WORKDIR "/dockup"
CMD ["/dockup/run.sh"]
ENV S3_BUCKET_NAME docker-backups.example.com
ENV AWS_ACCESS_KEY_ID **DefineMe**
ENV AWS_SECRET_ACCESS_KEY **DefineMe**
ENV AWS_DEFAULT_REGION us-east-1
ENV PATHS_TO_BACKUP auto
ENV BACKUP_NAME backup
ENV RESTORE false
ENV RESTORE_TAR_OPTION --preserve-permissions
ENV NOTIFY_BACKUP_SUCCESS false
ENV NOTIFY_BACKUP_FAILURE false
ENV BACKUP_TAR_TRIES 5
ENV BACKUP_TAR_RETRY_SLEEP 30
COPY ./scripts /dockup/
RUN chmod 755 /dockup/*.sh
RUN apt-get update \
&& apt-get install -y --no-install-recommends cron python-pip curl postfix \
&& pip install awscli \
&& apt-get autoclean -y \
&& apt-get autoremove -y \
&& rm -rf /usr/share/locale/* \
&& rm -rf /var/cache/debconf/*-old \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /usr/share/doc/*
