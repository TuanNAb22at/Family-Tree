package com.javaweb.service.impl;

import com.javaweb.converter.BranchConverter;
import com.javaweb.entity.BranchEntity;
import com.javaweb.model.dto.BranchDTO;
import com.javaweb.repository.BranchRepository;
import com.javaweb.service.IBranchService;
import com.javaweb.utils.FamilyTreeBranchUtils;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class BranchService implements IBranchService {

    private final BranchRepository branchRepository;

    private final BranchConverter branchConverter;

    public BranchService(BranchRepository branchRepository, BranchConverter branchConverter) {
        this.branchRepository = branchRepository;
        this.branchConverter = branchConverter;
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
                .sorted(Comparator
                        .comparing((BranchDTO branch) -> FamilyTreeBranchUtils.branchOrder(branch.getName()))
                        .thenComparing(branch -> {
                            String name = branch.getName();
                            return name == null ? "" : name.trim().toLowerCase();
                        })
                        .thenComparing(branch -> branch.getId() == null ? Long.MAX_VALUE : branch.getId()))
                .collect(Collectors.toList());
    }
}
