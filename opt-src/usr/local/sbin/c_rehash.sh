#!/bin/sh
#
CERTDIR="$1"

# remove hash links
/bin/busybox find "$CERTDIR" -regex '.*/[0-9a-f]\{8\}\.[0-9]\{1,\}' -type l -exec rm {} \;

for CFILE in $(/bin/busybox find $CERTDIR -regex '.*\.\(pem\|crt\|cer\|crl\)$') ; do
	FNAME=$(echo $CFILE | sed "s/'/\\'/g")
	KEYS=""
	grep -q -E '^-----BEGIN (X509 |TRUSTED |)CERTIFICATE-----' $FNAME 2>/dev/null && \
		KEYS=$(openssl x509 -subject_hash -fingerprint -noout -in $FNAME) && \
		CRL=""
	grep -q -E '^-----BEGIN X509 CRL-----' $FNAME 2>/dev/null && \
		KEYS=$(openssl crl -hash -fingerprint -noout -in $FNAME) && \
		CRL="r"
	if [ -n "$KEYS" ] ; then
		HASH=${KEYS:0:8}
		FPRINT=${KEYS##*=} && FPRINT=${FPRINT//:/}
		SFX=0
		while [ $SFX -lt 10 ] ; do
			HASHSFX=HASH_${HASH}_${CRL}${SFX}
			eval "HASHED=\${$HASHSFX}"
			if [ -z "$HASHED" ] ; then
				eval "$HASHSFX=$FPRINT"
				ln -s $CFILE "${HASH}.${CRL}${SFX}"
				break
			elif [ "$HASHED" = "$FPRINT" ] ; then
				echo "duplicate certificate $CFILE"
				break
			else
				SFX=$(($SFX + 1))
			fi
		done
	fi
done
