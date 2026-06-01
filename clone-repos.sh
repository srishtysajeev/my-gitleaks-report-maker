#!/bin/bash 

# TODO: Change this so that the repos are taken from the .txt file 
REPOS=(
     "https://github.com/srishtysajeev/pato-backend.git"
     #"https://github.com/DiamondLightSource/SynchWeb.git"
     #"https://$GITHUB_PAT@github.com/srishtysajeev/test_secret_repo.git"

)


get_repo_name() {
    local url="$1"
    echo "${url##*/}" | sed 's/\.git$//'
}


clone-new-repo(){
    
    #$1 is the full github url
    #$2 is the repo name extracted

    echo "[INFO] This is a new repo - making directory for $2"

    mkdir $2 
    cd $2 
    echo "Currently at location $PWD"

    # clone the repo inside
    git clone $1
    cd $2
}

existing-repo(){

    cd $2
    cd $2
    echo "Currently at location $PWD"

    git pull origin

    # /apps/test-using-baseline.sh

    #cd /apps

}

run_gitleaks_script(){
    echo "Creating reports"
    /apps/test-using-baseline.sh
    cd /apps
}

# here add conditionals for whether the repo already exists or not. 
# eventually you want to make the below a cron job !

for repo in ${REPOS[@]}; do

    echo "[INFO] Scanning repo $repo"
    REPO_NAME=$(get_repo_name "$repo")
    cd /data

    if [ -e "$REPO_NAME" ]; then 

        echo "[INFO] Remaking reports based on diff"
        existing-repo "$repo" "$REPO_NAME"

        . /apps/test-using-baseline.sh
        run_gitleaks $REPO_NAME

    else
        echo "[INFO] Creating reports for the first time"
        new-repo "$repo" "$REPO_NAME"

        . /apps/test-using-baseline.sh
        run_gitleaks $REPO_NAME
    fi
done