package com.javaweb.familytree.domain;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class FamilyTreeNode {
    private final Long anchorPersonId;
    private final FamilyMember primaryMember;
    private final List<FamilyMember> spouseMembers = new ArrayList<>();
    private final List<Long> childAnchorIds = new ArrayList<>();

    public FamilyTreeNode(Long anchorPersonId, FamilyMember primaryMember, List<FamilyMember> spouseMembers) {
        this.anchorPersonId = anchorPersonId;
        this.primaryMember = primaryMember;
        if (spouseMembers != null) {
            this.spouseMembers.addAll(spouseMembers);
        }
    }

    public Long getAnchorPersonId() {
        return anchorPersonId;
    }

    public FamilyMember getPrimaryMember() {
        return primaryMember;
    }

    public List<FamilyMember> getSpouseMembers() {
        return Collections.unmodifiableList(spouseMembers);
    }

    public List<Long> getChildAnchorIds() {
        return Collections.unmodifiableList(childAnchorIds);
    }

    public void setChildAnchorIds(List<Long> childAnchorIds) {
        this.childAnchorIds.clear();
        if (childAnchorIds != null) {
            this.childAnchorIds.addAll(childAnchorIds);
        }
    }
}
