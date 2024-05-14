# GnuPG on Debian Experimental

## TLDR

Get the keygrip of your authentication key (or subkey) and tell the gpg-agent to use if for ssh.

```bash
gpg -k --with-keygrip
gpg-connect-agent 'keyattr <auth keygrip> Use-for-ssh: true' /bye
```

Everything else is setup.

## Setup Debian Experimental

At time of writing you either need to build GnuPG 2.4 from source or use an experimental branch of debian. I used the later approach in a Virtual Machine to try this out.

[Debian Experimental](https://wiki.debian.org/DebianExperimental)

[Docs for gpg](https://manpages.debian.org/experimental/gpg/gpg.1.en.html)

As per the docs, adjust your `sources.list`, update and upgrade before installing `gpg`.

`/etc/apt/source.list`

```sourceslist
deb http://mirror.ox.ac.uk/debian unstable main non-free-firmware
deb-src http://mirror.ox.ac.uk/debian unstable main non-free-firmware

deb https://deb.debian.org/debian experimental main

deb http://security.debian.org/debian-security bookworm-security main non-free-firmware
deb-src http://security.debian.org/debian-security bookworm-security main non-free-firmware
```

```bash
sudo apt update
sudo apt upgrade
sudo apt -t experimental install gpg

gpg --version
gpg (GnuPG) 2.4.5
libgcrypt 1.10.3
Copyright (C) 2024 g10 Code GmbH
License GNU GPL-3.0-or-later <https://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Home: /home/test/.gnupg
Supported algorithms:
Pubkey: RSA, ELG, DSA, ECDH, ECDSA, EDDSA
Cipher: IDEA, 3DES, CAST5, BLOWFISH, AES, AES192, AES256, TWOFISH,
        CAMELLIA128, CAMELLIA192, CAMELLIA256
Hash: SHA1, RIPEMD160, SHA256, SHA384, SHA512, SHA224
Compression: Uncompressed, ZIP, ZLIB, BZIP2
```

## Configure Test Host

Nothing unusual here.

Check that the ssh server is running:

```bash
systemctl status sshd.service
```

Then enable public key authentication

```bash
sudo vim /etc/ssh/sshd_config

# Add the line (or uncomment)
PubkeyAuthentication yes
```

Quick restart

```bash
sudo systemctl restart sshd.service
```

Take a note of the ip address (if avahi mDNS isn't running).

```bash
ip a s
```

That's everything that needs doing for now on the server.

## Test Connection (password)

It's useful to use the `verbose` mode and see what's happening.

```bash
ssh -v user@debian-host.local
...
SSH2_MSG_SERVICE_ACCEPT received
debug1: Authentications that can continue: publickey,password
debug1: Next authentication method: publickey
debug1: Will attempt key: /home/test/.ssh/id_rsa
debug1: Will attempt key: /home/test/.ssh/id_ecdsa
debug1: Will attempt key: /home/test/.ssh/id_ecdsa_sk
debug1: Will attempt key: /home/test/.ssh/id_ed25519
debug1: Will attempt key: /home/test/.ssh/id_ed25519_sk
debug1: Will attempt key: /home/test/.ssh/id_xmss
debug1: Will attempt key: /home/test/.ssh/id_dsa
debug1: Trying private key: /home/test/.ssh/id_rsa
debug1: Trying private key: /home/test/.ssh/id_ecdsa
debug1: Trying private key: /home/test/.ssh/id_ecdsa_sk
debug1: Trying private key: /home/test/.ssh/id_ed25519
debug1: Trying private key: /home/test/.ssh/id_ed25519_sk
debug1: Trying private key: /home/test/.ssh/id_xmss
debug1: Trying private key: /home/test/.ssh/id_dsa
debug1: Next authentication method: password
```

This shows that the host will accept *publickey*, but at the moment no agent is providing us with a key.

## Create and Configure GPG Key

Nothing particularly unusual about this.

The `gpg-agent` is launched on first use.

```bash
gpg --list-keys
gpg: /home/test/.gnupg/trustdb.gpg: trustdb created

gpg-connect-agent 'keyinfo --ssh-list' /bye
gpg-connect-agent: no running gpg-agent - starting '/usr/bin/gpg-agent'
gpg-connect-agent: waiting for the agent to come up ... (5s)
gpg-connect-agent: connection to the agent established
OK
```

Here is a quick and dirty method for making gpg keys (this key is never going to be used) .

```bash
gpg --batch --passphrase "" --quick-gen-key "Demo <demo@example.com>" ed25519 cert 1d

PRIMARY_FPR=$(gpg --list-keys --with-colons demo@example.com | grep '^fpr:' | awk -F: '{print $10}' | awk 'NR==1' )

gpg --batch --passphrase "" --quick-add-key $PRIMARY_FPR rsa auth 1d
```

We'll need the keygrip later.

```bash
gpg -k --with-keygrip
[keyboxd]
---------
pub   ed25519 2024-05-01 [C] [expires: 2024-05-02]
      14BBE1B53A197D04F52CE0CB3D85F09D565F45F5
      Keygrip = 195FB01E170EF65F5A2F5A802064CA676ED82FBA
uid           [ultimate] Demo <demo@example.com>
sub   rsa3072 2024-05-01 [A] [expires: 2024-05-02]
      Keygrip = BB1B656805B57AB9CDCEAECA307FC3C5AE27F651
```

Before doing anything more, we can inspect the key attributes. Either specify a keygrip or use `--list`, `--ssh-list`.

```bash
gpg-connect-agent 'keyinfo BB1B656805B57AB9CDCEAECA307FC3C5AE27F651' /bye
S KEYINFO BB1B656805B57AB9CDCEAECA307FC3C5AE27F651 D - - - C - - -
OK
```

What these attributes all mean I don't know, but it's worth noting that there isn't an `S` here.

### Configuration

```bash
# Assuming you don't have GNUPGHOME set to some other location
cd ~/.gnupg

echo "enable-ssh-support" >> gpg-agent.conf

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
```

If we try and connect again we should see that the agent is running, but it doesn't know about our key yet.

```bash
ssh -v user@debian-host.local
...
debug1: Authentications that can continue: publickey,password
debug1: Next authentication method: publickey
debug1: get_agent_identities: ssh_fetch_identitylist: agent contains no identities
debug1: Will attempt key: /home/test/.ssh/id_rsa
...
debug1: Next authentication method: password
```

No change here:

```bash
gpg-connect-agent 'keyinfo --list' /bye
S KEYINFO BB1B656805B57AB9CDCEAECA307FC3C5AE27F651 D - - - C - - -
S KEYINFO 195FB01E170EF65F5A2F5A802064CA676ED82FBA D - - - C - - -
OK

gpg-connect-agent 'keyinfo --ssh-list' /bye
OK
```

:bulb:

```bash
gpg-connect-agent 'keyattr BB1B656805B57AB9CDCEAECA307FC3C5AE27F651 Use-for-ssh: true' /bye

ssh -v user@debian-host.local
debug1: Authentications that can continue: publickey,password
debug1: Next authentication method: publickey
debug1: get_agent_identities: agent returned 1 keys
debug1: Will attempt key: (none) RSA SHA256:NHK5Lj/IEQCAi4L8+AiCPYygWLTnMOrMTH8RqbowGvw agent
```

Now we're making progress.

Let's not forget to add our public key to the host.

```bash
ssh-copy-id test@192.168.122.232

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'test@192.168.122.232'"
and check to make sure that only the key(s) you wanted were added.
```

```bash
ssh -v user@debian-host.local
...
debug1: Authentications that can continue: publickey,password
debug1: Next authentication method: publickey
debug1: get_agent_identities: agent returned 1 keys
debug1: Will attempt key: (none) RSA SHA256:NHK5Lj/IEQCAi4L8+AiCPYygWLTnMOrMTH8RqbowGvw agent
...
debug1: Offering public key: (none) RSA SHA256:NHK5Lj/IEQCAi4L8+AiCPYygWLTnMOrMTH8RqbowGvw agent
debug1: Server accepts key: (none) RSA SHA256:NHK5Lj/IEQCAi4L8+AiCPYygWLTnMOrMTH8RqbowGvw agent
Authenticated to 192.168.122.232 ([192.168.122.232]:22) using "publickey".
...
test@host:~$ echo "And we're in!!!"
```

### Alternate way of adding GPG key to host

Using `ssh-copy-id` is usually easier but...

```bash
gpg --export-ssh-key --output gpg-ssh.key demo
scp gpg-ssh.key test@host.local:/home/test/.ssh
```

Note: I'm being lazy and just putting `demo` for the key identifier. If you have lots of keys you might need to be more specific.

Then on the host

```bash
cd ~/.ssh
cat gpg-ssh.key >> authorized_keys
```

## Confusion

Neither of these commands has change their output.

```bash
gpg-connect-agent 'keyinfo --list' /bye
S KEYINFO BB1B656805B57AB9CDCEAECA307FC3C5AE27F651 D - - - C - - -
S KEYINFO 195FB01E170EF65F5A2F5A802064CA676ED82FBA D - - - C - - -
OK

gpg-connect-agent 'keyinfo --ssh-list' /bye
OK
```

On my old system where I was using `sshcontrol` the last KEYATTR would be `S` and the keygrip would appear in the ssh list.

```bash
# My current system
gpg-connect-agent 'keyinfo --ssh-list' /bye
S KEYINFO <SOMEKEYGRIP> D - - - P - - S
OK
```

What you can see is:

```bash
gpg-connect-agent 'keyattr BB1B656805B57AB9CDCEAECA307FC3C5AE27F651 Use-for-ssh:' /bye
D true
OK
```

### Useful Commands

These are sometimes necessary.

```bash
gpg-connect-agent reloadagent /bye
OK

gpg-connect-agent updatestartuptty /bye
OK
```

You can also remove the key from ssh

```bash
gpg-connect-agent 'keyattr BB1B656805B57AB9CDCEAECA307FC3C5AE27F651 Use-for-ssh: false' /bye

# or delete it entirely
gpg-connect-agent 'keyattr --delete BB1B656805B57AB9CDCEAECA307FC3C5AE27F651 Use-for-ssh:' /bye
```

For more information search for `Use-for-ssh` in `man gpg-agent`.
