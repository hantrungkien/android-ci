### Continous Integration (CI) for Android apps on GitLab

![Docker Pulls](https://img.shields.io/docker/pulls/hantrungkien/android-ci.svg)
![Docker Automated](https://img.shields.io/docker/automated/hantrungkien/android-ci.svg)
![Docker Build](https://img.shields.io/docker/cloud/build/hantrungkien/android-ci.svg)

## Sample usages
### GitLab
*.gitlab-ci.yml*

```yml
image: hantrungkien/android-ci:latest

before_script:
    - export GRADLE_USER_HOME=`pwd`/.gradle
    - mkdir -p $GRADLE_USER_HOME
    - chmod +x ./gradlew

cache:
  key: "$CI_COMMIT_REF_NAME"
  paths:
     - .gradle/

stages:
  - build
  - test

build:
  stage: build
  script:
     - ./gradlew assembleDebug
  artifacts:
    paths:
      - app/build/outputs/apk/

unitTests:
  stage: test
  script:
    - ./gradlew test
```
