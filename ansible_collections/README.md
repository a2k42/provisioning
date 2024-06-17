# Ansible Collections

The root directory must be named `ansible_collections`.

Do ***NOT*** `become: true` at the playbook level unless you really do want the `ansible_user` to be `root` (rarely what you want). Once the ansible "magic" variables are set, they don't change, even if a task sets `become: false` later on.

## TODO

### Security

- [ ] Change default ssh port
