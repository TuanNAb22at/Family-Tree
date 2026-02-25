package com.javaweb.service;

import com.javaweb.model.dto.SecurityAuditDashboardDTO;

import javax.servlet.http.HttpServletRequest;

public interface IActivityLogService {
    void logLoginSuccess(String username, HttpServletRequest request);
    void logLoginFailed(String username, HttpServletRequest request);
    void logLogout(String username, HttpServletRequest request);
    SecurityAuditDashboardDTO getDashboardData();
}

