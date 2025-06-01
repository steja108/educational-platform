package com.eduplatform.course.repository;

import com.eduplatform.course.entity.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseRepository extends JpaRepository<Course, Long> {

    List<Course> findByIsPublishedTrue();

    List<Course> findByInstructorId(Long instructorId);

    List<Course> findByCategory(String category);

    List<Course> findByLevel(Course.Level level);

    @Query("SELECT c FROM Course c WHERE c.isPublished = true AND " +
            "LOWER(c.title) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Course> findPublishedByTitleContaining(@Param("keyword") String keyword);
}