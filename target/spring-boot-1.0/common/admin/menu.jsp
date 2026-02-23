<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<div id="sidebar" class="sidebar responsive ace-save-state" style="">
    <script type="text/javascript">
        try {
            ace.settings.loadState('sidebar')
        } catch (e) {}
    </script>

    <!-- Sidebar Shortcuts -->
    <div class="sidebar-shortcuts">
        <div class="sidebar-shortcuts-large">
            <a href="/trang-chu">
                <button class="btn btn-success" style="text-align: center; width: 41px; line-height: 24px; padding: 0; border-width: 4px;" title="Trang chủ">
                    <i class="fa-solid fa-house" style="color: #fff;"></i>
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


    <!-- Quản lý tài khoản -->
    <security:authorize access="hasRole('MANAGER')">
        <ul class="nav nav-list">
            <li class="">
                <a href="#" class="dropdown-toggle" style="padding: 10px">
                    <i class="fa-solid fa-user" style="font-size: 18px"></i>
                    <span class="menu-text">Quản Lý Tài Khoản</span>
                </a>
                <b class="arrow"></b>

                <ul class="submenu">
                    <li class="">
                        <a href="/admin/user-list">
                            <i class="fa-solid fa-users"></i>
                            Danh sách tài khoản
                        </a>
                        <b class="arrow"></b>
                    </li>
                </ul>
            </li>
        </ul>
    </security:authorize>

        <ul class="nav nav-list">
            <li class="">
                <a href="#" class="dropdown-toggle" style="padding: 10px">
                    <i class="fa-solid fa-user" style="font-size: 18px"></i>
                    <span class="menu-text">Quản Lý Gia Phả</span>
                </a>
                <b class="arrow"></b>

                <ul class="submenu">
                    <li class="">
                        <a href="/admin/familytree">
                           <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-network flex-shrink-0 h-5 w-5 mr-3"><rect x="16" y="16" width="6" height="6" rx="1"></rect><rect x="2" y="16" width="6" height="6" rx="1"></rect><rect x="9" y="2" width="6" height="6" rx="1"></rect><path d="M5 16v-3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1v3"></path><path d="M12 12V8"></path></svg>
                            Cây gia phả
                        </a>
                        <b class="arrow"></b>
                    </li>
                </ul>
            </li>
        </ul>


    <!-- Sidebar Collapse -->
    <div class="sidebar-toggle sidebar-collapse">
        <i class="ace-icon fa fa-angle-double-left ace-save-state"
           data-icon1="ace-icon fa fa-angle-double-left"
           data-icon2="ace-icon fa fa-angle-double-right"></i>
    </div>
</div>
