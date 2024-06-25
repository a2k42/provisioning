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

Add public keys to remote authorized_keys

```bash
ssh-copy-id test@debian-kde.local
```

Then run the playbook

```bash
ansible-playbook --limit virtual playbook.yaml
```

See the `ansible_playbooks` [README](ansible_playbooks/README.md) for details about setting ansible vault environment variables.

## Todo


- [ ] Tidy [Ansible Playbooks README](./ansible_playbooks/README.md)
- [ ] Update [Ansible Collections](./ansible_collections/README.md#TODO)
