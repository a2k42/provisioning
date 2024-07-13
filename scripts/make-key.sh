#!/bin/bash

if [ "$GNUPGHOME" = "" ]; then
    echo "Please provide path for GNUPGHOME"
    exit 1
fi

echo $GNUPGHOME

NAME="Test"
COMMENT="test 2024"
EMAIL="test@example.com"

gpg --batch --quick-gen-key "$NAME ($COMMENT) <$EMAIL>" ed25519 cert 1y

PRIMARY_FPR=$(gpg --list-keys --with-colons $EMAIL | grep '^fpr:' | awk -F: '{print $10}' | awk 'NR==1' )

echo "Enter passphrase for auth,sign key"
gpg --batch --passphrase-fd STDIN --quick-add-key $PRIMARY_FPR ed25519 auth,sign

echo "Enter passphrase for ecnryption key"
gpg --batch --passphrase-fd STDIN --quick-add-key $PRIMARY_FPR cv25519 encr

