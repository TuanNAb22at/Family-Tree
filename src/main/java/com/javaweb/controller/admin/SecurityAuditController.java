package com.javaweb.controller.admin;

import com.javaweb.model.dto.SecurityAuditDashboardDTO;
import com.javaweb.service.IActivityLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class SecurityAuditController {

    @Autowired
    private IActivityLogService activityLogService;

    @GetMapping("/admin/security-audit")
    public ModelAndView securityAuditPage() {
        ModelAndView mav = new ModelAndView("admin/security-audit/list");
        SecurityAuditDashboardDTO dashboard = activityLogService.getDashboardData();
        mav.addObject("dashboard", dashboard);
        return mav;
    }
}

