FROM ubuntu

MAINTAINER Rafael Avila <rafa.avim@gmail.com>

EXPOSE 80
EXPOSE 443

# update and install dependencies
RUN apt-get update
RUN apt-get install -y git git-core nginx curl
RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get install -y nodejs npm
RUN ln -s "$(which nodejs)" /usr/bin/node

# configure nginx ssl
RUN service nginx stop
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/cert.key -out /etc/nginx/cert.crt

RUN useradd -ms /bin/bash appRunner
USER appRunner
WORKDIR /home/appRunner

# clone and install c9 SDK
RUN git clone git://github.com/c9/core.git c9sdk
WORKDIR /home/appRunner/c9sdk
RUN scripts/install-sdk.sh

CMD [ "node server.js --port 8080" ]
