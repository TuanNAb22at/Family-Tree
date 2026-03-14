package com.javaweb.converter;

import com.javaweb.entity.PersonEntity;
import com.javaweb.model.dto.PersonDTO;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class PersonConverter {
    @Autowired
    private ModelMapper modelMapper;

    public PersonDTO convertToDto(PersonEntity personEntity){
        PersonDTO personDTO = modelMapper.map(personEntity,PersonDTO.class);
        return personDTO;
    }

    public PersonEntity convertToEntity(PersonDTO dto){
        PersonEntity entity = modelMapper.map(dto, PersonEntity.class);

        entity.setDob(dto.getDob() == null ? null : java.sql.Date.valueOf(dto.getDob()));
        entity.setDod(dto.getDod() == null ? null : java.sql.Date.valueOf(dto.getDod()));


        return entity;
    }
}
