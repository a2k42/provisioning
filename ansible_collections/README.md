# Ansible Collections

The root directory must be named `ansible_collections`.

Do ***NOT*** `become: true` at the playbook level unless you really do want the `ansible_user` to be `root` (rarely what you want). Once the ansible "magic" variables are set, they don't change, even if a task sets `become: false` later on.

## TODO

- [X] Use `loop` ~~or `with_items`~~ as per [docs](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html#comparing-loop-and-with)
- [ ] Checkout .dotfiles repo, permissions required

### Desktop

- [ ] Add console
- [ ] User creation makes 2 new users improperly - fix

### Developer

- [ ] Check for improvements to running Rootless Docker
- [ ] Clean up new user creation, with / without desktop flatpak settings
- [ ] Add `screenkey`
- [ ] Check if docker service running before attempting to stop

### Security

- [ ] Add role for `apparmor`
- [x] Backport kernel > v6.5
- [ ] Add checksums for texlive
- [ ] Better way of updating `rustup` and `juliaup` sha512 checksums
- [ ] Change default ssh port
- [ ] Clamavonacc fills up `/var/logs`

### System

- [ ] Option to install latest kernel or specific version
- [ ] Add `firmware-misc-nonfree` to get bluetooth working (desktop)
- [ ] Add `whois` package which contains `mkpasswd`

## Notes

- Firefox has a tendency to lie about its profile locations when installed as a flatpak. It also won't load profiles from simlinks making `stow` redundant here.

### Dotfiles

Using `stow` is useful for standalone dotfiles which are not installed by applications but can be used to control configuration

It's more problematic when installing a program creates default configuration files which you then want to overwrite.

- `stow` will not create a symlink if the file already exists (unless there is a setting for this)
    - If there is an option to overwrite, there is a danger of overwriting folders when only a file was meant to be overwritten (turn off folding?)
- Installing a program after symlinking will overwrite the symlink
