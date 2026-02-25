package com.javaweb.service.impl;

import com.javaweb.entity.ActivityLogEntity;
import com.javaweb.entity.UserEntity;
import com.javaweb.model.dto.ActivityLogDTO;
import com.javaweb.model.dto.SecurityAuditDashboardDTO;
import com.javaweb.repository.ActivityLogRepository;
import com.javaweb.repository.UserRepository;
import com.javaweb.service.IActivityLogService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityLogService implements IActivityLogService {

    private static final String LOGIN_SUCCESS = "LOGIN_SUCCESS";
    private static final String LOGIN_FAILED = "LOGIN_FAILED";
    private static final String LOGOUT = "LOGOUT";

    @Autowired
    private ActivityLogRepository activityLogRepository;

    @Autowired
    private UserRepository userRepository;

    @Override
    @Transactional
    public void logLoginSuccess(String username, HttpServletRequest request) {
        saveLog(username, LOGIN_SUCCESS, buildDescription("Dang nhap thanh cong", request));
    }

    @Override
    @Transactional
    public void logLoginFailed(String username, HttpServletRequest request) {
        saveLog(username, LOGIN_FAILED, buildDescription("Dang nhap that bai", request));
    }

    @Override
    @Transactional
    public void logLogout(String username, HttpServletRequest request) {
        saveLog(username, LOGOUT, buildDescription("Dang xuat", request));
    }

    @Override
    public SecurityAuditDashboardDTO getDashboardData() {
        SecurityAuditDashboardDTO dto = new SecurityAuditDashboardDTO();

        Date now = new Date();
        Date sevenDaysAgo = atStartOfDay(addDays(now, -6));

        long total = activityLogRepository.countByTimestampAfter(sevenDaysAgo);
        long loginSuccess = activityLogRepository.countByActionAndTimestampAfter(LOGIN_SUCCESS, sevenDaysAgo);
        long loginFailed = activityLogRepository.countByActionAndTimestampAfter(LOGIN_FAILED, sevenDaysAgo);
        long logout = activityLogRepository.countByActionAndTimestampAfter(LOGOUT, sevenDaysAgo);

        dto.setTotalEvents7Days(total);
        dto.setLoginSuccess7Days(loginSuccess);
        dto.setLoginFailed7Days(loginFailed);
        dto.setLogout7Days(logout);
        dto.setSuccessRate((loginSuccess + loginFailed) == 0 ? 0D
                : (loginSuccess * 100D / (loginSuccess + loginFailed)));

        buildFailedLoginSeries(dto, sevenDaysAgo, now);
        buildRecentLogs(dto);

        return dto;
    }

    private void buildRecentLogs(SecurityAuditDashboardDTO dto) {
        List<ActivityLogEntity> entities = activityLogRepository.findTop100ByOrderByTimestampDesc();
        List<ActivityLogDTO> logs = new ArrayList<>();
        for (ActivityLogEntity entity : entities) {
            ActivityLogDTO item = new ActivityLogDTO();
            if (entity.getUser() != null) {
                item.setUserName(entity.getUser().getUserName());
                item.setFullName(entity.getUser().getFullName());
            }
            item.setAction(entity.getAction());
            item.setDescription(entity.getDescription());
            item.setTimestamp(entity.getTimestamp());
            logs.add(item);
        }
        dto.setRecentLogs(logs);
    }

    private void buildFailedLoginSeries(SecurityAuditDashboardDTO dto, Date from, Date to) {
        List<ActivityLogEntity> logs = activityLogRepository.findByTimestampBetweenOrderByTimestampAsc(from, to);

        Map<String, Long> failedByDay = new LinkedHashMap<>();
        SimpleDateFormat keyFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat labelFormat = new SimpleDateFormat("dd/MM");

        Calendar cursor = Calendar.getInstance();
        cursor.setTime(from);
        for (int i = 0; i < 7; i++) {
            Date current = cursor.getTime();
            String key = keyFormat.format(current);
            failedByDay.put(key, 0L);
            dto.getDayLabels().add(labelFormat.format(current));
            cursor.add(Calendar.DATE, 1);
        }

        for (ActivityLogEntity log : logs) {
            if (!LOGIN_FAILED.equals(log.getAction()) || log.getTimestamp() == null) {
                continue;
            }
            String key = keyFormat.format(log.getTimestamp());
            if (failedByDay.containsKey(key)) {
                failedByDay.put(key, failedByDay.get(key) + 1);
            }
        }
        dto.setFailedLoginSeries(new ArrayList<>(failedByDay.values()));
    }

    private void saveLog(String username, String action, String description) {
        if (StringUtils.isBlank(username)) {
            return;
        }
        UserEntity user = userRepository.findOneByUserName(username.trim());
        if (user == null) {
            return;
        }
        ActivityLogEntity log = new ActivityLogEntity();
        log.setUser(user);
        log.setAction(action);
        log.setDescription(description);
        log.setTimestamp(new Date());
        activityLogRepository.save(log);
    }

    private String buildDescription(String prefix, HttpServletRequest request) {
        String ip = getClientIp(request);
        String agent = request != null ? request.getHeader("User-Agent") : null;
        String shortAgent = StringUtils.abbreviate(StringUtils.defaultString(agent), 120);
        return prefix + " | IP: " + ip + " | Agent: " + shortAgent;
    }

    private String getClientIp(HttpServletRequest request) {
        if (request == null) {
            return "unknown";
        }
        String forwarded = request.getHeader("X-Forwarded-For");
        if (StringUtils.isNotBlank(forwarded)) {
            return forwarded.split(",")[0].trim();
        }
        String realIp = request.getHeader("X-Real-IP");
        if (StringUtils.isNotBlank(realIp)) {
            return realIp.trim();
        }
        return StringUtils.defaultIfBlank(request.getRemoteAddr(), "unknown");
    }

    private Date addDays(Date source, int days) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(source);
        calendar.add(Calendar.DATE, days);
        return calendar.getTime();
    }

    private Date atStartOfDay(Date source) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(source);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        return calendar.getTime();
    }
}


