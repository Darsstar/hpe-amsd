FROM ubuntu:24.04

LABEL org.opencontainers.image.source="https://github.com/endrebjorsvik/hpe-amsd"
LABEL org.opencontainers.image.description="Small container for running HPE AMS software in a privileged container on TrueNAS Scale."
LABEL org.opencontainers.image.licenses="MIT"

# Install dependencies for populating APT keyring
RUN apt-get update && apt-get install -y curl gnupg apt-utils iproute2 && apt-get clean && rm -rf /var/lib/apt/lists/*

# See https://downloads.linux.hpe.com/SDR/keys.html for repo signing keys
RUN mkdir -m 0755 -p /etc/apt/keyrings
#RUN curl https://downloads.linux.hpe.com/SDR/hpPublicKey2048_key1.pub | gpg --dearmor -o /etc/apt/keyrings/hpPublicKey2048_key1.gpg
#RUN curl https://downloads.linux.hpe.com/SDR/hpePublicKey2048_key1.pub | gpg --dearmor -o /etc/apt/keyrings/hpePublicKey2048_key1.gpg
RUN curl https://downloads.linux.hpe.com/SDR/hpePublicKey2048_key2.pub | gpg --dearmor -o /etc/apt/keyrings/hpePublicKey2048_key2.gpg
RUN chmod 644 /etc/apt/keyrings/*
RUN apt-key list --keyring /etc/apt/keyrings/hpePublicKey2048_key2.gpg

# Add repo definition (deb822 style)
ADD mcp.sources /etc/apt/sources.list.d/

RUN apt-get update && apt-get install -y amsd hponcfg storcli ssa ssacli ssaducli && apt-get clean && rm -rf /var/lib/apt/lists/*

ADD start.sh /
RUN chmod +x /start.sh
CMD ["/start.sh"]
