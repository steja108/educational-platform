import React from 'react';
import { useNavigate } from 'react-router-dom';
import {
    Container,
    Typography,
    Button,
    Box,
    Paper,
} from '@mui/material';
import { Lock } from '@mui/icons-material';

const UnauthorizedPage: React.FC = () => {
    const navigate = useNavigate();

    return (
        <Container maxWidth="sm" sx={{ mt: 8 }}>
            <Paper sx={{ p: 4, textAlign: 'center' }}>
                <Lock color="error" sx={{ fontSize: 64, mb: 2 }} />
                <Typography variant="h4" gutterBottom>
                    Access Denied
                </Typography>
                <Typography variant="body1" color="text.secondary" paragraph>
                    You don't have permission to access this page. Please contact your administrator if you believe this is an error.
                </Typography>
                <Box sx={{ mt: 3 }}>
                    <Button
                        variant="contained"
                        onClick={() => navigate('/dashboard')}
                        sx={{ mr: 2 }}
                    >
                        Go to Dashboard
                    </Button>
                    <Button
                        variant="outlined"
                        onClick={() => navigate('/')}
                    >
                        Go Home
                    </Button>
                </Box>
            </Paper>
        </Container>
    );
};

export default UnauthorizedPage;