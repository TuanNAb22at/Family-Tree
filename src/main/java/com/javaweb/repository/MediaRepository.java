package com.javaweb.repository;

import com.javaweb.entity.MediaEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MediaRepository extends JpaRepository<MediaEntity,Long> {
}
