<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>
</head>
<body>

<div class="gpo-auth-card">
    <div class="text-center mb-4">
        <h2>Đăng nhập</h2>
        <p class="subtitle">Nhập tài khoản để truy cập hệ thống Gia Phả</p>
    </div>

    <c:if test="${param.incorrectAccount != null}">
        <div class="gpo-alert alert alert-danger">
            <i class="fa-solid fa-circle-exclamation me-1"></i>
            Tên đăng nhập hoặc mật khẩu không đúng.
        </div>
    </c:if>
    <c:if test="${param.accessDenied != null}">
        <div class="gpo-alert alert alert-warning">
            <i class="fa-solid fa-triangle-exclamation me-1"></i>
            Bạn không có quyền truy cập trang này.
        </div>
    </c:if>
    <c:if test="${param.sessionTimeout != null}">
        <div class="gpo-alert alert alert-info">
            <i class="fa-solid fa-clock me-1"></i>
            Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.
        </div>
    </c:if>
    <c:if test="${not empty registerSuccessMessage}">
        <div class="gpo-alert alert alert-success">
            <i class="fa-solid fa-circle-check me-1"></i>
            ${registerSuccessMessage}
        </div>
    </c:if>

    <form action="j_spring_security_check" id="formLogin" method="post">
        <div class="mb-3">
            <label class="gpo-form-label" for="userName">Tên đăng nhập</label>
            <input type="text" class="form-control gpo-form-control"
                   id="userName" name="j_username" placeholder="Nhập tên đăng nhập" required>
        </div>
        <div class="mb-3">
            <label class="gpo-form-label" for="password">Mật khẩu</label>
            <input type="password" class="form-control gpo-form-control"
                   id="password" name="j_password" placeholder="Nhập mật khẩu" required>
        </div>
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="form-check">
                <input class="form-check-input" type="checkbox" id="rememberMe">
                <label class="form-check-label" for="rememberMe" style="font-size:0.85rem;color:#64748b;">
                    Ghi nhớ đăng nhập
                </label>
            </div>
            <a href="#" class="gpo-link">Quên mật khẩu?</a>
        </div>
        <button type="submit" class="btn btn-gpo-primary">Đăng nhập</button>
    </form>

    <div class="gpo-divider"><span>hoặc</span></div>

    <div class="d-flex justify-content-center gap-3 mb-4">
        <a href="#" class="btn btn-outline-secondary btn-sm px-3"><i class="fab fa-facebook-f"></i></a>
        <a href="#" class="btn btn-outline-secondary btn-sm px-3"><i class="fab fa-google"></i></a>
        <a href="#" class="btn btn-outline-secondary btn-sm px-3"><i class="fab fa-twitter"></i></a>
    </div>

    <p class="text-center mb-0" style="font-size:0.9rem;color:#64748b;">
        Chưa có tài khoản? <a href="/dang-ky" class="gpo-link">Đăng ký ngay</a>
    </p>
</div>

</body>
</html>
