<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/common/taglib.jsp" %>
<html>
<head>
    <title>Danh sách khách hàng</title>
</head>
<body>

<div class="main-content">
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
                    <i class="ace-icon fa fa-home home-icon"></i>
                    <a href="#">Home</a>
                </li>
                <li class="active">Danh sách khách hàng</li>
            </ul><!-- /.breadcrumb -->
        </div>
        <div class="page-content">
            <div class="row">
                <div class="col-xs-12">
                    <div class="widget-box ui-sortable-handle">
                        <div class="widget-header">
                            <h5 class="widget-title fs-4 fw-bold">Tìm kiếm</h5>
                            <div class="widget-toolbar">
                                <a href="#" data-action="collapse">
                                    <i class="ace-icon fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>

                        <div class="widget-body" style="font-family: 'Times New Roman', Times, serif">
                            <div class="widget-main">
                                <form action="/admin/payment-list"
                                      method="GET"
                                      class="border rounded bg-white shadow-sm p-4 fs-5">
                                  <div class="form-group">
                                    <label for="customerName" class="bigger-120">
                                      Tên khách hàng
                                    </label>
                                    <input type="text"
                                           id="customerName"
                                           name="customerName"
                                           class="form-control input-lg"
                                           placeholder="Nhập tên khách hàng...">
                                  </div>
                                    <div class="text-center">
                                        <button type="submit"
                                                class="btn btn-primary btn-lg px-5 fw-semibold">
                                            🔍 Tìm khách hàng
                                        </button>
                                    </div>

                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- bảng danh sách -->
        <div class="widget-body" bis_skin_checked="1" style="display: block;">
            <div class="widget-main" bis_skin_checked="1">
                <table id="tableList" class="table table-striped table-bordered table-hover "
                       style="margin: 3em 0 1.5em; font-family:'Times New Roman', Times, serif ;">
                    <thead>
                    <tr class="bigger-120">
                        <th>Tên Khách hàng</th>
                        <th>Số điện thoại</th>
                        <th>Email</th>
                        <th>Thanh toán</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${customerList}">
                        <tr>
                            <td class="bigger-120">
                                    ${item.fullname}
                            </td>
                            <td class="bigger-120">
                                    ${item.phone}
                            </td>
                            <td class="bigger-120">
                                    ${item.email}
                            </td>
                            <td>
                                <a class="btn btn-xs btn-info"
                                   title="Danh sách phiếu đặt sân"
                                   href="/admin/retalreciept-list?id=${item.id}">
                                    <i class="fa fa-credit-card"></i>
                                </a>

                            </td>
                        </tr>

                    </c:forEach>
                    </tbody>
                </table>
            </div><!-- /.span -->
        </div>
    </div><!-- /.page-content -->
</div>
</div>


</body>
</html>
