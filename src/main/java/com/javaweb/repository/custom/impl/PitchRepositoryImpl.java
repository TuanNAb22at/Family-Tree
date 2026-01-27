package com.javaweb.repository.custom.impl;

import com.javaweb.entity.PitchEntity;
import com.javaweb.repository.custom.PitchRepositoryCustom;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.time.LocalDate;
import java.util.List;

@Repository
public class PitchRepositoryImpl implements PitchRepositoryCustom {
    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<PitchEntity> findAvailablePitches(String startDate, String endDate, String pitchTypeId) {
        String sql = "SELECT p FROM PitchEntity p " +
                "WHERE p.type LIKE '%" + pitchTypeId + "%' " +
                "AND p.id NOT IN (" +
                "   SELECT prd.pitch.id FROM PitchRentalDetailEntity prd " +
                "   WHERE NOT (prd.endDate < '" + startDate + "' OR prd.stDate > '" + endDate + "')" +
                ")";

        return entityManager.createQuery(sql, PitchEntity.class)
                .getResultList();

    }

    public List<PitchEntity> findAvailablePitchesToday() {
        String jpql = "SELECT p FROM PitchEntity p " +
                "WHERE NOT EXISTS ( " +
                "   SELECT 1 FROM PitchRentalDetailEntity prd " +
                "   WHERE prd.pitch = p " +
                "   AND prd.stDate <= CURRENT_DATE " +
                "   AND prd.endDate >= CURRENT_DATE " +
                ")";
        return entityManager.createQuery(jpql, PitchEntity.class)
                .getResultList();
    }


}

