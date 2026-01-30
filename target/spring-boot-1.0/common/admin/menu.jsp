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

    <!-- Quản lý sân bóng -->
    <ul class="nav nav-list">
        <li class="">
            <a href="#" class="dropdown-toggle" style="padding: 10px">
                <i class="fa fa-futbol"></i>
                <span class="menu-text">Quản Lý Sân Bóng</span>
            </a>
            <b class="arrow"></b>

            <ul class="submenu">
                <li class="">
                    <a href="/admin/pitchs-list">
                        <i class="fa-solid fa-calendar-check"></i>
                        Đặt Sân
                    </a>
                    <b class="arrow"></b>
                </li>
            </ul>

            <ul class="submenu">
                <li class="">
                    <a href="/admin/payment-list">
                        <i class="fa-solid fa-money-bill-wave"></i>
                        Thanh toán
                    </a>
                    <b class="arrow"></b>
                </li>
            </ul>

            <security:authorize access="hasRole('MANAGER')">
                <ul class="submenu">
                    <li class="">
                        <a href="/admin/user-list">
                            <i class="fa-solid fa-chart-column"></i>
                            Xem báo cáo thống kê
                        </a>
                        <b class="arrow"></b>
                    </li>
                </ul>
            </security:authorize>
        </li>
    </ul>

    <!-- Quản lý mặt hàng -->
    <ul class="nav nav-list">
        <li class="">
            <a href="#" class="dropdown-toggle" style="padding: 10px">
            <i class="fa-solid fa-tags" style="font-size: 20px"></i>
                <span class="menu-text">Quản Lý Mặt Hàng</span>
            </a>
            <b class="arrow"></b>

            <ul class="submenu">
                <li class="">
                    <a href="">
                        <i class="fa-solid fa-pen-to-square"></i>
                        Danh sách mặt hàng
                    </a>
                    <b class="arrow"></b>
                </li>

                <li class="">
                    <a href="">
                        <i class="fa-solid fa-box-open"></i>
                        Nhập hàng
                    </a>
                    <b class="arrow"></b>
                </li>
            </ul>
        </li>
    </ul>

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

    <!-- Quản lý khách hàng -->
    <ul class="nav nav-list">
        <li class="">
            <a href="#" class="dropdown-toggle" style="padding: 10px">
                <i class="fa-solid fa-person" style="font-size: 20px"></i>
                <span class="menu-text">Quản Lý Khách Hàng</span>
            </a>
            <b class="arrow"></b>

            <ul class="submenu">
                <li class="">
                    <a href="/admin/customer-list">
                        <i class="fa-solid fa-people-group"></i>
                        Danh sách khách hàng
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
