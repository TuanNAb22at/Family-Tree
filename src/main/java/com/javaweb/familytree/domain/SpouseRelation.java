package com.javaweb.familytree.domain;

public final class SpouseRelation {
    private final Long leftPersonId;
    private final Long rightPersonId;
    private final Integer relationOrder;
    private final String relationLabel;
    private final boolean inferred;

    public SpouseRelation(Long leftPersonId,
                          Long rightPersonId,
                          Integer relationOrder,
                          String relationLabel,
                          boolean inferred) {
        this.leftPersonId = leftPersonId;
        this.rightPersonId = rightPersonId;
        this.relationOrder = relationOrder;
        this.relationLabel = relationLabel;
        this.inferred = inferred;
    }

    public Long getLeftPersonId() {
        return leftPersonId;
    }

    public Long getRightPersonId() {
        return rightPersonId;
    }

    public Integer getRelationOrder() {
        return relationOrder;
    }

    public String getRelationLabel() {
        return relationLabel;
    }

    public boolean isInferred() {
        return inferred;
    }
}
