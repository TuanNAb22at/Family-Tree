<<<<<<< HEAD
﻿# 🏟️ HỆ THỐNG QUẢN LÝ CHO THUÊ SÂN BÓNG MINI

Hệ thống **Quản lý cho thuê sân bóng mini** hỗ trợ **chủ sân** và **nhân viên** quản lý toàn bộ nghiệp vụ: đặt sân, thuê theo buổi/tháng, lập phiếu đặt sân, hóa đơn thanh toán, quản lý khách hàng – sân bóng – user, quản lý mặt hàng ăn uống & nhập hàng, và thống kê doanh thu.

## Demo
- Live: `http://18.143.151.210:8080`

---

## 1. Tổng quan chức năng

### 1.1 Nghiệp vụ chính
- Đặt sân theo buổi / theo tháng, quản lý khung giờ và trạng thái sân.
- Lập phiếu đặt sân, hóa đơn thanh toán, quản lý hợp đồng.
- Quản lý khách hàng, user hệ thống, phân quyền (ADMIN / NHÂN VIÊN).
- Quản lý mặt hàng ăn uống, nhập hàng từ nhà cung cấp.
- Thống kê doanh thu theo tháng / quý / năm.

### 1.2 Điểm nổi bật
- Bám sát **nghiệp vụ thực tế** của sân bóng mini.
- Thiết kế CSDL rõ ràng, chuẩn hóa dữ liệu.
- Kiến trúc **MVC / Layered Architecture** tách lớp rõ ràng.
- Bảo mật và phân quyền với **Spring Security**.
- Dễ mở rộng: API, frontend riêng, tích hợp thanh toán online.
=======
# 🏟️ HỆ THỐNG QUẢN LÝ CHO THUÊ SÂN BÓNG MINI

## 1. Giới thiệu chung

Hệ thống **Quản lý cho thuê sân bóng mini** được xây dựng nhằm hỗ trợ **chủ sân bóng** và **nhân viên** trong việc quản lý toàn bộ nghiệp vụ liên quan đến:

* Đặt sân – cho thuê sân theo buổi / theo tháng
* Quản lý hợp đồng, phiếu đặt sân, hóa đơn thanh toán
* Quản lý khách hàng, sân bóng, user hệ thống
* Quản lý mặt hàng ăn uống, nhập hàng từ nhà cung cấp
* Thống kê doanh thu theo tháng, quý, năm

Hệ thống mô phỏng **nghiệp vụ thực tế** của một sân bóng mini, được thiết kế theo hướng **chuẩn hóa dữ liệu**, **tách lớp rõ ràng**, phù hợp để mở rộng và bảo trì.
>>>>>>> 0d6874e9a84bca9d90762c9db0b1dc823ecb5111

---

## 2. Công nghệ sử dụng

### Backend
<<<<<<< HEAD
- Java 8
- Spring Boot 2.0.9
- Spring Data JPA + Hibernate
- Spring Security
- JSTL + JSP (view)

### Database
- MySQL
- Có sẵn file database: `database/football_mini_db.sql`

### Hạ tầng & DevOps (đã triển khai)
- Docker hóa ứng dụng Spring Boot (chạy nhất quán mọi môi trường)
- CI/CD tự động: **build image → push Docker Hub → deploy EC2 qua SSH**
- Chạy production trên **AWS EC2**
- Database production dùng dịch vụ ngoài **Aiven MySQL** (không deploy cùng app)

---

## 3. Kiến trúc hệ thống

Mô hình **MVC / Layered Architecture**:
- Controller
- Service
- Repository
- Entity
- DTO

Gói chính:
- `com.javaweb.controller.*`
- `com.javaweb.service.*`
- `com.javaweb.repository.*`
- `com.javaweb.entity.*`
- `com.javaweb.model.dto.*`

---

## 4. Tài khoản đăng nhập mẫu
=======

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
>>>>>>> 0d6874e9a84bca9d90762c9db0b1dc823ecb5111

| Role  | Username   | Password |
| ----- | ---------- | -------- |
| ADMIN | nguyenvana | 123456   |

<<<<<<< HEAD
---

## 5. Mô tả nghiệp vụ tổng thể

### 5.1 Quản lý sân bóng
- Một sân bóng có thể gồm nhiều sân mini.
- Có thể ghép 2 hoặc 4 sân mini thành sân lớn theo yêu cầu.
- Mỗi sân có: **loại sân, giá thuê, trạng thái** (trống / đã đặt theo khung giờ).

### 5.2 Quản lý khách hàng
- Thêm / sửa / xóa khách hàng.
- Tìm kiếm khách hàng theo tên.
- Một khách hàng có thể có nhiều phiếu đặt sân.

---

## 6. Module ĐẶT SÂN (Core Feature)

