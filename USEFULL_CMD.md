# Yubikey and SSH on windows

```bash
# On Windows:
Follow this link https://developers.yubico.com/PGP/SSH_authentication/Windows.html to setup gpg on windows

# Export your public key to a keyserver
gpg --export <YOUR_EMAIL_ADDRESS> | curl -T - https://keys.openpgp.org

# Import a public key from a keyserver, key id is the signature key
gpg --keyserver hkps://keys.openpgp.org --recv-keys <key_id>

# Restart gpg-connect-agent
gpg-connect-agent killagent /bye
gpg-connect-agent /bye
```