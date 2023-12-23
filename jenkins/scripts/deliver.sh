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

# Extract the project name and version from the pom.xml
echo 'Extracting the project name and version from pom.xml'
set -x
NAME=$(mvn help:evaluate -Dexpression=project.artifactId | grep "^[^\[]" | tr -d '[:space:]')
VERSION=$(mvn help:evaluate -Dexpression=project.version | grep "^[^\[]" | tr -d '[:space:]')
set +x

# Echo the name and version
echo "Project Name: $NAME"
echo "Version: $VERSION"

# Execute the Java application using the jar file
echo 'Running the Java application.'
set -x

# Constructing the jar file name based on the extracted project name and version
JAR_NAME="${NAME}-${VERSION}.jar"
JAR_PATH="target/${JAR_NAME}"

# Check if the jar exists and is a file before attempting to run
if [ -f "$JAR_PATH" ]; then
    java -jar $JAR_PATH
else
    echo "Error: Jar file not found at $JAR_PATH"
    exit 1
fi
