FROM alpine:3.14

ENV APP_ROOT /var/www/html

# install packages
RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
    busybox-extras \
    bash \
    curl \
    mailx \
    supervisor \
    nodejs \
    npm

# install temporary packages
RUN apk add --no-cache --virtual .temp-pkgs \
    git

WORKDIR ${APP_ROOT}

# MailDev
ENV MAILDEV_REPO_COMMIT_ID 96248f8c38bd269f541dd91e60ad560f57eb46a0
RUN git clone https://github.com/maildev/maildev.git && \
    cd maildev && \
    git reset --hard ${MAILDEV_REPO_COMMIT_ID} && \
    npm ci --only=production && \
    ln -fs ${APP_ROOT}/maildev/bin/maildev /usr/local/bin/maildev

# sendgrid-dev
RUN curl -L -o /usr/local/bin/sendgrid-dev https://github.com/yKanazawa/sendgrid-dev/releases/download/v0.9.0/sendgrid-dev_$(if [ $(uname -m) = "aarch64" ]; then echo aarch64; else echo x86_64; fi)
RUN chmod 755 /usr/local/bin/sendgrid-dev

# superviserd
COPY supervisor/supervisord.conf /etc/supervisord.conf
COPY supervisor/app.conf /etc/supervisor/conf.d/app.conf
RUN echo files = /etc/supervisor/conf.d/*.conf >> /etc/supervisord.conf

# remove temporary packages
RUN apk del .temp-pkgs

# Service to run
CMD ["/usr/bin/supervisord"]
