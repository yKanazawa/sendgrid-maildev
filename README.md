# Overview

SendGrid MailDev is [SengGrid mock API](https://github.com/yKanazawa/sendgrid-dev) + [MailDev](https://maildev.github.io/maildev/). 
For test your sendgrid emails during development. 

# Example of development

![](https://raw.githubusercontent.com/yKanazawa/sendgrid-maildev/master/img/example_of_development.png)

## Example of docker-compose.yml

The setting environment variables are default values.

```
version: '2'

services:
  sendgrid-maildev:
    image: ykanazawa/sendgrid-maildev
    hostname: sendgrid-maildev
    environment:
      - SENDGRID_DEV_API_SERVER=:3030
      - SENDGRID_DEV_API_KEY=SG.xxxxx
      - SENDGRID_DEV_SMTP_SERVER=127.0.0.1:1025
    container_name: sendgrid-maildev
    ports:
      - 1025:1025
      - 1080:1080
      - 3030:3030
```

## Example with curl

```
% docker exec -it sendgrid-maildev bash
# curl --request POST \
  --url http://127.0.0.1:3030/v3/mail/send \
  --header 'Authorization: Bearer SG.xxxxx' \
  --header 'Content-Type: application/json' \
  --data '{"personalizations": [{ 
    "to": [{"email": "to@example.com"}]}], 
    "from": {"email": "from@example.com"}, 
    "subject": "Test Subject", 
    "content": [{"type": "text/plain", "value": "Test Content"}] 
  }'
```

# Example of AWS

![](https://raw.githubusercontent.com/yKanazawa/sendgrid-maildev/master/img/example_of_aws.png)
