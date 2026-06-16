#!/bin/bash

set -e  # stop script if any command fails

# $1 = app name (vote/result/worker)
# $2 = image repo (votingapp/vote)
# $3 = tag (build id)

git clone https://$pat_token@$azure_devops_org_url/_git/$azure_repo_name repo

cd repo

git config user.email "$git_email"
git config user.name "$git_name"

# Update image in deployment YAML

sed -i "s|image:.*|image: $acr_login_server/$2:$3|" k8s-specifications/$1-deployment.yaml

git add k8s-specifications/$1-deployment.yaml

git commit -m "update $1 image to $3" || echo "No changes to commit"

git push
