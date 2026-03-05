<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<html>
<head>
    <title>Gia phả Họ Trần Đức - Nhân Hữu, Nhân Thắng, Bắc Ninh</title>
</head>
<body>

    <!-- ============================================ -->
    <!-- HERO SECTION                                 -->
    <!-- ============================================ -->
    <section class="gpo-hero">
        <div class="container text-center">
            <h1 class="gpo-hero-title">
                Gia phả <span class="gpo-text-primary">Họ Trần Đức</span>
            </h1>
            <p class="gpo-hero-subtitle mx-auto">
                Chi Nhân Hữu - Nhân Thắng, Bắc Ninh.<br/>
                Nơi con cháu cùng lưu giữ thông tin gia tộc, ghi nhớ công đức tổ tiên
                và tiếp nối truyền thống cho các thế hệ sau.
            </p>
            <div class="d-flex justify-content-center gap-3 mb-5">
                <a href="/login" class="btn btn-gpo btn-lg">
                    Vào trang quản lý <i class="fa-solid fa-arrow-right ms-2"></i>
                </a>
                <a href="#about" class="btn btn-outline-gpo btn-lg">
                    Xem giới thiệu
                </a>
            </div>

            <%-- Thông tin nhanh về dòng họ --%>
            <div class="row justify-content-center gpo-stats">
                <div class="col-6 col-md-3">
                    <div class="gpo-stat-number">Họ Trần Đức</div>
                    <div class="gpo-stat-label">Dòng họ</div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="gpo-stat-number">Nhân Hữu</div>
                    <div class="gpo-stat-label">Chi họ</div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="gpo-stat-number">Nhân Thắng</div>
                    <div class="gpo-stat-label">Khu vực</div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="gpo-stat-number">Bắc Ninh</div>
                    <div class="gpo-stat-label">Quê quán</div>
                </div>
            </div>
        </div>
    </section>

    <!-- ============================================ -->
    <!-- FEATURES SECTION                             -->
    <!-- ============================================ -->
    <section id="features" class="gpo-features">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="gpo-section-title">Các chức năng đang sử dụng</h2>
                <p class="gpo-section-subtitle mx-auto">
                    Những công cụ phục vụ trực tiếp cho việc cập nhật và lưu trữ gia phả Họ Trần Đức.
                </p>
            </div>

            <div class="row g-4">
                <%-- Tính năng 1: Cây gia phả --%>
                <div class="col-md-6 col-lg-4">
                    <div class="gpo-feature-card">
                        <div class="gpo-feature-icon">
                            <i class="fa-solid fa-sitemap"></i>
                        </div>
                        <h3>Cây Gia phả</h3>
                        <p>Xây dựng và trực quan hóa cây phả hệ nhiều đời với
                           giao diện kéo thả trực quan.</p>
                    </div>
                </div>

                <%-- Tính năng 2: Thư viện ảnh/video --%>
                <div class="col-md-6 col-lg-4">
                    <div class="gpo-feature-card">
                        <div class="gpo-feature-icon">
                            <i class="fa-solid fa-photo-film"></i>
                        </div>
                        <h3>Thư viện Tư liệu</h3>
                        <p>Lưu trữ và sắp xếp ảnh, video, tài liệu gia đình
                           trong thư viện media an toàn.</p>
                    </div>
                </div>

                <%-- Tính năng 3: Phát trực tuyến --%>
                <div class="col-md-6 col-lg-4">
                    <div class="gpo-feature-card">
                        <div class="gpo-feature-icon">
                            <i class="fa-solid fa-video"></i>
                        </div>
                        <h3>Phát trực tuyến</h3>
                        <p>Livestream các buổi lễ, giỗ, họp mặt dòng họ
                           với tính năng trò chuyện tích hợp.</p>
                    </div>
                </div>

                <%-- Tính năng 4: Phân quyền --%>
                <div class="col-md-6 col-lg-4">
                    <div class="gpo-feature-card">
                        <div class="gpo-feature-icon">
                            <i class="fa-solid fa-shield-halved"></i>
                        </div>
                        <h3>Phân quyền truy cập</h3>
                        <p>Kiểm soát ai được xem, chỉnh sửa hay quản lý dữ liệu
                           gia phả với hệ thống phân quyền chi tiết.</p>
                    </div>
                </div>

                <%-- Tính năng 5: Mô hình dữ liệu nhiều đời --%>
                <div class="col-md-6 col-lg-4">
                    <div class="gpo-feature-card">
                        <div class="gpo-feature-icon">
                            <i class="fa-solid fa-database"></i>
                        </div>
                        <h3>Dữ liệu nhiều đời</h3>
                        <p>Theo dõi quan hệ huyết thống qua nhiều thế hệ với
                           mô hình dữ liệu gia phả chuyên sâu.</p>
                    </div>
                </div>

                <%-- Tính năng 6: Bảo mật --%>
                <div class="col-md-6 col-lg-4">
                    <div class="gpo-feature-card">
                        <div class="gpo-feature-icon">
                            <i class="fa-solid fa-lock"></i>
                        </div>
                        <h3>An toàn &amp; Bảo mật</h3>
                        <p>Dữ liệu được mã hóa, nhật ký hoạt động được ghi lại
                           đầy đủ phục vụ kiểm soát an toàn thông tin.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ============================================ -->
    <!-- ABOUT SECTION                                -->
    <!-- ============================================ -->
    <section id="about" class="gpo-about">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 mb-4 mb-lg-0">
                    <h2 class="gpo-section-title text-start">Đôi lời về Gia phả Họ Trần Đức</h2>
                    <p class="text-muted">
                        Trang web này được lập để con cháu Họ Trần Đức tại Nhân Hữu - Nhân Thắng - Bắc Ninh
                        cùng nhau lưu giữ gia phả, bổ sung thông tin các đời, bảo tồn ký ức gia đình và
                        gìn giữ đạo lý uống nước nhớ nguồn.
                    </p>
                    <ul class="gpo-check-list">
                        <li><i class="fa-solid fa-check"></i> Ghi chép thông tin tổ tiên và các thế hệ con cháu</li>
                        <li><i class="fa-solid fa-check"></i> Cập nhật ngày giỗ, sự kiện họ tộc và thông tin quan trọng</li>
                        <li><i class="fa-solid fa-check"></i> Lưu giữ ảnh, video và tư liệu của gia đình</li>
                        <li><i class="fa-solid fa-check"></i> Kết nối con cháu Nhân Hữu - Nhân Thắng ở mọi nơi</li>
                    </ul>
                </div>
                <div class="col-lg-6">
                    <div class="gpo-about-visual">
                        <div class="gpo-about-card">
                            <i class="fa-solid fa-users fa-3x mb-3 text-success"></i>
                            <h4>Uống nước nhớ nguồn</h4>
                            <p>Cùng nhau gìn giữ gia phả để truyền lại giá trị dòng họ cho thế hệ mai sau.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ============================================ -->
    <!-- CONTACT / CTA SECTION                        -->
    <!-- ============================================ -->
    <section id="contact" class="gpo-cta">
        <div class="container text-center">
            <h2 class="gpo-section-title text-white">Cùng xây dựng Gia phả Họ Trần Đức</h2>
            <p class="text-white-50 mx-auto mb-4" style="max-width: 600px;">
                Mời các thành viên trong họ cùng đăng nhập để bổ sung thông tin chính xác,
                đầy đủ và thống nhất cho gia phả chung.
            </p>
            <a href="/login" class="btn btn-light btn-lg">
                Đăng nhập để cập nhật <i class="fa-solid fa-arrow-right ms-2"></i>
            </a>
        </div>
    </section>

</body>
</html>
