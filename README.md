[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/a2k42/provisioning/deploy.yaml)](https://github.com/a2k42/provisioning/blob/docs/.github/workflows/deploy.yaml)

[![Notes](https://img.shields.io/badge/notes-blue?style=flat&logo=markdown)](https://a2k42.github.io/provisioning/)

# Provisioning

Your Development Machine. From bare-metal to configuration-management.

This is an in-progress bringing together of my personal notes and playbooks etc. that I use to manage my own hardware. I'm learning as I go and hope that you might find something useful, or save yourself hitting as many brick-walls as I did trying to figure it all out.

Everything is based around a [Debian](https://www.debian.org/) system. While many ansible roles and scripts might also apply to other variants, to keep things simple, only Debian is targeted. Automation can get complicated quickly and I find Debian a good base to start from when trying to keep things minimal and create a solid platform for software development.

One of my goals in developing this repository was to be able to keep *configuration-as-code* for ad-hoc machines. While working in academia and engineering research I often encountered computers tucked away in a lab somewhere that had been all but forgotten, and no one knew how they had been configured, or how they were supposed to be configured. A preseed file and playbook of ansible roles can keep an easily reproducible record of how a system has been setup, even when that system is normally kept offline and larger enterprise solutions for bare-metal provisioning would not be as applicable.

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

Add public keys to remote authorized_keys

```bash
ssh-copy-id test@debian-kde.local
```

Then run the playbook

```bash
ansible-playbook --limit virtual playbook.yaml
```

See the `ansible_playbooks` [README](ansible_playbooks/README.md) for details about setting ansible vault environment variables.

### Bare Metal

An example directory layout you may wish to use with [Ventoy](https://www.ventoy.net/en/index.html
):

```bash
/mnt/usb
├── debian
│   ├── debian-12.5.0-amd64-DVD-1.iso
│   └── debian-live-12.5.0-amd64-kde.iso
├── pop_os
│   └── pop-os_22.04_amd64_intel_20.iso
├── ventoy
│   ├── script
│   │   ├── laptop-preseed.cfg
│   │   ├── laptop-recipe.cfg
│   └── ventoy.json
└── windows
    └── Win11_22H2_EnglishInternational_x64v1.iso
```

> :warning: Ventoy doesn't seem to read external recipe files during preseeding so the partman configuration should be inlined in the preseed file.

## Todo


- [ ] Tidy [Ansible Playbooks README](./ansible_playbooks/README.md)
- [ ] Update [Ansible Collections](./ansible_collections/README.md#TODO)
