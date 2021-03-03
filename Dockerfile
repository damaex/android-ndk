FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y install git wget curl unzip default-jdk

# download and install Android SDK
# https://developer.android.com/studio#command-tools
ARG ANDROID_SDK_VERSION=6858069
ENV ANDROID_SDK_ROOT /opt/android-sdk
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip && \
    unzip *tools*linux*.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/tools && \
    rm *tools*linux*.zip

ENV PATH ${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin:${ANDROID_SDK_ROOT}/platform-tools

# update SDK manager
RUN yes | sdkmanager --licenses && yes | sdkmanager --update

# install system image, platform and build tools
RUN sdkmanager \
  "tools" \
  "platform-tools"

RUN sdkmanager \
  "build-tools;29.0.0" \
  "build-tools;29.0.1" \
  "build-tools;29.0.2" \
  "build-tools;29.0.3" \
  "build-tools;30.0.0" \
  "build-tools;30.0.1" \
  "build-tools;30.0.3"

# install platforms
RUN sdkmanager \
  "platforms;android-29" \
  "platforms;android-30"

# install cmake
RUN sdkmanager \
  "cmake;3.10.2.4988404" \
  "cmake;3.6.4111459"

# install extras
RUN sdkmanager \
  "extras;android;m2repository" \
  "extras;google;auto" \
  "extras;google;google_play_services" \
  "extras;google;m2repository" \
  "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2" \
  "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" \
  "patcher;v4"

# install ndk-bundle (newest ndk)
RUN sdkmanager "ndk-bundle"
