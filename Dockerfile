FROM python:rc-alpine

ARG TERRAFORM_VERSION=0.14.6
ARG HASHICORP_RELEASES=https://releases.hashicorp.com

RUN apk add --no-cache --update \
    ca-certificates \
    openssl

RUN wget ${HASHICORP_RELEASES}/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O /tmp/terraform.zip && \
    unzip -d /usr/bin /tmp/terraform.zip && \
    rm /tmp/terraform.zip && \
    chmod +x /usr/bin/terraform

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

COPY . /terrestrial
RUN chown -R nobody:nobody /terrestrial

USER nobody
WORKDIR /terrestrial

RUN cd terrestrial/ && \
    git clone --recurse-submodules https://github.com/bio-platform/bioportal_configs.git && \
    mv bioportal_configs configurations

ENTRYPOINT ["/terrestrial/entrypoint.sh"]
