# Security

:construction:

Security is difficult for two main reasons:

1. Lack of understanding of the
    1. core concepts, and
    1. implications of the concepts
1. Lack of organisation

Furthermore, you must balance security with usability.

::: info
A professional with access to a bank vault will have different needs to a nomadic user who lives in a camper van or shared accomodation.
:::


Keep your data safe from:

1. Theft (someone else gets your data)
    - Physical access to devices
    - Access to online systems (always physically accessible to an attacker)
    - Interception in-flight
1. Loss (you can't get to your own data)
    - Forgotten or misplaced passwords, passphrases, and keys
    - Data corruption (can't open encrypted device, files accidently or maliciously deleted)
    - Device physically destroyed (house burns down, drive stops working)

::: warning
The more copies of your data you have the safer it is from loss, but the more vulnerable it is to theft.
:::

## Checklist

::: danger
It can take a while to get familiar with all the tools and practices for security. Don't try and do it all in one go and then realise you've done something wrong, forgotten a password, lost a key, and now all your data is unrecoverable.
:::

- [ ] All devices with at-rest encryption (except for bootable recovery and installation media) e.g. LUKS
- [ ] Header files backed up for all encrypted devices (on different devices)
- [ ] Primary GPG key stored on 2/3 offline devices in secure locations
- [ ] Online devices have GPG subkeys and no primary key
- [ ] Primary key passphrase memorised or written down (non-digital) separately to locations of keys

## Devices

A suggested plan for how to manage external devices

1. Offline GPG Primary Key
1. Offline GPG Primary Key (backup)
1. Recovery Drive (Ventoy)
1. Data Sync - Green
1. Data Sync - Blue
1. Data Snapshots

::: info
Online (cloud) backups protect your data from loss of devices at one location (e.g. fire, burglary). However, as it is not your device, any important data should be encrypted *prior* to uploading.

If you use your GPG public key for this, then you need to make sure that you also have an off-site backup of your GPG keys (which should ***never*** be on a device you don't own and control), otherwise you'll never be able to decrypt your data and the backup is pointless.
:::

::: tip
One alternative is to use symettric encryption for cloud backups, then you don't have to worry about your GPG keys also been lost in a catastrophic event, and your data will be accesible from other devices. You do need to remember another passphrase though - it should definitely not be the same one you use for your keys.
:::

## Passphrase Strength

Let's compare dictionary sizes

- 72 = alpha-numeric + 10 special characters
- 7776 words in a word list

```julia
base = BigInt(72)
words = BigInt(7776)

base^17
words^7
```

A 17 digit password is roughly equivalent to a 7 word passphrase (if the adversary knows to do a dictionary attack)

10 digits ~ 5 words (I wouldn't use anything weaker than this)

> A passphrase is a backup to the physical key, the combination of key + passphrase significantly increases the security over just a password.
