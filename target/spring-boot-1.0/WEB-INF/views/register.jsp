<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng ký</title>
</head>
<body>

<div class="gpo-auth-card" style="max-width: 520px;">
    <div class="text-center mb-4">
        <h2>Tạo tài khoản</h2>
        <p class="subtitle">Đăng ký để tham gia hệ thống Gia Phả Online</p>
    </div>

    <c:if test="${param.register_required_fields != null}">
        <div class="gpo-alert alert alert-danger">
            Vui lòng nhập đầy đủ tên đăng nhập, mật khẩu và xác nhận mật khẩu.
        </div>
    </c:if>
    <c:if test="${param.register_confirm_password_not_match != null}">
        <div class="gpo-alert alert alert-danger">
            Xác nhận mật khẩu không khớp.
        </div>
    </c:if>
    <c:if test="${param.register_username_existed != null}">
        <div class="gpo-alert alert alert-danger">
            Tên đăng nhập đã tồn tại.
        </div>
    </c:if>
    <c:if test="${param.register_role_not_found != null || param.register_fail != null}">
        <div class="gpo-alert alert alert-danger">
            Đăng ký thất bại, vui lòng thử lại.
        </div>
    </c:if>

    <form action="/register" id="formRegister" method="post">
        <div class="mb-3">
            <label class="gpo-form-label" for="fullname">Họ và tên</label>
            <input type="text" class="form-control gpo-form-control"
                   id="fullname" name="fullname" placeholder="Nguyễn Văn A" maxlength="100" required>
        </div>
        <div class="mb-3">
            <label class="gpo-form-label" for="regUsername">Tên đăng nhập</label>
            <input type="text" class="form-control gpo-form-control"
                   id="regUsername" name="userName" placeholder="nguyenvana" maxlength="50" required>
        </div>
        <div class="mb-3">
            <label class="gpo-form-label" for="email">Email</label>
            <input type="email" class="form-control gpo-form-control"
                   id="email" name="email" placeholder="email@example.com" maxlength="100">
        </div>
        <div class="mb-3">
            <label class="gpo-form-label" for="phone">Số điện thoại</label>
            <input type="tel" class="form-control gpo-form-control"
                   id="phone" name="phone" placeholder="0912 345 678" maxlength="20">
        </div>
        <div class="mb-3">
            <label class="gpo-form-label" for="regPassword">Mật khẩu</label>
            <input type="password" class="form-control gpo-form-control"
                   id="regPassword" name="password" placeholder="Tối thiểu 6 ký tự" required>
        </div>
        <div class="mb-3">
            <label class="gpo-form-label" for="confirmPassword">Xác nhận mật khẩu</label>
            <input type="password" class="form-control gpo-form-control"
                   id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
        </div>
        <div class="form-check mb-4">
            <input class="form-check-input" type="checkbox" id="agreeTerms" required>
            <label class="form-check-label" for="agreeTerms" style="font-size:0.85rem;color:#64748b;">
                Tôi đồng ý với <a href="#" class="gpo-link">Điều khoản sử dụng</a>
                và <a href="#" class="gpo-link">Chính sách bảo mật</a>
            </label>
        </div>
        <button type="submit" class="btn btn-gpo-primary">Đăng ký</button>
    </form>

    <div class="gpo-divider"><span>hoặc</span></div>

    <div class="d-flex justify-content-center gap-3 mb-4">
        <a href="#" class="btn btn-outline-secondary btn-sm px-3"><i class="fab fa-facebook-f"></i></a>
        <a href="#" class="btn btn-outline-secondary btn-sm px-3"><i class="fab fa-google"></i></a>
        <a href="#" class="btn btn-outline-secondary btn-sm px-3"><i class="fab fa-twitter"></i></a>
    </div>

    <p class="text-center mb-0" style="font-size:0.9rem;color:#64748b;">
        Đã có tài khoản? <a href="/login" class="gpo-link">Đăng nhập</a>
    </p>
</div>

</body>
</html>
