package com.group17.SmartLocker.util;

import java.security.KeyStore;

public class KeyStorePasswordPair {
    public final KeyStore keyStore;
    public final char[] keyPassword;

    public KeyStorePasswordPair(KeyStore ks, char[] pwd) {
        this.keyStore = ks;
        this.keyPassword = pwd;
    }
}
