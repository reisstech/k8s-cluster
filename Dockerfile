FROM ubuntu:latest
RUN apt-get update && \
apt-get install ansible wget unzip curl python3-pip -y && \
pip3 install boto3 botocore &&\
wget https://releases.hashicorp.com/terraform/1.1.5/terraform_1.1.5_linux_amd64.zip -O /tmp/terraform_1.1.5_linux_amd64.zip && \
unzip /tmp/terraform_1.1.5_linux_amd64.zip -d /usr/bin