<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Đăng nhập</title>
</head>
<body>
	<div class="container" style="height: 100vh">
		<div class="login-form">
			<div class="main-div">
				<c:if test="${param.incorrectAccount != null}">
					<div class="alert alert-danger">Username or password incorrect</div>
				</c:if>
				<c:if test="${param.accessDenied != null}">
					<div class="alert alert-danger">You Not authorize</div>
				</c:if>
				<c:if test="${param.sessionTimeout != null}">
					<div class="alert alert-danger">Session Timeout</div>
				</c:if>

				<div class="container-fluid" style="padding-top: 100px">
					<section>
						<div class="row d-flex justify-content-center align-items-center">
							<div class="col-12 col-md-8 col-lg-6 col-xl-5">
								<div class="card text-white shadow-lg"
								     style="border-radius: 1rem; background: linear-gradient(135deg, #2193b0, #6dd5ed);">
									<div class="card-body p-5">
										<div class="text-center mb-4">
											<h2 class="fw-bold mb-2 text-uppercase">Login</h2>
											<p class="text-white-50 mb-5">Please enter your login and password!</p>
										</div>

										<form action="j_spring_security_check" id="formLogin" method="post">
											<div class="form-outline form-white mb-4">
												<label class="form-label" for="userName">Username</label>
												<input type="text" class="form-control" id="userName" name="j_username" placeholder="Tên đăng nhập">
											</div>

											<div class="form-outline form-white mb-4">
												<label class="form-label" for="password">Password</label>
												<input type="password" class="form-control" id="password" name="j_password" placeholder="Mật khẩu">
											</div>

											<p class="small mb-2 pb-lg-2 text-center">
												<a class="text-white-50" href="#!">Forgot password?</a>
											</p>

											<button type="submit" class="btn btn-light btn-lg w-100" style="color:#2193b0; font-weight:600;">
												Đăng nhập
											</button>
										</form>

										<div class="d-flex justify-content-center text-center mt-3 pt-2">
											<a href="#!" class="text-white mx-2"><i class="fab fa-facebook-f fa-lg"></i></a>
											<a href="#!" class="text-white mx-2"><i class="fab fa-twitter fa-lg"></i></a>
											<a href="#!" class="text-white mx-2"><i class="fab fa-google fa-lg"></i></a>
										</div>

										<div class="text-center mt-4">
											<p class="mb-0 text-white-50">
												Don't have an account? <a href="#!" class="text-white fw-bold">Sign Up</a>
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
