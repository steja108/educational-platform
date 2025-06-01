import * as React from 'react';
import { useState } from 'react';
import { useSelector } from 'react-redux';
import {
    Container,
    Typography,
    Paper,
    Box,
    TextField,
    Button,
    Avatar,
    Grid,
    Divider,
} from '@mui/material';
import { Edit, Save, Cancel } from '@mui/icons-material';
import { RootState } from '../store';

const ProfilePage: React.FC = () => {
    const { user } = useSelector((state: RootState) => state.auth);
    const [editMode, setEditMode] = useState(false);
    const [formData, setFormData] = useState({
        firstName: user?.firstName || '',
        lastName: user?.lastName || '',
        email: user?.email || '',
        phoneNumber: user?.phoneNumber || '',
    });

    const handleSave = () => {
        // TODO: Implement profile update API call
        console.log('Saving profile:', formData);
        setEditMode(false);
    };

    const handleCancel = () => {
        setFormData({
            firstName: user?.firstName || '',
            lastName: user?.lastName || '',
            email: user?.email || '',
            phoneNumber: user?.phoneNumber || '',
        });
        setEditMode(false);
    };

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        setFormData({
            ...formData,
            [e.target.name]: e.target.value,
        });
    };

    return (
        <Container maxWidth="md" sx={{ mt: 4, mb: 4 }}>
            <Typography variant="h4" gutterBottom>
                Profile
            </Typography>

            <Paper sx={{ p: 4 }}>
                <Box sx={{ display: 'flex', alignItems: 'center', mb: 4 }}>
                    <Avatar
                        sx={{ width: 100, height: 100, mr: 3 }}
                        src={user?.profilePicture}
                    >
                        {user?.firstName?.[0]}{user?.lastName?.[0]}
                    </Avatar>
                    <Box>
                        <Typography variant="h5">
                            {user?.firstName} {user?.lastName}
                        </Typography>
                        <Typography variant="body1" color="text.secondary">
                            {user?.roles.join(', ')}
                        </Typography>
                        <Typography variant="body2" color="text.secondary">
                            Member since: {new Date().toLocaleDateString()}
                        </Typography>
                    </Box>
                </Box>

                <Divider sx={{ mb: 3 }} />

                <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 3 }}>
                    <Typography variant="h6">
                        Personal Information
                    </Typography>
                    {!editMode ? (
                        <Button
                            startIcon={<Edit />}
                            onClick={() => setEditMode(true)}
                        >
                            Edit Profile
                        </Button>
                    ) : (
                        <Box>
                            <Button
                                startIcon={<Save />}
                                onClick={handleSave}
                                sx={{ mr: 1 }}
                                variant="contained"
                            >
                                Save
                            </Button>
                            <Button
                                startIcon={<Cancel />}
                                onClick={handleCancel}
                            >
                                Cancel
                            </Button>
                        </Box>
                    )}
                </Box>

                <Grid container spacing={3}>
                    <Grid item xs={12} sm={6}>
                        <TextField
                            fullWidth
                            label="First Name"
                            name="firstName"
                            value={formData.firstName}
                            onChange={handleChange}
                            disabled={!editMode}
                        />
                    </Grid>
                    <Grid item xs={12} sm={6}>
                        <TextField
                            fullWidth
                            label="Last Name"
                            name="lastName"
                            value={formData.lastName}
                            onChange={handleChange}
                            disabled={!editMode}
                        />
                    </Grid>
                    <Grid item xs={12} sm={6}>
                        <TextField
                            fullWidth
                            label="Email"
                            name="email"
                            type="email"
                            value={formData.email}
                            onChange={handleChange}
                            disabled={!editMode}
                        />
                    </Grid>
                    <Grid item xs={12} sm={6}>
                        <TextField
                            fullWidth
                            label="Phone Number"
                            name="phoneNumber"
                            value={formData.phoneNumber}
                            onChange={handleChange}
                            disabled={!editMode}
                        />
                    </Grid>
                </Grid>
            </Paper>
        </Container>
    );
};

export default ProfilePage;