<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<c:url var="homeUrl" value="/admin/home"/>
<c:url var="familyTreeUrl" value="/admin/familytree"/>
<c:url var="mediaUrl" value="/admin/media"/>
<c:url var="livestreamUrl" value="/admin/livestream"/>

<div class="main-content">
    <div class="main-content-inner">
        <div class="breadcrumbs" id="breadcrumbs">
            <ul class="breadcrumb">
                <li>
                    <i class="ace-icon fa-solid fa-house-chimney home-icon"></i>
                    <a href="${homeUrl}">Trang chủ</a>
                </li>
            </ul>
        </div>

        <div class="page-content dashboard-home">
            <div class="row">
                <div class="col-xs-12 col-sm-7">
                    <h2 class="home-title">Tổng quan hệ thống gia phả</h2>
                </div>
                <div class="col-xs-12 col-sm-5 text-right home-actions">
                    <a class="btn btn-success" href="${livestreamUrl}">
                        <i class="fa-solid fa-tower-broadcast"></i> Phát trực tiếp
                    </a>
                    <a class="btn btn-primary" href="${familyTreeUrl}">
                        <i class="fa-solid fa-diagram-project"></i> Cây gia phả
                    </a>
                    <a class="btn btn-info" href="${mediaUrl}">
                        <i class="fa-solid fa-photo-film"></i> Media
                    </a>
                </div>
            </div>

            <div class="row home-stats-row" style="margin-top:14px;">
                <div class="col-xs-12 col-sm-6 col-md-3">
                    <div class="widget-box home-stat-card">
                        <div class="widget-body"><div class="widget-main">
                            <span class="stat-icon"><i class="fa-solid fa-users"></i></span>
                            <h4>Tổng thành viên</h4>
                            <h2>${empty totalMembers ? 0 : totalMembers}</h2>
                            <p class="text-success"><strong>${empty membersGrowth ? '0%' : membersGrowth}</strong> so với tháng trước</p>
                        </div></div>
                    </div>
                </div>
                <div class="col-xs-12 col-sm-6 col-md-3">
                    <div class="widget-box home-stat-card">
                        <div class="widget-body"><div class="widget-main">
                            <span class="stat-icon"><i class="fa-solid fa-code-branch"></i></span>
                            <h4>Số nhánh gia đình</h4>
                            <h2>${empty totalBranches ? 0 : totalBranches}</h2>
                            <p class="text-success"><strong>${empty branchesGrowth ? '0%' : branchesGrowth}</strong> so với tháng trước</p>
                        </div></div>
                    </div>
                </div>
                <div class="col-xs-12 col-sm-6 col-md-3">
                    <div class="widget-box home-stat-card">
                        <div class="widget-body"><div class="widget-main">
                            <span class="stat-icon"><i class="fa-solid fa-photo-film"></i></span>
                            <h4>Tệp phương tiện</h4>
                            <h2>${empty totalMediaFiles ? 0 : totalMediaFiles}</h2>
                            <p class="text-success"><strong>${empty mediaGrowth ? '0%' : mediaGrowth}</strong> so với tháng trước</p>
                        </div></div>
                    </div>
                </div>
                <div class="col-xs-12 col-sm-6 col-md-3">
                    <div class="widget-box home-stat-card">
                        <div class="widget-body"><div class="widget-main">
                            <span class="stat-icon"><i class="fa-solid fa-chart-line"></i></span>
                            <h4>Người dùng hoạt động</h4>
                            <h2>${empty activeUsers ? 0 : activeUsers}</h2>
                            <p class="text-success"><strong>${empty activeUsersGrowth ? '0%' : activeUsersGrowth}</strong> so với tháng trước</p>
                        </div></div>
                    </div>
                </div>
            </div>

            <div class="row home-panels-row" style="margin-top:14px;">
                <div class="col-xs-12 col-lg-8">
                    <div class="widget-box home-panel">
                        <div class="widget-header">
                            <h4 class="widget-title">Thống kê tăng trưởng</h4>
                        </div>
                        <div class="widget-body">
                            <div class="widget-main no-padding">
                                <table class="table table-bordered table-striped">
                                    <thead>
                                    <tr>
                                        <th>Tháng</th>
                                        <th>Thành viên mới</th>
                                        <th>Tệp tải lên</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="stat" items="${monthlyStats}">
                                        <tr>
                                            <td><c:out value="${stat.monthLabel}"/></td>
                                            <td><c:out value="${stat.newMembers}"/></td>
                                            <td><c:out value="${stat.uploadedMedia}"/></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty monthlyStats}">
                                        <tr>
                                            <td colspan="3" class="text-center">Chưa có dữ liệu</td>
                                        </tr>
                                    </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-lg-4">
                    <div class="widget-box home-panel">
                        <div class="widget-header">
                            <h4 class="widget-title">Hoạt động gần đây</h4>
                        </div>
                        <div class="widget-body">
                            <div class="widget-main">
                                <ul class="list-unstyled spaced2 home-activity-list">
                                    <c:forEach var="activity" items="${recentActivities}">
                                        <li>
                                            <strong><c:out value="${activity.actor}"/></strong> - <c:out value="${activity.timeAgo}"/><br/>
                                            <c:out value="${activity.action}"/>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${empty recentActivities}">
                                        <li>Chưa có hoạt động gần đây</li>
                                    </c:if>
                                </ul>
                                <button class="btn btn-link no-padding-left">Xem toàn bộ hoạt động</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
