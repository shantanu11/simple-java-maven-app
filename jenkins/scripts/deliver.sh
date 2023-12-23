#!/usr/bin/env bash

# Echo the purpose of this script
echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'

#!/usr/bin/env bash

#The following commands install your Java application into the local Maven repository
set -x
mvn jar:jar install:install help:evaluate -Dexpression=project.name
set +x

# Extracting project name and version from the pom.xml
NAME=$(mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout)
VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)

# Constructing jar file name and path
JAR_NAME="${NAME}-${VERSION}.jar"
JAR_PATH="target/${JAR_NAME}"

# Printing the expected path for debugging
echo "Expected jar path: $JAR_PATH"

# Running the Java application if the jar exists
if [ -f "$JAR_PATH" ]; then
    java -jar $JAR_PATH
else
    echo "Error: Jar file not found at $JAR_PATH"
    exit 1
fi
