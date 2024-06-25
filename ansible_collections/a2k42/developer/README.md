# Ansible Developer Collection

- [ ] `java --version`
- [ ] `javac --version`
- [ ] `julia --version`
- [ ] `cargo --version`
- [ ] `rustc --version`
- [ ] `node --version`
- [ ] `npm --version`

- [ ] `git --version`
- [ ] `virsh --version`

## Verifying Julia

```bash
curl https://julialang.org/assets/juliareleases.asc

gpg --import juliareleases.asc

curl https://julialang-s3.julialang.org/bin/linux/x64/1.10/julia-1.10.1-linux-x86_64.tar.gz

curl https://julialang-s3.julialang.org/bin/linux/x64/1.10/julia-1.10.1-linux-x86_64.tar.gz.asc

gpg --verify julia-1.10.1-linux-x86_64.tar.gz.asc julia-1.10.1-linux-x86_64.tar.gz
gpg: Signature made Wed 14 Feb 2024 18:54:40 GMT
gpg:                using RSA key 3673DF529D9049477F76B37566E3C7DC03D6E495
gpg: Good signature from "Julia (Binary signing key) <buildbot@julialang.org>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 3673 DF52 9D90 4947 7F76  B375 66E3 C7DC 03D6 E495
```