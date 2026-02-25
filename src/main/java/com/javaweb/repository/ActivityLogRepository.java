package com.javaweb.repository;

import com.javaweb.entity.ActivityLogEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;
import java.util.List;

public interface ActivityLogRepository extends JpaRepository<ActivityLogEntity, Long> {
    List<ActivityLogEntity> findTop100ByOrderByTimestampDesc();
    List<ActivityLogEntity> findByTimestampBetweenOrderByTimestampAsc(Date from, Date to);
    long countByTimestampAfter(Date since);
    long countByActionAndTimestampAfter(String action, Date since);
}

