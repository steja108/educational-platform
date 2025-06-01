import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { Provider } from 'react-redux';
import { ThemeProvider, createTheme } from '@mui/material/styles';
import { CssBaseline } from '@mui/material';
import { store } from './store';
import Layout from './components/layout/Layout';
import ProtectedRoute from './components/common/ProtectedRoute';
import LoginForm from './components/auth/LoginForm';
import RegisterForm from './components/auth/RegisterForm';
import Dashboard from './pages/Dashboard';
import HomePage from './pages/HomePage';
import CoursesPage from './pages/CoursesPage';
import ProfilePage from './pages/ProfilePage';
import UnauthorizedPage from './pages/UnauthorizedPage';
import { Role } from './types';

const theme = createTheme({
    palette: {
        primary: {
            main: '#1976d2',
        },
        secondary: {
            main: '#dc004e',
        },
    },
});

function App() {
    return (
        <Provider store={store}>
            <ThemeProvider theme={theme}>
                <CssBaseline />
                <Router>
                    <Layout>
                        <Routes>
                            {/* Public Routes */}
                            <Route path="/" element={<HomePage />} />
                            <Route path="/login" element={<LoginForm />} />
                            <Route path="/register" element={<RegisterForm />} />
                            <Route path="/unauthorized" element={<UnauthorizedPage />} />

                            {/* Protected Routes */}
                            <Route
                                path="/dashboard"
                                element={
                                    <ProtectedRoute>
                                        <Dashboard />
                                    </ProtectedRoute>
                                }
                            />

                            <Route
                                path="/courses"
                                element={
                                    <ProtectedRoute>
                                        <CoursesPage />
                                    </ProtectedRoute>
                                }
                            />

                            <Route
                                path="/profile"
                                element={
                                    <ProtectedRoute>
                                        <ProfilePage />
                                    </ProtectedRoute>
                                }
                            />

                            {/* Admin Routes */}
                            <Route
                                path="/admin/*"
                                element={
                                    <ProtectedRoute roles={[Role.ADMIN]}>
                                        <AdminRoutes />
                                    </ProtectedRoute>
                                }
                            />

                            {/* Instructor Routes */}
                            <Route
                                path="/instructor/*"
                                element={
                                    <ProtectedRoute roles={[Role.INSTRUCTOR, Role.ADMIN]}>
                                        <InstructorRoutes />
                                    </ProtectedRoute>
                                }
                            />

                            {/* Catch all route */}
                            <Route path="*" element={<Navigate to="/" replace />} />
                        </Routes>
                    </Layout>
                </Router>
            </ThemeProvider>
        </Provider>
    );
}

// Admin Routes Component
const AdminRoutes: React.FC = () => {
    return (
        <Routes>
            <Route path="users" element={<div>User Management</div>} />
            <Route path="analytics" element={<div>System Analytics</div>} />
            <Route path="settings" element={<div>System Settings</div>} />
            <Route path="" element={<Navigate to="users" replace />} />
        </Routes>
    );
};

// Instructor Routes Component
const InstructorRoutes: React.FC = () => {
    return (
        <Routes>
            <Route path="courses" element={<div>Manage Courses</div>} />
            <Route path="create-course" element={<div>Create Course</div>} />
            <Route path="students" element={<div>Student Management</div>} />
            <Route path="" element={<Navigate to="courses" replace />} />
        </Routes>
    );
};

export default App;