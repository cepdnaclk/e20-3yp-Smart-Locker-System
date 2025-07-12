package com.group17.SmartLocker.service.image;

import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.model.Image;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.repository.ImageRepository;
import com.group17.SmartLocker.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.sql.rowset.serial.SerialBlob;
import java.io.IOException;
import java.sql.Blob;
import java.sql.SQLException;

@Service
@RequiredArgsConstructor
public class ImageService implements IImageService{

    private final ImageRepository imageRepository;
    private final UserRepository userRepository;

    @Override
    public Image uploadImage(String userId, MultipartFile file) throws IOException, SQLException {

        User user = userRepository.findByUsername(userId);

        if (user == null) throw new RuntimeException("User not found");

        Blob blob = new SerialBlob(file.getBytes());

        Image image = new Image();
        image.setFileName(file.getOriginalFilename());
        image.setFileType(file.getContentType());
        image.setImage(blob);
        image.setUser(user);

        return imageRepository.save(image);
    }

    @Override
    public Image getUserImages(String username) {
        return imageRepository.findByUserUsername(username);
    }

    @Override
    @Transactional
    public void deleteUserImages(String username) {
        Image image = imageRepository.findByUserUsername(username);

        if (image != null) {
            User user = image.getUser();
            user.setImage(null); // break the association
            userRepository.save(user); // update parent side

            imageRepository.delete(image); // now delete image safely
        } else {
            throw new ResourceNotFoundException("Image not found for user: " + username);
        }
    }
}
