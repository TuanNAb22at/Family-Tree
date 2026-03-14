package com.javaweb.converter;

import com.javaweb.entity.BranchEntity;
import com.javaweb.model.dto.BranchDTO;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class BranchConverter {
    @Autowired
    private ModelMapper modelMapper;

    public BranchDTO convertToDto(BranchEntity branchEntity){
        BranchDTO branchDTO = modelMapper.map(branchEntity,BranchDTO.class);
        return branchDTO;
    }

    public BranchEntity convertToEntity(BranchDTO branchDTO){
        BranchEntity branchEntity = modelMapper.map(branchDTO,BranchEntity.class);
        return branchEntity;
    }

}
