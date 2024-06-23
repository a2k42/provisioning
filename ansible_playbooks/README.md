# Ansible Playbooks

> :construction: Todo: this file needs work

## Getting Started

> :warning: The remote machines need `python3` installed

To run playbooks against any (non-local) machine you will need to authenticate via ssh.

For virtual machines, by default, the user name and password will have been set in the `<type>-preseed.cfg` file and mDNS should be `debian-<type>.local`.

```bash
ssh-copy-id test@debian-kde.local
```

In addition to authenticating to the remote machine, you will also need the `sudo` password for the user.

Use the `hosts.ini` file to specify an `ansible_user`.

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

## Using Vagrant

The `test-playbook` comes with a vagrant configuration on which the playbook can be run for development.

```bash
vagrant up

# If already provisioned, to run again
vagrant provision
```

Additionally, the vm can be seen in Virtual Manager

```bash
virt-manager

virsh list [--all]

virsh start <vm-name>
```

If there are any network connection issues

```bash
virsh net-list [--all]

virsh net-start <default|network_name>
```

## Password-Less

1. SSH keys
1. Sudoers

```bash
ssh-keygen -t ecdsa -C "test@debian.local" -f id_ecdsa
ssh-copy-id -i id_ecdsa.pub test@192.168.122.94

ssh test@192.168.122.94
```

Use the `nopass` role, you will have to supply a password with the `-K` option the first time; otherwise use `visudo`. Only do this on virtual machines you don't care about, it's generally a good idea to have to enter a sudo password.

Once the `a2k42.system.mdns` roles has been run, the IP address can be replaced with `<hostname>.local`.

## Default Variables

For user variables, they might be different for each machine, or unknown.

In the `hosts.ini` inventory file, you can use `[all:vars]` to set a default and then override it in each group

```ini
[workers:vars]
git_user_email: worker@exmple.com

[all:vars]
git_user_email: default@exmple.com
```

## Configure Virtual Machine

### Disk Size

Neither seem to work. The first is experimental, the second doesn't resize the filesystem in the VM

```rb
config.vm.disk :disk, size: "30GB"

libvirt.machine_virtual_size = 50   # doesn't resize filesystem
```

### Apt Packages

If not using the standard metapackage there are a few packages you might want to install to start with

- `bash-completion`
- `python3`
- `openssh-server`
- `git`

## Ansible Setup

### Testing Ad-hoc Commands

With `hosts.ini`

```ini
[virtual]
192.168.122.179
```

```bash
# adds to remote authorized_keys
ssh-copy-id test@192.168.122.179
# enter gpg passphrase

ansible -i hosts.ini virtual -m ping -u test

# without ssh key
ansible -i hosts.ini virtual -m ping -u test -K
```

Now add `ansible.cfg`

```ini
[defaults]
INVENTORY = hosts.ini
```

```bash
ansible virtual -m ping -u test

# defaults to command module
ansible virtual -a "free -h" -u test
```

We can make a more complex example

```ini
[virtual]
192.168.122.179 ansible_user=test

[local]
localhost ansible_connection=local
```

then

```bash
ansible virtual -a "free -h"
```

### Variables for Group

```ini
[virtual]
192.168.122.179

[virtual:vars]
ansible_user=test

[local]
localhost

[local:vars]
ansible_connection=local
ansible_user=a2k42
```

### Getting Help

```bash
ansible-doc <module>

ansible-doc apt
```

### Run In Background

```bash
time ansible virtual -B 60 -P 5 -a "sleep 6"

# poll every 5s, timeout after 1min, run in background
ansible virtual -b -K -B 60 -P 5 -a "sleep 6"
```

### Plasma Desktop

You can do a minimal debian install `< 3GB`, with the desktop `< 6GB`.

- Debian [`plasma-desktop`](https://packages.debian.org/bookworm/plasma-desktop) is the usual "minimal" install but still has quite a few unecessary apps.
- For wayland, use [`plasma-workspace-wayland`](https://packages.debian.org/bookworm/plasma-workspace-wayland) instead
- Using `--no-install-recommends` leaves the desktop broken, figuring exactly which packages to install looks to be quite a bit of work.
- There doesn't seem to be a way to turn off recommended installs on a per package basis in the auto-install.
- Debain wiki for [Wayland](https://wiki.debian.org/Wayland)
- [Wayland on NVidia](https://community.kde.org/Plasma/Wayland/Nvidia)

> Recommends: appmenu-gtk3-module, kde-cli-tools (>= 4:5.23.90~), kio-extras, libpam-kwallet5 (>= 5.14), powerdevil (>= 4:5.14)
