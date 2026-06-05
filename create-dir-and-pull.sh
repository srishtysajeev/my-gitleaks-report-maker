#!/bin/bash 

# These functions creates the directories using the repo name
# And then they clone / pull from github 
# TODO: There might be an extra step to do this from gitlab !

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

pull-existing-repo(){

    cd $2
    cd $2
    echo "Currently at location $PWD"

    git pull origin
}


# REDO THE ABOVE - you don't need the two options even because - actually keep the $2 it will be good to have the data separated by repo name so that your jsons can go in them

# make dir from the date and echo the date

# clone repos (this is currently done in the other script) and put in a tmp folder

# run gitleaks on all of the repos (probably one by one deleting the new ones as you go)
