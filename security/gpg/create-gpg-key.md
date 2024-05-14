# Creating and Managing GPG Keys

To improve security, the gpg key is created offline and then the subkeys are imported onto the devices where the keys are needed.

`man gpg`

::: details
```bash
--quick-add-key fpr [algo [usage [expire]]]
              Directly add a subkey to the key identified by the fingerprint fpr.  Without the optional arguments an encryption subkey is added.  If any of the arguments are given a more specific subkey is added.

              algo  may  be  any  of the supported algorithms or curve names given in the format as used by key listings.  To use the default algorithm the string ``default'' or ``-'' can be used.  Supported algorithms are ``rsa'', ``dsa'', ``elg'',
              ``ed25519'', ``cv25519'', and other ECC curves.  For example the string ``rsa'' adds an RSA key with the default key length; a string ``rsa4096'' requests that the key length is 4096 bits.  The string ``future-default'' is an alias for
              the algorithm which will likely be used as default algorithm in future versions of gpg.  To list the supported ECC curves the command gpg --with-colons --list-config curve can be used.

              Depending  on  the  given  algo the subkey may either be an encryption subkey or a signing subkey.  If an algorithm is capable of signing and encryption and such a subkey is desired, a usage string must be given.  This string is either
              ``default'' or ``-'' to keep the default or a comma delimited list (or space delimited list) of keywords: ``sign'' for a signing subkey, ``auth'' for an authentication subkey, and ``encr'' for an encryption subkey (``encrypt''  can  be
              used as alias for ``encr'').  The valid combinations depend on the algorithm.

              The  expire argument can be used to specify an expiration date for the key.  Several formats are supported; commonly the ISO formats ``YYYY-MM-DD'' or ``YYYYMMDDThhmmss'' are used.  To make the key expire in N seconds, N days, N weeks,
              N months, or N years use ``seconds=N'', ``Nd'', ``Nw'', ``Nm'', or ``Ny'' respectively.  Not specifying a value, or using ``-'' results in a key expiring in a reasonable default interval.  The values ``never'', ``none'' can be used for
              no expiration date.
```
:::

## Create a new key

::: info
When using GnuPG, we create a **primary key** and then an number of optional **subkeys**.

The primary key **usage** is always a certificate key (**cert**) and can also be **auth, sign, encr** (depending on the algorithm used).
:::

This assumes that the key will be stored on an external usb device which has been mounted.

If a `.gnupg` directory doesn't yet exist it will need to be created with the correct permissions.

```bash
mkdir /mnt/usb/.gnupg
chmod 0700 /mnt/usb/.gnupg
```

Now use the offline keystore and create a new key. This process can also be useful for experimenting with keys by using a temp directory e.g. `~/tmp/.gnupg`.

```bash
export GNUPGHOME=/mnt/usb/.gnupg

gpg --quick-gen-key "Jenny Mills (jm) <jenny.mills@example.com>" RSA4096 default 2d

# Create a certificate only primary key with an elliptic curve algorithm
gpg --quick-gen-key "Jenny Mills (jm) <jenny.mills@example.com>" ed25519 cert 2d
```

```bash
gpg --with-colons --list-config curve
```

### Scripted Creation

```bash
#!/bin/bash

if [ "$GNUPGHOME" = "" ]; then
    echo "Please provide path for GNUPGHOME"
    exit 1
fi

echo $GNUPGHOME

NAME="Test"
COMMENT="test key"
EMAIL="test@example.com"

gpg --batch --passphrase-fd STDIN --quick-gen-key "$NAME ($COMMENT) <$EMAIL>" ed25519 cert 1d

PRIMARY_FPR=$(gpg --list-keys --with-colons $EMAIL | grep '^fpr:' | awk -F: '{print $10}' | awk 'NR==1' )

echo "Enter passphrase for auth,sign key"
gpg --batch --passphrase-fd STDIN --quick-add-key $PRIMARY_FPR ed25519 auth,sign

echo "Enter passphrase for ecnryption key"
gpg --batch --passphrase-fd STDIN --quick-add-key $PRIMARY_FPR cv25519 encr
```

## Importing

Setting the `GNUPGHOME` environment variable to the location for the import and using `--homedir` for the export location seems to be less problematic for some reason.

```bash
export GNUPGHOME=

gpg --homedir /mnt/usb/.gnupg --export-secret-subkeys id@exmple.com | gpg --import
```

### Interactive Key Generation

Key generation can be done interactively. Use the `--expert` flag to see all the options

```bash
gpg --full-gen-key --expert
```

::: details
```bash
gpg (GnuPG) 2.2.27; Copyright (C) 2021 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
  (14) Existing key from card
Your selection? 1
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (3072) 4096
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 1
Key expires at Sun 21 Apr 2024 15:56:14 BST
Is this correct? (y/N) y

You need a user ID to identify your key; the software constructs the user ID
from the Real Name, Comment and Email Address in this form:
    "Heinrich Heine (Der Dichter) <heinrichh@duesseldorf.de>"

Real name: John Smith
E-mail address: john.smith@example.com
Comment: js-example
You selected this USER-ID:
    "John Smith (js-example) <john.smith@example.com>"

Change (N)ame, (C)omment, (E)-mail or (O)kay/(Q)uit? O
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilise the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilise the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
gpg: key 768777DEDD51B8ED marked as ultimately trusted
gpg: directory '/home/demo/tmp/offline/.gnupg/openpgp-revocs.d' created
gpg: revocation certificate stored as '/home/demo/tmp/offline/.gnupg/openpgp-revocs.d/6067BABEF1209A0A2C42F7E9768777DEDD51B8ED.rev'
public and secret key created and signed.

pub   rsa4096 2024-04-20 [SC] [expires: 2024-04-21]
      6067BABEF1209A0A2C42F7E9768777DEDD51B8ED
uid                      John Smith (js-example) <john.smith@example.com>
sub   rsa4096 2024-04-20 [E] [expires: 2024-04-21]
```
:::

### Non-Interactive Key Generation (for demos)

```bash
export GNUPGHOME="$(mktemp -d gnupg.XXX)"
# !!! Do not provide passwords or passphrases on the cli - it will end up in the bash history and is insecure
gpg --quick-gen-key --batch --passphrase "secret" "Demo (use for tutorial only) <demo@example.com>" RSA4096 default 2d

FINGERPRINT=$(gpg --list-keys --with-colons Demo | grep '^fpr:' | awk -F: '{print $10}')
```

## Edit Key (Id)

```bash
# the id only need uniquely identify the key
gpg --edit-key jenny
```

Change user id (add a new id, delete the old one)

```
adduid

uid 1

deluid
```