<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<html>
<head>
    <title>Gia Phả Online - Lưu giữ di sản dòng họ</title>
</head>
<body>

    <!-- ============================================ -->
    <!-- HERO SECTION                                 -->
    <!-- ============================================ -->
    <section class="gpo-hero">
        <div class="container text-center">
            <h1 class="gpo-hero-title">
                Lưu giữ <span class="gpo-text-primary">Di sản</span> Dòng họ cho Muôn đời
            </h1>
            <p class="gpo-hero-subtitle mx-auto">
                Nền tảng số hóa gia phả an toàn, chuyên nghiệp &mdash; xây dựng cây phả hệ,
                chia sẻ kỷ niệm và kết nối cội nguồn.
            </p>
            <div class="d-flex justify-content-center gap-3 mb-5">
                <a href="/login" class="btn btn-gpo btn-lg">
                    Bắt đầu ngay <i class="fa-solid fa-arrow-right ms-2"></i>
                </a>
                <a href="#features" class="btn btn-outline-gpo btn-lg">
                    Tìm hiểu thêm
                </a>
            </div>

            <%-- Thống kê nhanh --%>
            <div class="row justify-content-center gpo-stats">
                <div class="col-6 col-md-3">
                    <div class="gpo-stat-number">2,845</div>
                    <div class="gpo-stat-label">Thành viên</div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="gpo-stat-number">142</div>
                    <div class="gpo-stat-label">Chi nhánh</div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="gpo-stat-number">8,302</div>
                    <div class="gpo-stat-label">Tư liệu</div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="gpo-stat-number">315</div>
                    <div class="gpo-stat-label">Đang hoạt động</div>
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
                <h2 class="gpo-section-title">Mọi thứ bạn cần để quản lý Gia phả</h2>
                <p class="gpo-section-subtitle mx-auto">
                    Được xây dựng chuyên biệt cho các dòng họ Việt Nam với đầy đủ công cụ
                    hiện đại và bảo mật.
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
                    <h2 class="gpo-section-title text-start">Vì sao chọn Gia Phả Online?</h2>
                    <p class="text-muted">
                        Gia phả là di sản tinh thần quý giá của mỗi dòng họ. Chúng tôi số hóa
                        truyền thống ấy bằng công nghệ hiện đại, giúp mọi thế hệ dễ dàng
                        tra cứu, cập nhật và lưu truyền.
                    </p>
                    <ul class="gpo-check-list">
                        <li><i class="fa-solid fa-check"></i> Quản lý hồ sơ nhân khẩu theo chi nhánh</li>
                        <li><i class="fa-solid fa-check"></i> Ghi nhật ký mọi thay đổi phục vụ truy vết</li>
                        <li><i class="fa-solid fa-check"></i> Hỗ trợ 4 vai trò: Admin, Editor, Member, Guest</li>
                        <li><i class="fa-solid fa-check"></i> Tích hợp livestream sự kiện dòng họ</li>
                    </ul>
                </div>
                <div class="col-lg-6">
                    <div class="gpo-about-visual">
                        <div class="gpo-about-card">
                            <i class="fa-solid fa-users fa-3x mb-3 text-success"></i>
                            <h4>Kết nối Cội nguồn</h4>
                            <p>Gắn kết các thành viên trong gia tộc dù ở bất kỳ đâu.</p>
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
            <h2 class="gpo-section-title text-white">Sẵn sàng số hóa Gia phả?</h2>
            <p class="text-white-50 mx-auto mb-4" style="max-width: 600px;">
                Bắt đầu xây dựng cây gia phả số cho dòng họ bạn ngay hôm nay.
                Miễn phí và dễ sử dụng.
            </p>
            <a href="/login" class="btn btn-light btn-lg">
                Đăng nhập để bắt đầu <i class="fa-solid fa-arrow-right ms-2"></i>
            </a>
        </div>
    </section>

</body>
</html>