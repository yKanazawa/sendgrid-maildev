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

# MailDev
RUN npm install -g maildev

# sendgrid-dev
COPY sendgrid-dev /usr/local/bin/sendgrid-dev

# superviserd
COPY supervisor/supervisord.conf /etc/supervisord.conf
COPY supervisor/app.conf /etc/supervisor/conf.d/app.conf
RUN echo files = /etc/supervisor/conf.d/*.conf >> /etc/supervisord.conf

# Service to run
CMD ["/usr/bin/supervisord"]
