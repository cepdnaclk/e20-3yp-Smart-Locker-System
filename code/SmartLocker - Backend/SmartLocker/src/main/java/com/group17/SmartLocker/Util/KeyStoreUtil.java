package com.group17.SmartLocker.Util;

import org.bouncycastle.openssl.PEMKeyPair;
import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.openssl.jcajce.JcaPEMKeyConverter;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.security.KeyFactory;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.Security;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.UUID;

public class KeyStoreUtil {

    public static KeyStorePasswordPair getKeyStorePasswordPair(InputStream certificateFile, InputStream privateKeyFile) throws Exception {
        Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider());

        // Load cert
        CertificateFactory certFactory = CertificateFactory.getInstance("X.509");
        X509Certificate certificate = (X509Certificate) certFactory.generateCertificate(certificateFile);

        // Load key
        PEMParser pemParser = new PEMParser(new InputStreamReader(privateKeyFile));
        Object object = pemParser.readObject();
        pemParser.close();

        JcaPEMKeyConverter converter = new JcaPEMKeyConverter().setProvider("BC");
        PrivateKey privateKey = converter.getPrivateKey(((PEMKeyPair) object).getPrivateKeyInfo());

        // Generate keystore
        KeyStore ks = KeyStore.getInstance("JKS");
        ks.load(null, null);
        String alias = UUID.randomUUID().toString();
        char[] password = UUID.randomUUID().toString().toCharArray();

        ks.setKeyEntry(alias, privateKey, password, new java.security.cert.Certificate[]{certificate});

        return new KeyStorePasswordPair(ks, password);
    }
}
