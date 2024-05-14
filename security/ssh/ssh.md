# SSH

## Find Server Host Key Fingerprint

```bash
ssh-keygen -l -f /etc/ssh/ssh_host_ed25519_key.pub
```

When you connect this should match the key added to your client's `known_hosts` file