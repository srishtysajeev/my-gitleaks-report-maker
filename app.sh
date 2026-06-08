#!/bin/bash 

# This is the final wrapper script

# source the functions from the other bash files: 
. /apps/extract-dls-repos.sh
. /apps/run-gitleaks-and-create-report.sh
. /apps/create-dir-and-pull.sh

# Have this for local testing when I don't want to clone all of the repos
#REPOS=("https://github.com/DiamondLightSource/SynchWeb.git" "https://github.com/DiamondLightSource/ADCore.git" https://github.com/DiamondLightSource/python-zocalo.git)

DATE_DIR=$(date +%b-%Y)

#mkdir /data

mkdir -p "/reports/$DATE_DIR"

for repo in ${REPOS[@]}; do

    echo "[INFO] Scanning repo $repo"
    REPO_NAME=$(get_repo_name "$repo")
    cd /data

    if [ -e "$REPO_NAME" ]; then 

        echo "[INFO] Remaking reports based on diff"
        pull-existing-repo "$repo" "$REPO_NAME"

        run_gitleaks $REPO_NAME $DATE_DIR

    else
        echo "[INFO] Creating reports for the first time"
        clone-new-repo "$repo" "$REPO_NAME"

        run_gitleaks $REPO_NAME $DATE_DIR
    fi
done

