package com.group17.SmartLocker.Util;

import org.bouncycastle.asn1.pkcs.PrivateKeyInfo;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.openssl.PEMKeyPair;
import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.openssl.jcajce.JcaPEMKeyConverter;


import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.Security;
import java.security.cert.Certificate;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.UUID;

public class KeyStoreUtil {

    static {
        Security.addProvider(new BouncyCastleProvider());
    }

    public static KeyStorePasswordPair getKeyStorePasswordPair(String certFile, String keyFile) throws Exception {
        X509Certificate certificate;
        try (InputStream in = new FileInputStream(certFile)) {
            certificate = (X509Certificate) CertificateFactory.getInstance("X.509").generateCertificate(in);
        }

        PrivateKey privateKey;
        try (PEMParser pemParser = new PEMParser(new FileReader(keyFile))) {
            Object object = pemParser.readObject();
            JcaPEMKeyConverter converter = new JcaPEMKeyConverter().setProvider("BC");

            if (object instanceof PEMKeyPair) {
                privateKey = converter.getKeyPair((PEMKeyPair) object).getPrivate();
            } else if (object instanceof PrivateKeyInfo) {
                privateKey = converter.getPrivateKey((PrivateKeyInfo) object);
            } else {
                throw new IllegalArgumentException("Unsupported key format: " + object.getClass());
            }
        }

        KeyStore keyStore = KeyStore.getInstance(KeyStore.getDefaultType());
        keyStore.load(null);
        String alias = UUID.randomUUID().toString();
        char[] password = UUID.randomUUID().toString().toCharArray();
        keyStore.setKeyEntry(alias, privateKey, password, new Certificate[]{certificate});

        return new KeyStorePasswordPair(keyStore, password);
    }
}
