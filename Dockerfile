FROM alpine

LABEL net.juniper.image.maintainer="Juniper Networks <jnpr-community-netdev@juniper.net>" \
      net.juniper.image.description="Lightweight image with Ansible and the Junos roles"

RUN apk add --no-cache build-base python3-dev py3-pip \
    openssl-dev curl ca-certificates bash openssh-client \
    libffi-dev

WORKDIR /tmp
COPY requirements.txt .
RUN pip3 install -r requirements.txt --break-system-packages

RUN apk del -r --purge gcc make g++ &&\
    rm -rf /source/* &&\
    rm -rf /var/cache/apk/* &&\
    rm -rf /tmp/*

#WORKDIR /usr/share/ansible/collections/ansible_collections/
# COPY ansible_collections/ .

WORKDIR /usr/bin
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

WORKDIR /project

VOLUME /project

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
