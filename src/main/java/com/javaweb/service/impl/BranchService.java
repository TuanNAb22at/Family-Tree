package com.javaweb.service.impl;

import com.javaweb.converter.BranchConverter;
import com.javaweb.entity.BranchEntity;
import com.javaweb.model.dto.BranchDTO;
import com.javaweb.repository.BranchRepository;
import com.javaweb.service.IBranchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

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

    @Override
    public List<BranchDTO> findAllBranches() {
        return branchRepository.findAll(Sort.by(Sort.Direction.ASC, "id"))
                .stream()
                .map(branchConverter::convertToDto)
                .collect(Collectors.toList());
    }
}
