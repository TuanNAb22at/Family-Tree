package com.javaweb.repository;

import com.javaweb.entity.BranchEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface BranchRepository extends JpaRepository<BranchEntity,Long> {
    Optional<BranchEntity> findFirstByOrderByIdAsc();
}
