FROM alpine:3.19.1

ENV APP_ROOT /var/www/html

# install packages
RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
    busybox-extras \
    bash \
    curl \
    gcompat \
    git \
    mailx \
    supervisor \
    nodejs \
    npm

# MailDev
RUN npm install -g maildev

# sendgrid-dev
RUN curl -L -o /usr/local/bin/sendgrid-dev https://github.com/yKanazawa/sendgrid-dev/releases/download/v0.9.3/sendgrid-dev_$(if [ $(uname -m) = "aarch64" ]; then echo aarch64; else echo x86_64; fi)
RUN chmod 755 /usr/local/bin/sendgrid-dev

# superviserd
COPY supervisor/supervisord.conf /etc/supervisord.conf
COPY supervisor/app.conf /etc/supervisor/conf.d/app.conf
RUN echo files = /etc/supervisor/conf.d/*.conf >> /etc/supervisord.conf

# Service to run
CMD ["/usr/bin/supervisord"]
