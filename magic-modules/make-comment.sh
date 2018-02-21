#!/bin/bash

set -e
set -x

shopt -s dotglob
cd mm-initial-pr
ID=$(git config --get pullrequest.id)
BRANCH=$(git config --get pullrequest.branch)
echo $BRANCH
echo $ID
cat .git/branch
cd ..
cp -r magic-modules-out/* magic-modules-comment

cd magic-modules-comment
git config pullrequest.id $ID

cd ../terraform-prs-out
TF_PR=$(git config --get pullrequest.id)

cd ../magic-modules-comment
cat << EOF > ./pr_comment 
I am a robot that works on MagicModules PRs!

I built this PR into one or more PRs on other repositories, and when those are closed, this PR will also be merged and closed.
depends: https://github.com/$GH_USERNAME/terraform-provider-google/pull/$TF_PR
EOF
