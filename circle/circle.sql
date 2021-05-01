/*
 Navicat Premium Data Transfer

 Source Server         : 10.0.0.201
 Source Server Type    : MySQL
 Source Server Version : 50733
 Source Host           : 10.0.0.201:3306
 Source Schema         : circle

 Target Server Type    : MySQL
 Target Server Version : 50733
 File Encoding         : 65001

 Date: 02/05/2021 06:45:26
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `video_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES (1, '这是我的第一篇文章😀', NULL, 1, '2021-04-10 18:35:03');
INSERT INTO `article` VALUES (2, '这是我的第二篇文章,这是我的第二篇文章,这是我的第二篇文章,这是我的第二篇文章,这是我的第二篇文章,这是我的第二篇文章,这是我的第二篇文章,这是我的第二篇文章,这是我的第二篇文章,这是我的第二篇文章,这是我的第二篇文章,这是我的第二篇文章,这是我的第二篇文章', 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/SampleVideo_720x480_10mb.mp4', 1, '2021-04-10 18:35:03');
INSERT INTO `article` VALUES (3, '这是我的第三篇文章', NULL, 1, '2021-04-10 18:35:03');
INSERT INTO `article` VALUES (4, '这是我的第四篇文章', NULL, 1, '2021-04-10 18:35:03');
INSERT INTO `article` VALUES (5, '这是我的第五篇文章', NULL, 1, '2021-04-10 18:35:03');
INSERT INTO `article` VALUES (6, '这是余文艳写的第一篇文章', NULL, 2, '2021-04-10 18:35:03');
INSERT INTO `article` VALUES (7, '这是余文艳写的第二篇文章', NULL, 2, '2021-04-10 18:35:03');
INSERT INTO `article` VALUES (8, '这是余文艳写的第三篇文章', NULL, 2, '2021-04-10 18:35:03');
INSERT INTO `article` VALUES (9, '这是张凯旋写的第一篇文章', NULL, 3, '2021-04-10 18:35:03');
INSERT INTO `article` VALUES (10, '这是张凯旋写的第二篇文章', NULL, 3, '2021-04-10 18:35:03');
INSERT INTO `article` VALUES (11, '这是张凯旋写的第三篇文章', NULL, 3, '2021-04-10 18:35:03');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `from_user_id` bigint(20) UNSIGNED NOT NULL,
  `to_user_id` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `article_id` bigint(20) UNSIGNED NOT NULL,
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (1, 4, NULL, '这是蒋一天写的一篇好文章', 1, '2021-04-10 18:36:17');
INSERT INTO `comment` VALUES (2, 4, NULL, '这是蒋一天写的又一篇好文章', 2, '2021-04-10 18:36:17');
INSERT INTO `comment` VALUES (3, 5, NULL, '这是余文艳写的一篇好文章', 6, '2021-04-10 18:36:17');
INSERT INTO `comment` VALUES (4, 5, NULL, '这是余文艳写的又一篇好文章', 7, '2021-04-10 18:36:17');
INSERT INTO `comment` VALUES (5, 6, NULL, '这是张凯旋写的一篇好文章', 9, '2021-04-10 18:36:17');
INSERT INTO `comment` VALUES (6, 6, NULL, '这是张凯旋的又一篇好文章', 10, '2021-04-10 18:36:17');
INSERT INTO `comment` VALUES (7, 5, NULL, '这是蒋一天写的一篇好文章', 1, '2021-04-10 18:36:17');
INSERT INTO `comment` VALUES (9, 4, 5, '这是一篇好文章这是一篇好文章这是一篇好文章', 1, '2021-04-21 05:45:25');
INSERT INTO `comment` VALUES (14, 4, NULL, '这是一篇文章', 1, '2021-04-23 06:17:16');
INSERT INTO `comment` VALUES (16, 4, 5, '李四', 1, '2021-04-25 15:52:11');

-- ----------------------------
-- Table structure for image
-- ----------------------------
DROP TABLE IF EXISTS `image`;
CREATE TABLE `image`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `article_id` bigint(20) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of image
-- ----------------------------
INSERT INTO `image` VALUES (1, 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/image1.jpeg', 1);
INSERT INTO `image` VALUES (2, 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/image2.jpeg', 1);
INSERT INTO `image` VALUES (3, 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/image3.jpeg', 1);
INSERT INTO `image` VALUES (4, 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/image4.jpeg', 1);
INSERT INTO `image` VALUES (5, 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/image5.jpg', 1);
INSERT INTO `image` VALUES (6, 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/image6.jpg', 1);
INSERT INTO `image` VALUES (7, 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/image7.jpg', 1);
INSERT INTO `image` VALUES (8, 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/image8.jpg', 1);
INSERT INTO `image` VALUES (9, 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/image9.jpeg', 1);

-- ----------------------------
-- Table structure for like
-- ----------------------------
DROP TABLE IF EXISTS `like`;
CREATE TABLE `like`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `comment_id` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `article_id` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 111 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of like
-- ----------------------------
INSERT INTO `like` VALUES (2, NULL, 2, 4);
INSERT INTO `like` VALUES (3, NULL, 6, 5);
INSERT INTO `like` VALUES (4, NULL, 7, 5);
INSERT INTO `like` VALUES (5, NULL, 9, 6);
INSERT INTO `like` VALUES (6, NULL, 10, 6);
INSERT INTO `like` VALUES (7, 1, NULL, 7);
INSERT INTO `like` VALUES (8, 2, NULL, 8);
INSERT INTO `like` VALUES (9, NULL, 1, 9);
INSERT INTO `like` VALUES (10, NULL, 2, 10);
INSERT INTO `like` VALUES (26, NULL, 3, 4);
INSERT INTO `like` VALUES (38, NULL, 4, 4);
INSERT INTO `like` VALUES (46, NULL, 11, 4);
INSERT INTO `like` VALUES (47, NULL, 11, 4);
INSERT INTO `like` VALUES (49, NULL, 8, 4);
INSERT INTO `like` VALUES (50, NULL, 5, 4);
INSERT INTO `like` VALUES (110, NULL, 1, 4);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, '蒋一天', 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/avatars/default.jpg');
INSERT INTO `user` VALUES (2, '余文艳', 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/avatars/yuwenyan.jpeg');
INSERT INTO `user` VALUES (3, '张凯旋', 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/avatars/zhangkaixuan.jpeg');
INSERT INTO `user` VALUES (4, '张三', 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/avatars/zhangsan.jpeg');
INSERT INTO `user` VALUES (5, '李四', 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/avatars/lisi.jpeg');
INSERT INTO `user` VALUES (6, '王五', 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/avatars/wangwu.jpeg');
INSERT INTO `user` VALUES (7, '赵六', 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/avatars/zhaoliu.jpeg');
INSERT INTO `user` VALUES (8, '郑七', 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/avatars/zhenqi.jpeg');
INSERT INTO `user` VALUES (9, '刘八', 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/avatars/liuba.jpeg');
INSERT INTO `user` VALUES (10, '吴九', 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/avatars/wujiu.jpeg');
INSERT INTO `user` VALUES (11, '罗十', 'https://yitianjiang-circle.oss-cn-beijing.aliyuncs.com/avatars/luoshi.jpeg');

SET FOREIGN_KEY_CHECKS = 1;
