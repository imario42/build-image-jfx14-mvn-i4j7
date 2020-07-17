# Toolchain for JavaFX 14 applications.

This image switches from the usual ``root`` to the user ``devbot`` which is then used to run the build.

This allows you to use [Embedded PostgreSQL (opentable/otj-pg-embedded)](https://github.com/opentable/otj-pg-embedded) in your application tests.\
Rights have been setup so that this image can be used as [Gitlab Runner](https://docs.gitlab.com/runner/) image.

## Containing
* [bellsoft-jdk14.0.2+13-linux-amd64-full (JavaFX included)](https://bell-sw.com/java)
* [apache-maven-3.6.3](https://maven.apache.org/index.html)
* [install4j_unix_7_0_12](https://www.ej-technologies.com/products/install4j/overview.html)
* [bellsoft-jre8u252+9-linux-amd64 (for Install4j)](https://bell-sw.com/java)

## Environment
|**Name**|**Value**|
|----|-----|
|JAVA_HOME|/usr/lib/jvm/bellsoft-java14-full-amd64|
|MAVEN_HOME|/projects/bin/apache-maven-3.6.3|
|INSTALL4J_JAVA_HOME|/usr/lib/jvm/bellsoft-java8-runtime-amd64|
|INSTALL4J_HOME|/projects/bin/install4j7.0.12|
