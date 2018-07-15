# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM debian:9-slim

# workaround for:
# update-alternatives: error: error creating symbolic link `/usr/share/man/man1/java.1.gz.dpkg-tmp': No such file or directory
RUN mkdir -p /usr/share/man/man1/

RUN apt-get update -q \
  && apt-get install -y --no-install-recommends \
    curl \
    git \
    net-tools \
    netcat \
    openjdk-8-jre-headless \
    openssl \
    procps \
    python2.7 \
    sudo \
    vim \
    unzip \
    wget \
    zlibc \
  && rm -rf /var/lib/apt/lists/*

ENV TINI_VERSION v0.17.0
RUN curl -L -o /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-amd64 && chmod +x /tini

WORKDIR /opt
RUN git clone https://github.com/adoroszlai/launcher.git
WORKDIR /opt/launcher
ENV ENVTOCONF_URL https://github.com/adoroszlai/launcher/raw/envtoconf_ini/plugins/010_envtoconf/envtoconf
RUN find -name onbuild.sh | xargs -n1 bash -c

ENV "AMBARI.PROPERTIES!CFG_java.home" /usr/lib/jvm/java-7-openjdk-amd64/jre
ENV "AMBARI.PROPERTIES!CFG_server.os_family" debian
ENV "AMBARI.PROPERTIES!CFG_server.os_type" debian9

WORKDIR /
ENTRYPOINT [ "/tini", "--", "/opt/launcher/launcher.sh" ]
CMD [ "/bin/bash" ]
