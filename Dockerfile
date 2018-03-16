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

FROM centos:6

RUN yum update -y \
  && yum install -y \
    curl \
    git \
    initscripts \
    java-1.8.0-openjdk-headless \
    openssl \
    python \
    redhat-lsb \
    sudo \
    vim \
    unzip \
    wget \
    which \
    zlibc \
  && yum clean all \
  && rm -rf /var/cache/yum

ENV TINI_VERSION v0.17.0
RUN curl -L -o /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-amd64 && chmod +x /tini

WORKDIR /opt
RUN git clone --no-checkout https://github.com/adoroszlai/launcher.git && cd /opt/launcher && git checkout a35b778
WORKDIR /opt/launcher
ENV ENVTOCONF_URL https://github.com/adoroszlai/launcher/raw/envtoconf_ini/plugins/010_envtoconf/envtoconf
RUN find -name onbuild.sh | xargs -n1 bash -c

ENV "AMBARI.PROPERTIES!CFG_java.home" /usr/lib/jvm/jre-1.8.0-openjdk.x86_64
ENV "AMBARI.PROPERTIES!CFG_server.os_family" redhat6
ENV "AMBARI.PROPERTIES!CFG_server.os_type" centos6

WORKDIR /
ENTRYPOINT [ "/tini", "--", "/opt/launcher/launcher.sh" ]
CMD [ "/bin/bash" ]
