package com.javaweb.repository;

import com.javaweb.entity.BranchEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BranchRepository extends JpaRepository<BranchEntity,Long> {

}
