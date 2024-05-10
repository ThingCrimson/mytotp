# mytotp.rc

TOTP 2FA without smartphone

Simple replacement of TOTP Authenticator mobile app for POSIX console (using `oathtool`).

Now in two versions: plain BASH script and BASH functions for sourcing.

This readme file is about `mytotp.rc` version, if you want `mytotp.sh` then skip to [main README.md](./README.md)

## Prerequisits

POSIX-compliant console, with BASH, GNU utils, GNU Privacy Guard and `oathtool` available. The latest script version require MacOS bash be upgraded to modern version. see bellow for details. If you dont want to upgrade standard MacOS bash, then use previos ugly script version from [releases here](https://github.com/uyriq/mytotp_as_bashfuncs/releases/tag/0.0.1.rc)
for latest scipt then we need xclip (optional, for Linux only) or pbpaste (it is included in MacOS by default)
Note, that installed `brew` is required for MacOS, if you want to install modern bash. after `brew install bash` make symlink `sudo ln -s /opt/homebrew/bin/bash /usr/local/bin/bash` then you do not need to `chsh` your shell from zsh to bash, it is more convinient to use subshell with call of `/usr/local/bin/bash` and keep zsh as default

## Instalation

Put this file in ~ path and source it in .bashrc or .zshrc
like this

```bash
 if [ -f $HOME/mytotp.rc ]; then
    . $HOME/mytotp.rc
 fi
```

or just add next line to .bashrc or .zshrc
`source /path/to/somewhere/isplaced/mytotp.rc`

MacOS users with default zsh should start modern bash calling `/usr/local/bin/bash` then do `source /path/to/somewhere/isplaced/mytotp.rc`

Create a direcrory for TOTP keys `mkdir -p ~/.config/mytotp` it can be done with `mytotplist` command as well

If you have no suitable GPG key for encrypting of TOTP keys, create it
`gpg --yes --batch --passphrase-fd 0 --quick-generate-key 'My TOTP'`
enter your passphrase, (rememeber it) hit Enter, check keys with
`gpg --list-secret-keys | grep "My TOTP" ` you should view `[ultimate] My TOTP`

## Usage

To use these commands, follow these steps:

1. **List Services with `mytotplist`**: This command lists all the services that have been added to the TOTP generator. It reads the GPG files in the `~/.config/mytotp/` directory and prints the service IDs. If the `~/.config/mytotp` directory does not exist, the function will prompt the user to create it.

2. **Add a Service with `mytotpadd SERVID`**: When you activate 2FA on a service (let's call it SERVID), you will receive a TOTP key string. Copy this string, then run `mytotpadd SERVID`. This command adds a new service to the TOTP generator. You will be prompted to enter the service's initial secret key. This key is usually displayed as a QR code, but we need the alphanumeric form of this initial secret code. The service and its secret key will be stored in a GPG file in the `~/.config/mytotp/` directory. Optionally, the initial secret can be stored in a plain text file in the same directory. However, this is a development option and is not recommended for daily use due to security concerns. After running `mytotpadd SERVID`, paste the initial code string, then press <kbd>Enter</kbd> and <kbd>Ctrl</kbd>+<kbd>D</kbd>.

3. **Generate a TOTP with `mytotp SERVID`**: This command generates a Time-based One-Time Password (TOTP) for the specified service ID (SERVID). The output is a standard 6-digit TOTP code, which may not be compatible with other TOTP formats (e.g., Yandex TOTP). If no service ID is provided, the command will print usage help and version information. The `mytotp` function is identical to the standalone `mytotp.sh` script. For more information, see the [main README.md](./README.md).

To get a TOTP code for a service, run `mytotp.sh SERVID`, unlock your GPG key with the passphrase, then wait for the 6-digit code. The script will wait for the next 30-second interval before generating the code, giving you a maximum of 30 seconds to use it.
