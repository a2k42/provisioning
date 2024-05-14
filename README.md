[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/a2k42/provisioning/deploy.yaml)](https://github.com/a2k42/provisioning/blob/docs/.github/workflows/deploy.yaml)

[![Notes](https://img.shields.io/badge/notes-blue?style=flat&logo=markdown)](https://a2k42.github.io/provisioning/)

# Provisioning

Your Development Machine. From bare-metal to configuration-management.

This is an in-progress bringing together of my personal notes and playbooks etc. that I use to manage my own hardware. I'm learning as I go and hope that you might find something useful, or save yourself hitting as many brick-walls as I did trying to figure it all out.

## Running playbooks

```bash
cd ansible_playbooks
```

### Local

```bash
ansible-playbook --limit local --ask-become-pass playbook.yaml
```
or
```bash
ansible-playbook -l local -K playbook.yaml
```

### Virtual

To see a list of local machines

```bash
virsh list --all
```

Then to start the vm named `debian-kde`, for example

```bash
virsh start debian-kde
```

Then run the playbook

```bash
ansible-playbook --limit virtual playbook.yaml
```

See the `ansible_playbooks` [README](ansible_playbooks/README.md) for details about setting ansible vault environment variables.

## Todo

- [ ] Add `screenkey`


### Plasma Desktop

You can do a minimal debian install `< 3GB`, with the desktop `< 6GB`.

- Debian [`plasma-desktop`](https://packages.debian.org/bookworm/plasma-desktop) is the usual "minimal" install but still has quite a few unecessary apps.
- For wayland, use [`plasma-workspace-wayland`](https://packages.debian.org/bookworm/plasma-workspace-wayland) instead
- Using `--no-install-recommends` leaves the desktop broken, figuring exactly which packages to install looks to be quite a bit of work.
- There doesn't seem to be a way to turn off recommended installs on a per package basis in the auto-install.
- Debain wiki for [Wayland](https://wiki.debian.org/Wayland)
- [Wayland on NVidia](https://community.kde.org/Plasma/Wayland/Nvidia)

> Recommends: appmenu-gtk3-module, kde-cli-tools (>= 4:5.23.90~), kio-extras, libpam-kwallet5 (>= 5.14), powerdevil (>= 4:5.14)