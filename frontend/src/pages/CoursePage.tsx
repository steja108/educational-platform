import React, { useState } from 'react';
import {
    Container,
    Typography,
    Grid,
    Card,
    CardContent,
    CardMedia,
    CardActions,
    Button,
    Box,
    Chip,
    TextField,
    MenuItem,
} from '@mui/material';
import { PlayCircle, AccessTime, Star } from '@mui/icons-material';

// Mock data - will be replaced with API calls
const mockCourses = [
    {
        id: 1,
        title: 'React Development Fundamentals',
        description: 'Learn the basics of React development from scratch',
        instructor: 'John Doe',
        price: 99.99,
        category: 'Programming',
        level: 'BEGINNER',
        duration: 120,
        rating: 4.5,
        thumbnail: '/api/placeholder/300/200',
    },
    {
        id: 2,
        title: 'Advanced Java Programming',
        description: 'Master advanced Java concepts and design patterns',
        instructor: 'Jane Smith',
        price: 149.99,
        category: 'Programming',
        level: 'ADVANCED',
        duration: 180,
        rating: 4.8,
        thumbnail: '/api/placeholder/300/200',
    },
    {
        id: 3,
        title: 'Digital Marketing Essentials',
        description: 'Complete guide to digital marketing strategies',
        instructor: 'Mike Johnson',
        price: 79.99,
        category: 'Marketing',
        level: 'INTERMEDIATE',
        duration: 90,
        rating: 4.3,
        thumbnail: '/api/placeholder/300/200',
    },
];

const CoursesPage: React.FC = () => {
    const [searchTerm, setSearchTerm] = useState('');
    const [categoryFilter, setCategoryFilter] = useState('');
    const [levelFilter, setLevelFilter] = useState('');

    const categories = ['Programming', 'Marketing', 'Design', 'Business'];
    const levels = ['BEGINNER', 'INTERMEDIATE', 'ADVANCED'];

    const filteredCourses = mockCourses.filter(course => {
        return (
            course.title.toLowerCase().includes(searchTerm.toLowerCase()) &&
            (categoryFilter === '' || course.category === categoryFilter) &&
            (levelFilter === '' || course.level === levelFilter)
        );
    });

    const getLevelColor = (level: string) => {
        switch (level) {
            case 'BEGINNER': return 'success';
            case 'INTERMEDIATE': return 'warning';
            case 'ADVANCED': return 'error';
            default: return 'default';
        }
    };

    return (
        <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
            <Typography variant="h4" gutterBottom>
                Browse Courses
            </Typography>

            {/* Filters */}
            <Box sx={{ mb: 4 }}>
                <Grid container spacing={3}>
                    <Grid item xs={12} md={4}>
                        <TextField
                            fullWidth
                            label="Search Courses"
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                        />
                    </Grid>
                    <Grid item xs={12} md={4}>
                        <TextField
                            fullWidth
                            select
                            label="Category"
                            value={categoryFilter}
                            onChange={(e) => setCategoryFilter(e.target.value)}
                        >
                            <MenuItem value="">All Categories</MenuItem>
                            {categories.map((category) => (
                                <MenuItem key={category} value={category}>
                                    {category}
                                </MenuItem>
                            ))}
                        </TextField>
                    </Grid>
                    <Grid item xs={12} md={4}>
                        <TextField
                            fullWidth
                            select
                            label="Level"
                            value={levelFilter}
                            onChange={(e) => setLevelFilter(e.target.value)}
                        >
                            <MenuItem value="">All Levels</MenuItem>
                            {levels.map((level) => (
                                <MenuItem key={level} value={level}>
                                    {level}
                                </MenuItem>
                            ))}
                        </TextField>
                    </Grid>
                </Grid>
            </Box>

            {/* Course Grid */}
            <Grid container spacing={3}>
                {filteredCourses.map((course) => (
                    <Grid item xs={12} sm={6} md={4} key={course.id}>
                        <Card sx={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
                            <CardMedia
                                component="img"
                                height="200"
                                image={course.thumbnail}
                                alt={course.title}
                                sx={{ backgroundColor: 'grey.200' }}
                            />
                            <CardContent sx={{ flexGrow: 1 }}>
                                <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 1 }}>
                                    <Chip
                                        label={course.level}
                                        size="small"
                                        color={getLevelColor(course.level) as any}
                                    />
                                    <Chip label={course.category} size="small" variant="outlined" />
                                </Box>

                                <Typography variant="h6" component="h3" gutterBottom>
                                    {course.title}
                                </Typography>

                                <Typography variant="body2" color="text.secondary" paragraph>
                                    {course.description}
                                </Typography>

                                <Typography variant="body2" gutterBottom>
                                    Instructor: {course.instructor}
                                </Typography>

                                <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 1 }}>
                                    <Box sx={{ display: 'flex', alignItems: 'center' }}>
                                        <AccessTime fontSize="small" />
                                        <Typography variant="body2" sx={{ ml: 0.5 }}>
                                            {course.duration} min
                                        </Typography>
                                    </Box>
                                    <Box sx={{ display: 'flex', alignItems: 'center' }}>
                                        <Star fontSize="small" color="warning" />
                                        <Typography variant="body2" sx={{ ml: 0.5 }}>
                                            {course.rating}
                                        </Typography>
                                    </Box>
                                </Box>

                                <Typography variant="h6" color="primary">
                                    ${course.price}
                                </Typography>
                            </CardContent>

                            <CardActions>
                                <Button
                                    fullWidth
                                    variant="contained"
                                    startIcon={<PlayCircle />}
                                >
                                    Enroll Now
                                </Button>
                            </CardActions>
                        </Card>
                    </Grid>
                ))}
            </Grid>

            {filteredCourses.length === 0 && (
                <Box sx={{ textAlign: 'center', mt: 4 }}>
                    <Typography variant="h6" color="text.secondary">
                        No courses found matching your criteria
                    </Typography>
                </Box>
            )}
        </Container>
    );
};

export default CoursesPage;