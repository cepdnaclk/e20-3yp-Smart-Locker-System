package com.group17.SmartLocker.Util;


import javax.net.ssl.SSLSocketFactory;
import java.io.FileInputStream;
import java.security.KeyStore;
import java.security.SecureRandom;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;

public class SslUtil {

    public static SSLSocketFactory getSocketFactory(final String caPath, final String certPath, final String keyPath, final String password) throws Exception {
        CertificateFactory cf = CertificateFactory.getInstance("X.509");
        FileInputStream caInput = new FileInputStream(caPath);
        X509Certificate caCert = (X509Certificate) cf.generateCertificate(caInput);
        caInput.close();

        KeyStore ks = KeyStore.getInstance(KeyStore.getDefaultType());
        ks.load(null, null);
        ks.setCertificateEntry("caCert", caCert);

        TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        tmf.init(ks);

        KeyManagerFactory kmf = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
        kmf.init(ks, password.toCharArray());

        SSLContext context = SSLContext.getInstance("TLSv1.2");
//        SSLContext context = SSLContext.getInstance("TLS");
        context.init(kmf.getKeyManagers(), tmf.getTrustManagers(), new SecureRandom());

        return context.getSocketFactory();
    }
}
