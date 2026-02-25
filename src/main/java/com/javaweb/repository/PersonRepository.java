package com.javaweb.repository;

import com.javaweb.entity.PersonEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface PersonRepository extends JpaRepository<PersonEntity,Long> {
    Optional<PersonEntity>
    findFirstByBranch_IdAndGenerationOrderByIdAsc(
            Long branchId,
            Integer generation
    );

    Optional<PersonEntity> findByIdAndSpouseIsNull(Long id);

    @Query("select p from PersonEntity p where p.father.id = :parentId or p.mother.id = :parentId order by p.id asc")
    List<PersonEntity> findChildrenByParentId(@Param("parentId") Long parentId);

    @Query("select count(p.id) from PersonEntity p where p.father.id = :parentId or p.mother.id = :parentId")
    long countChildrenByParentId(@Param("parentId") Long parentId);

    Optional<PersonEntity> findFirstByBranch_IdOrderByGenerationAscIdAsc(Long branchId);

    @Query("select p from PersonEntity p where p.branch.id = :branchId and (p.father.id = :parentId or p.mother.id = :parentId) order by p.id asc")
    List<PersonEntity> findChildrenByParentIdAndBranchId(@Param("parentId") Long parentId, @Param("branchId") Long branchId);

    Optional<PersonEntity> findByUserId(Long userId);
}
