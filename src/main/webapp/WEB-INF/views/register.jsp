<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đăng ký</title>
</head>
<body>
<div class="container" style="height: 100vh">
    <div class="login-form">
        <div class="main-div">
            <c:if test="${param.register_required_fields != null}">
                <div class="alert alert-danger">Vui lòng nhập đầy đủ thông tin.</div>
            </c:if>
            <c:if test="${param.register_confirm_password_not_match != null}">
                <div class="alert alert-danger">Mật khẩu xác thực không khớp.</div>
            </c:if>
            <c:if test="${param.register_username_existed != null}">
                <div class="alert alert-danger">Tài khoản đã tồn tại.</div>
            </c:if>
            <c:if test="${param.register_role_not_found != null}">
                <div class="alert alert-danger">Không tìm thấy role mặc định ROLE_USER.</div>
            </c:if>
            <c:if test="${param.register_fail != null}">
                <div class="alert alert-danger">Đăng ký thất bại.</div>
            </c:if>

            <div class="container-fluid" style="padding-top: 100px">
                <section>
                    <div class="row d-flex justify-content-center align-items-center">
                        <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                            <div class="card text-white shadow-lg"
                                 style="border-radius: 1rem; background: linear-gradient(135deg, #2193b0, #6dd5ed);">
                                <div class="card-body p-5">
                                    <div class="text-center mb-4">
                                        <h2 class="fw-bold mb-2 text-uppercase">Sign Up</h2>
                                        <p class="text-white-50 mb-5">Tạo tài khoản mới</p>
                                    </div>

                                    <form action="<c:url value='/register'/>" method="post">
                                        <div class="form-outline form-white mb-4">
                                            <label class="form-label" for="userName">Tài khoản</label>
                                            <input type="text" class="form-control" id="userName" name="userName" placeholder="Nhập tài khoản">
                                        </div>

                                        <div class="form-outline form-white mb-4">
                                            <label class="form-label" for="password">Mật khẩu</label>
                                            <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu">
                                        </div>

                                        <div class="form-outline form-white mb-4">
                                            <label class="form-label" for="confirmPassword">Mật khẩu xác thực</label>
                                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu">
                                        </div>

                                        <button type="submit" class="btn btn-light btn-lg w-100" style="color:#2193b0; font-weight:600;">
                                            Đăng ký
                                        </button>
                                    </form>

                                    <div class="text-center mt-4">
                                        <p class="mb-0 text-white-50">
                                            Đã có tài khoản? <a href="<c:url value='/login'/>" class="text-white fw-bold">Đăng nhập</a>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </div>
</div>
</body>
</html>
