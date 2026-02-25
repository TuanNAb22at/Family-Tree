package com.javaweb.config;

import com.javaweb.security.CustomSuccessHandler;
import com.javaweb.security.CustomAuthenticationFailureHandler;
import com.javaweb.security.CustomLogoutSuccessHandler;
import com.javaweb.service.impl.CustomUserDetailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private CustomSuccessHandler customSuccessHandler;

    @Autowired
    private CustomAuthenticationFailureHandler customAuthenticationFailureHandler;

    @Autowired
    private CustomLogoutSuccessHandler customLogoutSuccessHandler;

    @Bean
    public UserDetailsService userDetailsService() {
        return new CustomUserDetailService();
    }
    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService());
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }
    @Override
    protected void configure(AuthenticationManagerBuilder auth) {
        auth.authenticationProvider(authenticationProvider());
    }
    @Override
    protected void configure(HttpSecurity http) throws Exception {
                http
                        .csrf()
                        .disable()
                        .authorizeRequests()

                        .antMatchers
                                (
                                         "/admin/user-edit/**", "/admin/user-list"
                                )
                        .hasRole("MANAGER")
                        .antMatchers(
                                "/admin/assets/**",
                                "/admin/js/**",
                                "/admin/css/**",
                                "/admin/font/**",
                                "/admin/font-awesome/**",
                                "/admin/paging/**",
                                "/admin/sweetalert/**"
                        ).permitAll()
                        .antMatchers("/admin/home").hasAnyRole("MANAGER","EDITOR","USER")
                        .antMatchers("/admin/familytree", "/admin/familytree/**").hasAnyRole("MANAGER","EDITOR","USER")
                        .antMatchers("/admin/profile-*", "/admin/profile-password").hasAnyRole("MANAGER","EDITOR","USER")
                        .antMatchers("/admin/security-audit").hasRole("MANAGER")
                        .antMatchers("/admin/**").hasAnyRole("MANAGER","EDITOR")
                        .antMatchers(HttpMethod.POST, "/api/person/**").hasAnyRole("MANAGER", "EDITOR")
                        .antMatchers(HttpMethod.PUT, "/api/person/**").hasAnyRole("MANAGER", "EDITOR")
                        .antMatchers(HttpMethod.DELETE, "/api/person/**").hasAnyRole("MANAGER", "EDITOR")
                        .antMatchers("/login", "/dang-ky", "/register", "/resource/**", "/trang-chu", "/api/**").permitAll()
                        .and()
                        .formLogin().loginPage("/login").usernameParameter("j_username").passwordParameter("j_password").permitAll()
                        .loginProcessingUrl("/j_spring_security_check")
                        .successHandler(customSuccessHandler)
                        .failureHandler(customAuthenticationFailureHandler).and()
                        .logout().logoutUrl("/logout").logoutSuccessHandler(customLogoutSuccessHandler).deleteCookies("JSESSIONID")
                        .and().exceptionHandling().accessDeniedPage("/access-denied").and()
                        .sessionManagement().maximumSessions(1).expiredUrl("/login?sessionTimeout");
    }
}
