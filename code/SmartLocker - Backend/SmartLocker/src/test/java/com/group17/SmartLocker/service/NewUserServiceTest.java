//package com.group17.SmartLocker.service;
//
//import com.group17.SmartLocker.dto.NewUserDto;
//import com.group17.SmartLocker.enums.Role;
//import com.group17.SmartLocker.enums.NewUserStatus;
//import com.group17.SmartLocker.model.NewUser;
//import com.group17.SmartLocker.model.User;
//import com.group17.SmartLocker.repository.NewUserRepository;
//import com.group17.SmartLocker.repository.UserRepository;
//import com.group17.SmartLocker.service.newUser.NewUserService;
//import org.junit.jupiter.api.BeforeEach;
//import org.junit.jupiter.api.Test;
//import org.junit.jupiter.api.extension.ExtendWith;
//import org.mockito.InjectMocks;
//import org.mockito.Mock;
//import org.mockito.junit.jupiter.MockitoExtension;
//import org.springframework.security.crypto.password.PasswordEncoder;
//
//import java.util.Arrays;
//import java.util.List;
//import java.util.Optional;
//
//import static org.junit.jupiter.api.Assertions.*;
//import static org.mockito.Mockito.*;
//
//@ExtendWith(MockitoExtension.class)
//class NewUserServiceTest {
//
//    @Mock
//    private NewUserRepository newUserRepository;
//
//    @Mock
//    private UserRepository userRepository;
//
//    @Mock
//    private PasswordEncoder passwordEncoder;
//
//    @InjectMocks
//    private NewUserService newUserService;
//
//    private NewUser newUser;
//    private User user;
//    private NewUserDto newUserDto;
//
//    @BeforeEach
//    void setUp() {
//        newUserDto = new NewUserDto();
//        newUserDto.setRegNo("E20002");
//        newUserDto.setFirstName("John");
//        newUserDto.setLastName("Doe");
//        newUserDto.setContactNumber("123456789");
//        newUserDto.setEmail("john.doe@example.com");
//        newUserDto.setPassword("password");
//
//        newUser = new NewUser();
//        newUser.setId(1L);
//        newUser.setRegNo("E20002");
//        newUser.setFirstName("John");
//        newUser.setLastName("Doe");
//        newUser.setContactNumber("123456789");
//        newUser.setEmail("john.doe@example.com");
//        newUser.setPassword("encodedPassword");
//        newUser.setRole(Role.NEW_USER);
//        newUser.setStatus(NewUserStatus.PENDING);
//
//        user = new User();
//        user.setId("E20002");
//        user.setUsername("E20002");
//        user.setFirstName("John");
//        user.setLastName("Doe");
//        user.setContactNumber("123456789");
//        user.setEmail("john.doe@example.com");
//        user.setPassword("encodedPassword");
//    }
//
//    // Test User Registration
//    @Test
//    void testRegisterUser() {
//        when(passwordEncoder.encode("password")).thenReturn("encodedPassword");
//        when(newUserRepository.save(any(NewUser.class))).thenReturn(newUser);
//
//        NewUser savedUser = newUserService.registerUser(newUserDto);
//
//        assertNotNull(savedUser);
//        assertEquals("E20002", savedUser.getRegNo());
//        assertEquals("John", savedUser.getFirstName());
//        assertEquals(NewUserStatus.PENDING, savedUser.getStatus());
//
//        verify(passwordEncoder, times(1)).encode("password");
//        verify(newUserRepository, times(1)).save(any(NewUser.class));
//    }
//
//    // Test Get Pending Users
//    @Test
//    void testGetPendingUsers() {
//        when(newUserRepository.findByStatus(NewUserStatus.PENDING)).thenReturn(Arrays.asList(newUser));
//
//        List<NewUser> pendingUsers = newUserService.getPendingUsers();
//
//        assertEquals(1, pendingUsers.size());
//        assertEquals("E20002", pendingUsers.get(0).getRegNo());
//
//        verify(newUserRepository, times(1)).findByStatus(NewUserStatus.PENDING);
//    }
//
//    // Test Approve User
//    @Test
//    void testApproveUser() {
//        when(newUserRepository.findById(1L)).thenReturn(Optional.of(newUser));
//        when(userRepository.save(any(User.class))).thenReturn(user);
//
//        Optional<User> approvedUser = newUserService.approveUser(1L);
//
//        assertTrue(approvedUser.isPresent());
//        assertEquals("E20002", approvedUser.get().getId());
//
//        verify(userRepository, times(1)).save(any(User.class));
//        verify(newUserRepository, times(1)).deleteById(1L);
//    }
//
//    // Test Approve User (User Not Found)
//    @Test
//    void testApproveUser_NotFound() {
//        when(newUserRepository.findById(1L)).thenReturn(Optional.empty());
//
//        Optional<User> approvedUser = newUserService.approveUser(1L);
//
//        assertFalse(approvedUser.isPresent());
//
//        verify(userRepository, never()).save(any(User.class));
//        verify(newUserRepository, never()).deleteById(anyLong());
//    }
//
//    // Test Reject User
//    @Test
//    void testRejectUser() {
//        newUserService.rejectUser(1L);
//
//        verify(newUserRepository, times(1)).deleteById(1L);
//    }
//}
