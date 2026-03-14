USE family_tree_db;

-- 1) Create media_album table if missing
CREATE TABLE IF NOT EXISTS `media_album` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `description` text DEFAULT NULL,
    `cover_url` varchar(500) DEFAULT NULL,
    `person_id` bigint(20) DEFAULT NULL,
    `branch_id` bigint(20) DEFAULT NULL,
    `uploader_id` bigint(20) DEFAULT NULL,
    `access_scope` varchar(20) NOT NULL,
    `createddate` datetime DEFAULT NULL,
    `modifieddate` datetime DEFAULT NULL,
    `createdby` varchar(255) DEFAULT NULL,
    `modifiedby` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_media_album_person` (`person_id`),
    KEY `idx_media_album_branch` (`branch_id`),
    KEY `idx_media_album_uploader` (`uploader_id`),
    CONSTRAINT `fk_media_album_person` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT `fk_media_album_branch` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT `fk_media_album_uploader` FOREIGN KEY (`uploader_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2) Ensure media.album_id exists
SET @has_album_col := (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE BINARY TABLE_SCHEMA = BINARY DATABASE()
      AND TABLE_NAME = 'media'
      AND COLUMN_NAME = 'album_id'
);

SET @sql_add_album_col := IF(
    @has_album_col = 0,
    'ALTER TABLE `media` ADD COLUMN `album_id` bigint(20) DEFAULT NULL',
    'SELECT 1'
);
PREPARE stmt FROM @sql_add_album_col;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 3) Ensure index for media.album_id exists
SET @has_album_idx := (
    SELECT COUNT(*)
    FROM information_schema.STATISTICS
    WHERE BINARY TABLE_SCHEMA = BINARY DATABASE()
      AND TABLE_NAME = 'media'
      AND INDEX_NAME = 'idx_media_album'
);

SET @sql_add_album_idx := IF(
    @has_album_idx = 0,
    'ALTER TABLE `media` ADD KEY `idx_media_album` (`album_id`)',
    'SELECT 1'
);
PREPARE stmt FROM @sql_add_album_idx;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4) Ensure FK media.album_id -> media_album.id exists
SET @has_album_fk := (
    SELECT COUNT(*)
    FROM information_schema.REFERENTIAL_CONSTRAINTS
    WHERE BINARY CONSTRAINT_SCHEMA = BINARY DATABASE()
      AND CONSTRAINT_NAME = 'fk_media_album'
);

SET @sql_add_album_fk := IF(
    @has_album_fk = 0,
    'ALTER TABLE `media` ADD CONSTRAINT `fk_media_album` FOREIGN KEY (`album_id`) REFERENCES `media_album` (`id`) ON DELETE SET NULL ON UPDATE CASCADE',
    'SELECT 1'
);
PREPARE stmt FROM @sql_add_album_fk;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
