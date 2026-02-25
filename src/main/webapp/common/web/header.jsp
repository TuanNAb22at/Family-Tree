<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.javaweb.security.utils.SecurityUtils" %>
<%@include file="/common/taglib.jsp" %>

<header class="gpo-header fixed-top">
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <%-- Logo --%>
            <a class="navbar-brand d-flex align-items-center" href="/trang-chu">
                <svg class="gpo-logo-icon" width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                </svg>
                <span class="gpo-logo-text ms-2">Gia Phả Online</span>
            </a>

            <%-- Nút toggle cho mobile --%>
            <button class="navbar-toggler" type="button"
                    data-bs-toggle="collapse" data-bs-target="#webNavbar">
                <span class="navbar-toggler-icon"></span>
            </button>

            <%-- Menu chính --%>
            <div class="collapse navbar-collapse" id="webNavbar">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#features">Tính năng</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#about">Giới thiệu</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#contact">Liên hệ</a>
                    </li>
                </ul>

                <%-- Nút đăng nhập / thông tin user --%>
                <div class="d-flex align-items-center gap-3">
                    <security:authorize access="isAnonymous()">
                        <a href="<c:url value='/login'/>" class="btn btn-outline-gpo btn-sm">Đăng nhập</a>
                        <a href="/dang-ky" class="btn btn-gpo btn-sm">Đăng ký</a>
                    </security:authorize>

                    <security:authorize access="isAuthenticated()">
                        <a href="/admin/home" class="btn btn-outline-gpo btn-sm">
                            <i class="fa-solid fa-user me-1"></i>
                            <%=SecurityUtils.getPrincipal().getUsername()%>
                        </a>
                        <a href="<c:url value='/logout'/>" class="btn btn-gpo btn-sm">
                            <i class="fa-solid fa-right-from-bracket me-1"></i> Đăng xuất
                        </a>
                    </security:authorize>
                </div>
            </div>
        </div>
    </nav>
</header>