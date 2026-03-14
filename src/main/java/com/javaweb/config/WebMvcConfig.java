package com.javaweb.config;

import com.javaweb.security.AuditTrailInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private AuditTrailInterceptor auditTrailInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(auditTrailInterceptor)
                .addPathPatterns("/admin/**", "/api/**")
                .excludePathPatterns(
                        "/admin/assets/**",
                        "/admin/js/**",
                        "/admin/css/**",
                        "/admin/font/**",
                        "/admin/font-awesome/**",
                        "/admin/paging/**",
                        "/admin/sweetalert/**"
                );
    }
}
