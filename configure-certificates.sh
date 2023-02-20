#!/bin/bash
set -eux

PKI_CONFIG_DIR="./out"
PKI_TRUSTPASS='whatever'
PKI_PASS='whatever'
PKI_STOREPASS=${PKI_PASS} #left for backwards compat
PKI_KEYPASS=${PKI_PASS} #left for backwards compat
PKI_TRUSTSTORE=./truststore.jks
PKI_KEYSTORE=./keystore.jks

echo "Use $PKI_PASS for all passwords...?"

# Make sure jks does not yet exists
rm -f ${PKI_KEYSTORE} ${PKI_TRUSTSTORE}

# In the trust store we import the ca certificate
keytool -importcert -noprompt -trustcacerts -alias ca -file ${PKI_CONFIG_DIR}/ca.crt -storepass ${PKI_TRUSTPASS} -keystore ${PKI_TRUSTSTORE}

# In the keystore we will do the same
keytool -importcert -noprompt -trustcacerts -alias ca -file ${PKI_CONFIG_DIR}/ca.crt -storepass ${PKI_PASS} -keypass ${PKI_PASS} -keystore ${PKI_KEYSTORE}

rm -f ${PKI_CONFIG_DIR}/client-keystore.p12
# Convert certificate/key pair into a JKS keystore
openssl pkcs12 -export -name client -in ${PKI_CONFIG_DIR}/client.crt -inkey ${PKI_CONFIG_DIR}/client.key -out ${PKI_CONFIG_DIR}/client-keystore.p12

# Import keystore
keytool -importkeystore -destkeystore ${PKI_KEYSTORE} -srckeystore ${PKI_CONFIG_DIR}/client-keystore.p12 -srcstoretype pkcs12 -alias client
