FROM amd64/ubuntu:20.04
# setup and update system
ENV LANG C.UTF-8
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libasound2 libfreetype6 libxdmcp6 libxext6 libxrender1 \
    libxtst6 libxi6 libxau6 libxdmcp6 libxcb1 libpangoft2-1.0-0 xvfb fonts-liberation \
    libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 libcairo2 libcups2 libdbus-1-3 libgbm1 \
    libgdk-pixbuf2.0-0 libgtk-3-0 libnspr4 libnss3 libpangocairo-1.0-0 libxcomposite1  \
    libxkbcommon0 libxrandr2 xdg-utils
RUN apt-get -y install fonts-dejavu fontconfig
RUN apt-get -y install wget procps curl jq git
# prepare environment
RUN useradd -g root -ms /bin/bash devbot
RUN mkdir -p /builds
RUN mkdir -p /projects/work
RUN mkdir -p /projects/bin
RUN chmod ug=rwx,o=rx /builds /projects /tmp
RUN chown devbot.root /builds /projects
WORKDIR /projects/work
# download development toolchain
# Java 8 for tooling
RUN wget --no-verbose "https://download.bell-sw.com/java/8u275+1/bellsoft-jre8u275+1-linux-amd64.deb"
RUN dpkg -i "bellsoft-jre8u275+1-linux-amd64.deb"
# Java 14 for development
RUN wget --no-verbose "https://download.bell-sw.com/java/14.0.2+13/bellsoft-jdk14.0.2+13-linux-amd64-full.deb"
RUN dpkg -i "bellsoft-jdk14.0.2+13-linux-amd64-full.deb"
## Maven
WORKDIR /projects/work
RUN wget --no-verbose "https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz"
WORKDIR /projects/bin
RUN tar xzvf "../work/apache-maven-3.6.3-bin.tar.gz"
## Install4j
WORKDIR /projects/work
RUN wget --no-verbose "https://download-gcdn.ej-technologies.com/install4j/install4j_unix_7_0_12.tar.gz"
WORKDIR /projects/bin
RUN tar xzvf "../work/install4j_unix_7_0_12.tar.gz"
# copy install4j jres for install bundles
COPY jres/macosx-amd64-14.0.2.tar.gz /projects/bin/install4j7.0.12/jres/.
COPY jres/windows-amd64-14.0.2.tar.gz /projects/bin/install4j7.0.12/jres/.
## Chrome Headless
WORKDIR /projects/work
RUN wget --no-verbose "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
RUN dpkg -i "google-chrome-stable_current_amd64.deb"
# install development toolchain
RUN rm -f "../work/*"
RUN apt clean
# setup environment
ENV JAVA_HOME "/usr/lib/jvm/bellsoft-java14-full-amd64"
ENV MAVEN_HOME "/projects/bin/apache-maven-3.6.3"
ENV INSTALL4J_JAVA_HOME "/usr/lib/jvm/bellsoft-java8-runtime-amd64"
ENV INSTALL4J_HOME "/projects/bin/install4j7.0.12"
ENV PATH "${MAVEN_HOME}/bin:${INSTALL4J_HOME}/bin:${PATH}"
# final update
RUN apt-get -y update
RUN apt-get -y upgrade
# output info
RUN wget --version
RUN curl --version
RUN git --version
RUN javac -version
RUN mvn -v
RUN install4jc -V
WORKDIR /projects
USER devbot
