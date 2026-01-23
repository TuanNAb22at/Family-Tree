<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/taglib.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Thêm sân bóng</title>

    <!-- Bootstrap -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <style>
        body {
            background-color: #f4f6f9;
            font-family: "Times New Roman", Times, serif;
        }

        .card {
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .card-header {
            border-radius: 10px 10px 0 0;
        }

        .form-group label {
            font-weight: 600;
        }

        .form-control:focus {
            border-color: #28a745;
            box-shadow: 0 0 0 0.15rem rgba(40, 167, 69, 0.25);
        }

        .btn {
            min-width: 120px;
            font-weight: 600;
        }
    </style>
</head>

<body>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-lg-7 col-md-9">

            <div class="card">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">
                        <i class="fas fa-futbol mr-2"></i>Thêm sân bóng
                    </h5>
                </div>

                <div class="card-body px-4 py-4">
                    <form action="/admin/pitch-save" method="post">

                        <!-- Tên sân -->
                        <div class="form-group">
                            <label>
                                <i class="fas fa-signature text-success mr-1"></i>
                                Tên sân
                            </label>
                            <input type="text"
                                   name="pitchName"
                                   class="form-control"
                                   placeholder="Ví dụ: Sân A1, Sân Mini 5..."
                                   required>
                        </div>

                        <!-- Loại sân -->
                        <div class="form-group">
                            <label>
                                <i class="fas fa-layer-group text-success mr-1"></i>
                                Loại sân
                            </label>
                            <select name="type" class="form-control" required>
                                <option value="">-- Chọn loại sân --</option>
                                <c:forEach var="t" items="${pitchTypes}">
                                    <option value="${t}">${t}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Giá thuê -->
                        <div class="form-group">
                            <label>
                                <i class="fas fa-money-bill-wave text-success mr-1"></i>
                                Giá thuê (VNĐ)
                            </label>
                            <input type="number"
                                   name="price"
                                   class="form-control"
                                   min="0"
                                   placeholder="Ví dụ: 300000"
                                   required>
                        </div>

                        <!-- Mô tả -->
                        <div class="form-group">
                            <label>
                                <i class="fas fa-align-left text-success mr-1"></i>
                                Mô tả
                            </label>
                            <textarea name="description"
                                      class="form-control"
                                      rows="3"
                                      placeholder="Ghi chú thêm về sân (nếu có)..."></textarea>
                        </div>

                        <!-- Action -->
                        <div class="text-center mt-4">
                            <button type="submit" class="btn btn-success mr-2">
                                <i class="fas fa-save mr-1"></i>Lưu mới
                            </button>
                            <a href="/admin/pitchs-list" class="btn btn-secondary">
                                <i class="fas fa-times mr-1"></i>Hủy
                            </a>
                        </div>

                    </form>
                </div>
            </div>

        </div>
    </div>
</div>

</body>
</html>
