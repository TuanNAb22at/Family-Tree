-- DROP DATABASE football_mini_db;
CREATE DATABASE football_mini_db;
use football_mini_db;
CREATE TABLE `customer` (
                            `id` bigint(20) NOT NULL AUTO_INCREMENT,
                            `fullname` varchar(255) NOT NULL,
                            `phone` varchar(255) NOT NULL,
                            `email` varchar(255) DEFAULT NULL,
                            companyname varchar(255) DEFAULT NULL,
                            demand varchar(255) DEFAULT NULL,
                            status varchar(255) DEFAULT NULL,
                            is_active TINYINT(1) DEFAULT 1,
                            `createddate` datetime DEFAULT NULL,
                            `modifieddate` datetime DEFAULT NULL,
                            `createdby` varchar(255) DEFAULT NULL,
                            `modifiedby` varchar(255) DEFAULT NULL,
                            PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO customer(fullname,phone,email,companyname,demand)
VALUES('Luc Van Hai','0905671231','hailv@gmail.com',null,null),
      ('Nguyen Xuan Hong','0205671231','hongxuanng@gmail.com',null,null),
      ('Ta Thi Cuc','0912121231','cucthita1@gmail.com',null,null);

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
SET character_set_client = utf8mb4 ;
CREATE TABLE `role` (
                        `id` bigint(20) NOT NULL AUTO_INCREMENT,
                        `name` varchar(255) NOT NULL,
                        `code` varchar(255) NOT NULL,
                        `createddate` datetime DEFAULT NULL,
                        `modifieddate` datetime DEFAULT NULL,
                        `createdby` varchar(255) DEFAULT NULL,
                        `modifiedby` varchar(255) DEFAULT NULL,
                        PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
INSERT INTO `role` VALUES (1,'Quản lý','MANAGER',NULL,NULL,NULL,NULL),(2,'Nhân viên','STAFF',NULL,NULL,NULL,NULL),(3,'Người dùng','USER',NULL,NULL,NULL,NULL);

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
SET character_set_client = utf8mb4 ;
CREATE TABLE `user` (
                        `id` bigint(20) NOT NULL AUTO_INCREMENT,
                        `username` varchar(255) NOT NULL,
                        `password` varchar(255) NOT NULL,
                        `fullname` varchar(255) DEFAULT NULL,
                        `phone` varchar(255) DEFAULT NULL,
                        `email` varchar(255) DEFAULT NULL,
                        `status` int(11) NOT NULL,
                        `createddate` datetime DEFAULT NULL,
                        `modifieddate` datetime DEFAULT NULL,
                        `createdby` varchar(255) DEFAULT NULL,
                        `modifiedby` varchar(255) DEFAULT NULL,
                        PRIMARY KEY (`id`),
                        UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
INSERT INTO `user` VALUES (1,'nguyenvana','$2a$10$/RUbuT9KIqk6f8enaTQiLOXzhnUkiwEJRdtzdrMXXwU7dgnLKTCYG','nguyen van a',NULL,NULL,1,NULL,NULL,NULL,NULL),(2,'nguyenvanb','$2a$10$/RUbuT9KIqk6f8enaTQiLOXzhnUkiwEJRdtzdrMXXwU7dgnLKTCYG','nguyen van b',NULL,NULL,1,NULL,NULL,NULL,NULL),(3,'nguyenvanc','$2a$10$/RUbuT9KIqk6f8enaTQiLOXzhnUkiwEJRdtzdrMXXwU7dgnLKTCYG','nguyen van c',NULL,NULL,1,NULL,NULL,NULL,NULL),(4,'nguyenvand','$2a$10$/RUbuT9KIqk6f8enaTQiLOXzhnUkiwEJRdtzdrMXXwU7dgnLKTCYG','nguyen van d',NULL,NULL,1,NULL,NULL,NULL,NULL);

DROP TABLE IF EXISTS `user_role`;
SET character_set_client = utf8mb4 ;
CREATE TABLE `user_role` (
                             `id` bigint(20) NOT NULL AUTO_INCREMENT,
                             `role_id` bigint(20) NOT NULL,
                             `user_id` bigint(20) NOT NULL,
                             `createddate` datetime DEFAULT NULL,
                             `modifieddate` datetime DEFAULT NULL,
                             `createdby` varchar(255) DEFAULT NULL,
                             `modifiedby` varchar(255) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             KEY `fk_user_role` (`user_id`),
                             KEY `fk_role_user` (`role_id`),
                             CONSTRAINT `fk_role_user` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`),
                             CONSTRAINT `fk_user_role` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
INSERT INTO `user_role` VALUES (1,1,1,NULL,NULL,NULL,NULL),(2,2,2,NULL,NULL,NULL,NULL),(3,2,3,NULL,NULL,NULL,NULL),(4,2,4,NULL,NULL,NULL,NULL);
-- 5. Nhà cung cấp
CREATE TABLE supplier (
                          id INT PRIMARY KEY AUTO_INCREMENT,
                          supplier_name VARCHAR(50),
                          email VARCHAR(100),
                          phone_number VARCHAR(10),
                          description VARCHAR(500),
                          createddate DATETIME,
                          modifieddate DATETIME,
                          createdby VARCHAR(50),
                          modifiedby VARCHAR(50)
);
INSERT INTO supplier (supplier_name, email, phone_number, description, createddate, createdby) VALUES
                                                                                                   ('Công ty TNHH Nước Uống ABC', 'contact@abcwater.vn', '0987654321', 'Nhà cung cấp nước uống tinh khiết cho hệ thống sân bóng và văn phòng.', NOW(), 'admin'),
                                                                                                   ('Công ty TNHH Thực Phẩm Minh An', 'info@minhanfoods.vn', '0912345678', 'Chuyên cung cấp đồ uống, nước ngọt, bánh kẹo cho căng tin và sự kiện thể thao.', NOW(), 'admin'),
                                                                                                   ('Công ty Cổ phần Thiết Bị Thể Thao Đông Á', 'support@dongasport.vn', '0905123456', 'Nhà phân phối bóng đá, lưới, cọc biên và đồng phục thể thao.', NOW(), 'admin'),
                                                                                                   ('Công ty TNHH Dịch Vụ Vệ Sinh Xanh Sạch', 'contact@xanhsach.com', '0978123456', 'Dịch vụ vệ sinh sân bóng, nhà vệ sinh và khu vực công cộng định kỳ.', NOW(), 'admin'),
                                                                                                   ('Công ty TNHH Ánh Sáng Việt', 'sales@anhsangviet.vn', '0932123456', 'Chuyên cung cấp đèn LED chiếu sáng sân bóng, bảng điện tử và thiết bị điện.', NOW(), 'admin'),
                                                                                                   ('Công ty TNHH Cỏ Nhân Tạo Hưng Thịnh', 'hungthinh@cogreen.vn', '0965345678', 'Nhà cung cấp và thi công cỏ nhân tạo, vật liệu trải nền cho sân mini.', NOW(), 'admin'),
                                                                                                   ('Công ty TNHH Đồ Uống Thể Thao EnergyX', 'contact@energyx.vn', '0988776655', 'Phân phối nước tăng lực, nước bù khoáng, và thực phẩm bổ sung năng lượng.', NOW(), 'admin'),
                                                                                                   ('Công ty TNHH Thiết Bị Âm Thanh Việt Sound', 'info@vietsound.vn', '0908765432', 'Nhà cung cấp loa, micro, hệ thống âm thanh cho sự kiện thể thao và sân cỏ.', NOW(), 'admin');

-- 6. Nhóm sân (cụm sân)
CREATE TABLE big_pitch (
                           id INT PRIMARY KEY AUTO_INCREMENT,
                           address VARCHAR(200),
                           description VARCHAR(500),
                           createddate DATETIME,
                           modifieddate DATETIME,
                           createdby VARCHAR(50),
                           modifiedby VARCHAR(50)
);
INSERT INTO big_pitch (address, description, createddate)
VALUES
    ('123 Đường Lê Lợi, Hoàn Kiếm, Hà Nội', 'Cụm sân trung tâm thành phố', NOW()),
    ('45 Nguyễn Trãi, Thanh Xuân, Hà Nội', 'Cụm sân mini gần trung tâm quận', NOW()),
    ('27 Trần Phú, Ba Đình, Hà Nội', 'Sân bóng chuẩn 7 người', NOW()),
    ('68 Lê Duẩn, Hai Bà Trưng, Hà Nội', 'Sân mini phục vụ phong trào', NOW()),
    ('89 Nguyễn Khuyến, Đống Đa, Hà Nội', 'Cụm sân cỏ nhân tạo chất lượng', NOW()),
    ('15 Phạm Văn Đồng, Bắc Từ Liêm, Hà Nội', 'Sân rộng, có bãi đỗ xe', NOW()),
    ('21 Cách Mạng Tháng 8, Cầu Giấy, Hà Nội', 'Sân mini tiêu chuẩn', NOW()),
    ('9 Nguyễn Huệ, Hoàn Kiếm, Hà Nội', 'Sân bóng gần trung tâm thương mại', NOW()),
    ('77 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội', 'Cụm sân phục vụ giải phong trào', NOW()),
    ('102 Trường Chinh, Thanh Xuân, Hà Nội', 'Cụm sân mini mới mở', NOW());

-- 7. Sân bóng
CREATE TABLE pitch (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       pitch_name VARCHAR(50),
                       price FLOAT,
                       description VARCHAR(500),
                       big_pitch_id INT,
                       pitch_type VARCHAR(50),
                       createddate DATETIME,
                       modifieddate DATETIME,
                       createdby VARCHAR(50),
                       modifiedby VARCHAR(50),
                       FOREIGN KEY (big_pitch_id) REFERENCES big_pitch(id)
);

INSERT INTO pitch (pitch_name, price, pitch_type, description, big_pitch_id)
VALUES
    ('Sân A1', 500000, 'Sân 5 người', 'Sân 5 người, mặt cỏ nhân tạo', 1),
    ('Sân A2', 600000, 'Sân 7 người', 'Sân 7 người, mặt cỏ tự nhiên', 1),
    ('Sân A3', 550000, 'Sân 5 người', 'Sân 5 người, mặt cỏ nhân tạo mới', 1),
    ('Sân A4', 650000, 'Sân 7 người', 'Sân 7 người, cỏ tự nhiên, có đèn chiếu sáng', 1),
    ('Sân B1', 400000, 'Sân 5 người', 'Sân 5 người, khu vực ngoại ô', 2),
    ('Sân B2', 700000, 'Sân 11 người', 'Sân 11 người, chuẩn FIFA', 2),
    ('Sân B3', 450000, 'Sân 5 người', 'Sân 5 người, khu vực ngoại ô, yên tĩnh', 2),
    ('Sân B4', 750000, 'Sân 11 người', 'Sân 11 người, chuẩn FIFA, có phòng thay đồ', 2),
    ('Sân C1', 500000, 'Sân 5 người', 'Sân 5 người, khu trung tâm quận Hà Đông', 3),
    ('Sân C2', 700000, 'Sân 7 người', 'Sân 7 người, mặt cỏ tự nhiên, gần bãi đỗ xe', 3);


-- 8. Hợp đồng
CREATE TABLE contract (
                          id INT PRIMARY KEY AUTO_INCREMENT,
                          start_date DATE,
                          end_date DATE,
                          note VARCHAR(500),
                          total_rental_price FLOAT,
                          user_id BIGINT,
                          customer_id BIGINT, -- sửa INT thành BIGINT
                          FOREIGN KEY (user_id) REFERENCES `user`(id),
                          FOREIGN KEY (customer_id) REFERENCES customer(id),
                          createddate DATETIME,
                          modifieddate DATETIME,
                          createdby VARCHAR(50),
                          modifiedby VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO contract (start_date, end_date, note, total_rental_price, user_id, customer_id, createddate)
VALUES ('2025-06-01', '2025-06-30', 'Thuê theo tháng', 6000000, 1, 1, NOW());


-- 9. Hóa đơn thanh toán
CREATE TABLE payment_invoice (
                                 id INT PRIMARY KEY AUTO_INCREMENT,
                                 payment_method VARCHAR(50),
                                 payment_date DATE,
                                 total_price FLOAT,
                                 user_id BIGINT,
                                 customer_id BIGINT, -- sửa INT thành BIGINT
                                 FOREIGN KEY (user_id) REFERENCES `user`(id),
                                 FOREIGN KEY (customer_id) REFERENCES customer(id),
                                 createddate DATETIME,
                                 modifieddate DATETIME,
                                 createdby VARCHAR(50),
                                 modifiedby VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO payment_invoice (payment_method, payment_date, total_price, user_id, customer_id, createddate)
VALUES ('Tiền mặt', '2025-06-01', 6000000, 1, 1, NOW());

-- 10. Phiếu thuê sân
CREATE TABLE rental_receipt (
                                id INT PRIMARY KEY AUTO_INCREMENT,
                                session_rental_price FLOAT,
                                start_date DATE,
                                end_date DATE,
                                deposit FLOAT,
                                total_price FLOAT,

                                status INT NOT NULL DEFAULT 0 COMMENT '0: CHUA_THANH_TOAN, 1: DA_THANH_TOAN, 2: HUY',

                                payment_invoice_id INT,
                                customer_id BIGINT,

                                createddate DATETIME,
                                modifieddate DATETIME,
                                createdby VARCHAR(50),
                                modifiedby VARCHAR(50),

                                FOREIGN KEY (payment_invoice_id) REFERENCES payment_invoice(id),
                                FOREIGN KEY (customer_id) REFERENCES customer(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 11. Chi tiết thuê sân
CREATE TABLE pitch_rental_detail (
                                     id INT PRIMARY KEY AUTO_INCREMENT,
                                     date DATE,
                                     start_date DATE,
                                     end_date DATE,
                                     note VARCHAR(500),
                                     pitch_id INT,
                                     rental_receipt_id INT,
                                     FOREIGN KEY (pitch_id) REFERENCES pitch(id),
                                     FOREIGN KEY (rental_receipt_id) REFERENCES rental_receipt(id),
                                     createddate DATETIME,
                                     modifieddate DATETIME,
                                     createdby VARCHAR(50),
                                     modifiedby VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 12. Mặt hàng
CREATE TABLE item (
                      id INT PRIMARY KEY AUTO_INCREMENT,
                      item_name VARCHAR(50),
                      current_quantity INT,
                      item_type VARCHAR(50),
                      price FLOAT,
                      createddate DATETIME,
                      modifieddate DATETIME,
                      createdby VARCHAR(50),
                      modifiedby VARCHAR(50)
);
INSERT INTO item (item_name, current_quantity, item_type, price, createddate) VALUES
                                                                                  ('Nước suối Aquafina', 100, 'Nước', 10000, NOW()),
                                                                                  ('Nước tăng lực Red Bull', 50, 'Nước', 25000, NOW()),
                                                                                  ('Bánh quy Oreo', 200, 'Bánh kẹo', 15000, NOW()),
                                                                                  ('Snack Khoai Tây Lay\'s', 150, 'Bánh kẹo', 12000, NOW()),
('Trà Lipton Chanh', 80, 'Nước', 18000, NOW()),
('Nước ngọt Coca-Cola', 120, 'Nước', 15000, NOW()),
('Nước ngọt Pepsi', 100, 'Nước', 15000, NOW()),
('Bánh Gato Mini', 60, 'Bánh kẹo', 30000, NOW()),
('Snack Hạnh Nhân', 90, 'Bánh kẹo', 22000, NOW()),
('Sữa tươi Vinamilk', 70, 'Nước', 20000, NOW());

CREATE TABLE used_item (
  id INT PRIMARY KEY AUTO_INCREMENT,
  quantity INT,
  sell_price FLOAT,
  item_id INT,
  rental_receipt_id INT,
  FOREIGN KEY (item_id) REFERENCES item(id),
  FOREIGN KEY (rental_receipt_id) REFERENCES rental_receipt(id),
  createddate DATETIME,
  modifieddate DATETIME,
  createdby VARCHAR(50),
  modifiedby VARCHAR(50)
);

CREATE TABLE purchase_invoice (
  id INT PRIMARY KEY AUTO_INCREMENT,
  total_price FLOAT,
  user_id BIGINT,
  supplier_id INT,
  FOREIGN KEY (user_id) REFERENCES `user`(id),
  FOREIGN KEY (supplier_id) REFERENCES supplier(id),
  createddate DATETIME,
  modifieddate DATETIME,
  createdby VARCHAR(50),
  modifiedby VARCHAR(50)
);

INSERT INTO purchase_invoice (total_price, user_id, supplier_id, createddate)
VALUES 
(1000000, 1, 1, NOW());

CREATE TABLE purchase_detail (
  id INT PRIMARY KEY AUTO_INCREMENT,
  quantity INT,
  note VARCHAR(500),
  purchase_invoice_id INT,
  item_id INT,
  FOREIGN KEY (purchase_invoice_id) REFERENCES purchase_invoice(id),
  FOREIGN KEY (item_id) REFERENCES item(id),
  createddate DATETIME,
  modifieddate DATETIME,
  createdby VARCHAR(50),
  modifiedby VARCHAR(50)
);
INSERT INTO purchase_detail (quantity, note, purchase_invoice_id, item_id, createddate)
VALUES 
(50, 'Nhập hàng đợt 1', 1, 1, NOW());

DROP TABLE IF EXISTS `transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `customerid` bigint(20) NOT NULL,
  `createddate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  `staffid` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_customer_transaction` (`customerid`),
  CONSTRAINT `fk_customer_transaction` FOREIGN KEY (`customerid`) REFERENCES `customer` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `assignmentcustomer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `assignmentcustomer` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `staffid` bigint(20) NOT NULL,
  `customerid` bigint(20) NOT NULL,
  `createddate` datetime DEFAULT NULL,
  `modifieddate` datetime DEFAULT NULL,
  `createdby` varchar(255) DEFAULT NULL,
  `modifiedby` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_user_customer` (`staffid`),
  KEY `fk_customer_user` (`customerid`),
  CONSTRAINT `fk_customer_user` FOREIGN KEY (`customerid`) REFERENCES `customer` (`id`),
  CONSTRAINT `fk_user_customer` FOREIGN KEY (`staffid`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;