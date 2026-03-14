package com.javaweb.repository;

import com.javaweb.entity.MediaAlbumEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface MediaAlbumRepository extends JpaRepository<MediaAlbumEntity, Long> {

    @Query("select distinct a from MediaAlbumEntity a " +
            "left join fetch a.person p " +
            "left join fetch a.branch b " +
            "left join fetch a.uploader u " +
            "order by a.createdDate desc, a.id desc")
    List<MediaAlbumEntity> findAllForAdminView();
}
