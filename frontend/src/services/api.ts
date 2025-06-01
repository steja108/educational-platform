// frontend/src/services/api.ts - Fixed with proper imports
import axios, { AxiosInstance, AxiosResponse } from 'axios';
import { LoginRequest, RegisterRequest, AuthResponse, User, Course } from '../types';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8080';

class ApiService {
    private api: AxiosInstance;

    constructor() {
        this.api = axios.create({
            baseURL: API_BASE_URL,
            headers: {
                'Content-Type': 'application/json',
            },
        });

        // Request interceptor to add auth token
        this.api.interceptors.request.use(
            (config) => {
                const token = localStorage.getItem('token');
                if (token) {
                    config.headers.Authorization = `Bearer ${token}`;
                }
                return config;
            },
            (error) => Promise.reject(error)
        );

        // Response interceptor to handle token expiration
        this.api.interceptors.response.use(
            (response) => response,
            (error) => {
                if (error.response?.status === 401) {
                    localStorage.removeItem('token');
                    localStorage.removeItem('refreshToken');
                    localStorage.removeItem('user');
                    window.location.href = '/login';
                }
                return Promise.reject(error);
            }
        );
    }

    // Auth endpoints
    login = (credentials: LoginRequest): Promise<AxiosResponse<AuthResponse>> =>
        this.api.post('/api/auth/login', credentials);

    register = (userData: RegisterRequest): Promise<AxiosResponse<AuthResponse>> =>
        this.api.post('/api/auth/register', userData);

    logout = (): Promise<AxiosResponse<void>> =>
        this.api.post('/api/auth/logout');

    // User endpoints
    getCurrentUser = (): Promise<AxiosResponse<User>> =>
        this.api.get('/api/users/me');

    updateProfile = (userData: Partial<User>): Promise<AxiosResponse<User>> =>
        this.api.put('/api/users/profile', userData);

    // Course endpoints
    getCourses = (): Promise<AxiosResponse<Course[]>> =>
        this.api.get('/api/courses');

    getCourse = (id: number): Promise<AxiosResponse<Course>> =>
        this.api.get(`/api/courses/${id}`);

    createCourse = (courseData: Partial<Course>): Promise<AxiosResponse<Course>> =>
        this.api.post('/api/courses', courseData);

    updateCourse = (id: number, courseData: Partial<Course>): Promise<AxiosResponse<Course>> =>
        this.api.put(`/api/courses/${id}`, courseData);

    deleteCourse = (id: number): Promise<AxiosResponse<void>> =>
        this.api.delete(`/api/courses/${id}`);
}

export default new ApiService();