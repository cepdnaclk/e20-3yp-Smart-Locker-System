package com.group17.SmartLocker.Util;

import java.security.KeyStore;

public class KeyStorePasswordPair {
    public final KeyStore keyStore;
    public final char[] keyPassword;

    public KeyStorePasswordPair(KeyStore keystore, char[] keyPassword){
        this.keyStore = keystore;
        this.keyPassword = keyPassword;
    }
}
