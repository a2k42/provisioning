# Ansible Collections

The root directory must be named `ansible_collections`.

Do ***NOT*** `become: true` at the playbook level unless you really do want the `ansible_user` to be `root` (rarely what you want). Once the ansible "magic" variables are set, they don't change, even if a task sets `become: false` later on.

## TODO

### Security

- [ ] Add role for `apparmor`
- [ ] Backport kernel > v6.5
- [ ] Add checksums for texlive
- [ ] Better way of updating `rustup` and `juliaup` sha512 checksums
- [ ] Change default ssh port
- [ ] Add `screenkey`
- [ ] Checkout .dotfiles repo, permissions required
- [ ] Use `loop` or `with_items` as per [docs](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html#comparing-loop-and-with)
- [ ] Clean up new user creation, with / without desktop flatpak settings
