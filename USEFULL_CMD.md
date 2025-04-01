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
# Run this command to restart the gpg-agent every time you restart your computer
gpg-connect-agent /bye
```

# VSCode SSH login via Yubikey or local GPG key

```bash
ssh -v -T -D 35269 -o ConnectTimeout=15 <SSH-HOST>
```