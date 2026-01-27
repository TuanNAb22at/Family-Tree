# 🏟️ HỆ THỐNG QUẢN LÝ CHO THUÊ SÂN BÓNG MINI

## 1. Giới thiệu chung

Hệ thống **Quản lý cho thuê sân bóng mini** được xây dựng nhằm hỗ trợ **chủ sân bóng** và **nhân viên** trong việc quản lý toàn bộ nghiệp vụ liên quan đến:

* Đặt sân – cho thuê sân theo buổi / theo tháng
* Quản lý hợp đồng, phiếu đặt sân, hóa đơn thanh toán
* Quản lý khách hàng, sân bóng, user hệ thống
* Quản lý mặt hàng ăn uống, nhập hàng từ nhà cung cấp
* Thống kê doanh thu theo tháng, quý, năm

Hệ thống mô phỏng **nghiệp vụ thực tế** của một sân bóng mini, được thiết kế theo hướng **chuẩn hóa dữ liệu**, **tách lớp rõ ràng**, phù hợp để mở rộng và bảo trì.

---

## 2. Công nghệ sử dụng

### Backend

* **Java 8** 
* **Spring Boot**
* **Spring Data JPA**
* **Spring Security** 
* **Hibernate ORM**

### Database

* **MySQL**
* Đã có sẵn **file database** (import trực tiếp để chạy hệ thống)

### Kiến trúc

* Mô hình **MVC / Layered Architecture**
* Các tầng chính:

  * Controller
  * Service
  * Repository 
  * Entity
  * DTO 

---

## 3. Tài khoản đăng nhập mẫu

| Role  | Username   | Password |
| ----- | ---------- | -------- |
| ADMIN | nguyenvana | 123456   |

> Hệ thống sử dụng **Spring Security** để kiểm soát truy cập.

---

## 4. Mô tả nghiệp vụ tổng thể

### 4.1 Quản lý sân bóng

* Một sân bóng có thể gồm **nhiều sân mini**
* Có thể **ghép 2 hoặc 4 sân mini liền nhau** để tạo thành sân lớn theo yêu cầu khách hàng
* Mỗi sân:

  * Có loại sân
  * Có giá thuê
  * Có trạng thái (trống / đã đặt theo khung giờ)

---

### 4.2 Quản lý khách hàng

* Thêm / sửa / xóa khách hàng
* Tìm kiếm khách hàng theo tên
* Một khách hàng:

  * Có thể đặt **nhiều sân**
  * Có thể có **nhiều phiếu đặt sân**

---

## 5. Module ĐẶT SÂN (Core Feature)

### Luồng nghiệp vụ chi tiết

1. **Khách hàng yêu cầu đặt sân**
2. Nhân viên (NV) chọn chức năng **Đặt sân**
3. Hệ thống hiển thị giao diện **tìm sân trống theo khung giờ**
4. NV:

   * Nhập khung giờ
   * Chọn loại sân
   * Click **Tìm kiếm**
5. Hệ thống:

   * Truy vấn CSDL
   * Hiển thị danh sách **sân còn trống** theo khung giờ
6. NV chọn 1 sân phù hợp
7. Hệ thống hiển thị giao diện **chọn khách hàng**
8. NV:

   * Nhập tên KH
   * Tìm kiếm
   * Chọn KH phù hợp
   * Nếu KH mới → **Thêm mới khách hàng**
9. NV nhập:

   * Ngày bắt đầu
   * Ngày kết thúc (ưu tiên đặt theo **quý**)
10. NV click xác nhận
11. Hệ thống sinh **Phiếu đặt sân**, bao gồm:

    * Thông tin khách hàng
    * Thông tin sân
    * Giá thuê 1 buổi
    * Khung giờ thuê trong tuần
    * Tổng số buổi
    * Tổng tiền dự kiến
    * Tiền đặt cọc 
12. NV xác nhận → hệ thống:

    * In phiếu đặt sân
    * Lưu dữ liệu vào CSDL

---


## 6. Module KHÁCH HÀNG THANH TOÁN

### Luồng nghiệp vụ chi tiết

1. KH đến yêu cầu thanh toán
2. NV chọn menu **Tìm phiếu đặt sân**
3. NV nhập **tên khách hàng** → Click tìm
4. Hệ thống hiển thị danh sách KH trùng tên
5. NV chọn đúng KH
6. Hệ thống hiển thị **danh sách các phiếu đặt sân** của KH
7. NV chọn **1 phiếu đặt sân** để thanh toán
8. Hệ thống hiển thị **HÓA ĐƠN**, gồm:

   * Thông tin khách hàng
   * Thông tin thuê sân
   * Các buổi thuê 
   
9. Nếu KH khiếu nại:

   * NV chỉnh sửa số lượng / mặt hàng
   * Hệ thống tự động cập nhật tổng tiền
10. NV click **Xác nhận thanh toán**
11. Hệ thống:

* Lưu hóa đơn
* Cập nhật CSDL

---


## 7. Module THỐNG KÊ DOANH THU

### Luồng nghiệp vụ

1. Quản lý (QL) chọn menu **Thống kê doanh thu**
2. Chọn thống kê theo:

   * Tháng
   * Quý
   * Năm
3. Ví dụ: thống kê theo **tháng**
4. Hệ thống hiển thị bảng doanh thu **12 tháng gần nhất**:

   * Tên tháng
   * Tổng doanh thu
   * Sắp xếp từ mới → cũ
5. QL click vào 1 dòng
6. Hệ thống hiển thị **chi tiết hóa đơn** trong khoảng thời gian đó:

   * ID hóa đơn
   * Tên khách hàng
   * Tên sân
   * Ngày giờ
   * Tổng tiền thanh toán

---

## 8. Quản lý hệ thống

### 8.1 Quản lý User

* Thêm / sửa / xóa user
* Phân quyền (ADMIN / NHÂN VIÊN)

### 8.2 Đăng nhập & bảo mật

* Spring Security
* Xác thực username / password
* Phân quyền theo role

---

## 9. Điểm nổi bật của project

* Bám sát **nghiệp vụ thực tế**
* Thiết kế CSDL rõ ràng, chuẩn hóa
* Áp dụng **JPA + Spring Data JPA**
* Có phân quyền & bảo mật
* Có đầy đủ:

  * Đặt sân
  * Thanh toán
  * Hóa đơn
  * Thống kê
* Dễ mở rộng: API, frontend riêng, payment online

---

## 10. Hướng phát triển trong tương lai

* Tích hợp thanh toán online (VNPay, Momo)
* Frontend React / Angular
* Quản lý lịch sân realtime
* Xuất hóa đơn PDF
* Dashboard thống kê nâng cao

---

## 11. Hướng dẫn chạy project

1. Import database MySQL (file có sẵn)
2. Cấu hình `application.properties`
3. Chạy project bằng Spring Boot
4. Đăng nhập bằng tài khoản mẫu

