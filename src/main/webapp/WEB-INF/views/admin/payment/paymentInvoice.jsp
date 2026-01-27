<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/common/taglib.jsp" %>
<html>
<head>
    <title>Hóa đơn thanh toán</title>
</head>
<body>

<div class="main-content">
    <div class="main-content-inner">

        <!-- Breadcrumb -->
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
                <li class="active">Hóa đơn thanh toán</li>
            </ul>
        </div>

        <!-- Page content -->
        <div class="page-content">
            <div class="row">
                <div class="col-xs-12">

                    <div class="widget-box">
                        <!-- Header -->
                        <div class="widget-header widget-header-large">
                            <h3 class="widget-title grey lighter">
                                <i class="ace-icon fa fa-credit-card"></i>
                                HÓA ĐƠN THANH TOÁN
                            </h3>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main padding-24">

                                <!-- Thông tin hóa đơn + khách hàng -->
                                <div class="row">

                                    <!-- Thông tin hóa đơn -->
                                    <div class="col-sm-6">
                                        <h4 class="blue">
                                            <i class="ace-icon fa fa-file-text-o"></i>
                                            Thông tin hóa đơn
                                        </h4>
                                        <p><strong>Mã hóa đơn:</strong> ${paymentInvoiceDTO.id}</p>
                                        <p><strong>Ngày thanh toán:</strong> ${paymentInvoiceDTO.paymentDate}</p>
                                    </div>

                                    <!-- Thông tin khách hàng -->
                                    <div class="col-sm-6">
                                        <h4 class="blue">
                                            <i class="ace-icon fa fa-user"></i>
                                            Thông tin khách hàng
                                        </h4>
                                        <p><strong>Họ tên:</strong> ${paymentInvoiceDTO.customer.fullname}</p>
                                        <p><strong>SĐT:</strong> ${paymentInvoiceDTO.customer.phone}</p>
                                        <p><strong>Email:</strong> ${paymentInvoiceDTO.customer.email}</p>
                                    </div>

                                </div>

                                <div class="space"></div>
                                <div class="hr hr8 hr-double hr-dotted"></div>

                                <!-- Danh sách phiếu thuê -->
                                <h4 class="header smaller lighter">
                                    <i class="ace-icon fa fa-list"></i>
                                    Danh sách phiếu thuê
                                </h4>

                                <table class="table table-striped table-bordered">
                                    <thead>
                                    <tr>
                                        <th style="width: 60px">#</th>
                                        <th>Mã phiếu thuê</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="rid" items="${paymentInvoiceDTO.receiptIds}" varStatus="st">
                                        <tr>
                                            <td>${st.index + 1}</td>
                                            <td>${rid}</td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>

                                <div class="hr hr8 hr-double hr-dotted"></div>

                                <!-- Tổng tiền -->
                                <div class="row">
                                    <div class="col-sm-12 text-right">
                                        <h3 class="red">
                                            Tổng tiền:
                                            <strong>
                                                ${paymentInvoiceDTO.totalPrice} VND
                                            </strong>
                                        </h3>
                                    </div>
                                </div>

                                <div class="space-12"></div>

                                <!-- Hành động -->
                                <div class="text-center">

                                    <form action="/admin/payment-confirm"
                                          method="post"
                                          style="display: inline-block;">

                                        <input type="hidden" name="customerId"
                                               value="${paymentInvoiceDTO.customer.id}"/>

                                        <c:forEach var="rid" items="${paymentInvoiceDTO.receiptIds}">
                                            <input type="hidden" name="receiptIds" value="${rid}"/>
                                        </c:forEach>

                                        <button type="submit" class="btn btn-success btn-lg">
                                            <i class="ace-icon fa fa-check"></i>
                                            Xác nhận thanh toán
                                        </button>
                                    </form>

                                    <a href="/admin/retalreciept-list"
                                       class="btn btn-default btn-lg"
                                       style="margin-left: 10px;">
                                        <i class="ace-icon fa fa-arrow-left"></i>
                                        Quay lại
                                    </a>

                                </div>

                            </div>

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
