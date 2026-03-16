package com.javaweb.familytree.dto;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class FamilyTreeAuditReport {
    private final Long branchId;
    private final int totalMembers;
    private final int scopedMembers;
    private final int rootNodes;
    private final int parentChildRelations;
    private final int spouseRelations;
    private final int errorCount;
    private final int warningCount;
    private final int infoCount;
    private final List<FamilyTreeAuditIssue> issues;

    public FamilyTreeAuditReport(Long branchId,
                                 int totalMembers,
                                 int scopedMembers,
                                 int rootNodes,
                                 int parentChildRelations,
                                 int spouseRelations,
                                 int errorCount,
                                 int warningCount,
                                 int infoCount,
                                 List<FamilyTreeAuditIssue> issues) {
        this.branchId = branchId;
        this.totalMembers = totalMembers;
        this.scopedMembers = scopedMembers;
        this.rootNodes = rootNodes;
        this.parentChildRelations = parentChildRelations;
        this.spouseRelations = spouseRelations;
        this.errorCount = errorCount;
        this.warningCount = warningCount;
        this.infoCount = infoCount;
        this.issues = issues == null ? new ArrayList<>() : new ArrayList<>(issues);
    }

    public Long getBranchId() {
        return branchId;
    }

    public int getTotalMembers() {
        return totalMembers;
    }

    public int getScopedMembers() {
        return scopedMembers;
    }

    public int getRootNodes() {
        return rootNodes;
    }

    public int getParentChildRelations() {
        return parentChildRelations;
    }

    public int getSpouseRelations() {
        return spouseRelations;
    }

    public int getErrorCount() {
        return errorCount;
    }

    public int getWarningCount() {
        return warningCount;
    }

    public int getInfoCount() {
        return infoCount;
    }

    public List<FamilyTreeAuditIssue> getIssues() {
        return Collections.unmodifiableList(issues);
    }
}
