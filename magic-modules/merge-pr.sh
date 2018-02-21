#!/bin/bash

set -e
set -x

echo "$CREDS" > ~/github_private_key
chmod 400 ~/github_private_key


shopt -s dotglob
cd mm-approved-prs
ID=$(git config --get pullrequest.id)
BRANCH=$(git config --get pullrequest.branch)
cd ..
cp -r mm-approved-prs/* mm-output

cd mm-output
git config pullrequest.id $ID
git checkout $BRANCH
git config --global user.email "nmckinley@google.com"
git config --global user.name "Magic Module Bot"
git config -f .gitmodules submodule.build/terraform.branch master
git config -f .gitmodules submodule.build/terraform.url "git@github.com:terraform-providers/terraform-provider-google.git"
ssh-agent bash -c "ssh-add ~/github_private_key; git submodule update --remote --init build/terraform"

git add build/terraform
git add .gitmodules

git commit -m "Update terraform -> HEAD on `date`"
echo "Merged PR #$ID." > ./commit_message
