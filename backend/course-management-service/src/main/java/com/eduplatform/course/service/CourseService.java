package com.eduplatform.course.service;

import com.eduplatform.course.entity.Course;
import com.eduplatform.course.repository.CourseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class CourseService {

    private final CourseRepository courseRepository;

    public List<Course> getAllPublishedCourses() {
        return courseRepository.findByIsPublishedTrue();
    }

    public Optional<Course> getCourseById(Long id) {
        return courseRepository.findById(id);
    }

    public Course createCourse(Course course) {
        return courseRepository.save(course);
    }

    public Optional<Course> updateCourse(Long id, Course courseDetails) {
        return courseRepository.findById(id)
                .map(course -> {
                    course.setTitle(courseDetails.getTitle());
                    course.setDescription(courseDetails.getDescription());
                    course.setPrice(courseDetails.getPrice());
                    course.setCategory(courseDetails.getCategory());
                    course.setThumbnail(courseDetails.getThumbnail());
                    course.setDuration(courseDetails.getDuration());
                    course.setLevel(courseDetails.getLevel());
                    course.setIsPublished(courseDetails.getIsPublished());
                    return courseRepository.save(course);
                });
    }

    public void deleteCourse(Long id) {
        courseRepository.deleteById(id);
    }

    public List<Course> getCoursesByInstructor(Long instructorId) {
        return courseRepository.findByInstructorId(instructorId);
    }
}