package com.javaweb.familytree.dto;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class FamilyTreeAuditIssue {
    private final String severity;
    private final String code;
    private final String message;
    private final List<Long> memberIds;

    public FamilyTreeAuditIssue(String severity, String code, String message, List<Long> memberIds) {
        this.severity = severity;
        this.code = code;
        this.message = message;
        this.memberIds = memberIds == null ? new ArrayList<>() : new ArrayList<>(memberIds);
    }

    public String getSeverity() {
        return severity;
    }

    public String getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }

    public List<Long> getMemberIds() {
        return Collections.unmodifiableList(memberIds);
    }
}
