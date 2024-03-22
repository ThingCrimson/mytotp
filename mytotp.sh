#!/bin/bash -u
#
# for put OATH key to GPG file crypted for 'My TOTP'
# gpg -e -r 'My TOTP' > KEY-ID.gpg

KEYDIR="~/.mytotp"
KEYEXT=".gpg"
KEY_ID="$1"
TOTPEX="oathtool -b --totp -"

if [ -z "${KEY_ID}" ] ; then
  echo -e "Usage: $0 KEY_ID\nKEY_ID is a service name, abbreviated, w/o ext:"
  ls -1 ${KEYDIR}/*${KEYEXT} | sed -e 's/\/home.*\//  /; s/\.gpg//'
  exit 2
fi

if [ ! -f "${KEYDIR}/${KEY_ID}${KEYEXT}" ] ; then
  echo "No key for ${KEYDIR}/${KEY_ID}${KEYEXT}"
  exit 1
fi

OKEY=$(gpg -d --quiet "${KEYDIR}/${KEY_ID}${KEYEXT}")

NOWS=$(date +'%S')
# depending on seconds: 00-10, 30-40 no wait?
WAIT=$(( 60 - $NOWS))
if [ ${WAIT} -gt 30 ]; then
  WAIT=$(( $WAIT - 30 ))
fi
echo -n "Seconds :${NOWS} (wait ${WAIT}) ... "
sleep ${WAIT}

OATH=$(echo "${OKEY}" | ${TOTPEX} )

echo ${OATH}
OKEY="none"

exit 0

