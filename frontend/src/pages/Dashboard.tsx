import React from 'react';
import { useSelector } from 'react-redux';
import {
    Container,
    Typography,
    Grid,
    Paper,
    Box,
    Button,
    Card,
    CardContent,
} from '@mui/material';
import { School, Assignment, TrendingUp, People } from '@mui/icons-material';
import { RootState } from '../store';
import { Role } from '../types';

const Dashboard: React.FC = () => {
    const { user } = useSelector((state: RootState) => state.auth);

    const isStudent = user?.roles.includes(Role.STUDENT);
    const isInstructor = user?.roles.includes(Role.INSTRUCTOR);
    const isAdmin = user?.roles.includes(Role.ADMIN);

    const studentStats = [
        { title: 'Enrolled Courses', value: '5', icon: <School /> },
        { title: 'Completed Assignments', value: '12', icon: <Assignment /> },
        { title: 'Progress', value: '78%', icon: <TrendingUp /> },
    ];

    const instructorStats = [
        { title: 'My Courses', value: '3', icon: <School /> },
        { title: 'Total Students', value: '147', icon: <People /> },
        { title: 'Pending Reviews', value: '8', icon: <Assignment /> },
    ];

    const adminStats = [
        { title: 'Total Courses', value: '45', icon: <School /> },
        { title: 'Total Users', value: '1,250', icon: <People /> },
        { title: 'Revenue', value: '$12,450', icon: <TrendingUp /> },
    ];

    const getStats = () => {
        if (isAdmin) return adminStats;
        if (isInstructor) return instructorStats;
        return studentStats;
    };

    const getWelcomeMessage = () => {
        if (isAdmin) return 'Admin Dashboard';
        if (isInstructor) return 'Instructor Dashboard';
        return 'Student Dashboard';
    };

    return (
        <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
            <Typography variant="h4" gutterBottom>
                {getWelcomeMessage()}
            </Typography>

            <Grid container spacing={3}>
                {getStats().map((stat, index) => (
                    <Grid item xs={12} sm={6} md={4} key={index}>
                        <Card>
                            <CardContent>
                                <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
                                    {stat.icon}
                                    <Typography variant="h6" sx={{ ml: 1 }}>
                                        {stat.title}
                                    </Typography>
                                </Box>
                                <Typography variant="h4" color="primary">
                                    {stat.value}
                                </Typography>
                            </CardContent>
                        </Card>
                    </Grid>
                ))}
            </Grid>

            <Grid container spacing={3} sx={{ mt: 3 }}>
                <Grid item xs={12} md={8}>
                    <Paper sx={{ p: 3 }}>
                        <Typography variant="h6" gutterBottom>
                            Recent Activity
                        </Typography>
                        <Typography variant="body1" color="text.secondary">
                            No recent activity to display.
                        </Typography>
                    </Paper>
                </Grid>

                <Grid item xs={12} md={4}>
                    <Paper sx={{ p: 3 }}>
                        <Typography variant="h6" gutterBottom>
                            Quick Actions
                        </Typography>
                        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
                            {isStudent && (
                                <>
                                    <Button variant="contained" fullWidth>
                                        Browse Courses
                                    </Button>
                                    <Button variant="outlined" fullWidth>
                                        View Progress
                                    </Button>
                                </>
                            )}
                            {isInstructor && (
                                <>
                                    <Button variant="contained" fullWidth>
                                        Create Course
                                    </Button>
                                    <Button variant="outlined" fullWidth>
                                        Manage Courses
                                    </Button>
                                </>
                            )}
                            {isAdmin && (
                                <>
                                    <Button variant="contained" fullWidth>
                                        User Management
                                    </Button>
                                    <Button variant="outlined" fullWidth>
                                        System Analytics
                                    </Button>
                                </>
                            )}
                        </Box>
                    </Paper>
                </Grid>
            </Grid>
        </Container>
    );
};

export default Dashboard;