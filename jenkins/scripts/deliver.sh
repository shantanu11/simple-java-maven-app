#!/usr/bin/env bash

# Echo the purpose of this script
echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'

# Install the project into the local Maven repository
set -x
mvn jar:jar install:install help:evaluate -Dexpression=project.name
set +x

# Extracting the project name and version from pom.xml
echo 'Extracting the project name and version from pom.xml'
set -x
NAME=$(mvn help:evaluate -Dexpression=project.artifactId | grep -E '^\[.*' | tr -d '[:space:]')
VERSION=$(mvn help:evaluate -Dexpression=project.version | grep -E '^\[.*' | tr -d '[:space:]')
set +x

# Running the Java application
echo 'Running the Java application.'
set -x

JAR_NAME="${NAME}-${VERSION}.jar"
JAR_PATH="target/${JAR_NAME}"

echo "Looking for jar at: $JAR_PATH"

if [ -f "$JAR_PATH" ]; then
    java -jar $JAR_PATH
else
    echo "Error: Jar file not found at $JAR_PATH"
    exit 1
fi
