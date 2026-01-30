<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/common/taglib.jsp" %>
<html>
<head>
    <title>Hóa đơn thanh toán</title>
    <meta charset="UTF-8">
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700;800&display=swap">
    <style>
        :root {
            --ink: #1f2532;
            --muted: #6b7280;
            --accent: #2563eb;
            --accent-2: #1e40af;
            --card: #ffffff;
            --ring: rgba(37, 99, 235, 0.18);
        }

        .invoice-page {
            font-family: "Merriweather", "Times New Roman", serif;
        }

        .invoice-card {
            border: 1px solid rgba(37, 99, 235, 0.12);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 18px 36px rgba(31, 37, 50, 0.08);
        }

        .invoice-header {
            background: linear-gradient(135deg, var(--accent) 0%, var(--accent-2) 100%);
            color: #fff;
            border-bottom: none;
        }

        .invoice-title {
            font-weight: 800;
            letter-spacing: 0.3px;
        }

        .invoice-body {
            color: var(--ink);
            background: #f7f9fc;
        }

        .info-card {
            background: var(--card);
            border: 1px solid #e3e8f3;
            border-radius: 12px;
            padding: 16px 18px;
            min-height: 140px;
        }

        .info-card h4 {
            margin-top: 0;
            font-weight: 700;
        }

        .info-card p {
            margin: 6px 0;
            color: var(--muted);
        }

        .info-card strong {
            color: var(--ink);
        }

        .invoice-table {
            background: var(--card);
            border-radius: 12px;
            overflow: hidden;
        }

        .invoice-table thead th {
            background: #eef3ff;
            color: var(--ink);
            border-bottom: 1px solid #e2e8f0;
        }

        .total-box {
            background: #fff3f0;
            border: 1px solid #ffd6cc;
            border-radius: 12px;
            padding: 12px 18px;
            display: inline-block;
        }

        .btn-primary-glow {
            background: linear-gradient(135deg, var(--accent) 0%, var(--accent-2) 100%);
            border: none;
            color: #fff;
            box-shadow: 0 12px 20px rgba(37, 99, 235, 0.25);
        }

        .btn-primary-glow:hover {
            color: #fff;
        }

        .btn-outline-soft {
            background: #eef1f6;
            color: var(--muted);
            border: 1px solid #d7dee9;
        }
    </style>
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

                    <div class="widget-box invoice-card">
                        <!-- Header -->
                        <div class="widget-header widget-header-large invoice-header">
                            <h3 class="widget-title invoice-title">
                                <i class="ace-icon fa fa-credit-card"></i>
                                HÓA ĐƠN THANH TOÁN
                            </h3>
                        </div>

                        <div class="widget-body">
                            <div class="widget-main padding-24 invoice-body">

                                <!-- Thông tin hóa đơn + khách hàng -->
                                <div class="row">

                                    <!-- Thông tin hóa đơn -->
                                    <div class="col-sm-6">
                                        <div class="info-card">
                                            <h4>
                                                <i class="ace-icon fa fa-file-text-o"></i>
                                                Thông tin hóa đơn
                                            </h4>
                                            <p><strong>Mã hóa đơn:</strong> ${paymentInvoiceDTO.id}</p>
                                            <p><strong>Ngày thanh toán:</strong> ${paymentInvoiceDTO.paymentDate}</p>
                                        </div>
                                    </div>

                                    <!-- Thông tin khách hàng -->
                                    <div class="col-sm-6">
                                        <div class="info-card">
                                            <h4>
                                                <i class="ace-icon fa fa-user"></i>
                                                Thông tin khách hàng
                                            </h4>
                                            <p><strong>Họ tên:</strong> ${paymentInvoiceDTO.customer.fullname}</p>
                                            <p><strong>SĐT:</strong> ${paymentInvoiceDTO.customer.phone}</p>
                                            <p><strong>Email:</strong> ${paymentInvoiceDTO.customer.email}</p>
                                        </div>
                                    </div>

                                </div>

                                <div class="space"></div>
                                <div class="hr hr8 hr-double hr-dotted"></div>

                                <!-- Danh sách phiếu thuê -->
                                <h4 class="header smaller lighter">
                                    <i class="ace-icon fa fa-list"></i>
                                    Danh sách phiếu thuê
                                </h4>

                                <table class="table table-striped table-bordered invoice-table">
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
                                        <div class="total-box">
                                            <h3 class="red" style="margin: 0;">
                                                Tổng tiền:
                                                <strong>
                                                    ${paymentInvoiceDTO.totalPrice} VND
                                                </strong>
                                            </h3>
                                        </div>
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

                                        <button type="submit" class="btn btn-lg btn-primary-glow">
                                            <i class="ace-icon fa fa-check"></i>
                                            Xác nhận thanh toán
                                        </button>
                                    </form>

                                    <a href="/admin/retalreciept-list?id=${paymentInvoiceDTO.customer.id}"
                                       class="btn btn-default btn-lg btn-outline-soft"
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
