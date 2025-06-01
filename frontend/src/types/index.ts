export interface User {
    id: number;
    username: string;
    email: string;
    firstName: string;
    lastName: string;
    profilePicture?: string;
    phoneNumber?: string;
    roles: Role[];
    isActive: boolean;
    isEmailVerified: boolean;
}

export enum Role {
    STUDENT = 'STUDENT',
    INSTRUCTOR = 'INSTRUCTOR',
    ADMIN = 'ADMIN'
}

export interface LoginRequest {
    email: string;
    password: string;
}

export interface RegisterRequest {
    username: string;
    email: string;
    password: string;
    firstName: string;
    lastName: string;
    phoneNumber?: string;
    role: Role;
}

export interface AuthResponse {
    token: string;
    type: string;
    refreshToken: string;
    user: User;
}

export interface Course {
    id: number;
    title: string;
    description: string;
    instructor: User;
    price: number;
    category: string;
    thumbnail?: string;
    duration: number;
    level: 'BEGINNER' | 'INTERMEDIATE' | 'ADVANCED';
    isPublished: boolean;
    createdAt: string;
    updatedAt: string;
}