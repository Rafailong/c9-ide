FROM ubuntu

MAINTAINER Rafael Avila <rafa.avim@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV IDE_WORKSPACE /home/appRunner/app

COPY /certs /etc/nginx/certs
COPY upgrade-python.sh /
COPY proxy-config /proxy-config

# update and install dependencies
RUN apt-get update
RUN apt-get install -y git git-core nginx curl build-essential

RUN chmod +x upgrade-python.sh
RUN ./upgrade-python.sh

RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get install -y nodejs

# configure nginx ssl
RUN service nginx stop
RUN cat /proxy-config/config > /etc/nginx/sites-available/default
RUN service nginx start

# clone and install c9 SDK
RUN git clone git://github.com/c9/core.git c9sdk
WORKDIR /c9sdk
RUN scripts/install-sdk.sh

ENTRYPOINT exec node server.js --port 8080 -w ${IDE_WORKSPACE}

# docker run -it --name="c9" -p 8080:80 -p 8888:443 -v app:/home/appRunner/app c9-ide
