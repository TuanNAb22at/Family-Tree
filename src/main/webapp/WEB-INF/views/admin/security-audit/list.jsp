<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/common/taglib.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Bảo mật &amp; Kiểm toán</title>
</head>
<body>

<div class="main-content">
    <div class="main-content-inner">
        <div class="breadcrumbs" id="breadcrumbs">
            <ul class="breadcrumb">
                <li>
                    <i class="ace-icon fa-solid fa-house-chimney home-icon"></i>
                    <a href="<c:url value='/admin/home'/>">Trang chủ</a>
                </li>
                <li class="active">Bảo mật &amp; Kiểm toán</li>
            </ul>
        </div>

        <div class="page-content security-audit-page">
            <div class="row">
                <div class="col-xs-12">
                    <h3 class="audit-title">Bảo mật &amp; Kiểm toán</h3>
                    <p class="audit-subtitle">Tổng quan hoạt động trong 7 ngày gần nhất</p>
                </div>
            </div>

            <div class="row audit-stats-row">
                <div class="col-sm-3">
                    <div class="widget-box audit-stat-card">
                        <div class="widget-body">
                            <div class="widget-main">
                                <span class="audit-stat-icon"><i class="fa fa-list-alt"></i></span>
                                <div class="bigger-150"><strong>${dashboard.totalEvents7Days}</strong></div>
                                <div>Tổng sự kiện</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="widget-box audit-stat-card">
                        <div class="widget-body">
                            <div class="widget-main">
                                <span class="audit-stat-icon"><i class="fa fa-check-circle"></i></span>
                                <div class="bigger-150 text-success"><strong>${dashboard.loginSuccess7Days}</strong></div>
                                <div>Đăng nhập thành công</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="widget-box audit-stat-card">
                        <div class="widget-body">
                            <div class="widget-main">
                                <span class="audit-stat-icon"><i class="fa fa-times-circle"></i></span>
                                <div class="bigger-150 text-danger"><strong>${dashboard.loginFailed7Days}</strong></div>
                                <div>Đăng nhập thất bại</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="widget-box audit-stat-card">
                        <div class="widget-body">
                            <div class="widget-main">
                                <span class="audit-stat-icon"><i class="fa fa-pie-chart"></i></span>
                                <div class="bigger-150"><strong>${dashboard.successRate}%</strong></div>
                                <div>Tỷ lệ thành công</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-xs-12">
                    <div class="widget-box audit-log-panel">
                        <div class="widget-header">
                            <h4 class="widget-title">Nhật ký gần đây</h4>
                        </div>
                        <div class="widget-body">
                            <div class="widget-main no-padding">
                                <table class="table table-striped table-bordered table-hover audit-log-table">
                                    <thead>
                                    <tr>
                                        <th>Thời gian</th>
                                        <th>Tài khoản</th>
                                        <th>Họ tên</th>
                                        <th>Hành động</th>
                                        <th>Mô tả</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="log" items="${dashboard.recentLogs}">
                                        <tr>
                                            <td><c:out value="${log.timestamp}"/></td>
                                            <td><c:out value="${log.userName}"/></td>
                                            <td><c:out value="${log.fullName}"/></td>
                                            <td><c:out value="${log.action}"/></td>
                                            <td><c:out value="${log.description}"/></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty dashboard.recentLogs}">
                                        <tr>
                                            <td colspan="5" class="text-center">Chưa có dữ liệu log</td>
                                        </tr>
                                    </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
