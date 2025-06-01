package com.eduplatform.user.dto;

import lombok.Data;

@Data
public class JwtResponse {
    private String token;
    private String type = "Bearer";
    private String refreshToken;
    private UserResponse user;

    public JwtResponse(String accessToken, String refreshToken, UserResponse user) {
        this.token = accessToken;
        this.refreshToken = refreshToken;
        this.user = user;
    }
}
