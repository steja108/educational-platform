package com.eduplatform.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.reactive.CorsWebFilter;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@SpringBootApplication
public class ApiGatewayApplication {

    public static void main(String[] args) {
        SpringApplication.run(ApiGatewayApplication.class, args);
    }

    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
                // User Management Service Routes
                .route("user-service", r -> r.path("/api/users/**", "/api/auth/**")
                        .filters(f -> f.stripPrefix(1))
                        .uri("http://user-management-service:8081"))

                // Course Management Service Routes
                .route("course-service", r -> r.path("/api/courses/**")
                        .filters(f -> f.stripPrefix(1))
                        .uri("http://course-management-service:8082"))

                // Content Delivery Service Routes
                .route("content-service", r -> r.path("/api/content/**", "/api/videos/**")
                        .filters(f -> f.stripPrefix(1))
                        .uri("http://localhost:8083"))

                // Assessment Service Routes
                .route("assessment-service", r -> r.path("/api/quizzes/**", "/api/assignments/**")
                        .filters(f -> f.stripPrefix(1))
                        .uri("http://localhost:8084"))

                // Progress Tracking Service Routes
                .route("progress-service", r -> r.path("/api/progress/**", "/api/analytics/**")
                        .filters(f -> f.stripPrefix(1))
                        .uri("http://localhost:8085"))

                // Payment Service Routes
                .route("payment-service", r -> r.path("/api/payments/**", "/api/subscriptions/**")
                        .filters(f -> f.stripPrefix(1))
                        .uri("http://localhost:8086"))

                // Notification Service Routes
                .route("notification-service", r -> r.path("/api/notifications/**")
                        .filters(f -> f.stripPrefix(1))
                        .uri("http://localhost:8087"))

                .build();
    }

    @Bean
    public CorsWebFilter corsWebFilter() {
        CorsConfiguration corsConfig = new CorsConfiguration();
        corsConfig.setAllowCredentials(true);
        corsConfig.setAllowedOriginPatterns(Arrays.asList("*"));
        corsConfig.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        corsConfig.setAllowedHeaders(Arrays.asList("*"));
        corsConfig.setExposedHeaders(Arrays.asList("*"));

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", corsConfig);

        return new CorsWebFilter(source);
    }
}