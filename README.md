# mytotp

TOTP 2FA without smartphone

Simple replacement of TOTP Authenticator mobile app for POSIX console (using `oathtool`).

## Prerequisits

POSIX-compliant console, with BASH, GNU utils, GNU Privacy Guard and oathtool available.

## Installation

Just place mytotp.sh somewhere within your $PATH, check is +x attribute present.

Create a direcrory for TOTP keys `mkdir -p ~/.config/mytotp`

If you have no suitable GPG key for encrypting of TOTP keys, create it
`gpg --yes --batch --passphrase 'Some-words' --quick-generate-key "My TOTP"`

## Usage

When you activate 2FA on some service, get TOTP key string, copy it into buffer, then `gpg -e -r "My TOTP" >~/.config/mytotp/SERVID.gpg`, paste string, press Enter and Crtl+D.

For getting TOTP code for this service do `mytotp.sh SERVID`, unlock your GPG key with above passphrase, then wait for 6-digit code (for your convenience script will wait for next 30 second interval before generating, so you will have a maximum of 30 seconds time for use it).

## Afterword

I wrote this script for my own usage, trying to keep a balance between simplicity and usability. So anyone can try to use it, or modify for it's own needs.

