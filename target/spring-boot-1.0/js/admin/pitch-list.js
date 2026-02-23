let selectedCustomerID = null; // idKH
let selectedPitchID = null; // idSan
let bookingData = null;

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

    // Luôn chặn ngày bắt đầu < hôm nay (KHÔNG set value)
    startInput.min = today;

    // Chặn ngày kết thúc < ngày bắt đầu
    if (startDate) {
        endInput.min = startDate;

        // Chỉ sửa khi người dùng chọn sai
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
                        <th>Lựa chọn</th>
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

    // Đổ vào modal nhập thời gian
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
        success: function () {
            alert('Đặt sân thành công!');
            $('#bookingReceiptModal').modal('hide');
            window.location.reload();
        },
        error: function () {
            alert('Có lỗi xảy ra khi đặt sân!');
        }
    });
}

function deletePitch(id) {
    if (!confirm("Bạn có chắc chắn muốn xóa sân bóng này không?")) {
        return;
    }
    $.ajax({
        url: '/api/pitch/delete/' + id,
        type: 'DELETE',
        success: function () {
            alert("Xóa sân bóng thành công!");
            location.reload();
        },
        error: function (xhr) {
            if (xhr.status === 404) {
                alert("Không tìm thấy sân bóng!");
            } else {
                alert("Sân đang có khách sử dụng!");
            }
        }
    });
}
