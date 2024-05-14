# Using GPG Keys with GitHub and SSH

## Recognising GitHub's Signing Key

When you initialise a new repository on github it is automatically signed by the [web-flow](https://github.com/web-flow) user.

Its public key can be found at https://github.com/web-flow.gpg

Copy the contents of this key and then import it into your keyring.

```bash
gpg --import web-flow.gpg

gpg --check-trustdb
```


## Exporting *Just* the Subkey

```bash
gpg -K --with-subkey-fingerprint
# look for the authentication [A] subkey id

gpg --armor --export abcded! > jm.auth.asc
# or
gpg --armor --export --output jm.auth.asc abcded!
```

> :bulb: Note the `!` at the end of the fingerprint
