FROM ubuntu:16.04

# Copy load test files into container
#COPY testing/artillery/load.yaml .

WORKDIR /Users/Riley/Documents/NSC Application Development/NSC Winter 2021/AD440/ad440-winter2021-tuesday-repo/testing/kubernetes-perf-test

RUN apk add --update nodejs nodejs-npm
SHELL [ "pwsh", "--Command" ]

COPY /Users/Riley/Documents/NSC Application Development/NSC Winter 2021/AD440/ad440-winter2021-tuesday-repo/ui/package.json/

# Restore the NPM packages
RUN ["npm", "install"]

RUN pwsh -c Install-Module -Name Az -AllowClobber -Force

#COPY ./artifacts/ .
COPY ./container-scripts/ .

# Build time argument
ARG ARTILLERY_ENVIRONMENT=dev
ARG RESULTS_FILE_SHARE=.
ARG REPORT_NAME=report
ARG ARTILLERYIO_FILE=./load.yml 

# Run time argument, default to the build time argument
ENV ARTILLERY_ENVIRONMENT=$ARTILLERY_ENVIRONMENT
ENV RESULTS_FILE_SHARE=$RESULTS_FILE_SHARE
ENV REPORT_NAME=$REPORT_NAME
ENV ARTILLERYIO_FILE=$ARTILLERYIO_FILE
ENV AZ_STORAGE_ACCOUNT=''
ENV AZ_STORAGE_KEY=''
ENV LOAD_TEST_NAME=''

ENTRYPOINT [ "pwsh", "run-load-test.ps1" ]