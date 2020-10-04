#!/bin/bash

NOT_EXIST=128
NOT_EMPTY=0
EMPTY=2

git ls-remote --exit-code $1 &> /dev/null
remote_code=$?
if [ $remote_code -eq $EMPTY ]; then
    # git init
    if [ ! `git rev-parse --is-inside-work-tree` ]; then
        git init
    fi
    git remote add origin $1
    git switch master
    # gitignore の追加
    if [ ! -e .gitignore ]; then
        touch .gitignore
        git add .gitignore
        git commit --message "add gitignore"
    fi
    git push --set-upstream origin master
    # gitlab flow production の作成
    git show-ref --verify --quiet refs/heads/production
    exists_production=$?
    if [ ! exists_production == 0 ]; then
        git branch production
    fi
    git push --set-upstream origin production

    exit 0
else
    if [ $remote_code -eq $NOT_EMPTY ]; then
        echo "Remote repository is not empty."
    else 
        if [ $remote_code -eq $NOT_EXIST ]; then
            echo "Remote repository not exists."
        else
            echo "Unexpected error has occurred."
        fi
    fi

    exit 1
fi