### Luồng nghiệp vụ chi tiết
1. Khách hàng yêu cầu đặt sân.
2. Nhân viên chọn chức năng **Đặt sân**.
3. Hệ thống hiển thị giao diện tìm sân trống theo khung giờ.
4. Nhân viên nhập khung giờ, chọn loại sân → **Tìm kiếm**.
5. Hệ thống truy vấn CSDL và hiển thị danh sách sân còn trống.
6. Nhân viên chọn sân phù hợp.
7. Hệ thống hiển thị giao diện **chọn khách hàng**.
8. Nhân viên nhập tên KH → tìm kiếm → chọn KH phù hợp (hoặc tạo KH mới).
9. Nhập ngày bắt đầu / ngày kết thúc (ưu tiên đặt theo quý).
10. Xác nhận → hệ thống sinh **Phiếu đặt sân** gồm:
    - Thông tin khách hàng
    - Thông tin sân
    - Giá thuê 1 buổi
    - Khung giờ thuê trong tuần
    - Tổng số buổi
    - Tổng tiền dự kiến
    - Tiền đặt cọc
11. Nhân viên xác nhận → lưu dữ liệu vào CSDL.

---

## 7. Module KHÁCH HÀNG THANH TOÁN

### Luồng nghiệp vụ
1. KH đến yêu cầu thanh toán.
2. NV chọn menu **Tìm phiếu đặt sân**.
3. NV nhập tên KH → tìm kiếm.
4. Hệ thống hiển thị danh sách KH trùng tên.
5. NV chọn đúng KH.
6. Hệ thống hiển thị danh sách phiếu đặt sân của KH.
7. NV chọn phiếu đặt sân cần thanh toán.
8. Hệ thống hiển thị **HÓA ĐƠN**:
   - Thông tin khách hàng
   - Thông tin thuê sân
   - Các buổi thuê
9. Nếu KH khiếu nại, NV chỉnh sửa số lượng / mặt hàng → hệ thống tự cập nhật tổng tiền.
10. NV xác nhận thanh toán → hệ thống lưu hóa đơn và cập nhật CSDL.

---

## 8. Module THỐNG KÊ DOANH THU

### Luồng nghiệp vụ
1. Quản lý chọn menu **Thống kê doanh thu**.
2. Chọn thống kê theo: tháng / quý / năm.
3. Hệ thống hiển thị doanh thu 12 tháng gần nhất (mới → cũ).
4. Chọn 1 dòng để xem chi tiết hóa đơn trong khoảng thời gian đó.

---

## 9. Cấu trúc thư mục quan trọng

- `src/main/java/com/javaweb` — Backend Java (Controller/Service/Repository/Entity/DTO)
- `src/main/webapp/WEB-INF/views` — JSP views
- `src/main/resources` — cấu hình & static assets
- `database/football_mini_db.sql` — database mẫu
- `.github/workflows/ci-cd.yml` — pipeline CI/CD lên AWS EC2
- `Dockerfile` — dockerize ứng dụng

---

## 10. Hướng dẫn chạy project (Local)

### 10.1 Chuẩn bị
- Java 8
- Maven
- MySQL

### 10.2 Import database
1. Tạo DB: `football_mini_db`.
2. Import file: `database/football_mini_db.sql`.

### 10.3 Cấu hình database
File: `src/main/resources/application-dev.properties`
```
spring.datasource.url = jdbc:mysql://localhost:3306/football_mini_db
spring.datasource.username = root
spring.datasource.password = 12345
```

### 10.4 Chạy ứng dụng
- Dùng Maven:
```
mvn spring-boot:run
```
- Hoặc build WAR:
```
mvn clean package
```

Ứng dụng mặc định chạy ở: `http://localhost:8080`

---

## 11. Docker hóa ứng dụng

Ứng dụng đã được dockerize thông qua `Dockerfile` (build WAR + chạy trên Tomcat 9).

Build image:
```
docker build -t mini-football-app .
```
Run container:
```
docker run -d --name mini-football-app -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=pro \
  -e DB_URL='jdbc:mysql://<host>:<port>/<db>' \
  -e DB_USERNAME='<user>' \
  -e DB_PASSWORD='<pass>' \
  mini-football-app
```

> Lưu ý: profile production hiện dùng file `application-pro.properties`.

---

## 12. CI/CD lên AWS EC2 (đã triển khai)

Workflow: `.github/workflows/ci-cd.yml`

Luồng tự động:
1. Push code vào nhánh `main`.
2. GitHub Actions build Docker image.
3. Push image lên Docker Hub.
4. SSH vào EC2 và deploy container mới.

Biến môi trường cần cấu hình (GitHub Secrets):
- `DOCKER_USER`, `DOCKER_TOKEN`
- `EC2_HOST`, `EC2_USER`, `EC2_KEY`
- `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`

Lệnh deploy trên EC2 (trong workflow):
- Stop/remove container cũ
- Pull image mới
- Run container với env DB (Aiven MySQL)

---

## 13. Hướng phát triển tương lai

- Tích hợp thanh toán online (VNPay, MoMo)
- Frontend React/Angular
- Quản lý lịch sân realtime
- Xuất hóa đơn PDF
- Dashboard thống kê nâng cao

---

## 14. Ghi chú

- Hệ thống dùng **Spring Security** để kiểm soát truy cập.
- Database production dùng **Aiven MySQL** (không deploy cùng app).
- CI/CD tự động giúp deploy nhanh và nhất quán trên AWS EC2.
=======
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

>>>>>>> 0d6874e9a84bca9d90762c9db0b1dc823ecb5111
