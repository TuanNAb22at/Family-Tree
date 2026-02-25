package com.javaweb.model.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
public class SecurityAuditDashboardDTO {
    private long totalEvents7Days;
    private long loginSuccess7Days;
    private long loginFailed7Days;
    private long logout7Days;
    private double successRate;
    private List<String> dayLabels = new ArrayList<>();
    private List<Long> failedLoginSeries = new ArrayList<>();
    private List<ActivityLogDTO> recentLogs = new ArrayList<>();
}

