<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<style>
    .nav.nav-list > li > a {
        padding: 10px 12px !important;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .nav.nav-list > li > a .menu-icon {
        width: 20px;
        min-width: 20px;
        text-align: center;
        font-size: 16px;
    }
</style>

<div id="sidebar" class="sidebar responsive ace-save-state" style="">
    <script type="text/javascript">
        try {
            ace.settings.loadState('sidebar')
        } catch (e) {}
    </script>

    <div class="sidebar-shortcuts">
        <div class="sidebar-shortcuts-large">
            <a href="/trang-chu">
                <button class="btn btn-success" style="text-align: center; width: 41px; line-height: 24px; padding: 0; border-width: 4px;" title="Trang chủ">
                    <i class="ace-icon fa fa-home" style="color: #fff;"></i>
                </button>
            </a>

            <button class="btn btn-info">
                <i class="ace-icon fa fa-pencil"></i>
            </button>

            <button class="btn btn-warning">
                <i class="ace-icon fa fa-users"></i>
            </button>

            <button class="btn btn-danger">
                <i class="ace-icon fa fa-cogs"></i>
            </button>
        </div>

        <div class="sidebar-shortcuts-mini">
            <span class="btn btn-success"></span>
            <span class="btn btn-info"></span>
            <span class="btn btn-warning"></span>
            <span class="btn btn-danger"></span>
        </div>
    </div>

    <ul class="nav nav-list">
        <security:authorize access="hasRole('MANAGER')">
            <li class="">
                <a href="/admin/user-list">
                    <i class="menu-icon ace-icon fa fa-user"></i>
                    <span class="menu-text">Quản lý tài khoản</span>
                </a>
                <b class="arrow"></b>
            </li>

            <li class="">
                <a href="/admin/security-audit">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-shield-alert flex-shrink-0 h-5 w-5 mr-3" data-fg-cxov13="2034.56:2035.116:/src/app/layouts/MainLayout.tsx:76:15:3100:87:e:item.icon"><path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"></path><path d="M12 8v4"></path><path d="M12 16h.01"></path></svg>
                    <span class="menu-text">Bảo mật &amp; Kiểm toán</span>
                </a>
                <b class="arrow"></b>
            </li>
        </security:authorize>

        <li class="">
            <a href="/admin/familytree">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-network flex-shrink-0 h-5 w-5 mr-3" data-fg-cxov13="2034.56:2035.116:/src/app/layouts/MainLayout.tsx:76:15:3100:87:e:item.icon"><rect x="16" y="16" width="6" height="6" rx="1"></rect><rect x="2" y="16" width="6" height="6" rx="1"></rect><rect x="9" y="2" width="6" height="6" rx="1"></rect><path d="M5 16v-3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1v3"></path><path d="M12 12V8"></path></svg>
                <span class="menu-text">Cây gia phả</span>
            </a>
            <b class="arrow"></b>
        </li>
        <li class="">
            <a href="/admin/livestream">
                <i class="menu-icon ace-icon fa fa-video-camera"></i>
                <span class="menu-text">Livestream</span>
            </a>
            <b class="arrow"></b>
        </li>
        <li class="">
            <a href="/admin/media">
                <i class="fa fa-photo"></i>
                <span class="menu-text">Media</span>
            </a>
            <b class="arrow"></b>
        </li>
    </ul>

    <div class="sidebar-toggle sidebar-collapse">
        <i class="ace-icon fa fa-angle-double-left ace-save-state"
           data-icon1="ace-icon fa fa-angle-double-left"
           data-icon2="ace-icon fa fa-angle-double-right"></i>
    </div>
</div>




