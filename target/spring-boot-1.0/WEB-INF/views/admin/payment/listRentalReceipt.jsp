<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/common/taglib.jsp" %>
<html>
<head>
    <title>Danh sách phiếu đặt sân</title>
    <meta charset="UTF-8">
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
                <li class="active">Danh sách phiếu đặt chưa thanh toán</li>
            </ul><!-- /.breadcrumb -->
        </div>

        <!-- bảng danh sách -->
        <div class="widget-body" bis_skin_checked="1" style="display: block;">
            <div class="widget-main" bis_skin_checked="1">
                <table id="tableList" class="table table-striped table-bordered table-hover "
                       style="margin: 3em 0 1.5em; font-family:'Times New Roman', Times, serif ;">
                    <thead>
                    <tr class="bigger-120">
                        <th></th>
                        <th>Mã phiếu</th>
                        <th>Giá thuê 1 phiên</th>
                        <th>Ngày bắt đầu</th>
                        <th>Ngày kết thúc</th>
                        <th>Tổng số tiền</th>
                        <th>Số tiền đặt cọc</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${rentalReciptList}">
                        <tr>
                            <td class="text-center">
                                <input type="checkbox"
                                       name="rentalReceiptIds"
                                       value="${item.id}"
                                       class="receipt-checkbox"/>
                            </td>
                            <td class="bigger-120">
                                    ${item.id}
                            </td>
                            <td class="bigger-120">
                                    ${item.sessionRentalPrice}
                            </td>
                            <td class="bigger-120">
                                    ${item.startDate}
                            </td>
                            <td class="bigger-120">
                                    ${item.endDate}
                            </td>
                            <td class="bigger-120">
                                    ${item.totalPrice}
                            </td>
                            <td class="bigger-120">
                                    ${item.deposit}
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div><!-- /.span -->
        </div>
        <div class="text-center">
            <a href="#" class="btn btn-success" onclick="submitInvoice()">
                <i class="fa fa-credit-card"></i> Tạo hóa đơn
            </a>
        </div>
    </div><!-- /.page-content -->
</div>
</div>


<script>
    function submitInvoice() {
        const checked = document.querySelectorAll('.receipt-checkbox:checked');
        if (checked.length === 0) {
            alert("Vui lòng chọn ít nhất 1 phiếu!");
            return;
        }

        let params = [];
        checked.forEach(cb => {
            params.push("rentalReceiptIds=" + cb.value);
        });

        window.location.href = "/admin/create-invoice?" + params.join("&");
    }
</script>

</body>
</html>
