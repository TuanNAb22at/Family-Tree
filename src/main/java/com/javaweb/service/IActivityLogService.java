package com.javaweb.service;

import com.javaweb.model.dto.SecurityAuditDashboardDTO;

import javax.servlet.http.HttpServletRequest;

public interface IActivityLogService {
    void logLoginSuccess(String username, HttpServletRequest request);
    void logLoginFailed(String username, HttpServletRequest request);
    void logLogout(String username, HttpServletRequest request);
    void logCustomAction(String username, String action, String summary, HttpServletRequest request);
    void logAccessDenied(String username, HttpServletRequest request, String resource);
    SecurityAuditDashboardDTO getDashboardData();
}

