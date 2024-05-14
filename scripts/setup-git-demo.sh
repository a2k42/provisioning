#!/bin/bash

if [ $0 = $BASH_SOURCE ]; then
    echo -e "Usage:\n\tsource setup-git-demo.sh"
    exit 1
fi

# https://www.gnupg.org/documentation/manuals/gnupg/Unattended-Usage-of-GPG.html

REPO_NAME=my-git-repo
echo $REPO_NAME > .gitignore

## Generate demo gpg key
TEMP_DIR="${TMPDIR:-/tmp}"
echo mktemp will set the 0700 permission by default
export GNUPGHOME="$(mktemp -d $TEMP_DIR/.gnupg.XXX)"
echo -e "!!! Do not provide passwords or passphrases on the cli - it will end up in the bash history and is insecure\n"
set -v
gpg --quick-gen-key --batch --passphrase "primary" "Demo (use for tutorial only) <demo@example.com>" ed25519 default 2d
set +v

FINGERPRINT=$(gpg --list-keys --with-colons demo@example.com | grep '^fpr:' | awk -F: '{print $10}')

## Setup git repo
REPO_NAME=my-git-repo
echo -e "\v"

set -x
mkdir $REPO_NAME
cd $REPO_NAME

git init
git config --add user.name Demo
git config --add user.email demo@example.com
git config --add user.signingkey $FINGERPRINT

echo "# $REPO_NAME" > README.md

git add .
git commit -m "My first commit"


# git commit --all -m "Add and commit tracked files"

# git status

set +x
echo -e "\vRemember to clear GNUPGHOME=$GNUPGHOME when you are done experimenting! Enter:\n"
echo -e "\tGNUPGHOME="
