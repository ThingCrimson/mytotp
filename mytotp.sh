#!/bin/bash
#
# Put TOTP key for service SERVID to GPG file crypted for 'My TOTP'
#  gpg -e -r 'My TOTP' > ~/.config/mytotp/SERVID.gpg

KEYDIR=~/.config/mytotp
KEYEXT=.gpg
SERVID=$1

if [ -z "${SERVID}" ] ; then
  echo -e "Usage: $0 SERVID\n\tSERVID is a service ID, abbreviated, w/o ext:"
  find ${KEYDIR}/*${KEYEXT} | sed -e 's/\/home.*\//  /; s/\.gpg//'
  exit 2
fi

if [ ! -f "${KEYDIR}/${SERVID}${KEYEXT}" ] ; then
  echo "No key for ${KEYDIR}/${SERVID}${KEYEXT}"
  exit 1
fi

SKEY=$(gpg -d --quiet "${KEYDIR}/${SERVID}${KEYEXT}")

NOWS=$(date +'%S')
WAIT=$((60 - NOWS))
if [ ${WAIT} -gt 30 ]; then
  WAIT=$((WAIT - 30))
fi
echo -n "Seconds :${NOWS} (wait ${WAIT}) ... "
sleep ${WAIT}

TOTP=$(echo "${SKEY}" | oathtool -b --totp - )

echo "${TOTP}"
SKEY="none"

exit 0
