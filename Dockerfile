FROM openjdk:11-jdk

LABEL maintainer="NickHuang <nickhuang@climax.com.tw>"

# ANDROID_HOME ENV
ENV ANDROID_HOME=/opt/android-sdk-linux

# Create android sdk directory
RUN mkdir -p ${ANDROID_HOME}

# Download sdkmanager
RUN cd ${ANDROID_HOME} \
    && curl -o commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip \
    && unzip commandlinetools.zip \
    && rm commandlinetools.zip

# Download android sdk, ndk and tools
RUN ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --list
RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses 
RUN ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools" "platforms;android-28" "ndk-bundle"
ENV PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

# Define Gradle versions to download
ENV GRADLE_VERSIONS="5.4.1 6.1.1"

# Download and install multiple versions of Gradle
RUN mkdir /opt/gradle && \
    for version in ${GRADLE_VERSIONS}; do \
        wget -q https://services.gradle.org/distributions/gradle-${version}-bin.zip -P /tmp && \
        unzip /tmp/gradle-${version}-bin.zip -d /opt/gradle && \
        rm /tmp/gradle-${version}-bin.zip; \
    done

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Environment variable to manage Gradle versions
ENV GRADLE_HOME=/opt/gradle