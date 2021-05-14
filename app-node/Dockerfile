FROM alpine:3.13
WORKDIR /etc/apk/keys
RUN wget http://alpine.adiscon.com/rsyslog@lists.adiscon.com-5a55e598.rsa.pub
RUN echo 'http://alpine.adiscon.com/3.7/stable' >> /etc/apk/repositories
RUN apk update && apk add rsyslog
