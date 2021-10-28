#!/bin/bash

# Explicitly remove the old expired X3 certificate from the trust store
# Download two new LetsEncrypt certificates
# Update the start-devmode.sh script to overlay this data over the readonly filesystem and reload CA cert config on boot
# Tam Oct 2021

export PURPOSE="Overlay our custom CA certificate configuration (to replace outdated CA certs) and update trust store"

export DEV_MODE_SCRIPT=/media/cryptofs/apps/usr/palm/services/com.palmdts.devmode.service/start-devmode.sh
export CERT_FIX_DIR=/home/certfix-overlay

if ! grep -q "${PURPOSE}" ${DEV_MODE_SCRIPT}; then

	mkdir -p ${CERT_FIX_DIR}/etc/
	mkdir -p ${CERT_FIX_DIR}/usr_share_ca-certificates/
	mkdir -p ${CERT_FIX_DIR}/work-etc/
	mkdir -p ${CERT_FIX_DIR}/work-usr_share_ca-certificates/

	cat /etc/ca-certificates.conf | sed '/^mozilla\/DST_Root_CA_X3.crt$/ s/./!&/' > ${CERT_FIX_DIR}/etc/ca-certificates.conf
	curl -k https://letsencrypt.org/certs/lets-encrypt-r3.pem --output ${CERT_FIX_DIR}/usr_share_ca-certificates/lets-encrypt-r3.crt
	curl -k https://letsencrypt.org/certs/isrgrootx1.pem --output ${CERT_FIX_DIR}/usr_share_ca-certificates/isrgrootx1.crt
	echo "lets-encrypt-r3.crt" >> ${CERT_FIX_DIR}/etc/ca-certificates.conf
	echo "isrgrootx1.crt" >> ${CERT_FIX_DIR}/etc/ca-certificates.conf

	echo "" >> ${DEV_MODE_SCRIPT}
	echo "# ${PURPOSE}" >> ${DEV_MODE_SCRIPT}
	echo "mount -t overlay overlay -o lowerdir=/etc,upperdir=${CERT_FIX_DIR}/etc,workdir=${CERT_FIX_DIR}/work-etc /etc" >> ${DEV_MODE_SCRIPT}
	echo "mount -t overlay overlay -o lowerdir=/usr/share/ca-certificates,upperdir=${CERT_FIX_DIR}/usr_share_ca-certificates,workdir=${CERT_FIX_DIR}/work-usr_share_ca-certificates /usr/share/ca-certificates" >> ${DEV_MODE_SCRIPT}
	echo "update-ca-certificates" >> ${DEV_MODE_SCRIPT}
	echo "" >> ${DEV_MODE_SCRIPT}
	reboot
fi
