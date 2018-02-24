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

FROM openjdk:8-jdk-slim

RUN apt-get update -q \
  && apt-get install -y --no-install-recommends \
    curl \
    git \
    net-tools \
    procps \
    python2.7 \
    sudo \
    vim \
    wget \
    zlibc \
  && rm -rf /var/lib/apt/lists/*

ENV TINI_VERSION v0.17.0
RUN curl -L -o /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-amd64 && chmod +x /tini

WORKDIR /opt
RUN git clone --no-checkout https://github.com/adoroszlai/launcher.git && cd /opt/launcher && git checkout 0229967
WORKDIR /opt/launcher
ENV ENVTOCONF_URL https://github.com/adoroszlai/launcher/raw/envtoconf_ini/plugins/010_envtoconf/envtoconf
RUN find -name onbuild.sh | xargs -n1 bash -c

WORKDIR /
ENTRYPOINT [ "/tini", "--", "/opt/launcher/launcher.sh" ]
CMD [ "/bin/bash" ]
