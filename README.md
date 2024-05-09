# mytotp

TOTP 2FA without smartphone

Simple replacement of TOTP Authenticator mobile app for POSIX console (using `oathtool`).

Now in two versions: plain BASH script and BASH functions for sourcing.

## Prerequisits

POSIX-compliant console, with BASH, GNU utils, GNU Privacy Guard and oathtool available.

## Installation

Just place mytotp.sh somewhere within your $PATH, check is +x attribute present.

Or add `source mytotp.rc` to your .bashrc or .zshrc to have all functions available, this way you get `mytotp` for generating, `mytotpadd` for adding and `mytotplist` for listing.

Create a direcrory for TOTP keys `mkdir -p ~/.config/mytotp`

If you have no suitable GPG key for encrypting of TOTP keys, create it
`gpg --yes --batch --passphrase-fd 0 --quick-generate-key 'My TOTP'`
enter your passphrase hit Enter, check keys with 
`gpg --list-secret-keys` 

## Usage

When you activate 2FA on some service (assuming it name is SERVID), get TOTP key string, copy it into buffer, then do
 `gpg -e -r "My TOTP" >~/.config/mytotp/SERVID.gpg` (for script version)
 OR `mytotpadd SERVID` (for functions version), paste string, press Enter and Crtl+D.

For getting TOTP code for this service do `mytotp.sh SERVID`, unlock your GPG key with above passphrase, then wait for 6-digit code (for your convenience script will wait for next 30 second interval before generating, so you will have a maximum of 30 seconds time for use it).

## Afterword

I wrote this script for my own usage, trying to keep a balance between simplicity and usability. So anyone can try to use it, or modify for it's own needs.

Thanks to [uyriq](https://github.com/uyriq) for adding BASH functions version `mytotp.rc`.
