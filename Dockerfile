FROM openjdk:8-jdk

MAINTAINER KienHT<kienhantrung@gmai.com>

ENV ANDROID_SDK_ROOT "/sdk"
ENV ANDROID_HOME "${ANDROID_SDK_ROOT}"
ENV ANDROID_NDK_HOME "${ANDROID_SDK_ROOT}/ndk-bundle"
ENV PATH "$PATH:${ANDROID_SDK_ROOT}/tools"
ENV GRADLE_USER_HOME=$PWD/.gradle
ENV VERSION_TOOLS "6609375"
ENV ANDROID_CMAKE_REV_3_10="3.10.2.4988404"
ENV VERSION_ANDROID_NDK="android-ndk-r11"

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update \
 	&& apt-get install -qqy --no-install-recommends \
 		apt-utils \
      	curl \
      	lib32stdc++6 \
      	unzip \
 	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& apt-get autoremove -y \
	&& apt-get clean

RUN curl -s https://dl.google.com/android/repository/commandlinetools-linux-${VERSION_TOOLS}_latest.zip > /tools.zip \
 	&& mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
 	&& unzip /tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
 	&& rm -v /tools.zip

RUN mkdir -p $ANDROID_SDK_ROOT/licenses/ \
 	&& echo "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e\n24333f8a63b6825ea9c5514f83c2829b004d1fee" > $ANDROID_SDK_ROOT/licenses/android-sdk-license \
 	&& echo "84831b9409646a918e30573bab4c9c91346d8abd\n504667f4c0de7af1a06de9f4b1727b84351f2910" > $ANDROID_SDK_ROOT/licenses/android-sdk-preview-license \
	&& yes | ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses >/dev/null

ADD packages.txt /sdk
RUN mkdir -p /root/.android \
	&& touch /root/.android/repositories.cfg \
	&& ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --update

RUN while read -r package; do PACKAGES="${PACKAGES}${package} "; done < /sdk/packages.txt \
	&& ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} ${PACKAGES}

RUN curl -s https://dl.google.com/android/repository/${VERSION_ANDROID_NDK}-linux-x86_64.zip > /ndk.zip \
	&& unzip /ndk.zip -d $ANDROID_NDK_HOME \
    && rm -v /ndk.zip

RUN yes | ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager --channel=3 --channel=1 'cmake;'$ANDROID_CMAKE_REV_3_10 \
    && yes | ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager 'ndk-bundle' 