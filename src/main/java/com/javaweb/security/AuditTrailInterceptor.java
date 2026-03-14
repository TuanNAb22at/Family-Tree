package com.javaweb.security;

import com.javaweb.service.IActivityLogService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Component
public class AuditTrailInterceptor implements HandlerInterceptor {

    @Autowired
    private IActivityLogService activityLogService;

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || authentication instanceof AnonymousAuthenticationToken) {
            return;
        }
        String username = authentication.getName();
        String method = StringUtils.upperCase(request.getMethod());
        String uri = StringUtils.defaultIfBlank(request.getRequestURI(), "/");
        int status = response.getStatus();

        if (isSensitiveAdminPageView(method, uri, status)) {
            activityLogService.logCustomAction(
                    username,
                    "ADMIN_PAGE_VIEW",
                    "Truy cập trang quản trị nhạy cảm " + uri + " (status=" + status + ")",
                    request
            );
            return;
        }

        if (isApiMutation(method, uri)) {
            String action = resolveMutationAction(uri, status);
            String summary = method + " " + uri + " (status=" + status + ")";
            activityLogService.logCustomAction(username, action, summary, request);
        }
    }

    private boolean isApiMutation(String method, String uri) {
        if (StringUtils.isBlank(uri)) {
            return false;
        }
        return ("/api/".equals(uri) || uri.startsWith("/api/"))
                && ("POST".equals(method) || "PUT".equals(method) || "PATCH".equals(method) || "DELETE".equals(method));
    }

    private boolean isSensitiveAdminPageView(String method, String uri, int status) {
        if (!"GET".equals(method) || status >= 400 || StringUtils.isBlank(uri)) {
            return false;
        }
        return uri.startsWith("/admin/security-audit")
                || uri.startsWith("/admin/user-list")
                || uri.startsWith("/admin/user-edit")
                || uri.startsWith("/admin/profile-");
    }

    private String resolveMutationAction(String uri, int status) {
        String baseAction;
        if (uri.startsWith("/api/person")) {
            baseAction = "FAMILY_TREE_CHANGE";
        } else if (uri.startsWith("/api/media")) {
            baseAction = "MEDIA_CHANGE";
        } else if (uri.startsWith("/api/branch")) {
            baseAction = "BRANCH_CHANGE";
        } else if (uri.startsWith("/api/user/change-password")) {
            baseAction = "USER_PASSWORD_CHANGE";
        } else if (uri.startsWith("/api/user/password/") && uri.endsWith("/reset")) {
            baseAction = "USER_PASSWORD_RESET";
        } else if (uri.startsWith("/api/user")) {
            baseAction = "USER_ACCOUNT_CHANGE";
        } else if (uri.startsWith("/api/livestream")) {
            baseAction = "LIVESTREAM_CONTROL";
        } else {
            baseAction = "API_MUTATION";
        }

        return status >= 400 ? baseAction + "_FAILED" : baseAction;
    }
}
