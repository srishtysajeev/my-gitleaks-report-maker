#!/bin/bash 

# This is the final wrapper script

# TODO: Change this so that the repos are taken from the .txt file 

REPOS=(
     "https://github.com/srishtysajeev/pato-backend.git"
     #"https://github.com/DiamondLightSource/SynchWeb.git"
     #"https://$GITHUB_PAT@github.com/srishtysajeev/test_secret_repo.git"
)

# source the functions from the other bash files: 
. /apps/run-gitleaks-and-create-report.sh
. /apps/create-dir-and-pull.sh

mkdir /data
for repo in ${REPOS[@]}; do

    echo "[INFO] Scanning repo $repo"
    REPO_NAME=$(get_repo_name "$repo")
    cd /data

    if [ -e "$REPO_NAME" ]; then 

        echo "[INFO] Remaking reports based on diff"
        pull-existing-repo "$repo" "$REPO_NAME"

        run_gitleaks $REPO_NAME

    else
        echo "[INFO] Creating reports for the first time"
        clone-new-repo "$repo" "$REPO_NAME"

        run_gitleaks $REPO_NAME
    fi
done

