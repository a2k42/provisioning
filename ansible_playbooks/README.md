# Ansible Playbooks

## Getting Started

To run playbooks against any (non-local) machine you will need to authenticate via ssh.

For virtual machines, by default, the user name and password will have been set in the `<type>-preseed.cfg` file and mDNS should be `debian-<type>.local`.

```bash
ssh-copy-id test@debian-kde.local
```

In addition to authenticating to the remote machine, you will also need the `sudo` password for the user.

## Ansible Vault

First, create a password file outside of this repository

```bash
touch $HOME/ansible_vault_pass.txt

export ANSIBLE_VAULT_PASSWORD_FILE=$HOME/ansible_vault_pass.txt
```

Then use the following ansible command to manage secret files.

```bash
ansible-vault encrypt secrets.yaml
```

```bash
ansible-vault edit secrets.yaml
```

Prefer using `edit` so that secrets are not accidently left decrypted.

```bash
ansible-vault decrypt secrets.yaml
```
