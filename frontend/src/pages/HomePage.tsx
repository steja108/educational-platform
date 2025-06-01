import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useSelector } from 'react-redux';
import {
    Container,
    Typography,
    Button,
    Box,
    Grid,
    Card,
    CardContent,
    CardActions,
} from '@mui/material';
import { School, PlayCircle, Assignment, TrendingUp } from '@mui/icons-material';
import { RootState } from '../store';

const HomePage: React.FC = () => {
    const navigate = useNavigate();
    const { isAuthenticated } = useSelector((state: RootState) => state.auth);

    const features = [
        {
            icon: <School fontSize="large" color="primary" />,
            title: 'Expert-Led Courses',
            description: 'Learn from industry professionals with real-world experience',
        },
        {
            icon: <PlayCircle fontSize="large" color="primary" />,
            title: 'Video Learning',
            description: 'High-quality video content with adaptive streaming',
        },
        {
            icon: <Assignment fontSize="large" color="primary" />,
            title: 'Interactive Quizzes',
            description: 'Test your knowledge with comprehensive assessments',
        },
        {
            icon: <TrendingUp fontSize="large" color="primary" />,
            title: 'Progress Tracking',
            description: 'Monitor your learning journey and achievements',
        },
    ];

    return (
        <Container maxWidth="lg">
            {/* Hero Section */}
            <Box
                sx={{
                    textAlign: 'center',
                    py: { xs: 8, md: 12 },
                    px: 2,
                }}
            >
                <Typography
                    variant="h2"
                    component="h1"
                    gutterBottom
                    sx={{
                        fontWeight: 'bold',
                        fontSize: { xs: '2.5rem', md: '3.75rem' },
                    }}
                >
                    Master New Skills with
                    <Typography
                        component="span"
                        variant="h2"
                        color="primary"
                        sx={{ display: 'block', fontSize: 'inherit' }}
                    >
                        EduPlatform
                    </Typography>
                </Typography>

                <Typography
                    variant="h5"
                    color="text.secondary"
                    paragraph
                    sx={{ mb: 4, maxWidth: '600px', mx: 'auto' }}
                >
                    Join thousands of learners worldwide and unlock your potential with our comprehensive online courses
                </Typography>

                <Box sx={{ display: 'flex', gap: 2, justifyContent: 'center', flexWrap: 'wrap' }}>
                    {!isAuthenticated ? (
                        <>
                            <Button
                                variant="contained"
                                size="large"
                                onClick={() => navigate('/register')}
                                sx={{ px: 4, py: 1.5 }}
                            >
                                Get Started Free
                            </Button>
                            <Button
                                variant="outlined"
                                size="large"
                                onClick={() => navigate('/courses')}
                                sx={{ px: 4, py: 1.5 }}
                            >
                                Browse Courses
                            </Button>
                        </>
                    ) : (
                        <Button
                            variant="contained"
                            size="large"
                            onClick={() => navigate('/dashboard')}
                            sx={{ px: 4, py: 1.5 }}
                        >
                            Go to Dashboard
                        </Button>
                    )}
                </Box>
            </Box>

            {/* Features Section */}
            <Box sx={{ py: 8 }}>
                <Typography
                    variant="h3"
                    component="h2"
                    textAlign="center"
                    gutterBottom
                    sx={{ mb: 6 }}
                >
                    Why Choose EduPlatform?
                </Typography>

                <Grid container spacing={4}>
                    {features.map((feature, index) => (
                        <Grid item xs={12} sm={6} md={3} key={index}>
                            <Card sx={{ height: '100%', textAlign: 'center', p: 2 }}>
                                <CardContent>
                                    <Box sx={{ mb: 2 }}>
                                        {feature.icon}
                                    </Box>
                                    <Typography variant="h6" component="h3" gutterBottom>
                                        {feature.title}
                                    </Typography>
                                    <Typography variant="body2" color="text.secondary">
                                        {feature.description}
                                    </Typography>
                                </CardContent>
                            </Card>
                        </Grid>
                    ))}
                </Grid>
            </Box>

            {/* CTA Section */}
            <Box
                sx={{
                    textAlign: 'center',
                    py: 8,
                    px: 4,
                    backgroundColor: 'primary.main',
                    color: 'primary.contrastText',
                    borderRadius: 2,
                    mb: 8,
                }}
            >
                <Typography variant="h4" component="h2" gutterBottom>
                    Ready to Start Learning?
                </Typography>
                <Typography variant="h6" paragraph sx={{ mb: 4 }}>
                    Join our community of learners and start your journey today
                </Typography>
                {!isAuthenticated && (
                    <Button
                        variant="contained"
                        size="large"
                        onClick={() => navigate('/register')}
                        sx={{
                            backgroundColor: 'white',
                            color: 'primary.main',
                            '&:hover': {
                                backgroundColor: 'grey.100',
                            },
                            px: 4,
                            py: 1.5,
                        }}
                    >
                        Sign Up Now
                    </Button>
                )}
            </Box>
        </Container>
    );
};

export default HomePage;