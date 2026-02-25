package com.javaweb.config;

import com.opensymphony.module.sitemesh.filter.PageFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SiteMeshConfig {

    @Bean
    public FilterRegistrationBean<PageFilter> siteMeshFilter() {
        FilterRegistrationBean<PageFilter> filter = new FilterRegistrationBean<>();
        filter.setFilter(new PageFilter());
        filter.addUrlPatterns("/*");
        return filter;
    }
}
