package com.javaweb.service;

import com.javaweb.model.dto.PersonDTO;

public interface IPersonService {
    void createPerson(PersonDTO personDTO);
    long countPersons();
    PersonDTO findRootPersonByBranchId(Long branchId);
    PersonDTO addSpouse(Long personId, PersonDTO spouseDTO);
    PersonDTO addChild(Long personId, PersonDTO childDTO);
    PersonDTO updatePerson(Long personId, PersonDTO personDTO);
    void deletePerson(Long personId);
}
