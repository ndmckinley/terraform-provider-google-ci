#!/bin/bash

# Setup GOPATH
export GOPATH="${PWD}/go"
WORKDIR="${PWD}"

set -x
set -e

# Create GOPATH structure
mkdir -p "${GOPATH}/src/github.com/terraform-providers"

cd magic-modules
git submodule update --init build/terraform
ln -s "${PWD}/build/terraform/" "${GOPATH}/src/github.com/terraform-providers/terraform-provider-google"

cd "${GOPATH}/src/github.com/terraform-providers/terraform-provider-google"

go get

cd "${WORKDIR}/magic-modules"

bundle install
bundle exec ruby compiler.rb -p products/compute -e terraform -o "${GOPATH}/src/github.com/terraform-providers/terraform-provider-google/google/" -t BackendBucket

cd "build/terraform"
git add -A
git config user.email "nmckinley@google.com"
git config user.name "Magic Module Bot"
git commit -m "magic modules change happened here"
git checkout -B magic_modules

cd "../../"

cp -r ./ "${WORKDIR}/mm-output/"
