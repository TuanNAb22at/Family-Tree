<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/common/taglib.jsp" %>
<html>
<head>
    <title>Danh sách sân bóng</title>
    <style>
        .booking-receipt-modal .modal-content {
            border-radius: 16px;
            border: 1px solid rgba(31, 143, 91, 0.18);
            background: linear-gradient(180deg, #ffffff 0%, #f7faf8 100%);
            font-family: "Times New Roman", Times, serif;
            font-size: 16px;
            line-height: 1.6;
            box-shadow: 0 18px 36px rgba(31, 37, 50, 0.12);
        }

        .booking-receipt-modal .modal-header {
            background: linear-gradient(135deg, #1f8f5b 0%, #0e6a41 100%);
            color: #fff;
            padding: 16px 22px;
            border-bottom: none;
            position: relative;
        }

        .booking-receipt-modal .modal-title {
            font-weight: 700;
            letter-spacing: 0.4px;
            font-size: 18px;
        }

        .booking-receipt-modal .modal-header .close {
            position: absolute;
            top: 8px;
            right: 12px;
            font-size: 28px;
            line-height: 1;
            opacity: 1;
            color: #fff;
        }

        .booking-receipt-modal .section-title {
            font-weight: 700;
            color: #0e6a41;
            font-size: 17px;
            letter-spacing: 0.3px;
        }

        .booking-receipt-modal .info-card {
            background: #fff;
            border: 1px solid #e4e9f2;
            border-radius: 12px;
            padding: 12px 14px;
        }

        .booking-receipt-modal .info-table td {
            padding: 6px 8px;
        }

        .booking-receipt-modal .divider {
            border-top: 1px dashed #d8e0ea;
            margin: 12px 0;
        }

        .booking-receipt-modal .cost-table thead th {
            background: #f1f6f3;
        }

        .booking-receipt-modal .total-amount {
            font-size: 20px;
            font-weight: 700;
        }

        .booking-receipt-modal .modal-footer {
            background: #f7faf8;
            border-top: 1px solid #e7edf2;
        }

        .booking-receipt-modal .btn-confirm {
            background: linear-gradient(135deg, #1f8f5b 0%, #0e6a41 100%);
            border: none;
            color: #fff;
            border-radius: 999px;
            padding: 8px 20px;
            font-weight: 700;
        }

        .booking-receipt-modal .btn-cancel {
            border-radius: 999px;
            padding: 8px 18px;
            font-weight: 700;
        }
    </style>
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
                <li class="active">Danh sách sân bóng</li>
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
                                <form action="/admin/pitchs-list"
                                      method="GET"
                                      class="border rounded bg-white shadow-sm p-4 fs-5">

                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <label class="bigger-120">
                                                <i class="fa fa-calendar bigger-120"></i> Ngày bắt đầu
                                            </label>
                                            <input type="date"
                                                   id="searchStartDate"
                                                   name="startDate"
                                                   class="form-control form-control-lg"
                                                   required
                                                   value="${param.startDate}"
                                                   onchange="validateDate()">
                                        </div>

                                        <div class="col-md-6">
                                            <label class="bigger-120">
                                                <i class="fa fa-calendar-check-o text-danger bigger-120"></i>
                                                Ngày kết thúc
                                            </label>
                                            <input type="date"
                                                   id="searchEndDate"
                                                   name="endDate"
                                                   class="form-control form-control-lg"
                                                   required
                                                   value="${param.endDate}"
                                                   onchange="validateDate()">
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="form-group" style="margin-top: 12px;">
                                                <label class="bigger-120" for="pitchTypeId"
                                                       style="display: inline-block; margin-right: 8px;">
                                                    Loại sân
                                                </label>
                                                <select id="pitchTypeId"
                                                        name="pitchTypeId"
                                                        class="form-control input-lg"
                                                        style="display: inline-block; width: auto; vertical-align: middle;">
                                                    <option value="">-- Chọn loại sân --</option>
                                                    <c:forEach var="type" items="${pitchTypes}">
                                                        <option value="${type}"
                                                                <c:if test="${type eq param.pitchTypeId}">selected</c:if>>
                                                                ${type}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="text-center">
                                        <button type="submit"
                                                class="btn btn-primary btn-lg px-5 fw-semibold">
                                            🔍 Tìm sân trống
                                        </button>
                                    </div>

                                </form>
                            </div>
                        </div>
                    </div>

                    <a href="/admin/pitch-add"
                       class="btn btn-info btn-lg mt-3"
                       title="Thêm mới sân bóng">
                        <i class="fa-solid fa-plus-circle"></i> Thêm sân bóng
                    </a>
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
                        <th>Tên sân</th>
                        <th>Giá thuê (VNĐ)</th>
                        <th>Loại sân</th>
                        <th>Mô tả sân</th>
                        <th>Thao tác</th>

                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${pitchList}">
                        <tr>
                            <td class="bigger-120">
                                    ${item.pitchName}
                            </td>
                            <td class="bigger-120">
                                    ${item.price}
                            </td>
                            <td class="bigger-120">
                                    ${item.type}
                            </td>
                            <td class="bigger-120">
                                    ${item.description}
                            </td>
                            <td>
                                <button class="btn btn-xs btn-success" title="Giao sân bóng cho khách hàng"
                                        onclick="openCustomerModal(${item.id})">
                                    <i class="fa-solid fa-paper-plane"></i>
                                </button>
                                <a class="btn btn-xs btn-info"
                                   title="Sửa sân bóng"
                                   href="/admin/pitch-edit?id=${item.id}">
                                    <i class="ace-icon fa fa-pencil bigger-120"></i>
                                </a>
                                <button class="btn btn-xs btn-danger " title="Xóa sân bóng"
                                        onclick="deletePitch(${item.id})">
                                    <i class="ace-icon fa fa-trash-o bigger-120"></i>
                                </button>
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


<%--tìm khách hàng--%>
<div class="modal fade" id="customerModal" tabindex="-1" role="dialog"
     style="font-family: 'Times New Roman', Times, serif;">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">

            <!-- HEADER -->
            <div class="modal-header bg-primary text-white">
                <button type="button" class="close" data-dismiss="modal">
                    &times;
                </button>
                <h4 class="modal-title">
                    🔍 Tìm kiếm khách hàng
                </h4>
            </div>

            <!-- BODY -->
            <div class="modal-body">
                <div class="form-group">
                    <label for="customerName" class="bigger-120"
                           style="display: inline-block; margin-right: 8px; margin-bottom: 0;">
                        Tên khách hàng
                    </label>
                    <input type="text"
                           id="customerName"
                           class="form-control input-lg"
                           placeholder="Nhập tên khách hàng...">
                </div>

                <div class="text-center">
                    <button type="button"
                            class="btn btn-primary btn-lg"
                            onclick="searchCustomer()">
                        🔎 Tìm khách hàng
                    </button>
                </div>

                <hr>

                <div id="searchResults" class="table-responsive">
                    <!-- Kết quả tìm kiếm -->
                </div>
            </div>

            <!-- FOOTER -->
            <div class="modal-footer">
                <button type="button"
                        class="btn btn-default"
                        data-dismiss="modal">
                    Đóng
                </button>
            </div>

        </div>
    </div>
</div>


<!-- Modal Nhập Thời Gian -->
<div class="modal fade" id="timeModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header bg-primary text-white">
                <button type="button" class="close" data-dismiss="modal">
                    &times;
                </button>
                <h4 class="modal-title">
                    ⏰ Nhập thời gian đặt sân
                </h4>
            </div>

            <div class="modal-body">
                <div class="row">
                    <div class="col-md-6">
                        <label>Ngày bắt đầu</label>
                        <input type="date" id="startDate" class="form-control input-lg"/>
                    </div>

                    <div class="col-md-6">
                        <label>Ngày kết thúc</label>
                        <input type="date" id="endDate" class="form-control input-lg"/>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button"
                        class="btn btn-default"
                        data-dismiss="modal">
                    Hủy
                </button>
                <button type="button"
                        class="btn btn-success"
                        onclick="generateBookingReceipt()">
                    ✅ Xác nhận
                </button>
            </div>

        </div>
    </div>
</div>


<!-- PHIẾU ĐẶT SÂN -->
<div class="modal fade booking-receipt-modal" id="bookingReceiptModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-xl modal-dialog-centered" role="document">
        <div class="modal-content shadow-lg">
            <!-- Header -->
            <div class="modal-header d-flex align-items-center justify-content-between">
                <h5 class="modal-title mb-0">
                    <i class="fa fa-file-text-o mr-2"></i> PHIẾU ĐẶT SÂN
                </h5>
                <button type="button"
                        class="close"
                        data-dismiss="modal"
                        aria-label="Close"
                        style="position: absolute; top: 8px; right: 12px;">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <!-- Body -->
            <div class="modal-body px-4 py-3">

                <!-- Thông tin khách hàng -->
                <div class="mb-4 info-card">
                    <h6 class="section-title mb-2">
                        <i class="fa fa-user mr-2"></i> Thông tin khách hàng
                    </h6>
                    <table class="table table-sm table-borderless mb-0 info-table">
                        <tr>
                            <td width="30%" class="text-muted">Họ và tên</td>
                            <td class="fw-medium" id="tenKH"></td>
                            <td width="30%" class="text-muted">Số điện thoại</td>
                            <td class="fw-medium" id="customerPhone"></td>
                        </tr>
                    </table>
                </div>

                <div class="divider"></div>

                <!-- Thông tin sân -->
                <div class="mb-4 info-card">
                    <h6 class="section-title mb-2">
                        <i class="fa fa-futbol-o mr-2"></i> Thông tin sân
                    </h6>
                    <table class="table table-sm table-borderless mb-0 info-table">
                        <tr>
                            <td width="30%" class="text-muted">Tên sân</td>
                            <td class="fw-medium" id="pitchName"></td>
                            <td width="30%" class="text-muted">Loại sân</td>
                            <td class="fw-medium" id="pitchType"></td>
                        </tr>
                    </table>
                </div>

                <div class="divider"></div>

                <!-- Thời gian -->
                <div class="mb-4 info-card">
                    <h6 class="section-title mb-2">
                        <i class="fa fa-calendar mr-2"></i> Thời gian đặt
                    </h6>
                    <table class="table table-sm table-borderless mb-0 info-table">
                        <tr>
                            <td width="30%" class="text-muted">Ngày bắt đầu</td>
                            <td class="fw-medium" id="ngayBD"></td>
                            <td width="30%" class="text-muted">Ngày kết thúc</td>
                            <td class="fw-medium" id="ngayKT"></td>
                        </tr>
                        <tr>
                            <td class="text-muted">Tổng số buổi</td>
                            <td colspan="3" class="fw-semibold">
                                <span id="totalDay"></span> buổi
                            </td>
                        </tr>
                    </table>
                </div>

                <div class="divider"></div>

                <!-- Chi phí -->
                <div class="info-card">
                    <h6 class="section-title mb-2">
                        <i class="fa fa-money mr-2"></i> Chi phí
                    </h6>
                    <table class="table table-bordered text-center mb-0 cost-table">
                        <thead class="thead-light">
                        <tr>
                            <th class="fw-semibold">Tổng tiền (VNĐ)</th>
                            <th class="fw-semibold">Tiền đặt cọc (10%)</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class="fw-bold text-danger total-amount" id="totalPrice"></td>
                            <td class="fw-bold text-success total-amount" id="deposit"></td>
                        </tr>
                        </tbody>
                    </table>
                </div>

            </div>

            <!-- Footer -->
            <div class="modal-footer">
                <button class="btn btn-outline-secondary btn-cancel"
                        data-dismiss="modal">
                    ❌ Hủy
                </button>
                <button class="btn btn-confirm"
                        onclick="confirmBooking()">
                    ✅ Xác nhận đặt sân
                </button>
            </div>

        </div>
    </div>
</div>


<script>

    let selectedCustomerID = null; //idKH
    let selectedPitchID = null; //idSan
    $('#btnPitch').click(function (e) {
        e.preventDefault();
        $('#listForm').submit();
    });

    function validateDate() {
        const startInput = document.getElementById("searchStartDate");
        const endInput = document.getElementById("searchEndDate");

        const today = new Date().toISOString().split('T')[0];
        const startDate = startInput.value;
        const endDate = endInput.value;

        // 1️⃣ Luôn chặn ngày bắt đầu < hôm nay (KHÔNG set value)
        startInput.min = today;

        // 2️⃣ Chặn ngày kết thúc < ngày bắt đầu
        if (startDate) {
            endInput.min = startDate;

            // Chỉ sửa khi người dùng chọn SAI
            if (endDate && endDate < startDate) {
                endInput.value = startDate;
            }
        }
    }

    function openCustomerModal(pitchID) {
        selectedPitchID = pitchID;
        $('#customerModal').modal();
    }

    function searchCustomer() {
        const name = $('#customerName').val();
        if (name === "") {
            document.getElementById("searchResults").innerHTML = "<p style='color:orange;'>Vui lòng nhập tên khách hàng cần tìm.</p>";
            return;
        }
        $.ajax({
            type: "GET",
            url: "/api/pitch/searchCustomer",
            data: {name: name},
            dataType: "json",
            success: function (data) {
                let html = `
         <h3 style="text-align:center; margin-bottom: 20px; color: #2c3e50;">Kết quả tìm kiếm</h3>
        <div style="display:flex; justify-content:center;">
            <table border="1" cellpadding="10" cellspacing="0" style="width:80%; text-align:center; border-collapse: collapse; font-family: Arial, sans-serif;">
                <thead style="background-color: #007bff; color: white;">
                    <tr>
                        <th>Mã KH</th>
                        <th>Họ tên</th>
                        <th>SĐT</th>
                        <th>Email</th>
                        <th>lựa chọn</th>
                    </tr>
                </thead>
                <tbody>
                `;
                if (data.length === 0) {
                    html += `<tr><td colspan="5">Không tìm thấy khách hàng nào.</td></tr>`;
                } else {
                    $.each(data, function (index, c) {
                        html += '<tr>';
                        html += '<td class="text-center">' + c.id + '</td>';
                        html += '<td class="text-center">' + c.fullname + '</td>';
                        html += '<td class="text-center">' + c.phone + '</td>';
                        html += '<td class="text-center">' + c.email + '</td>';
                        html += '<td class="text-center">';
                        html += '<button class="btn btn-primary btn-sm" onclick="selectCustomer(' + c.id + ', \'' + selectedPitchID + '\')">Chọn</button>';
                        html += '</td>';
                        html += '</tr>';
                    });
                }
                html += `</tbody></table></div>`;
                $('#searchResults').html(html);
            },
            error: function () {
                $('#searchResults').html("<p style='color:red; text-align:center;'>Đã xảy ra lỗi khi tìm kiếm.</p>");
            }
        });
    }


    function selectCustomer(idKH, idSan) {
        selectedCustomerID = idKH;
        let searchStartDate = document.getElementById("searchStartDate")?.value;
        let searchEndDate = document.getElementById("searchEndDate")?.value;
        const today = new Date().toISOString().split('T')[0];
        if (!searchStartDate) {
            searchStartDate = today;
        }
        if (!searchEndDate) {
            searchEndDate = today;
        }

        // ĐỔ VÀO MODAL NHẬP THỜI GIAN
        document.getElementById("startDate").value = searchStartDate;
        document.getElementById("endDate").value = searchEndDate;

        // Đóng modal khách hàng
        $('#customerModal').modal('hide');
        $('#timeModal').modal('show');
    }

    function generateBookingReceipt() {
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;
        if (!startDate || !endDate) {
            alert("Vui lòng nhập đầy đủ ngày bắt đầu và ngày kết thúc!");
            return;
        }
        const data = {
            customerId: selectedCustomerID,
            pitchId: selectedPitchID,
            startDate: startDate,
            endDate: endDate
        };

        $.ajax({
            url: '/api/pitch/createBooking',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function (response) {
                $('#timeModal').modal('hide');
                showBookingSummary(response);
            },
            error: function (xhr) {
                alert("Lỗi khi tạo phiếu đặt sân: " + xhr.responseText);
            }
        });
    }

    let bookingData = null;

    function showBookingSummary(data) {
        bookingData = data;
        $('#tenKH').text(data.tenKH || 'Không có');
        $('#customerPhone').text(data.customerPhone || 'Không có');
        $('#pitchName').text(data.pitchName || 'Không có');
        $('#pitchType').text(data.pitchType || 'Không có');
        $('#totalDay').text(data.totalDay || 0);
        $('#totalPrice').text((data.totalPrice || 0).toLocaleString('vi-VN'));
        $('#deposit').text((data.deposit || 0).toLocaleString('vi-VN'));
        $('#ngayBD').text(data.ngayBD);
        $('#ngayKT').text(data.ngayKT);
        $('#bookingReceiptModal').modal('show');
    }

    function confirmBooking() {
        if (!bookingData) {
            alert('Không có dữ liệu đặt sân!');
            return;
        }
        $.ajax({
            url: '/api/pitch/confirmbooking',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(bookingData),
            success: function (res) {
                alert('✅ Đặt sân thành công!');
                $('#bookingReceiptModal').modal('hide');
                window.location.reload();
            },
            error: function () {
                alert('❌ Có lỗi xảy ra khi đặt sân!');
            }
        });
    }

    function deletePitch(id) {
        if (!confirm("⚠️ Bạn có chắc chắn muốn xóa sân bóng này không?")) {
            return;
        }
        $.ajax({
            url: '/api/pitch/delete/' + id,
            type: 'DELETE',
            success: function (result) {
                alert("✅ Xóa sân bóng thành công!");
                location.reload();
            },
            error: function (xhr, status, error) {
                console.error("Lỗi:", error);
                if (xhr.status === 404) {
                    alert("❌ Không tìm thấy sân bóng!");
                } else {
                    alert("❌ Sân đang có khách sử dụng!");
                }
            }
        });
    }
</script>

</body>
</html>
