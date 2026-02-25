-- DROP database family_tree_db;
CREATE DATABASE family_tree_db;
USE family_tree_db;

-- vai trò
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
INSERT INTO `role` 
VALUES 
(1,'Quản lý','MANAGER',NULL,NULL,NULL,NULL),
(2,'Editor','EDITOR',NULL,NULL,NULL,NULL),
(3,'Người dùng','USER',NULL,NULL,NULL,NULL);

-- người dùng
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


-- BRANCH
DROP TABLE IF EXISTS `branch`;
SET character_set_client = utf8mb4 ;
CREATE TABLE `branch` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `description` text DEFAULT NULL,

    `createddate` datetime DEFAULT NULL,
    `modifieddate` datetime DEFAULT NULL,
    `createdby` varchar(255) DEFAULT NULL,
    `modifiedby` varchar(255) DEFAULT NULL,

    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- PERSON
DROP TABLE IF EXISTS `person`;
SET character_set_client = utf8mb4 ;
CREATE TABLE `person` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `branch_id` bigint(20) NOT NULL,
    `user_id` bigint(20) DEFAULT NULL,
    `fullname` varchar(255) NOT NULL,
    `gender` varchar(20) DEFAULT NULL,
    `avatar` longtext DEFAULT NULL,
    `dob` date DEFAULT NULL,
    `dod` date DEFAULT NULL,
    `generation` int(11) DEFAULT NULL,
    `father_id` bigint(20) DEFAULT NULL,
    `mother_id` bigint(20) DEFAULT NULL,

    -- NEW: spouse relation
    `spouse_id` bigint(20) DEFAULT NULL,

    `createddate` datetime DEFAULT NULL,
    `modifieddate` datetime DEFAULT NULL,
    `createdby` varchar(255) DEFAULT NULL,
    `modifiedby` varchar(255) DEFAULT NULL,

    PRIMARY KEY (`id`),

    KEY `fk_person_branch` (`branch_id`),
    UNIQUE KEY `uk_person_user` (`user_id`),
    KEY `fk_person_father` (`father_id`),
    KEY `fk_person_mother` (`mother_id`),

    -- NEW: spouse indexes
    KEY `fk_person_spouse` (`spouse_id`),
    UNIQUE KEY `uk_person_spouse` (`spouse_id`),

    CONSTRAINT `fk_person_branch`
        FOREIGN KEY (`branch_id`) REFERENCES `branch` (`id`),

    CONSTRAINT `fk_person_father`
        FOREIGN KEY (`father_id`) REFERENCES `person` (`id`)
        ON DELETE SET NULL ON UPDATE CASCADE,

    CONSTRAINT `fk_person_mother`
        FOREIGN KEY (`mother_id`) REFERENCES `person` (`id`)
        ON DELETE SET NULL ON UPDATE CASCADE,

    -- NEW: spouse FK
    CONSTRAINT `fk_person_spouse`
        FOREIGN KEY (`spouse_id`) REFERENCES `person` (`id`)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- MEDIA
DROP TABLE IF EXISTS `media`;
SET character_set_client = utf8mb4 ;
CREATE TABLE `media` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `file_url` varchar(500) NOT NULL,
    `media_type` varchar(50) NOT NULL,
    `person_id` bigint(20) DEFAULT NULL,
    `branch_id` bigint(20) DEFAULT NULL,
    `uploader_id` bigint(20) NOT NULL,

    `createddate` datetime DEFAULT NULL,
    `modifieddate` datetime DEFAULT NULL,
    `createdby` varchar(255) DEFAULT NULL,
    `modifiedby` varchar(255) DEFAULT NULL,

    PRIMARY KEY (`id`),

    KEY `fk_media_person` (`person_id`),
    KEY `fk_media_branch` (`branch_id`),
    KEY `fk_media_uploader` (`uploader_id`),

    CONSTRAINT `fk_media_person`
        FOREIGN KEY (`person_id`) REFERENCES `person` (`id`)
        ON DELETE SET NULL ON UPDATE CASCADE,

    CONSTRAINT `fk_media_branch`
        FOREIGN KEY (`branch_id`) REFERENCES `branch` (`id`)
        ON DELETE SET NULL ON UPDATE CASCADE,

    CONSTRAINT `fk_media_uploader`
        FOREIGN KEY (`uploader_id`) REFERENCES `user` (`id`)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- LIVESTREAM
DROP TABLE IF EXISTS `livestream`;
SET character_set_client = utf8mb4 ;
CREATE TABLE `livestream` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `title` varchar(255) NOT NULL,
    `stream_url` varchar(500) NOT NULL,
    `status` int(11) NOT NULL,
    `branch_id` bigint(20) NOT NULL,
    `host_id` bigint(20) NOT NULL,

    `createddate` datetime DEFAULT NULL,
    `modifieddate` datetime DEFAULT NULL,
    `createdby` varchar(255) DEFAULT NULL,
    `modifiedby` varchar(255) DEFAULT NULL,

    PRIMARY KEY (`id`),

    KEY `fk_livestream_branch` (`branch_id`),
    KEY `fk_livestream_host` (`host_id`),

    CONSTRAINT `fk_livestream_branch`
        FOREIGN KEY (`branch_id`) REFERENCES `branch` (`id`)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT `fk_livestream_host`
        FOREIGN KEY (`host_id`) REFERENCES `user` (`id`)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ACTIVITYLOG
DROP TABLE IF EXISTS `activitylog`;
SET character_set_client = utf8mb4 ;
CREATE TABLE `activitylog` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `user_id` bigint(20) NOT NULL,
    `action` varchar(255) NOT NULL,
    `description` text DEFAULT NULL,
    `timestamp` datetime NOT NULL,

    `createddate` datetime DEFAULT NULL,
    `modifieddate` datetime DEFAULT NULL,
    `createdby` varchar(255) DEFAULT NULL,
    `modifiedby` varchar(255) DEFAULT NULL,

    PRIMARY KEY (`id`),

    KEY `fk_activitylog_user` (`user_id`),

    CONSTRAINT `fk_activitylog_user`
        FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
