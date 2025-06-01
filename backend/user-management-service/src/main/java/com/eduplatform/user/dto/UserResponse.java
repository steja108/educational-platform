package com.eduplatform.user.dto;

import com.eduplatform.user.entity.User;
import lombok.Data;

import java.util.Set;

@Data
public class UserResponse {
    private Long id;
    private String username;
    private String email;
    private String firstName;
    private String lastName;
    private String profilePicture;
    private String phoneNumber;
    private Set<User.Role> roles;
    private Boolean isActive;
    private Boolean isEmailVerified;
}