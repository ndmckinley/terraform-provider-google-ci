#!/bin/bash

# Setup GOPATH
WORKDIR="${PWD}"

set -x
set -e

cd "${WORKDIR}/mm-output"
git submodule sync
git submodule update build/terraform

git add build/terraform
git config --global user.email "nmckinley@google.com"
git config --global user.name "Magic Module Bot"
git commit --amend -m "update terraform." || true  # don't crash if no changes

cp -r ./ "${WORKDIR}/mm-put/"
