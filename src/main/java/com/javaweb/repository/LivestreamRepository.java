package com.javaweb.repository;

import com.javaweb.entity.LivestreamEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface LivestreamRepository extends JpaRepository<LivestreamEntity, Long> {
    Optional<LivestreamEntity> findFirstByBranch_IdAndStatusOrderByIdDesc(Long branchId, Integer status);

    Optional<LivestreamEntity> findFirstByStatusOrderByIdDesc(Integer status);

    Optional<LivestreamEntity> findByIdAndStatus(Long id, Integer status);
}
