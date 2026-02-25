package com.javaweb.service;

import com.javaweb.model.dto.BranchDTO;
import java.util.List;

public interface IBranchService {
    BranchDTO createBranch(BranchDTO branchDTO);
    List<BranchDTO> findAllBranches();
}
