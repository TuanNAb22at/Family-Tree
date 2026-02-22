package com.javaweb.service.impl;

import com.javaweb.converter.BranchConverter;
import com.javaweb.entity.BranchEntity;
import com.javaweb.model.dto.BranchDTO;
import com.javaweb.repository.BranchRepository;
import com.javaweb.service.IBranchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BranchService implements IBranchService {

    @Autowired
    private BranchRepository branchRepository;

    @Autowired
    private BranchConverter branchConverter;

    public BranchService(BranchRepository branchRepository) {
        this.branchRepository = branchRepository;
    }

    @Override
    public BranchDTO createBranch(BranchDTO branchDTO) {
        BranchEntity branchEntity = branchConverter.convertToEntity(branchDTO);
        return branchConverter.convertToDto(branchRepository.save(branchEntity));
    }
}
