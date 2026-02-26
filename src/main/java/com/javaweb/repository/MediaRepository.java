package com.javaweb.repository;

import com.javaweb.entity.MediaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface MediaRepository extends JpaRepository<MediaEntity,Long> {
    @Query("select m from MediaEntity m " +
            "left join fetch m.person p " +
            "left join fetch m.branch b " +
            "left join fetch m.uploader u " +
            "order by m.createdDate desc, m.id desc")
    List<MediaEntity> findAllForAdminView();

    Optional<MediaEntity> findFirstByFileUrlContaining(String fileUrlPart);

    long countByCreatedDateBetween(Date from, Date to);
}
