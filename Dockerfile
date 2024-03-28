FROM azul/zulu-openjdk:11-latest

ARG api_token=""
ARG reddit_username=""

ENV API_TOKEN=${api_token}
ENV REDDIT_USERNAME=${reddit_username}
ENV USER_AGENT="android:personal-app:0.0.1 (by \/u\/${REDDIT_USERNAME})"
ENV REDIRECT_URI="http:\/\/127.0.0.1"

# if api token and username are not provided, then raise error and exit
RUN if [ -z "$API_TOKEN" ] || [ -z "$REDDIT_USERNAME" ]; then echo "API token and Reddit username are required"; exit 1; fi

# install required packages
RUN apt-get update && apt-get install -y git wget unzip

# download the Android SDK
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip
RUN unzip -q android-sdk.zip -d android-sdk && rm android-sdk.zip
ENV ANDROID_SDK_ROOT="/android-sdk"
ENV PATH=$PATH:${ANDROID_SDK_ROOT}/tools/bin:${ANDROID_SDK_ROOT}/platform-tools

# setup sdkmanager
RUN yes | ${ANDROID_SDK_ROOT}/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platforms;android-30" "build-tools;30.0.3"

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]