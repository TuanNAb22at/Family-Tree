package com.javaweb.model.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class ActivityLogDTO {
    private String userName;
    private String fullName;
    private String action;
    private String actionLabel;
    private String riskLevel;
    private String description;
    private Date timestamp;
}

