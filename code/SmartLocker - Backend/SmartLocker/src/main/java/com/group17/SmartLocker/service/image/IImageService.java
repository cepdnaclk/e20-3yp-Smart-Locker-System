package com.group17.SmartLocker.service.image;

import com.group17.SmartLocker.model.Image;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.sql.SQLException;

public interface IImageService {
    Image uploadImage(String username, MultipartFile file) throws IOException, SQLException;

    Image getUserImages(String username);

    void deleteUserImages(String username);
}
