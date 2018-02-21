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
BRANCH=$(git rev-parse --short HEAD)

bundle install
bundle exec ruby compiler.rb -p products/compute -e terraform -o "${GOPATH}/src/github.com/terraform-providers/terraform-provider-google/"

cd "build/terraform"
git add -A
git config --global user.email "nmckinley@google.com"
git config --global user.name "Magic Module Bot"
git commit -m "magic modules change happened here" || true  # don't crash if no changes
git checkout -B $BRANCH

cd "../../"
git config -f .gitmodules submodule.build/terraform.branch $BRANCH
git config -f .gitmodules submodule.build/terraform.url "git@github.com:$GH_USERNAME/terraform-provider-google.git"
git submodule sync

# ./branchname is intentionally not committed - but run *before* the commit, because it should contain the hash of
# the commit which kicked off this process, *not* the resulting commit.
echo "$BRANCH" > ./branchname

git add build/terraform
git add .gitmodules
git commit -m "update terraform." || true  # don't crash if no changes
git checkout -B $BRANCH

cp -r ./ "${WORKDIR}/mm-output/"
