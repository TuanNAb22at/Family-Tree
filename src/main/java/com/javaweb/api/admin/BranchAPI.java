package com.javaweb.api.admin;

import com.javaweb.model.dto.BranchDTO;
import com.javaweb.model.dto.UserDTO;
import com.javaweb.service.IBranchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/branch")
public class BranchAPI {
    @Autowired
    IBranchService iBranchService;
    @PostMapping
    public ResponseEntity<BranchDTO> createBranch(@RequestBody BranchDTO branchDTO) {
        return ResponseEntity.ok(iBranchService.createBranch(branchDTO));
    }
}
