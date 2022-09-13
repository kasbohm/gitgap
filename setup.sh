#!/bin/bash
set -e

# Test that we are in a git repository
if ! [ $(git rev-parse --is-inside-work-tree) ]; then
    echo "Not in a git repository, please initialize your repository first"
    exit 1
fi

# Add gitgap/gitconfig to the gitconfig inlude.path
if [ $(echo $(git config --get include.path) | grep "gitgap/gitconfig") ]; then
  echo "gitgap/gitconfig is already in the local repo gitconfig include.path. Please remove it and try again."
  else
  git config --add include.path ../gitgap/gitconfig
fi


# Make sure gitgap folder does not exist
if [ -d "gitgap" ]; then
  echo "gitgap folder already exists. Please remove it and try again."
  exit 1
  else
  git clone --depth=1 --branch=main https://github.com/kasbohm/gitgap.git && rm -rf gitgap/.git
fi

