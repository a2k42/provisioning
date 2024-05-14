#!/bin/bash

if [ $0 = $BASH_SOURCE ]; then
    echo -e "Usage:\n\tsource quick-gpg-demo.sh"
    exit 1
fi

OFFLINE=offline-master
ONLINE=online-insecure
PRIMARY_PASS=
SUB_PASS=
ENC_PASS=
# PRIMARY_PASS=primary
# SUB_PASS=subkey

mkdir $OFFLINE
mkdir $ONLINE
chmod 0700 $OFFLINE
chmod 0700 $ONLINE
export GNUPGHOME=$OFFLINE

gpg --batch --passphrase "$PRIMARY_PASS" --quick-gen-key  "Demo (use for tutorial only) <demo@example.com>" ed25519 cert 2d

PRIMARY_FPR=$(gpg --list-keys --with-colons demo@example.com | grep '^fpr:' | awk -F: '{print $10}' | awk 'NR==1' )
echo $PRIMARY_FPR

echo -e "\v"

gpg --batch --passphrase "$SUB_PASS" --quick-add-key $PRIMARY_FPR ed25519 auth,sign 1d

SUBKEY_FPR=$(gpg --list-keys --with-colons demo@example.com | grep '^fpr:' | awk -F: '{print $10}' | awk 'NR==2' )
echo $SUBKEY_FPR

gpg --batch --passphrase "$ENC_PASS" --quick-add-key $PRIMARY_FPR rsa4096 encr 1d
ENCKEY_FPR=$(gpg --list-keys --with-colons demo@example.com | grep '^fpr:' | awk -F: '{print $10}' | awk 'NR==3' )
echo $ENCKEY_FPR

# echo "Export secret keys - All the same but with different flag at the end"
# gpg --export-secret-keys --batch --passphrase "$PRIMARY_PASS" --armor
# gpg --export-secret-keys --batch --passphrase "$PRIMARY_PASS" --armor $PRIMARY_FPR
# gpg --export-secret-keys --batch --passphrase "$PRIMARY_PASS" --armor $PRIMARY_FPR!

# echo "Export secret subkeys - Identical outputs when only primary key"
# gpg --export-secret-subkeys --batch --passphrase "$PRIMARY_PASS" --armor
# gpg --export-secret-subkeys --batch --passphrase "$PRIMARY_PASS" --armor $PRIMARY_FPR
# gpg --export-secret-subkeys --batch --passphrase "$PRIMARY_PASS" --armor $PRIMARY_FPR!
# gpg --export-secret-subkeys --batch --passphrase "$SUB_PASS" --armor $SUBKEY_FPR!
#
# gpg --export-secret-keys --armor $SUBKEY_FPR!
# gpg --export-secret-subkeys --armor $PRIMARY_FPR

# gpg --batch --passphrase "$PRIMARY_PASS" --export-secret-keys | gpg --homedir $ONLINE --import
# gpg --batch --passphrase "$PRIMARY_PASS" --export-secret-subkeys | gpg --homedir $ONLINE --import
# gpg --batch --passphrase "$SUBKEY_PASS" --export-secret-subkeys $SUBKEY_FPR! | gpg --homedir $ONLINE --import
# gpg --batch --passphrase "$SUBKEY_PASS" --armor --export-secret-keys $SUBKEY_FPR!


########################## Test Import of Keys #########################################

# Only export primary secret key
# gpg --batch --passphrase "$PRIMARY_PASS" --export-secret-keys $PRIMARY_FPR! | gpg --homedir $ONLINE --import

# Exports only primary public key
# gpg --batch --passphrase "$PRIMARY_PASS" --export-secret-subkeys $PRIMARY_FPR! | gpg --homedir $ONLINE --import

# Export primary secret and subkey
# gpg --batch --passphrase "$PRIMARY_PASS" --export-secret-keys $SUBKEY_FPR! | gpg --homedir $ONLINE --import

# Export dummy primary and subkey
# gpg --batch --passphrase "$PRIMARY_PASS" --export-secret-subkeys $SUBKEY_FPR! | gpg --homedir $ONLINE --import
gpg --batch --passphrase "$PRIMARY_PASS" --export-secret-subkeys $ENCKEY_FPR! | gpg --homedir $ONLINE --import

export GNUPGHOME=$ONLINE
gpg -k --with-subkey-fingerprint
gpg -K --with-subkey-fingerprint


########################### Compare ASCII Representations ###############################
# gpg --batch --passphrase "$PRIMARY_PASS" --armor --export-secret-subkeys $SUBKEY_FPR
# gpg --batch --passphrase "$PRIMARY_PASS" --armor --export-secret-subkeys $SUBKEY_FPR!
