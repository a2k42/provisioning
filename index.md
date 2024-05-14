---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: "Provisioning"
  text: Your Development Machine
  tagline: "From bare-metal to configuration-management"
  actions:
    - theme: brand
      text: Security
      link: /security/
    - theme: alt
      text: Issues and suggestions
      link: https://github.com/a2k42/provisioning/issues

features:
  - title: Virtualisation
    details: Test configurations using QEMU and Vagrant.
  - title: Bare Metal Provisioning
    details: Use Ventoy and Debian Auto-Install.
  - title: Configuration Management
    details: Manage system configuration with Ansible.
  - title: Security
    details: LUKS, GPG, OpenSSH Certificates, SSH and remote logins.
  - title: Containerisation
    details: Develop with Docker for realistic local environments.
---

