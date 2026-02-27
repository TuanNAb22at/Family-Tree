<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp" %>
<%@ page import="com.javaweb.security.utils.SecurityUtils" %>
<%@ page import="java.util.List" %>
<%
    String uri = request.getRequestURI();
    boolean homeActive = uri.contains("/admin/home");
    boolean familyActive = uri.contains("/admin/familytree");
    boolean mediaActive = uri.contains("/admin/media");
    boolean liveActive = uri.contains("/admin/livestream");
    boolean userActive = uri.contains("/admin/user");
    boolean auditActive = uri.contains("/admin/security-audit");
    String roleLabel = "Người dùng";
    try {
        List<String> authorities = SecurityUtils.getAuthorities();
        if (authorities != null) {
            if (authorities.contains("ROLE_MANAGER")) {
                roleLabel = "Quản trị viên";
            } else if (authorities.contains("ROLE_EDITOR")) {
                roleLabel = "Biên tập viên";
            } else if (authorities.contains("ROLE_USER")) {
                roleLabel = "Người dùng";
            }
        }
    } catch (Exception ignore) {
    }
%>

<aside class="app-sidebar">
    <div class="app-brand">
        <div class="brand-icon"><i class="fa fa-users"></i></div>
        <div class="brand-text">Gia ph&#7843; Online</div>
    </div>

    <nav class="app-nav">
        <a class="app-nav-item <%= homeActive ? "active" : "" %>" href="/admin/home">
            <i class="fa fa-dashboard"></i>
            <span>Trang chủ</span>
        </a>
        <a class="app-nav-item <%= familyActive ? "active" : "" %>" href="/admin/familytree">
            <i class="fa fa-sitemap"></i>
            <span>Cây gia phả</span>
        </a>
        <a class="app-nav-item <%= mediaActive ? "active" : "" %>" href="/admin/media">
            <i class="fa fa-picture-o"></i>
            <span>Thư viện Media</span>
        </a>
        <a class="app-nav-item <%= liveActive ? "active" : "" %>" href="/admin/livestream">
            <i class="fa fa-video-camera"></i>
            <span>Phát trực tiếp</span>
        </a>

        <security:authorize access="hasRole('MANAGER')">
            <a class="app-nav-item <%= userActive ? "active" : "" %>" href="/admin/user-list">
                <i class="fa fa-user"></i>
                <span>Quản lý người dùng</span>
                <span class="role-badge">QUẢN TRỊ</span>
            </a>
            <a class="app-nav-item <%= auditActive ? "active" : "" %>" href="/admin/security-audit">
                <i class="fa fa-shield"></i>
                <span>Bảo mật &amp; Kiểm toán</span>
                <span class="role-badge">QUẢN TRỊ</span>
            </a>
        </security:authorize>
    </nav>

    <div class="app-sidebar-bottom">
        <div class="dropdown dropup app-user-dropdown">
            <a data-toggle="dropdown" href="#" class="dropdown-toggle app-user-box">
                <div class="avatar"><i class="fa fa-user-circle"></i></div>
                <div class="meta">
                    <div class="name"><%=SecurityUtils.getPrincipal().getFullName()%></div>
                    <div class="role"><%=roleLabel%></div>
                </div>
            </a>
            <ul class="user-menu dropdown-menu-right dropdown-menu dropdown-yellow dropdown-caret dropdown-close">
                <li>
                    <a href="/admin/profile-<%=SecurityUtils.getPrincipal().getUsername()%>">
                        <i class="ace-icon fa fa-user"></i>
                        Thông tin tài khoản
                    </a>
                </li>
                <li>
                    <a href="<c:url value='/admin/profile-password'/>">
                        <i class="ace-icon fa fa-key"></i>
                        Đổi mật khẩu
                    </a>
                </li>
            </ul>
        </div>
        <a class="sign-out" href="<c:url value='/logout'/>">
            <i class="fa fa-sign-out"></i> Đăng xuất
        </a>
    </div>
</aside>

