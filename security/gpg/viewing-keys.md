# Viewing Keys

[GnuPG Manual](https://www.gnupg.org/documentation/manuals/gnupg/)

## Viewing Key Status

Check local key status

```bash
# -k
gpg --list-keys [identifier]

/tmp/.gnupg.Msa/pubring.kbx
---------------------------
pub   rsa4096 2024-05-01 [SC] [expires: 2024-05-03]
      E0739E9873EDDB560909472605DA274A7349302B
uid           [ultimate] Demo (use for tutorial only) <demo@example.com>
```

Check secret keys. Will show `sec` instead of `pub`

```bash
# -K
gpg --list-secret-keys

# ...
sec   rsa4096 2024-05-01 [SC] [expires: 2024-05-03]
```

If you see a hash `#`, that means that the primary secret key is not available (offline)

```bash
sec#   rsa4096 2024-05-01 [SC] [expires: 2024-05-03]
```

### Meaning

- **sec**: private primary signing key
- **ssb**: private subordinates keys
- **pub**: public primary signing key
- **sub**: public subordinate key
- **uid**: user ids

Usage (public) | Char | Meaning
--- | --- | ---
Signing | S | sign data
Certification | C | sign a key (always on)
Encryption | E | encrypt data
Authentication | A | authenticate to a computer (login e.g., ssh)