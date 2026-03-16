package com.javaweb.familytree.domain;

public final class ParentChildRelation {
    private final Long parentId;
    private final Long childId;
    private final ParentRole parentRole;

    public ParentChildRelation(Long parentId, Long childId, ParentRole parentRole) {
        this.parentId = parentId;
        this.childId = childId;
        this.parentRole = parentRole;
    }

    public Long getParentId() {
        return parentId;
    }

    public Long getChildId() {
        return childId;
    }

    public ParentRole getParentRole() {
        return parentRole;
    }
}
