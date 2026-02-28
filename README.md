# 🌳 NỀN TẢNG GIA PHẢ ONLINE ĐA NGƯỜI DÙNG
### Tích hợp Ảnh, Video và Livestream thời gian thực

![Java](https://img.shields.io/badge/Java-8-orange)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-2.0.9-brightgreen)
![Database](https://img.shields.io/badge/Database-MySQL-blue)
![Deploy](https://img.shields.io/badge/Deploy-AWS%20EC2-232F3E)
![Container](https://img.shields.io/badge/Container-Docker-2496ED)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF)

### Dự án này dùng để làm gì?

Hệ thống giúp dòng họ lưu trữ và quản lý thông tin gia phả trên nền tảng online, thay cho cách ghi chép rời rạc bằng giấy hoặc file cá nhân.

---
## 🔗 Demo

- **Trang chủ:** http://18.143.147.205:8080/trang-chu

---
## 🎯 Điểm nổi bật 

- Thiết kế và triển khai **full-stack backend-driven** với Spring Boot + JSP.
- Xây dựng **mô hình dữ liệu gia phả nhiều đời** (cha/mẹ/con, vợ/chồng, chi nhánh).
- Áp dụng **RBAC** (Role-Based Access Control) với các vai trò `MANAGER`, `EDITOR`, `USER`.
- Tích hợp **upload và quản lý media** (ảnh/video/audio), có phân quyền xem `PUBLIC` / `PRIVATE`.
- Triển khai **livestream realtime** bằng **WebRTC + WebSocket signaling**.
- Có **audit log và dashboard an toàn thông tin** để giám sát truy cập và thay đổi dữ liệu.
- Đưa hệ thống lên production bằng **Docker + CI/CD + AWS EC2**, DB tách rời trên **Aiven MySQL**.

---

## 🧱 Công nghệ sử dụng

### Backend

- Java 8
- Spring Boot 2.0.9
- Spring Data JPA + Hibernate
- Spring Security
- Spring WebSocket
- JSP + JSTL + SiteMesh
- Maven

### Hạ tầng & DevOps

- Docker hóa ứng dụng (WAR chạy trên Tomcat 9)
- GitHub Actions pipeline (build image -> push Docker Hub -> deploy EC2 qua SSH)
- AWS EC2 (runtime production)
- Aiven MySQL (database production)
- Nginx reverse proxy + WebSocket upgrade
- Coturn (khuyến nghị cho WebRTC production)

---

## 🏗️ Kiến trúc hệ thống

```text
Client Browser
   -> Nginx (HTTPS / Reverse Proxy / WebSocket Upgrade)
      -> Spring Boot App (Tomcat 9, Docker, EC2)
         -> Aiven MySQL

Livestream:
Host Browser <-> Viewer Browser (WebRTC)
Signaling: /ws/live (WebSocket)
```

---

## ⚙️ Chức năng chính

### 1) Quản lý gia phả

- Tạo thành viên gốc, thêm vợ/chồng, thêm con, cập nhật, xóa theo ràng buộc nghiệp vụ.
- Mô hình quan hệ gia đình đầy đủ: cha - mẹ - con - vợ/chồng.
- Quản lý theo chi nhánh và theo đời.
- Giao diện cây gia phả trực quan: lọc, zoom, thao tác nhanh.

### 2) Người dùng & phân quyền

- `MANAGER`: toàn quyền quản trị, quản lý user, xem security audit.
- `EDITOR`: cập nhật gia phả, quản lý media.
- `USER`: truy cập nội dung theo quyền được cấp.
- Guest: truy cập trang công khai, đăng ký/đăng nhập.

### 3) Ảnh, Video, Audio

- Upload đa tệp (`multipart/form-data`), giới hạn 200MB/tệp theo cấu hình.
- Gắn media với nhân khẩu, chi nhánh, người tải lên.
- Hỗ trợ preview, download, xóa theo quyền.
- Phân mức truy cập:
  - `PUBLIC`: người dùng thường có thể xem.
  - `PRIVATE`: chỉ `MANAGER` / `EDITOR` có quyền xem.

### 4) Livestream thời gian thực

- Tạo phòng livestream theo chi nhánh.
- Tham gia phòng qua `livestreamId`.
- Chia sẻ màn hình, bật/tắt camera và microphone.
- Chat realtime và danh sách người tham gia realtime.
- Kết thúc livestream theo quyền host/manager.

---

## 🔌 API tiêu biểu

### Gia phả

- `GET /api/person/root`
- `POST /api/person`
- `POST /api/person/{id}/spouse`
- `POST /api/person/{id}/child`
- `PUT /api/person/{id}`
- `DELETE /api/person/{id}`

### Media

- `POST /api/media/upload`
- `GET /api/media/{id}/download`
- `GET /api/media/file/{fileName}`
- `DELETE /api/media/{id}`

### Livestream

- `POST /api/livestream/start`
- `GET /api/livestream/watch`
- `GET /api/livestream/live`
- `PUT /api/livestream/{id}/end`

---

## 🔒 An toàn thông tin (QLATTT)

### Đã triển khai

- Phân quyền truy cập theo vai trò người dùng.
- Mật khẩu mã hóa bằng BCrypt.
- Ghi log các sự kiện quan trọng:
  - đăng nhập thành công/thất bại
  - đăng xuất
  - truy cập bị từ chối
  - thay đổi dữ liệu qua API
- Dashboard Security Audit cho quản trị viên.

### Định hướng nâng cấp

- Bổ sung rate-limit/CAPTCHA chống brute-force.
- Chuẩn hóa quy trình backup/restore định kỳ.
- Tăng cường secret management ở production.
- Mở rộng kiểm soát truy cập sâu theo từng chi nhánh.

---

## 🚀 Triển khai production

### CI/CD hiện tại

Khi push lên `main`, workflow tự động:

1. Build Docker image
2. Push Docker Hub
3. SSH vào EC2 để pull image mới và chạy container



### Livestream Internet

- Dùng Nginx cho reverse proxy và websocket upgrade.
- Dùng TURN server (coturn) để tăng độ ổn định WebRTC trên mạng thực.
- Cấu hình tham khảo nằm trong thư mục `deploy/`.

---

## 🧪 Chạy local nhanh

### Yêu cầu

- JDK 8
- Maven 3.x
- MySQL 8

### Các bước

1. Import database:

```bash
mysql -u root -p < database/family_tree_db.sql
```

2. Cấu hình datasource trong profile local (`application-dev.properties` hoặc `application-uat.properties`).

3. Khởi chạy ứng dụng:

```bash
mvn clean package -DskipTests
mvn spring-boot:run
```

4. Truy cập:

- `http://localhost:8080/trang-chu`
- `http://localhost:8080/login`

---

## 👤 Tài khoản demo

- **Admin / MANAGER**
  - Username: `nguyenvana`
  - Password: `123456`
- **Editor**
  - Username: `nguyenvanb`
  - Password: `123456`

---

## 📁 Cấu trúc dự án

```text
.
├── .github/workflows/ci-cd.yml
├── database/family_tree_db.sql
├── deploy/
├── src/main/java/com/javaweb/
├── src/main/resources/
├── src/main/webapp/WEB-INF/views/
├── Dockerfile
└── pom.xml
```

