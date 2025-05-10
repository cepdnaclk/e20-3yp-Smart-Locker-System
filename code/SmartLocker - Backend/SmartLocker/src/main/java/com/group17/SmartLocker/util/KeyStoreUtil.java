package com.group17.SmartLocker.util;

import java.io.FileInputStream;
import java.security.KeyStore;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.security.PrivateKey;
import java.security.KeyFactory;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.Base64;

public class KeyStoreUtil {

    public static KeyStorePasswordPair getKeyStorePasswordPair(String certificateFile, String privateKeyFile) throws Exception {
        String cert = new String(java.nio.file.Files.readAllBytes(java.nio.file.Paths.get(certificateFile)));
        String key = new String(java.nio.file.Files.readAllBytes(java.nio.file.Paths.get(privateKeyFile)));

        // Decode cert
        CertificateFactory certFactory = CertificateFactory.getInstance("X.509");
        FileInputStream fis = new FileInputStream(certificateFile);
        X509Certificate certificate = (X509Certificate) certFactory.generateCertificate(fis);

        // Decode private key
        String privateKeyPEM = key
                .replaceAll("-----BEGIN (.*)-----", "")
                .replaceAll("-----END (.*)-----", "")
                .replaceAll("\\s", "");  // remove any remaining whitespace
        byte[] encoded = Base64.getDecoder().decode(privateKeyPEM);
        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(encoded);
        PrivateKey privateKey = KeyFactory.getInstance("RSA").generatePrivate(keySpec);

        // Create KeyStore
        KeyStore ks = KeyStore.getInstance(KeyStore.getDefaultType());
        ks.load(null, null);
        ks.setKeyEntry("alias", privateKey, "".toCharArray(), new java.security.cert.Certificate[]{certificate});

        return new KeyStorePasswordPair(ks, "".toCharArray());
    }
}
