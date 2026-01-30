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

    <!-- Fonts -->
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700;800&display=swap">

    <style>
        :root {
            --bg-1: #f5f7fb;
            --bg-2: #e9eff7;
            --ink: #1f2532;
            --muted: #6b7280;
            --accent: #1f8f5b;
            --accent-2: #0e6a41;
            --card: #ffffff;
            --ring: rgba(31, 143, 91, 0.2);
        }

        body {
            background:
                    radial-gradient(1000px 500px at 10% -10%, #ffffff 0%, transparent 60%),
                    radial-gradient(900px 450px at 90% 0%, #f0f6ff 0%, transparent 55%),
                    linear-gradient(180deg, var(--bg-1) 0%, var(--bg-2) 100%);
            color: var(--ink);
            font-family: "Merriweather", "Times New Roman", serif;
        }

        .page-shell {
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 48px 0;
        }

        .pitch-card {
            border: 1px solid rgba(31, 143, 91, 0.15);
            border-radius: 18px;
            background: var(--card);
            box-shadow: 0 18px 40px rgba(31, 37, 50, 0.08);
            overflow: hidden;
            max-width: 1040px;
            margin: 0 auto;
        }

        .card-header {
            background: linear-gradient(135deg, var(--accent) 0%, var(--accent-2) 100%);
            color: #fff;
            border-bottom: none;
        }

        .section-title {
            font-weight: 800;
            letter-spacing: 0.3px;
        }

        .form-group label {
            font-weight: 700;
            letter-spacing: 0.2px;
        }

        .form-control {
            border-radius: 12px;
            border-color: #d6dde7;
            background-color: #fbfcfe;
        }

        .form-control:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 0.2rem var(--ring);
        }

        .form-control::placeholder {
            color: #9aa4b2;
        }

        .btn-save {
            min-width: 160px;
            border-radius: 999px;
            font-weight: 700;
            background: linear-gradient(135deg, var(--accent) 0%, var(--accent-2) 100%);
            border: none;
            box-shadow: 0 12px 20px rgba(31, 143, 91, 0.25);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 18px 28px rgba(31, 143, 91, 0.3);
        }

        .btn-cancel {
            min-width: 130px;
            border-radius: 999px;
            font-weight: 700;
            background: #eef1f6;
            color: var(--muted);
            border: 1px solid #d7dee9;
        }

        @media (max-width: 576px) {
            .page-shell {
                padding: 24px 0;
            }

            .card-body {
                padding: 20px !important;
            }
        }
    </style>
</head>

<body>

<div class="page-shell">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10 col-md-11">

                <div class="card pitch-card">
                    <div class="card-header">
                        <h5 class="mb-0 section-title">
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
                                <button type="submit" class="btn btn-save mr-2 text-white">
                                    <i class="fas fa-save mr-1"></i>Lưu mới
                                </button>
                                <a href="/admin/pitchs-list" class="btn btn-cancel">
                                    <i class="fas fa-times mr-1"></i>Hủy
                                </a>
                            </div>

                        </form>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

</body>
</html>
