package com.javaweb.familytree.domain;

public final class SpouseRelation {
    private final Long leftPersonId;
    private final Long rightPersonId;
    private final boolean inferred;

    public SpouseRelation(Long leftPersonId, Long rightPersonId, boolean inferred) {
        this.leftPersonId = leftPersonId;
        this.rightPersonId = rightPersonId;
        this.inferred = inferred;
    }

    public Long getLeftPersonId() {
        return leftPersonId;
    }

    public Long getRightPersonId() {
        return rightPersonId;
    }

    public boolean isInferred() {
        return inferred;
    }
}
