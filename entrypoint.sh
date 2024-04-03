#!/bin/sh

# check if the required environment variables are set
echo "The following environment variables are set: "
echo "  - API_TOKEN: ${API_TOKEN}"
echo "  - REDDIT_USERNAME: ${REDDIT_USERNAME}"
echo "  - USER_AGENT: ${USER_AGENT}"
echo "  - REDIRECT_URI: ${REDIRECT_URI}"

echo "Running the script..."

# download / update the source code
if [ -d "Infinity-For-Reddit" ]; then
  echo "The source code is already downloaded. Updating the source code..."
  cd Infinity-For-Reddit
  git fetch --all
  git reset --hard origin/master
else
  echo "Downloading the source code..."
  git clone https://github.com/Docile-Alligator/Infinity-For-Reddit
fi

cd /Infinity-For-Reddit

# change api token, user agent and redirect uri in the source code
APIUTILS_FILE="/Infinity-For-Reddit/app/src/main/java/ml/docilealligator/infinityforreddit/utils/APIUtils.java"
sed -i "s/NOe2iKrPPzwscA/${API_TOKEN}/g" "${APIUTILS_FILE}"
sed -i "s/infinity:\/\/localhost/${REDIRECT_URI}/g" "${APIUTILS_FILE}"
sed -i "s/public static final String USER_AGENT = \".*\";/public static final String USER_AGENT = \"${USER_AGENT}\";/g" "${APIUTILS_FILE}"

# add keystore
wget -P ../ "https://github.com/TanukiAI/Infinity-keystore/raw/main/Infinity.jks"
BUILD_GRADLE_FILE="/Infinity-For-Reddit/app/build.gradle"
sed -i "s/buildTypes {/signingConfigs {\n        release {\n            storeFile file(\"\/Infinity.jks\")\n            storePassword \"Infinity\"\n            keyAlias \"Infinity\"\n            keyPassword \"Infinity\"\n        }\n    }\n    buildTypes {/g" "${BUILD_GRADLE_FILE}"
sed -i "/buildTypes {/{N; s/release {/release {\n            signingConfig signingConfigs.release/g}" "${BUILD_GRADLE_FILE}"

# build the apk
./gradlew assembleRelease

# copy the apt to root
cp /Infinity-For-Reddit/app/build/outputs/apk/release/app-release.apk /Infinity.apk --force
echo "The APK is available at /Infinity.apk"
echo "Please run the following command to copy the APK to the host:"
echo "  docker cp <container_id>:/Infinity.apk ."
echo "The container id is \"infinity-build\" if you used docker compose."

exit 0