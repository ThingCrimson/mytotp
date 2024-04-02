# this code is a fork of https://github.com/ThingCrimson/mytotp
# put this file in path and source it in .bashrc or .zshrc
# add next line to .bashrc or .zshrc
# source mytotp.sh
# create a directory for the keys ~/.config/mytotp
# usage, mannually creating SERVID.gpg file:
# Put TOTP key for service SERVID to GPG file crypted for '\''My TOTP'\''
# gpg -e -r '\''My TOTP'\'' > ~/.config/mytotp/SERVID.gpg
# usage, getting TOTP for service SERVID:
# mytotp SERVID
# usage, adding new SERVID:
# mytotpadd SERVID
# usage, listing all SERVIDs:
# mytotplist
function mytotp() {  
    if ! command -v oathtool &> /dev/null
  then
    echo "oathtool could not be found"
    echo "Please install it with: brew install oath-toolkit"
    return 1
  fi

  KEYDIR=~/.config/mytotp
  KEYEXT=.gpg
  SERVID=$1

  if [ -z "${SERVID}" ] ; then
    echo -e "Usage: $0 SERVID\n\tSERVID is a service ID, abbreviated, w/o ext:"
    find ${KEYDIR}/*${KEYEXT} | sed -e 's/\/home.*\//  /; s/\.gpg//'
    return 2
  fi

  if [ ! -f "${KEYDIR}/${SERVID}${KEYEXT}" ] ; then
    echo "No key for ${KEYDIR}/${SERVID}${KEYEXT}"
    return 1
  fi



  SKEY=$(gpg -d --quiet "${KEYDIR}/${SERVID}${KEYEXT}")

  NOWS=$(date +'%S')
  WAIT=$((60 - NOWS))
  if [ ${WAIT} -gt 30 ]; then
    WAIT=$((WAIT - 30))
  fi
  echo -n "Seconds :${NOWS} (we need to wait ${WAIT}) ... "
  sleep ${WAIT}

  TOTP=$(echo "${SKEY}" | oathtool -b --totp - )

  echo "${TOTP}"
  SKEY="none"
  return 0
}

# add new SERVID to GPG file in ~/.config/mytotp/SERVID.gpg
# paste the key in the prompt and press enter, then $SERVID.gpg will be created
function mytotpadd() {
  # if no $1 supplied, exit
  if [ -z "$1" ] ; then
    echo -e "Usage: $0 SERVID\n\tSERVID is a service ID, abbreviated, w/o ext:"
    return 1
  fi
  KEYDIR=~/.config/mytotp
  KEYEXT=.gpg
  SERVID=$1
  # print user instruction about press control-D to stop gpg"
  echo "Paste the key in the prompt, press enter, and then press control-D to stop gpg"
  gpg -e -r "My TOTP" >~/.config/mytotp/$SERVID.gpg
}

# function to list all SERVIDs in ~/.config/mytotp
function mytotplist() {
  KEYDIR=~/.config/mytotp
  KEYEXT=.gpg
  find ${KEYDIR}/*${KEYEXT} | sed -e 's/\/home.*\//  /; s/\.gpg//'
}
