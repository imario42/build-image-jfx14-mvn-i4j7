FROM amd64/ubuntu:20.04
# setup and update system
ENV LANG C.UTF-8
RUN apt-get update
RUN apt-get -y install wget
# prepare environment
RUN useradd -g root -ms /bin/bash devbot
RUN mkdir -p /builds
RUN mkdir -p /projects/work
RUN mkdir -p /projects/bin
RUN chmod ug=rwx,o=rx /builds /projects /tmp
RUN chown devbot.root /builds /projects
WORKDIR /projects/work
# download development toolchain
RUN apt-get -y install libasound2 libfreetype6 libxdmcp6 libxext6 libxrender1 libxtst6 libxi6 libxau6 libxdmcp6 libxcb1
# Java 8 for tooling
RUN wget --no-verbose "https://download.bell-sw.com/java/8u252+9/bellsoft-jre8u252+9-linux-amd64.deb"
# Java 14 for development & build
RUN wget --no-verbose "https://download.bell-sw.com/java/14.0.2+13/bellsoft-jdk14.0.2+13-linux-amd64-full.deb"
RUN wget --no-verbose "https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz"
RUN wget --no-verbose "https://download-gcdn.ej-technologies.com/install4j/install4j_unix_7_0_12.tar.gz"
# install development toolchain
RUN dpkg -i "bellsoft-jre8u252+9-linux-amd64.deb"
RUN dpkg -i "bellsoft-jdk14.0.2+13-linux-amd64-full.deb"
WORKDIR /projects/bin
RUN tar xzvf "../work/apache-maven-3.6.3-bin.tar.gz"
RUN tar xzvf "../work/install4j_unix_7_0_12.tar.gz"
RUN rm -f "../work/*"
# copy install4j jres for install bundles
COPY jres/macosx-amd64-14.0.2.tar.gz /projects/bin/install4j7.0.12/jres/.
COPY jres/windows-amd64-14.0.2.tar.gz /projects/bin/install4j7.0.12/jres/.
# setup environment
ENV JAVA_HOME "/usr/lib/jvm/bellsoft-java14-full-amd64"
ENV MAVEN_HOME "/projects/bin/apache-maven-3.6.3"
ENV INSTALL4J_JAVA_HOME "/usr/lib/jvm/bellsoft-java8-runtime-amd64"
ENV INSTALL4J_HOME "/projects/bin/install4j7.0.12"
ENV PATH "${MAVEN_HOME}/bin:${INSTALL4J_HOME}/bin:${PATH}"
# output info
RUN javac -version
RUN mvn -v
RUN install4jc -V
WORKDIR /projects
USER devbot
