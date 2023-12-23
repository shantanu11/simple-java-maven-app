#!/usr/bin/env bash

# Echo the purpose of this script
echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'

#!/usr/bin/env bash
#!/usr/bin/env bash

# Install the project into the local Maven repository
mvn jar:jar install:install help:evaluate -Dexpression=project.name

# Extracting project name and version from the pom.xml
NAME=$(mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout)
VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)

# Debug: print the variables
echo "NAME: $NAME, VERSION: $VERSION"

#!/usr/bin/env bash

# Define NAME and VERSION directly
NAME="my-app"
VERSION="1.0-SNAPSHOT"

# Constructing jar file name and path
JAR_NAME="${NAME}-${VERSION}.jar"
JAR_PATH="target/${JAR_NAME}"

# Print the expected jar path for debugging
echo "Expected jar path: $JAR_PATH"

# Listing files in target directory for debugging
echo "Listing files in target directory:"
ls target/

# Running the Java application if the jar exists
if [ -f "$JAR_PATH" ]; then
    java -jar $JAR_PATH
else
    echo "Error: Jar file not found at $JAR_PATH"
    exit 1
fi
