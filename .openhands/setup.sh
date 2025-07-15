#!/bin/bash
apt-get update && apt-get install -y curl \
                                    libc6 \
                                    libgcc-s1 \
                                    libgssapi-krb5-2 \
                                    libicu72 \
                                    libssl3 \
                                    libstdc++6 \
                                    zlib1g 
curl -L https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
chmod +x /tmp/dotnet-install.sh && /tmp/dotnet-install.sh --channel 6.0
export PATH=$PATH:/root/.dotnet
echo "export PATH=\$PATH:/root/.dotnet" >> /root/.bashrc