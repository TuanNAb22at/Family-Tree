package com.javaweb.familytree.domain;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class FamilyTreeNode {
    private final Long anchorPersonId;
    private final FamilyMember primaryMember;
    private final FamilyMember spouseMember;
    private final List<Long> childAnchorIds = new ArrayList<>();

    public FamilyTreeNode(Long anchorPersonId, FamilyMember primaryMember, FamilyMember spouseMember) {
        this.anchorPersonId = anchorPersonId;
        this.primaryMember = primaryMember;
        this.spouseMember = spouseMember;
    }

    public Long getAnchorPersonId() {
        return anchorPersonId;
    }

    public FamilyMember getPrimaryMember() {
        return primaryMember;
    }

    public FamilyMember getSpouseMember() {
        return spouseMember;
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
