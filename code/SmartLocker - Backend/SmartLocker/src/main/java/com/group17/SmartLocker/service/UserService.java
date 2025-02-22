package com.group17.SmartLocker.service;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.WriteResult;
import com.google.firebase.cloud.FirestoreClient;
import com.group17.SmartLocker.entity.User;
import org.springframework.stereotype.Service;

import java.util.concurrent.ExecutionException;

@Service
public class UserService {

    private static final String COLLECTION_NAME = "User";

    public String saveUser(User user) throws ExecutionException, InterruptedException {

        Firestore dbFirestore = FirestoreClient.getFirestore();

        ApiFuture<WriteResult> collectionApiFuture = dbFirestore.collection(COLLECTION_NAME).document(user.getId()).set(user);

        return collectionApiFuture.get().getUpdateTime().toString();
    }
}
