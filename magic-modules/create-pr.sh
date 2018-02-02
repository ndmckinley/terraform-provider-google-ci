#!/bin/bash

set -e
set -x

shopt -s dotglob
cp -r magic-modules/* magic-modules-out
cd magic-modules-out
git checkout -t $(git branch -a --contains $(git rev-parse HEAD) | grep -v "detached")
git config pullrequest.id new
cd build/terraform

git checkout -t $(git branch -a --contains $(git rev-parse HEAD) | grep -v "detached")
git config pullrequest.id new
