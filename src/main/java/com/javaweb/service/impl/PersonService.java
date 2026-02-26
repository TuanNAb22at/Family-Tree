package com.javaweb.service.impl;

import com.javaweb.entity.BranchEntity;
import com.javaweb.entity.PersonEntity;
import com.javaweb.model.dto.PersonDTO;
import com.javaweb.repository.BranchRepository;
import com.javaweb.repository.PersonRepository;
import com.javaweb.service.IPersonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class PersonService implements IPersonService {
    @Autowired
    PersonRepository personRepository;

    @Autowired
    BranchRepository branchRepository;

    @Override
    public void createPerson(PersonDTO personDTO) {
        PersonEntity personEntity = new PersonEntity();
        BranchEntity branchEntity = resolveBranch(personDTO.getBranch());
        personEntity.setDob(personDTO.getDob() == null ? null : java.sql.Date.valueOf(personDTO.getDob()));
        personEntity.setDod(personDTO.getDod() == null ? null : java.sql.Date.valueOf(personDTO.getDod()));
        personEntity.setFullName(personDTO.getFullName());
        personEntity.setGeneration(personDTO.getGeneration());
        personEntity.setGender(personDTO.getGender());
        personEntity.setAvatar(personDTO.getAvatar());
        personEntity.setBranch(branchEntity);
        personRepository.save(personEntity);
    }

    @Override
    public long countPersons() {
        return personRepository.count();
    }

    @Override
    @Transactional
    public PersonDTO addSpouse(Long personId, PersonDTO spouseDTO) {
        if (spouseDTO.getFullName() == null || spouseDTO.getFullName().trim().isEmpty()) {
            throw new IllegalArgumentException("Spouse full name is required");
        }
        PersonEntity person = personRepository.findByIdAndSpouseIsNull(personId).orElseThrow(
                () -> new IllegalArgumentException("Person not found or already has spouse: " + personId)
        );

        PersonEntity spouse = new PersonEntity();
        spouse.setFullName(spouseDTO.getFullName());
        spouse.setGender(spouseDTO.getGender());
        spouse.setDob(spouseDTO.getDob() == null ? null : java.sql.Date.valueOf(spouseDTO.getDob()));
        spouse.setDod(spouseDTO.getDod() == null ? null : java.sql.Date.valueOf(spouseDTO.getDod()));
        spouse.setGeneration(person.getGeneration());
        spouse.setBranch(resolveBranchOrDefault(spouseDTO.getBranch(), person.getBranch()));
        spouse.setAvatar(spouseDTO.getAvatar());
        spouse = personRepository.save(spouse);

        person.setSpouse(spouse);
        spouse.setSpouse(person);
        personRepository.save(person);
        personRepository.save(spouse);

        return toPersonDTO(person);
    }

    @Override
    @Transactional
    public PersonDTO addChild(Long personId, PersonDTO childDTO) {
        if (childDTO.getFullName() == null || childDTO.getFullName().trim().isEmpty()) {
            throw new IllegalArgumentException("Child full name is required");
        }
        PersonEntity parent = personRepository.findById(personId).orElseThrow(
                () -> new IllegalArgumentException("Parent not found: " + personId)
        );

        PersonEntity child = new PersonEntity();
        child.setFullName(childDTO.getFullName());
        child.setGender(childDTO.getGender());
        child.setDob(childDTO.getDob() == null ? null : java.sql.Date.valueOf(childDTO.getDob()));
        child.setDod(childDTO.getDod() == null ? null : java.sql.Date.valueOf(childDTO.getDod()));
        child.setGeneration(parent.getGeneration() == null ? 1 : parent.getGeneration() + 1);
        child.setBranch(resolveBranchOrDefault(childDTO.getBranch(), parent.getBranch()));
        child.setAvatar(childDTO.getAvatar());

        if ("female".equalsIgnoreCase(parent.getGender())) {
            child.setMother(parent);
            child.setFather(parent.getSpouse());
        } else {
            child.setFather(parent);
            child.setMother(parent.getSpouse());
        }

        personRepository.save(child);
        return toPersonDTO(parent);
    }

    @Override
    @Transactional
    public PersonDTO updatePerson(Long personId, PersonDTO personDTO) {
        PersonEntity person = personRepository.findById(personId).orElseThrow(
                () -> new IllegalArgumentException("Person not found: " + personId)
        );

        if (personDTO.getFullName() != null && !personDTO.getFullName().trim().isEmpty()) {
            person.setFullName(personDTO.getFullName().trim());
        }
        person.setGender(personDTO.getGender());
        person.setDob(personDTO.getDob() == null ? null : java.sql.Date.valueOf(personDTO.getDob()));
        person.setDod(personDTO.getDod() == null ? null : java.sql.Date.valueOf(personDTO.getDod()));
        if (personDTO.getGeneration() != null) {
            person.setGeneration(personDTO.getGeneration());
        }
        if (personDTO.getAvatar() != null && !personDTO.getAvatar().trim().isEmpty()) {
            person.setAvatar(personDTO.getAvatar());
        }

        if (personDTO.getBranch() != null && !personDTO.getBranch().trim().isEmpty()) {
            person.setBranch(resolveBranch(personDTO.getBranch()));
        }

        personRepository.save(person);
        return toPersonDTO(person);
    }

    @Override
    @Transactional
    public void deletePerson(Long personId) {
        PersonEntity person = personRepository.findById(personId).orElseThrow(
                () -> new IllegalArgumentException("Person not found: " + personId)
        );

        long childrenCount = personRepository.countChildrenByParentId(personId);
        if (childrenCount > 0) {
            throw new IllegalArgumentException(
                    "Khong the xoa thanh vien nay vi van con. Vui long xoa con truoc, sau do moi xoa cha/me."
            );
        }

        PersonEntity spouse = person.getSpouse();
        if (spouse != null) {
            spouse.setSpouse(null);
            person.setSpouse(null);
            personRepository.save(spouse);
        }

        personRepository.delete(person);
    }



    @Override
    @Transactional(readOnly = true)
    public PersonDTO findRootPersonByBranchId(Long branchId) {
        Optional<BranchEntity> mainBranch = branchRepository.findFirstByOrderByIdAsc();
        if (mainBranch.isPresent() && Objects.equals(mainBranch.get().getId(), branchId)) {
            Optional<PersonEntity> mainRoot =
                    personRepository.findFirstByBranch_IdAndGenerationOrderByIdAsc(branchId, 1);
            if (!mainRoot.isPresent()) {
                mainRoot = personRepository.findFirstByBranch_IdOrderByGenerationAscIdAsc(branchId);
            }
            return mainRoot.map(this::toPersonDTO).orElse(null);
        }

        Optional<PersonEntity> optionalEntity =
                personRepository.findFirstByBranch_IdAndGenerationOrderByIdAsc(
                        branchId, 1
                );
        if (!optionalEntity.isPresent()) {
            optionalEntity = personRepository.findFirstByBranch_IdOrderByGenerationAscIdAsc(branchId);
        }
        if (!optionalEntity.isPresent()) {
            return null;
        }
        return toPersonDTOByBranch(optionalEntity.get(), branchId);
    }

    private PersonDTO toPersonDTO(PersonEntity entity) {
        return toPersonDTO(entity, 0);
    }

    private PersonDTO toPersonDTOByBranch(PersonEntity entity, Long branchId) {
        return toPersonDTO(entity, 0, branchId);
    }

    private PersonDTO toPersonDTO(PersonEntity entity, int level) {
        return toPersonDTO(entity, level, null);
    }

    private PersonDTO toPersonDTO(PersonEntity entity, int level, Long branchId) {
        PersonDTO dto = new PersonDTO();
        dto.setId(entity.getId());
        dto.setFullName(entity.getFullName());
        dto.setGender(entity.getGender());
        dto.setAvatar(entity.getAvatar());
        dto.setGeneration(entity.getGeneration());
        if (entity.getBranch() != null) {
            dto.setBranch(String.valueOf(entity.getBranch().getId()));
            dto.setBranchName(entity.getBranch().getName());
        }
        dto.setDob(toLocalDate(entity.getDob()));
        dto.setDod(toLocalDate(entity.getDod()));
        if (entity.getSpouse() != null
                && (branchId == null
                || (entity.getSpouse().getBranch() != null
                && Objects.equals(entity.getSpouse().getBranch().getId(), branchId)))) {
            dto.setSpouseId(entity.getSpouse().getId());
            dto.setSpouseFullName(entity.getSpouse().getFullName());
            dto.setSpouseGender(entity.getSpouse().getGender());
            dto.setSpouseGeneration(entity.getSpouse().getGeneration());
            if (entity.getSpouse().getBranch() != null) {
                dto.setSpouseBranchName(entity.getSpouse().getBranch().getName());
            }
            dto.setSpouseAvatar(entity.getSpouse().getAvatar());
            dto.setSpouseDob(toLocalDate(entity.getSpouse().getDob()));
            dto.setSpouseDod(toLocalDate(entity.getSpouse().getDod()));
        }
        if (level < 8) {
            List<PersonEntity> children;
            if (branchId != null) {
                children = personRepository.findChildrenByParentIdAndBranchId(entity.getId(), branchId);
            } else {
                children = personRepository.findChildrenByParentId(entity.getId());
            }
            dto.setChildren(children.stream()
                    .map(child -> toPersonDTO(child, level + 1, branchId))
                    .collect(Collectors.toList()));
        }
        return dto;
    }

    private LocalDate toLocalDate(java.util.Date date) {
        if (date == null) {
            return null;
        }
        return java.time.Instant.ofEpochMilli(date.getTime())
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
    }

    private BranchEntity resolveBranch(String branchValue) {
        if (branchValue != null && !branchValue.trim().isEmpty()) {
            try {
                Long branchId = Long.parseLong(branchValue.trim());
                Optional<BranchEntity> exact = branchRepository.findById(branchId);
                if (exact.isPresent()) {
                    return exact.get();
                }
            } catch (NumberFormatException ignored) {
            }
        }

        Optional<BranchEntity> firstBranch = branchRepository.findFirstByOrderByIdAsc();
        if (firstBranch.isPresent()) {
            return firstBranch.get();
        }

        BranchEntity defaultBranch = new BranchEntity();
        defaultBranch.setName("Chi chinh");
        defaultBranch.setDescription("Tao tu dong khi he thong chua co chi nhanh");
        return branchRepository.save(defaultBranch);
    }

    private BranchEntity resolveBranchOrDefault(String branchValue, BranchEntity defaultBranch) {
        if (branchValue != null && !branchValue.trim().isEmpty()) {
            try {
                Long branchId = Long.parseLong(branchValue.trim());
                Optional<BranchEntity> exact = branchRepository.findById(branchId);
                if (exact.isPresent()) {
                    return exact.get();
                }
            } catch (NumberFormatException ignored) {
            }
        }
        return defaultBranch != null ? defaultBranch : resolveBranch(null);
    }
}
