<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/common/taglib.jsp" %>
<c:url var="formUrl" value="/admin/user-list"/>
<c:url var="formAjax" value="/api/user"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý người dùng</title>
</head>
<body>
<div class="main-content">
    <form:form modelAttribute="model" action="${formUrl}" id="listForm" method="GET">
        <div class="main-content-inner">
            <div class="breadcrumbs" id="breadcrumbs">
                <script type="text/javascript">
                    try {
                        ace.settings.check('breadcrumbs', 'fixed')
                    } catch (e) {
                    }
                </script>

                <ul class="breadcrumb">
                    <li>
                        <i class="ace-icon fa-solid fa-house-chimney home-icon"></i>
                        <a href="<c:url value='/admin/home'/>">Trang chủ</a>
                    </li>
                    <li class="active">Quản lý tài khoản</li>
                </ul>
            </div>

            <div class="page-content user-mgmt-page user-list-page">
                <div class="row">
                    <div class="col-xs-12 col-sm-7">
                        <h2 class="user-list-title">Quản lý người dùng</h2>
                        <p class="user-list-subtitle">Quản lý truy cập, vai trò và trạng thái tài khoản.</p>
                    </div>
                    <div class="col-xs-12 col-sm-5 text-right user-list-actions">
                        <a href="<c:url value='/admin/user-edit'/>" class="btn btn-success">
                            <i class="fa fa-user-plus"></i> Mời người dùng
                        </a>
                    </div>
                </div>

                <div class="widget-box user-filter-card">
                    <div class="widget-body">
                        <div class="widget-main">
                            <div class="row">
                                <div class="col-xs-12 col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-search"></i></span>
                                        <form:input path="searchValue" cssClass="form-control" placeholder="Tìm theo tên, email hoặc vai trò..."/>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-md-4">
                                    <div class="row">
                                        <div class="col-xs-6">
                                            <select class="form-control" name="roleFilter">
                                                <option value="">Tất cả vai trò</option>
                                                <option value="MANAGER">Admin</option>
                                                <option value="STAFF">Thành viên</option>
                                            </select>
                                        </div>
                                        <div class="col-xs-6">
                                            <select class="form-control" name="statusFilter">
                                                <option value="">Tất cả trạng thái</option>
                                                <option value="ACTIVE">Đang hoạt động</option>
                                                <option value="INACTIVE">Không hoạt động</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xs-12 col-md-2 text-right">
                                    <button id="btnSearch" type="button" class="btn btn-success btn-block">
                                        Tìm kiếm
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-xs-12">
                        <c:if test="${messageResponse!=null}">
                            <div class="alert alert-block alert-${alert}">
                                <button type="button" class="close" data-dismiss="alert">
                                    <i class="ace-icon fa fa-times"></i>
                                </button>
                                    ${messageResponse}
                            </div>
                        </c:if>

                        <div class="table-btn-controls user-table-actions">
                            <div class="dt-buttons btn-overlap btn-group">
                                <button id="btnDelete" type="button" disabled
                                        class="dt-button buttons-html5 btn btn-white btn-primary btn-bold"
                                        data-toggle="tooltip"
                                        title="Xóa tài khoản đã chọn" onclick="warningBeforeDelete()">
                                    <span><i class="fa fa-trash-o bigger-110 pink"></i></span>
                                </button>
                            </div>
                        </div>

                        <div class="widget-box user-table-card">
                            <div class="widget-body">
                                <div class="widget-main no-padding">
                                    <div class="table-responsive">
                                        <display:table name="model.listResult" cellspacing="0" cellpadding="0"
                                                       requestURI="${formUrl}" partialList="true" sort="external"
                                                       size="${model.totalItems}" defaultsort="2" defaultorder="ascending"
                                                       id="tableList" pagesize="${model.maxPageItems}"
                                                       export="false"
                                                       class="table table-fcv-ace table-striped table-bordered table-hover dataTable no-footer user-table"
                                                       style="margin: 0;">
                                            <display:column title="<fieldset class='form-group'>
                                                            <input type='checkbox' id='checkAll' class='check-box-element'>
                                                            </fieldset>"
                                                            class="center select-cell"
                                                            headerClass="center select-cell">
                                                <fieldset>
                                                    <input type="checkbox" name="checkList" value="${tableList.id}"
                                                           id="checkbox_${tableList.id}" class="check-box-element"/>
                                                </fieldset>
                                            </display:column>
                                            <display:column headerClass="text-left" property="userName" title="Tên đăng nhập"/>
                                            <display:column headerClass="text-left" property="fullName" title="Họ và tên"/>
                                            <display:column headerClass="col-actions" title="Thao tác">
                                                <c:if test="${tableList.roleCode != 'MANAGER'}">
                                                    <a class="btn btn-sm btn-primary btn-edit" data-toggle="tooltip"
                                                       title="Cập nhật người dùng"
                                                       href='<c:url value="/admin/user-edit-${tableList.id}"/>'>
                                                        <i class="fa fa-pencil-square-o" aria-hidden="true"></i>
                                                    </a>
                                                </c:if>
                                                <c:if test="${tableList.roleCode == 'MANAGER'}">
                                                    <span class="text-muted">Không thao tác</span>
                                                </c:if>
                                            </display:column>
                                        </display:table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form:form>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        $('#btnSearch').click(function () {
            $('#listForm').submit();
        });
    });

    function warningBeforeDelete() {
        showAlertBeforeDelete(function () {
            event.preventDefault();
            var dataArray = $('tbody input[type=checkbox]:checked').map(function () {
                return $(this).val();
            }).get();
            deleteUser(dataArray);
        });
    }

    function deleteUser(data) {
        $.ajax({
            url: '${formAjax}/',
            type: 'DELETE',
            dataType: 'json',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function (res) {
                window.location.href = "<c:url value='/admin/user-list?message=delete_success'/>";
            },
            error: function (res) {
                console.log(res);
                window.location.href = "<c:url value='/admin/user-list?message=error_system'/>";
            }
        });
    }
</script>
</body>
</html>
