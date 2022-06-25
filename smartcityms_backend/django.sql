/*
 Navicat Premium Data Transfer

 Source Server         : mysql8local
 Source Server Type    : MySQL
 Source Server Version : 80029
 Source Host           : localhost:3366
 Source Schema         : django

 Target Server Type    : MySQL
 Target Server Version : 80029
 File Encoding         : 65001

 Date: 04/05/2022 14:55:53
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group
-- ----------------------------

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `group_id` int(0) NOT NULL,
  `permission_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id`, `permission_id`) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content_type_id` int(0) NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id`, `codename`) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 69 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add user', 4, 'add_user');
INSERT INTO `auth_permission` VALUES (14, 'Can change user', 4, 'change_user');
INSERT INTO `auth_permission` VALUES (15, 'Can delete user', 4, 'delete_user');
INSERT INTO `auth_permission` VALUES (16, 'Can view user', 4, 'view_user');
INSERT INTO `auth_permission` VALUES (17, 'Can add content type', 5, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (18, 'Can change content type', 5, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (19, 'Can delete content type', 5, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (20, 'Can view content type', 5, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (21, 'Can add session', 6, 'add_session');
INSERT INTO `auth_permission` VALUES (22, 'Can change session', 6, 'change_session');
INSERT INTO `auth_permission` VALUES (23, 'Can delete session', 6, 'delete_session');
INSERT INTO `auth_permission` VALUES (24, 'Can view session', 6, 'view_session');
INSERT INTO `auth_permission` VALUES (25, 'Can add 权限', 7, 'add_permission');
INSERT INTO `auth_permission` VALUES (26, 'Can change 权限', 7, 'change_permission');
INSERT INTO `auth_permission` VALUES (27, 'Can delete 权限', 7, 'delete_permission');
INSERT INTO `auth_permission` VALUES (28, 'Can view 权限', 7, 'view_permission');
INSERT INTO `auth_permission` VALUES (29, 'Can add 角色', 8, 'add_role');
INSERT INTO `auth_permission` VALUES (30, 'Can change 角色', 8, 'change_role');
INSERT INTO `auth_permission` VALUES (31, 'Can delete 角色', 8, 'delete_role');
INSERT INTO `auth_permission` VALUES (32, 'Can view 角色', 8, 'view_role');
INSERT INTO `auth_permission` VALUES (33, 'Can add 账号', 9, 'add_account');
INSERT INTO `auth_permission` VALUES (34, 'Can change 账号', 9, 'change_account');
INSERT INTO `auth_permission` VALUES (35, 'Can delete 账号', 9, 'delete_account');
INSERT INTO `auth_permission` VALUES (36, 'Can view 账号', 9, 'view_account');
INSERT INTO `auth_permission` VALUES (37, 'Can add blacklisted token', 10, 'add_blacklistedtoken');
INSERT INTO `auth_permission` VALUES (38, 'Can change blacklisted token', 10, 'change_blacklistedtoken');
INSERT INTO `auth_permission` VALUES (39, 'Can delete blacklisted token', 10, 'delete_blacklistedtoken');
INSERT INTO `auth_permission` VALUES (40, 'Can view blacklisted token', 10, 'view_blacklistedtoken');
INSERT INTO `auth_permission` VALUES (41, 'Can add outstanding token', 11, 'add_outstandingtoken');
INSERT INTO `auth_permission` VALUES (42, 'Can change outstanding token', 11, 'change_outstandingtoken');
INSERT INTO `auth_permission` VALUES (43, 'Can delete outstanding token', 11, 'delete_outstandingtoken');
INSERT INTO `auth_permission` VALUES (44, 'Can view outstanding token', 11, 'view_outstandingtoken');
INSERT INTO `auth_permission` VALUES (45, 'Can add 任务', 12, 'add_task');
INSERT INTO `auth_permission` VALUES (46, 'Can change 任务', 12, 'change_task');
INSERT INTO `auth_permission` VALUES (47, 'Can delete 任务', 12, 'delete_task');
INSERT INTO `auth_permission` VALUES (48, 'Can view 任务', 12, 'view_task');
INSERT INTO `auth_permission` VALUES (49, 'Can add 文件', 13, 'add_file');
INSERT INTO `auth_permission` VALUES (50, 'Can change 文件', 13, 'change_file');
INSERT INTO `auth_permission` VALUES (51, 'Can delete 文件', 13, 'delete_file');
INSERT INTO `auth_permission` VALUES (52, 'Can view 文件', 13, 'view_file');
INSERT INTO `auth_permission` VALUES (53, 'Can add 交通状态预测任务评价指标', 14, 'add_trafficstatepred');
INSERT INTO `auth_permission` VALUES (54, 'Can change 交通状态预测任务评价指标', 14, 'change_trafficstatepred');
INSERT INTO `auth_permission` VALUES (55, 'Can delete 交通状态预测任务评价指标', 14, 'delete_trafficstatepred');
INSERT INTO `auth_permission` VALUES (56, 'Can view 交通状态预测任务评价指标', 14, 'view_trafficstatepred');
INSERT INTO `auth_permission` VALUES (57, 'Can add 交通状态预测任务和到达时间预测评价指标', 15, 'add_trafficstatepredandeta');
INSERT INTO `auth_permission` VALUES (58, 'Can change 交通状态预测任务和到达时间预测评价指标', 15, 'change_trafficstatepredandeta');
INSERT INTO `auth_permission` VALUES (59, 'Can delete 交通状态预测任务和到达时间预测评价指标', 15, 'delete_trafficstatepredandeta');
INSERT INTO `auth_permission` VALUES (60, 'Can view 交通状态预测任务和到达时间预测评价指标', 15, 'view_trafficstatepredandeta');
INSERT INTO `auth_permission` VALUES (61, 'Can add map matching', 16, 'add_mapmatching');
INSERT INTO `auth_permission` VALUES (62, 'Can change map matching', 16, 'change_mapmatching');
INSERT INTO `auth_permission` VALUES (63, 'Can delete map matching', 16, 'delete_mapmatching');
INSERT INTO `auth_permission` VALUES (64, 'Can view map matching', 16, 'view_mapmatching');
INSERT INTO `auth_permission` VALUES (65, 'Can add 轨迹下一跳预测评价指标', 17, 'add_trajlocpred');
INSERT INTO `auth_permission` VALUES (66, 'Can change 轨迹下一跳预测评价指标', 17, 'change_trajlocpred');
INSERT INTO `auth_permission` VALUES (67, 'Can delete 轨迹下一跳预测评价指标', 17, 'delete_trajlocpred');
INSERT INTO `auth_permission` VALUES (68, 'Can view 轨迹下一跳预测评价指标', 17, 'view_trajlocpred');

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `first_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user
-- ----------------------------

-- ----------------------------
-- Table structure for auth_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NOT NULL,
  `group_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_groups_user_id_group_id_94350c0c_uniq`(`user_id`, `group_id`) USING BTREE,
  INDEX `auth_user_groups_group_id_97559544_fk_auth_group_id`(`group_id`) USING BTREE,
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user_groups
-- ----------------------------

-- ----------------------------
-- Table structure for auth_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NOT NULL,
  `permission_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq`(`user_id`, `permission_id`) USING BTREE,
  INDEX `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user_user_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `action_flag` smallint(0) UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content_type_id` int(0) NULL DEFAULT NULL,
  `user_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id`) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_auth_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label`, `model`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (4, 'auth', 'user');
INSERT INTO `django_content_type` VALUES (9, 'authentication', 'account');
INSERT INTO `django_content_type` VALUES (7, 'authentication', 'permission');
INSERT INTO `django_content_type` VALUES (8, 'authentication', 'role');
INSERT INTO `django_content_type` VALUES (13, 'business', 'file');
INSERT INTO `django_content_type` VALUES (16, 'business', 'mapmatching');
INSERT INTO `django_content_type` VALUES (12, 'business', 'task');
INSERT INTO `django_content_type` VALUES (14, 'business', 'trafficstatepred');
INSERT INTO `django_content_type` VALUES (15, 'business', 'trafficstatepredandeta');
INSERT INTO `django_content_type` VALUES (17, 'business', 'trajlocpred');
INSERT INTO `django_content_type` VALUES (5, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (6, 'sessions', 'session');
INSERT INTO `django_content_type` VALUES (10, 'token_blacklist', 'blacklistedtoken');
INSERT INTO `django_content_type` VALUES (11, 'token_blacklist', 'outstandingtoken');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 68 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'contenttypes', '0001_initial', '2021-11-19 05:34:46.181810');
INSERT INTO `django_migrations` VALUES (2, 'auth', '0001_initial', '2021-11-19 05:34:50.300884');
INSERT INTO `django_migrations` VALUES (3, 'admin', '0001_initial', '2021-11-19 05:34:51.349180');
INSERT INTO `django_migrations` VALUES (4, 'admin', '0002_logentry_remove_auto_add', '2021-11-19 05:34:51.462555');
INSERT INTO `django_migrations` VALUES (5, 'admin', '0003_logentry_add_action_flag_choices', '2021-11-19 05:34:51.576757');
INSERT INTO `django_migrations` VALUES (6, 'contenttypes', '0002_remove_content_type_name', '2021-11-19 05:34:52.194495');
INSERT INTO `django_migrations` VALUES (7, 'auth', '0002_alter_permission_name_max_length', '2021-11-19 05:34:52.563143');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0003_alter_user_email_max_length', '2021-11-19 05:34:52.770825');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0004_alter_user_username_opts', '2021-11-19 05:34:52.887204');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0005_alter_user_last_login_null', '2021-11-19 05:34:53.170425');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0006_require_contenttypes_0002', '2021-11-19 05:34:53.292284');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0007_alter_validators_add_error_messages', '2021-11-19 05:34:53.404301');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0008_alter_user_username_max_length', '2021-11-19 05:34:53.780955');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0009_alter_user_last_name_max_length', '2021-11-19 05:34:54.091130');
INSERT INTO `django_migrations` VALUES (15, 'auth', '0010_alter_group_name_max_length', '2021-11-19 05:34:54.272701');
INSERT INTO `django_migrations` VALUES (16, 'auth', '0011_update_proxy_permissions', '2021-11-19 05:34:54.538539');
INSERT INTO `django_migrations` VALUES (17, 'auth', '0012_alter_user_first_name_max_length', '2021-11-19 05:34:54.828554');
INSERT INTO `django_migrations` VALUES (18, 'authentication', '0001_initial', '2021-11-19 05:34:58.059166');
INSERT INTO `django_migrations` VALUES (19, 'sessions', '0001_initial', '2021-11-19 05:34:58.515588');
INSERT INTO `django_migrations` VALUES (20, 'authentication', '0002_auto_20211119_1518', '2021-11-19 07:19:12.452322');
INSERT INTO `django_migrations` VALUES (21, 'token_blacklist', '0001_initial', '2021-11-23 01:40:54.011042');
INSERT INTO `django_migrations` VALUES (22, 'token_blacklist', '0002_outstandingtoken_jti_hex', '2021-11-23 01:40:54.591262');
INSERT INTO `django_migrations` VALUES (23, 'token_blacklist', '0003_auto_20171017_2007', '2021-11-23 01:40:54.970867');
INSERT INTO `django_migrations` VALUES (24, 'token_blacklist', '0004_auto_20171017_2013', '2021-11-23 01:40:55.349704');
INSERT INTO `django_migrations` VALUES (25, 'token_blacklist', '0005_remove_outstandingtoken_jti', '2021-11-23 01:40:55.669504');
INSERT INTO `django_migrations` VALUES (26, 'token_blacklist', '0006_auto_20171017_2113', '2021-11-23 01:40:55.912773');
INSERT INTO `django_migrations` VALUES (27, 'token_blacklist', '0007_auto_20171017_2214', '2021-11-23 01:40:57.089218');
INSERT INTO `django_migrations` VALUES (28, 'token_blacklist', '0008_migrate_to_bigautofield', '2021-11-23 01:40:58.885166');
INSERT INTO `django_migrations` VALUES (29, 'token_blacklist', '0010_fix_migrate_to_bigautofield', '2021-11-23 01:40:59.273871');
INSERT INTO `django_migrations` VALUES (30, 'token_blacklist', '0011_linearizes_history', '2021-11-23 01:40:59.411866');
INSERT INTO `django_migrations` VALUES (31, 'business', '0001_initial', '2021-12-16 07:44:57.896393');
INSERT INTO `django_migrations` VALUES (32, 'business', '0002_alter_task_task_name', '2021-12-16 07:58:44.057125');
INSERT INTO `django_migrations` VALUES (33, 'business', '0003_auto_20211216_1732', '2021-12-16 09:32:17.437432');
INSERT INTO `django_migrations` VALUES (34, 'business', '0004_auto_20211220_0917', '2021-12-20 01:17:22.175243');
INSERT INTO `django_migrations` VALUES (35, 'business', '0005_auto_20211220_0919', '2021-12-20 01:19:54.693852');
INSERT INTO `django_migrations` VALUES (36, 'business', '0006_auto_20211220_1535', '2021-12-20 07:35:41.519671');
INSERT INTO `django_migrations` VALUES (37, 'business', '0007_task_learning_rate', '2021-12-20 07:46:24.249776');
INSERT INTO `django_migrations` VALUES (38, 'business', '0008_auto_20211220_1636', '2021-12-20 08:36:22.927095');
INSERT INTO `django_migrations` VALUES (39, 'business', '0009_auto_20211224_1447', '2021-12-24 06:47:55.232668');
INSERT INTO `django_migrations` VALUES (40, 'business', '0010_task_execute_time', '2021-12-27 09:35:24.673541');
INSERT INTO `django_migrations` VALUES (41, 'business', '0011_task_execute_end_time', '2021-12-28 05:56:44.962693');
INSERT INTO `django_migrations` VALUES (42, 'business', '0012_trafficstatepred', '2022-01-05 00:55:04.762178');
INSERT INTO `django_migrations` VALUES (43, 'business', '0013_auto_20220105_0936', '2022-01-05 01:36:48.936397');
INSERT INTO `django_migrations` VALUES (44, 'business', '0014_auto_20220105_1022', '2022-01-05 02:22:18.985077');
INSERT INTO `django_migrations` VALUES (47, 'business', '0015_mapmatching', '2022-01-05 06:40:28.120968');
INSERT INTO `django_migrations` VALUES (48, 'business', '0016_auto_20220105_1504', '2022-01-05 07:04:45.540710');
INSERT INTO `django_migrations` VALUES (49, 'business', '0017_task_execute_msg', '2022-01-05 09:02:53.940749');
INSERT INTO `django_migrations` VALUES (50, 'authentication', '0003_alter_role_description', '2022-01-06 00:56:42.548226');
INSERT INTO `django_migrations` VALUES (51, 'business', '0018_trajlocpred', '2022-01-07 01:54:08.695012');
INSERT INTO `django_migrations` VALUES (52, 'business', '0019_file_dataset_status', '2022-01-07 06:53:56.355326');
INSERT INTO `django_migrations` VALUES (53, 'authentication', '0004_alter_role_name', '2022-01-11 07:54:53.185546');
INSERT INTO `django_migrations` VALUES (54, 'authentication', '0005_alter_account_password', '2022-01-27 02:22:38.133171');
INSERT INTO `django_migrations` VALUES (55, 'business', '0020_auto_20220127_1022', '2022-01-27 02:22:38.622054');
INSERT INTO `django_migrations` VALUES (56, 'business', '0021_auto_20220127_1025', '2022-01-27 02:25:57.121472');
INSERT INTO `django_migrations` VALUES (57, 'business', '0022_file_background_id', '2022-02-17 08:42:53.221926');
INSERT INTO `django_migrations` VALUES (58, 'business', '0023_auto_20220308_1357', '2022-03-08 05:58:20.738289');
INSERT INTO `django_migrations` VALUES (59, 'business', '0024_alter_task_exp_id', '2022-03-08 06:15:02.636748');
INSERT INTO `django_migrations` VALUES (60, 'business', '0025_alter_task_log_file_name', '2022-03-09 03:03:54.932585');
INSERT INTO `django_migrations` VALUES (61, 'authentication', '0006_account_mail', '2022-03-19 10:45:16.479930');
INSERT INTO `django_migrations` VALUES (62, 'authentication', '0007_alter_account_mail', '2022-03-23 06:37:48.765478');
INSERT INTO `django_migrations` VALUES (63, 'business', '0026_auto_20220323_1437', '2022-03-23 06:37:49.625390');
INSERT INTO `django_migrations` VALUES (64, 'business', '0027_task_visibility', '2022-03-28 10:56:53.397634');
INSERT INTO `django_migrations` VALUES (65, 'business', '0028_file_file_original_name', '2022-04-30 08:24:47.955652');
INSERT INTO `django_migrations` VALUES (66, 'business', '0029_file_error_message', '2022-05-01 05:21:45.743386');
INSERT INTO `django_migrations` VALUES (67, 'business', '0030_task_task_name_show', '2022-05-04 05:21:08.838918');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_session
-- ----------------------------

-- ----------------------------
-- Table structure for map_matching
-- ----------------------------
DROP TABLE IF EXISTS `map_matching`;
CREATE TABLE `map_matching`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `RMF` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `AN` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `AL` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `task_id` bigint(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `map_matching_task_id_929888af`(`task_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of map_matching
-- ----------------------------

-- ----------------------------
-- Table structure for tb_account
-- ----------------------------
DROP TABLE IF EXISTS `tb_account`;
CREATE TABLE `tb_account`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `account_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `mail` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tb_account_account_number_fc4a79aa_uniq`(`account_number`) USING BTREE,
  UNIQUE INDEX `tb_account_mail_6f44a236_uniq`(`mail`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_account
-- ----------------------------
INSERT INTO `tb_account` VALUES (3, '2021-11-22 14:04:29.502334', '2022-03-29 06:25:35.108416', 'admin', 'pbkdf2_sha256$260000$qOPXQPWgcalBnC1suXa3GJ$gOCHFmVrlm/g1gfODeHo8i+WSPJP52zsEahPmuombCM=', '2021-11-22 14:04:13.565000', '321@qq.com');
INSERT INTO `tb_account` VALUES (14, '2022-03-22 10:00:17.964629', '2022-03-22 10:00:17.964629', 'test1', 'pbkdf2_sha256$260000$9TyfUlOtsRa7pu7SDI0DWP$4aQeLqTTTsu1h4wgaRDI6M+ODrMRxTyvJNkwUlKw8do=', NULL, 'd@163.com');
INSERT INTO `tb_account` VALUES (15, '2022-03-22 10:12:49.034190', '2022-03-22 10:12:49.034190', '123@aa.com', 'pbkdf2_sha256$260000$1Jhd852ZcFZV6lsxFiMt1v$bNs5hMBrkKlHbO6+3Gax/oWqYpSpaoDfS312yqXUyKs=', NULL, '111113@aa.com');
INSERT INTO `tb_account` VALUES (16, '2022-03-28 09:28:56.000000', '2022-05-04 06:19:51.625719', 'ceshi', 'pbkdf2_sha256$260000$LyS8k3rxhn1NakxiHLJdL7$u3e+3fb+tV2eovjTZtyONJICGcnoVKREgTkUTCyNhR0=', NULL, '52@qq.com');
INSERT INTO `tb_account` VALUES (17, '2022-03-28 09:41:02.073040', '2022-03-28 09:41:02.073040', 'test12', 'pbkdf2_sha256$260000$6buS1fQYQxvlczleT8wXrI$N36+vN4TRg/P8gBUnHIncGdsweqWbkj+zS5F5EIXdUE=', NULL, 'd@gmail.com');

-- ----------------------------
-- Table structure for tb_account_roles
-- ----------------------------
DROP TABLE IF EXISTS `tb_account_roles`;
CREATE TABLE `tb_account_roles`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `account_id` bigint(0) NOT NULL,
  `role_id` bigint(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tb_account_roles_account_id_role_id_608f5ea8_uniq`(`account_id`, `role_id`) USING BTREE,
  INDEX `tb_account_roles_role_id_8e729436_fk_tb_role_id`(`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_account_roles
-- ----------------------------
INSERT INTO `tb_account_roles` VALUES (2, 3, 6);
INSERT INTO `tb_account_roles` VALUES (15, 14, 12);
INSERT INTO `tb_account_roles` VALUES (16, 15, 12);
INSERT INTO `tb_account_roles` VALUES (17, 16, 12);
INSERT INTO `tb_account_roles` VALUES (18, 17, 12);

-- ----------------------------
-- Table structure for tb_file
-- ----------------------------
DROP TABLE IF EXISTS `tb_file`;
CREATE TABLE `tb_file`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `file_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `file_size` bigint(0) NULL DEFAULT NULL,
  `file_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `extract_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `dataset_status` int(0) NOT NULL,
  `background_id` int(0) NOT NULL,
  `creator_id` bigint(0) NULL DEFAULT NULL,
  `visibility` int(0) NOT NULL,
  `file_original_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `error_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `tb_file_creator_id_ca69c6d2`(`creator_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_file
-- ----------------------------

-- ----------------------------
-- Table structure for tb_permission
-- ----------------------------
DROP TABLE IF EXISTS `tb_permission`;
CREATE TABLE `tb_permission`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `parent_id` bigint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `tb_permission_parent_id_ed335716_fk_tb_permission_id`(`parent_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_permission
-- ----------------------------
INSERT INTO `tb_permission` VALUES (1, '2021-11-22 14:02:52.924872', '2021-11-22 14:02:53.097085', '系统最高权限', 'menu', 'admin', NULL);
INSERT INTO `tb_permission` VALUES (2, '2021-11-23 08:45:53.288643', '2021-11-23 08:45:53.648575', '账号管理', 'menu', 'accountManage', NULL);
INSERT INTO `tb_permission` VALUES (3, '2021-11-23 08:46:58.218920', '2021-11-23 08:46:58.538658', '角色管理', 'menu', 'roleManage', NULL);
INSERT INTO `tb_permission` VALUES (9, '2021-11-23 08:57:23.471317', '2021-11-23 08:57:23.471317', '添加账号', 'interface', 'accountAdd', 2);
INSERT INTO `tb_permission` VALUES (10, '2021-11-23 08:57:55.951116', '2021-11-23 08:57:55.951116', '编辑账号', 'interface', 'accountEdit', 2);
INSERT INTO `tb_permission` VALUES (11, '2021-11-23 08:58:07.950965', '2021-11-23 08:58:07.950965', '删除账号', 'interface', 'accountDelete', 2);
INSERT INTO `tb_permission` VALUES (12, '2021-11-23 09:00:54.863040', '2021-11-23 09:00:54.863040', '添加角色', 'interface', 'roleAdd', 3);
INSERT INTO `tb_permission` VALUES (13, '2021-11-23 09:01:16.588003', '2021-11-23 09:01:16.588003', '编辑角色', 'interface', 'roleEdit', 3);
INSERT INTO `tb_permission` VALUES (14, '2021-11-23 09:01:29.459712', '2021-11-23 09:01:29.459712', '删除角色', 'interface', 'roleDelete', 3);
INSERT INTO `tb_permission` VALUES (15, '2021-12-17 07:52:49.155000', '2021-12-17 07:53:52.940451', '数据集管理', 'menu', 'datasetManage', NULL);
INSERT INTO `tb_permission` VALUES (16, '2021-12-17 07:54:15.296000', '2021-12-17 07:54:45.109156', '数据集上传/下载', 'interface', 'datasetUpload', 15);
INSERT INTO `tb_permission` VALUES (17, '2021-12-17 07:54:15.296000', '2021-12-17 07:55:11.137160', '删除数据集', 'interface', 'datasetDelete', 15);
INSERT INTO `tb_permission` VALUES (18, '2021-12-21 08:24:50.456000', '2021-12-21 08:25:13.811238', '新建实验', 'menu', 'tasksAdd', NULL);
INSERT INTO `tb_permission` VALUES (19, '2021-12-21 08:24:50.456000', '2021-12-21 08:25:37.013735', '实验列表', 'menu', 'taskList', NULL);
INSERT INTO `tb_permission` VALUES (20, '2021-12-21 08:24:50.456000', '2021-12-21 08:26:22.890470', '编辑实验', 'interface', 'taskEdit', 19);
INSERT INTO `tb_permission` VALUES (21, '2021-12-21 08:24:50.456000', '2021-12-21 08:26:35.968260', '删除实验', 'interface', 'taskDelete', 19);
INSERT INTO `tb_permission` VALUES (22, '2021-12-21 08:24:50.456000', '2021-12-21 08:26:49.901613', '执行实验', 'interface', 'taskExecute', 19);
INSERT INTO `tb_permission` VALUES (23, '2022-03-21 06:42:36.242000', '2022-03-21 06:43:12.627839', '查看账号列表', 'interface', 'accountList', 2);
INSERT INTO `tb_permission` VALUES (24, '2022-03-21 06:42:36.242000', '2022-03-21 06:45:13.783040', '查看角色列表', 'interface', 'roleList', 3);
INSERT INTO `tb_permission` VALUES (25, '2022-03-21 06:42:36.242000', '2022-03-21 06:47:04.173341', '查看数据集列表', 'interface', 'datasetList', 15);
INSERT INTO `tb_permission` VALUES (26, '2022-03-21 06:42:36.242000', '2022-03-21 06:48:48.702956', '查看实验列表', 'interface', 'expList', 19);

-- ----------------------------
-- Table structure for tb_role
-- ----------------------------
DROP TABLE IF EXISTS `tb_role`;
CREATE TABLE `tb_role`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tb_role_name_32629d38_uniq`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_role
-- ----------------------------
INSERT INTO `tb_role` VALUES (6, '2021-11-24 06:40:46.425480', '2021-11-24 06:40:46.426477', '系统管理员', '拥有系统最高权限');
INSERT INTO `tb_role` VALUES (12, '2022-03-19 11:25:42.000000', '2022-03-28 09:29:38.598781', '普通用户', '新注册用户默认角色');
INSERT INTO `tb_role` VALUES (14, '2022-03-21 10:19:24.549252', '2022-03-21 10:19:24.549252', '测试用户角色', '测试用户角色');

-- ----------------------------
-- Table structure for tb_role_permissions
-- ----------------------------
DROP TABLE IF EXISTS `tb_role_permissions`;
CREATE TABLE `tb_role_permissions`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `role_id` bigint(0) NOT NULL,
  `permission_id` bigint(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tb_role_permissions_role_id_permission_id_0884ad22_uniq`(`role_id`, `permission_id`) USING BTREE,
  INDEX `tb_role_permissions_permission_id_054c7c00_fk_tb_permission_id`(`permission_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 74 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_role_permissions
-- ----------------------------
INSERT INTO `tb_role_permissions` VALUES (10, 6, 1);
INSERT INTO `tb_role_permissions` VALUES (21, 12, 15);
INSERT INTO `tb_role_permissions` VALUES (22, 12, 16);
INSERT INTO `tb_role_permissions` VALUES (23, 12, 17);
INSERT INTO `tb_role_permissions` VALUES (25, 12, 19);
INSERT INTO `tb_role_permissions` VALUES (26, 12, 20);
INSERT INTO `tb_role_permissions` VALUES (27, 12, 21);
INSERT INTO `tb_role_permissions` VALUES (28, 12, 22);
INSERT INTO `tb_role_permissions` VALUES (57, 12, 25);
INSERT INTO `tb_role_permissions` VALUES (58, 12, 26);
INSERT INTO `tb_role_permissions` VALUES (49, 14, 2);
INSERT INTO `tb_role_permissions` VALUES (50, 14, 3);
INSERT INTO `tb_role_permissions` VALUES (51, 14, 9);
INSERT INTO `tb_role_permissions` VALUES (52, 14, 10);
INSERT INTO `tb_role_permissions` VALUES (53, 14, 11);
INSERT INTO `tb_role_permissions` VALUES (54, 14, 12);
INSERT INTO `tb_role_permissions` VALUES (55, 14, 13);
INSERT INTO `tb_role_permissions` VALUES (56, 14, 14);

-- ----------------------------
-- Table structure for tb_task
-- ----------------------------
DROP TABLE IF EXISTS `tb_task`;
CREATE TABLE `tb_task`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `update_time` datetime(6) NOT NULL,
  `task_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `task_description` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `task_status` int(0) NOT NULL,
  `task` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `model` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `dataset` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `config_file` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `saved_model` tinyint(1) NULL DEFAULT NULL,
  `train` tinyint(1) NULL DEFAULT NULL,
  `batch_size` bigint(0) NULL DEFAULT NULL,
  `train_rate` double NULL DEFAULT NULL,
  `eval_rate` double NULL DEFAULT NULL,
  `max_epoch` int(0) NULL DEFAULT NULL,
  `gpu` tinyint(1) NULL DEFAULT NULL,
  `gpu_id` int(0) NULL DEFAULT NULL,
  `creator_id` bigint(0) NULL DEFAULT NULL,
  `learning_rate` double NULL DEFAULT NULL,
  `execute_time` datetime(6) NULL DEFAULT NULL,
  `execute_end_time` datetime(6) NULL DEFAULT NULL,
  `execute_msg` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `exp_id` int(0) NULL DEFAULT NULL,
  `log_file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `visibility` int(0) NOT NULL,
  `task_name_show` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `tb_task_task_name_cbc8821d_uniq`(`task_name`) USING BTREE,
  INDEX `tb_task_creator_id_2e465b67`(`creator_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_task
-- ----------------------------

-- ----------------------------
-- Table structure for token_blacklist_blacklistedtoken
-- ----------------------------
DROP TABLE IF EXISTS `token_blacklist_blacklistedtoken`;
CREATE TABLE `token_blacklist_blacklistedtoken`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `blacklisted_at` datetime(6) NOT NULL,
  `token_id` bigint(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `token_id`(`token_id`) USING BTREE,
  CONSTRAINT `token_blacklist_blacklistedtoken_token_id_3cc7fe56_fk` FOREIGN KEY (`token_id`) REFERENCES `token_blacklist_outstandingtoken` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of token_blacklist_blacklistedtoken
-- ----------------------------

-- ----------------------------
-- Table structure for token_blacklist_outstandingtoken
-- ----------------------------
DROP TABLE IF EXISTS `token_blacklist_outstandingtoken`;
CREATE TABLE `token_blacklist_outstandingtoken`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `token` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime(6) NULL DEFAULT NULL,
  `expires_at` datetime(6) NOT NULL,
  `user_id` bigint(0) NULL DEFAULT NULL,
  `jti` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_uniq`(`jti`) USING BTREE,
  INDEX `token_blacklist_outs_user_id_83bc629a_fk_tb_accoun`(`user_id`) USING BTREE,
  CONSTRAINT `token_blacklist_outs_user_id_83bc629a_fk_tb_accoun` FOREIGN KEY (`user_id`) REFERENCES `tb_account` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 201 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of token_blacklist_outstandingtoken
-- ----------------------------
INSERT INTO `token_blacklist_outstandingtoken` VALUES (2, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzNzcyMDY4MCwiaWF0IjoxNjM3NjM0MjgwLCJqdGkiOiIzOWJiMTdmOGJiYTI0NTc4YTc3NTFjMThlZTFjNTk5ZCIsInVzZXJfaWQiOjN9.oEf9btdUUYiwT_-H4TbLzgX2-eZFtEkqbltJBhcglIY', '2021-11-23 02:24:40.091559', '2021-11-24 02:24:40.000000', 3, '39bb17f8bba24578a7751c18ee1c599d');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (3, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzNzcyMDg2MSwiaWF0IjoxNjM3NjM0NDYxLCJqdGkiOiJkZTI2NDg4YWY5OWM0YWYwYTFiYzk2MzBhZmI4OTY0ZiIsInVzZXJfaWQiOjN9.FRe9Rqeqo29zFd9DoqMYa4XvwdeNUD2s6tMqfyojCAE', '2021-11-23 02:27:41.154800', '2021-11-24 02:27:41.000000', 3, 'de26488af99c4af0a1bc9630afb8964f');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzNzcyNDM5MCwiaWF0IjoxNjM3NjM3OTkwLCJqdGkiOiI4NmUwNGM4ODEyMDY0ZmE2OWI3ZTBkNmYzNWM5ZGY5MyIsInVzZXJfaWQiOjN9.x4Kjqzz2xdv-nyWqBjuBbFqVmJGjdCJMVW2HppZJIyU', '2021-11-23 03:26:30.065737', '2021-11-24 03:26:30.000000', 3, '86e04c8812064fa69b7e0d6f35c9df93');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (5, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzNzcyNTg5MCwiaWF0IjoxNjM3NjM5NDkwLCJqdGkiOiJhZTI4NjAxYjE1YjE0ZGQzOWMyZTY1N2E3M2E1Yzc0NiIsInVzZXJfaWQiOjN9.7bqiJ2A49dpIHDMV0ELWvVa-qFq4siMfL-neGy6TPpI', '2021-11-23 03:51:30.679177', '2021-11-24 03:51:30.000000', 3, 'ae28601b15b14dd39c2e657a73a5c746');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (6, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzNzczODkyNiwiaWF0IjoxNjM3NjUyNTI2LCJqdGkiOiI5MGUxNjYxZTMwNGI0YjEyYWI2NDZiNDM5NjFjZDkxZSIsInVzZXJfaWQiOjN9.yVjkW6we1LUfYvlB2Kag6FGz2rK60ZYY9Cf0qLBLJrs', '2021-11-23 07:28:46.681954', '2021-11-24 07:28:46.000000', 3, '90e1661e304b4b12ab646b43961cd91e');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (7, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzNzc0MzM0MCwiaWF0IjoxNjM3NjU2OTQwLCJqdGkiOiI0YWI0MTYxNjBlYTk0MWJlOTRhNTg1ZjdlMGU0NDMyNCIsInVzZXJfaWQiOjN9.bG_H0yodybQ9I7D0v03RSby4Ap5jJEzcNPJyUxEmzYE', '2021-11-23 08:42:20.771771', '2021-11-24 08:42:20.000000', 3, '4ab416160ea941be94a585f7e0e44324');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (8, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzNzc2NjUyOSwiaWF0IjoxNjM3NjgwMTI5LCJqdGkiOiJkOTEyNzM4NDc4MjA0YzQyYTczNTVjMTY2MzRjMmIzZCIsInVzZXJfaWQiOjN9.-CzkkSVRZVFgi-Q6XnhGRVUI1MZv1z_1ldLS0ae3M58', '2021-11-23 15:08:49.057319', '2021-11-24 15:08:49.000000', 3, 'd912738478204c42a7355c16634c2b3d');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (9, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzNzgwNTkzMiwiaWF0IjoxNjM3NzE5NTMyLCJqdGkiOiI3ODgxMjgxOTRlYTg0Y2EzYjEwY2JiNzdjMDg2ZTY4YyIsInVzZXJfaWQiOjN9.U4L2XQe3Cq37Q83oD2ZTwoefFDsLncaa00N6if56-ro', '2021-11-24 02:05:32.426456', '2021-11-25 02:05:32.000000', 3, '788128194ea84ca3b10cbb77c086e68c');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (11, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzNzgyODQ5NywiaWF0IjoxNjM3NzQyMDk3LCJqdGkiOiJjY2ViZWVhYjU1NTI0NTJlODUyZWE5YTU3MGYyOTMzNiIsInVzZXJfaWQiOjN9.AnRKEe3UuV_REIVXWXhBW1Kt5sFCV3Ll_Py7ncViOYk', '2021-11-24 08:21:37.903762', '2021-11-25 08:21:37.000000', 3, 'ccebeeab5552452e852ea9a570f29336');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (12, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzNzg5MDMzNCwiaWF0IjoxNjM3ODAzOTM0LCJqdGkiOiJmMTI1MzYxYjc4ZWM0MDQ4OTkyY2QyNDE4ZGIzMjQzMCIsInVzZXJfaWQiOjN9.0MQyNvSO0B4Hys69UJP-TIIjlF5yBcAfq2b7w61K2mg', '2021-11-25 01:32:14.214317', '2021-11-26 01:32:14.000000', 3, 'f125361b78ec4048992cd2418db32430');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (13, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzOTYxODc0OCwiaWF0IjoxNjM5NTMyMzQ4LCJqdGkiOiI2OWI4ZjYwOTVkMTE0ZWRhOGI5NzNhN2ZlMTdmNThmZSIsInVzZXJfaWQiOjN9.TqMmzOdYJThZIFfYLpaxCMUqErp_luXfayw3e9uQhmo', '2021-12-15 01:39:08.016223', '2021-12-16 01:39:08.000000', 3, '69b8f6095d114eda8b973a7fe17f58fe');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (14, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzOTY0MjAzNywiaWF0IjoxNjM5NTU1NjM3LCJqdGkiOiI5YzZhZDIxM2ZhMzg0OTQ5YTEzNDcxZjEzZjNlNGMzOCIsInVzZXJfaWQiOjN9.STuUaAIwJvwUMuIkf8SjABA1WfFlV71wrSD_rOOX5Q0', '2021-12-15 08:07:17.143594', '2021-12-16 08:07:17.000000', 3, '9c6ad213fa384949a13471f13f3e4c38');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (15, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzOTczMjg1NywiaWF0IjoxNjM5NjQ2NDU3LCJqdGkiOiI3ZGY0NjcxM2FhNTY0YjU5YjA1ZThlMzFiMWNmM2JjNyIsInVzZXJfaWQiOjN9.nlzTosBmZKo2NW4T_ED8ufD3SzABmlNrf_YFuEotovk', '2021-12-16 09:20:57.702829', '2021-12-17 09:20:57.000000', 3, '7df46713aa564b59b05e8e31b1cf3bc7');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (16, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzOTgwODAwMiwiaWF0IjoxNjM5NzIxNjAyLCJqdGkiOiJiMTI4YjdlYjUwN2Q0NjI2YTg5MzE3NGFmYjkwOWI3YSIsInVzZXJfaWQiOjN9.eRrb2527UBhfMMvKhG6C6-jy-TopIG5gUijeCCWnKBo', '2021-12-17 06:13:22.841722', '2021-12-18 06:13:22.000000', 3, 'b128b7eb507d4626a893174afb909b7a');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (18, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MDA0NjkzMiwiaWF0IjoxNjM5OTYwNTMyLCJqdGkiOiI4ODBmMGNmZDNhOTA0YWUzYmM0MzcwZDAxNTU0ZDM0NyIsInVzZXJfaWQiOjN9.UPdHe9PzsiMCCcjuHFcyVTOnfKyvNmM3XfcNRyCrp98', '2021-12-20 00:35:32.520049', '2021-12-21 00:35:32.000000', 3, '880f0cfd3a904ae3bc4370d01554d347');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (19, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MDA1OTQ0MiwiaWF0IjoxNjM5OTczMDQyLCJqdGkiOiI4MTgzMGFjZTFkNDk0N2UxYTRmZjQ1NGQ3YWJlZDE2MiIsInVzZXJfaWQiOjN9.Lop8YoG5vbul3gwYWTRwsMZ6_t2rv59JyNnAvjNqCNc', '2021-12-20 04:04:02.823753', '2021-12-21 04:04:02.000000', 3, '81830ace1d4947e1a4ff454d7abed162');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (20, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MDA2OTIzMiwiaWF0IjoxNjM5OTgyODMyLCJqdGkiOiIxZGVhZjZkODllNjk0OTcwYjFkZmFiZTc1N2E4NzlhNCIsInVzZXJfaWQiOjN9.qd6PTnw-9IlynEoQmBl8mpxw1aEEarXYOznzAiK2blw', '2021-12-20 06:47:12.636987', '2021-12-21 06:47:12.000000', 3, '1deaf6d89e694970b1dfabe757a879a4');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (21, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MDE1NTgyMCwiaWF0IjoxNjQwMDY5NDIwLCJqdGkiOiJlODZiNWRjY2Q4OGU0M2Y0YWFmOGUyMGI1ZTQzMDU0MiIsInVzZXJfaWQiOjN9._dOhJhSZzD5IwOfeG1UhEwlu8E4aiuXDT424tbG4414', '2021-12-21 06:50:20.305631', '2021-12-22 06:50:20.000000', 3, 'e86b5dccd88e43f4aaf8e20b5e430542');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (23, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MDIyNDQ1MSwiaWF0IjoxNjQwMTM4MDUxLCJqdGkiOiJkOWI4NWZjYmVlOGE0OWJmYTU4ZTcxZDQxOTM0MDExNyIsInVzZXJfaWQiOjN9.mA1yYSfriZXGmZ9gEy1yxwJ3HKlLiiz50qx5Ptiru0A', '2021-12-22 01:54:11.220535', '2021-12-23 01:54:11.000000', 3, 'd9b85fcbee8a49bfa58e71d419340117');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (24, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MDIyOTM3MywiaWF0IjoxNjQwMTQyOTczLCJqdGkiOiIxMzJjYjE2MGIzMWU0NzJjOWM5MjVlYzVjNDhiNTdjZiIsInVzZXJfaWQiOjN9.COv1TJEOI8z5i9wV-jcCpOFWWnmLdQ9JWdaCYlE-FcA', '2021-12-22 03:16:13.250474', '2021-12-23 03:16:13.000000', 3, '132cb160b31e472c9c925ec5c48b57cf');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (25, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MDI1MTE5MywiaWF0IjoxNjQwMTY0NzkzLCJqdGkiOiJlMWFjZjNhOGEwOGI0NGZmYjJkMDgxODdkNTRiNzI5MCIsInVzZXJfaWQiOjN9.RO0ynDdVEUZDsWRPF5Ee_gqDgKxcWtuYI66LOuavZmM', '2021-12-22 09:19:53.929945', '2021-12-23 09:19:53.000000', 3, 'e1acf3a8a08b44ffb2d08187d54b7290');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (26, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MDMwNjkwMSwiaWF0IjoxNjQwMjIwNTAxLCJqdGkiOiI3NGU0Y2M5MTFhNzM0MGUwYTQ3OGRhNjM2NGQ3NGRlMSIsInVzZXJfaWQiOjN9.r0Xea2IhZlKaGAA_h3DDIjgSO7j6GMXEqqXw-AuWWS8', '2021-12-23 00:48:21.291911', '2021-12-24 00:48:21.000000', 3, '74e4cc911a7340e0a478da6364d74de1');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (27, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MDM5NzA0MiwiaWF0IjoxNjQwMzEwNjQyLCJqdGkiOiJhNWRkMjdkMDI5Njg0Zjc4YTFlYmNiOWE5NjBiYTMyZiIsInVzZXJfaWQiOjN9.do3G2uRc5n8Z_5cegXFVVqriRppuNqDsQexdRrThNmM', '2021-12-24 01:50:42.551132', '2021-12-25 01:50:42.000000', 3, 'a5dd27d029684f78a1ebcb9a960ba32f');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (28, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MDM5NzA0MiwiaWF0IjoxNjQwMzEwNjQyLCJqdGkiOiIxMTA5OGVkMmQ3YmM0MTcyOWQ4YzRhYTI1N2ViNWMwNiIsInVzZXJfaWQiOjN9.dxgCUH07AlNZaLJQklhH7RCFowcONYPH4dRrnQCBEXM', '2021-12-24 01:50:42.618297', '2021-12-25 01:50:42.000000', 3, '11098ed2d7bc41729d8c4aa257eb5c06');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (29, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MDQwMDU3MiwiaWF0IjoxNjQwMzE0MTcyLCJqdGkiOiJkZTYyMTg1MWI1OTI0ZGU5OGM1YTA1ZDFlOTFmYjZhYiIsInVzZXJfaWQiOjN9.Wj_1nyJQNfmtUl5w2VUY17aPpxAHHc7Y3YfO7e6FQnY', '2021-12-24 02:49:32.214715', '2021-12-25 02:49:32.000000', 3, 'de621851b5924de98c5a05d1e91fb6ab');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (30, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MDY1MjExOCwiaWF0IjoxNjQwNTY1NzE4LCJqdGkiOiJiOGViNjQ3NTE5ZDM0ZDNmYTRmZGY1ZmQ2ZDM0MmI0NyIsInVzZXJfaWQiOjN9.fEzutjeCC289wMbp8cTVs2Br5F57MsupZAwY22zc0es', '2021-12-27 00:41:58.070775', '2021-12-28 00:41:58.000000', 3, 'b8eb647519d34d3fa4fdf5fd6d342b47');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (31, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MDY1MjE2OSwiaWF0IjoxNjQwNTY1NzY5LCJqdGkiOiI5MDY0Y2NhNDIzZjI0NmY5OGQ4ZGRmYzhkMmI4ODIxZiIsInVzZXJfaWQiOjN9.1jD3EzMv-2ay8G_Bs0oI75QMy_2GyFF7y9MRxbEjwZg', '2021-12-27 00:42:49.465985', '2021-12-28 00:42:49.000000', 3, '9064cca423f246f98d8ddfc8d2b8821f');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (32, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MDc0MDM3MCwiaWF0IjoxNjQwNjUzOTcwLCJqdGkiOiI3OGE1OTQ1ODZiNGY0ZmFkYmUxNzQ2ZWE4OGMwNzJkNiIsInVzZXJfaWQiOjN9.8Y27P8jNE8uQ32hz2IxHijVcHzZi7bo2b9STrM0JRcI', '2021-12-28 01:12:50.517709', '2021-12-29 01:12:50.000000', 3, '78a594586b4f4fadbe1746ea88c072d6');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (33, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MDgyNzgzOCwiaWF0IjoxNjQwNzQxNDM4LCJqdGkiOiJlZmViOGY2NzcwOWY0MzEyOWNhMDg3OGRjZWJlZDkzNyIsInVzZXJfaWQiOjN9.Sb_cBI6Md7fIjVBQdFSRYVPFn575Hw-1Xz9Evs2xF7s', '2021-12-29 01:30:38.507357', '2021-12-30 01:30:38.000000', 3, 'efeb8f67709f43129ca0878dcebed937');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (34, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MDkxNDU0MCwiaWF0IjoxNjQwODI4MTQwLCJqdGkiOiIyMDQ4MDAwYWM3NmE0NDJmYTVlODc1YmE4NTU0OWQzOSIsInVzZXJfaWQiOjN9.SFQ3XP1cCJXc81hC04xxwOq8mQ6ZVDiOuS2IGNw_3Uk', '2021-12-30 01:35:40.811020', '2021-12-31 01:35:40.000000', 3, '2048000ac76a442fa5e875ba85549d39');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (35, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MTAwMTM0MSwiaWF0IjoxNjQwOTE0OTQxLCJqdGkiOiI4Mzc3ZjA3ZGQ3MjI0OGZiOGRmNGExOWYzMDIzNDg2YSIsInVzZXJfaWQiOjN9.tek6qiT3zKJvdyuOhzVztoSwXPXw35scVWkAxh34s9c', '2021-12-31 01:42:21.461552', '2022-01-01 01:42:21.000000', 3, '8377f07dd72248fb8df4a19f3023486a');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (36, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MTI4MzU0OSwiaWF0IjoxNjQxMTk3MTQ5LCJqdGkiOiI0ZTk4OTk3ZjY3ZWQ0N2JiODNmMjIzY2EwYzc5OWY5NSIsInVzZXJfaWQiOjN9.hF3QjF1Ru6FZPrfg6S2ukkhk30kci3RBTYlqhW-hBK0', '2022-01-03 08:05:49.154777', '2022-01-04 08:05:49.000000', 3, '4e98997f67ed47bb83f223ca0c799f95');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (37, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MTM2NTQzNiwiaWF0IjoxNjQxMjc5MDM2LCJqdGkiOiI3YzFiY2UzZGE1YmQ0NDFmYTRlMTBjZTY5ZGM2ZWI1ZCIsInVzZXJfaWQiOjN9.JMtkePDyeqodcNCSdU4W7hCu0GTF4LmGwaNK2ZT972Q', '2022-01-04 06:50:36.753246', '2022-01-05 06:50:36.000000', 3, '7c1bce3da5bd441fa4e10ce69dc6eb5d');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (38, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MTQ1MjQ5OSwiaWF0IjoxNjQxMzY2MDk5LCJqdGkiOiJkM2ZjZGNjZDcyZmY0MThiYWIwYWUxNzhmOTA4ODg1MyIsInVzZXJfaWQiOjN9.2eAtcaGgaJ7j7cPL6BinDm_aN0mcFW7q3xUT9Rj02Ug', '2022-01-05 07:01:39.670965', '2022-01-06 07:01:39.000000', 3, 'd3fcdccd72ff418bab0ae178f9088853');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (39, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MTUzOTMxMSwiaWF0IjoxNjQxNDUyOTExLCJqdGkiOiI1OTRhMzgxNWM0MzU0MTVmODNmMjdhMDk1MWYyNWNkMiIsInVzZXJfaWQiOjN9.hUN_ataGzOhS73Cnm9c3_RgcJx62NhW7ffy5YtQscCo', '2022-01-06 07:08:31.500148', '2022-01-07 07:08:31.000000', 3, '594a3815c435415f83f27a0951f25cd2');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (40, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MTYxMTU4OSwiaWF0IjoxNjQxNTI1MTg5LCJqdGkiOiIzY2FlOGFjNzg4MDU0MDdiYmQyMzBhMmMzNjQ2OGI4NSIsInVzZXJfaWQiOjN9.8fSH-ys2XPxJp_N42aDhwUtYgnrFgIbruZkvwplR9nU', '2022-01-07 03:13:09.629068', '2022-01-08 03:13:09.000000', 3, '3cae8ac78805407bbd230a2c36468b85');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (41, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MTYyMjY2MiwiaWF0IjoxNjQxNTM2MjYyLCJqdGkiOiIyMjNiNWJjZGJhOGM0NzY3YWU1ZTRiODc4M2MzMGRkYiIsInVzZXJfaWQiOjN9.ILmJLUCEHdkI9RBcKPWtdhVlZ3vVIzJzbKxZLPIY8VY', '2022-01-07 06:17:42.658052', '2022-01-08 06:17:42.000000', 3, '223b5bcdba8c4767ae5e4b8783c30ddb');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (42, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MTYyMjY3MiwiaWF0IjoxNjQxNTM2MjcyLCJqdGkiOiIyNmQwNGY5Yjc0NjY0NTA1ODE0YWM3YTY2MmNhNTllMiIsInVzZXJfaWQiOjN9.gP1V8swLAU9VpMonPeek_3fi__czfQR3aPs_6wUAAQM', '2022-01-07 06:17:52.739199', '2022-01-08 06:17:52.000000', 3, '26d04f9b74664505814ac7a662ca59e2');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (43, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MTYyMjY4MSwiaWF0IjoxNjQxNTM2MjgxLCJqdGkiOiJhNzdkYTRmMTQwNDA0ZGZkOWE3NWI5ODJiZjA5ZTJmOSIsInVzZXJfaWQiOjN9.NxpIj_U65NKLUQAo1UTQR0sHlR5VZlZL3om6SjrnsTA', '2022-01-07 06:18:01.649627', '2022-01-08 06:18:01.000000', 3, 'a77da4f140404dfd9a75b982bf09e2f9');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (44, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MTYyMjcxMiwiaWF0IjoxNjQxNTM2MzEyLCJqdGkiOiJhYmJkNGY5NDI2Yzg0YjI5YjcxOThlY2FmMWFhMTVlNyIsInVzZXJfaWQiOjN9.9YRAmw-4GBoia8XjzGBDFxP6oNoNvV1fRMKrPcIY2RY', '2022-01-07 06:18:32.118175', '2022-01-08 06:18:32.000000', 3, 'abbd4f9426c84b29b7198ecaf1aa15e7');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (45, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MTYyMjgwNiwiaWF0IjoxNjQxNTM2NDA2LCJqdGkiOiI5ZWU4MzdkMjQxMGY0NTdlODdkZDA4NTg0N2RiYTY1MyIsInVzZXJfaWQiOjN9.jL0JDJN8lnivkUuW2OwH57-HpvIW1za6gZmXccZUZFk', '2022-01-07 06:20:06.274487', '2022-01-08 06:20:06.000000', 3, '9ee837d2410f457e87dd085847dba653');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (46, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MTYyNDIyOCwiaWF0IjoxNjQxNTM3ODI4LCJqdGkiOiIwODUyZjE1YTM5ODM0NWM2YTBjZTA4OTI2ODE2Y2ZmZCIsInVzZXJfaWQiOjN9.TqYct6zBFp_JMh1b6DleTVsyDauQQmYLPflthqoAZyg', '2022-01-07 06:43:48.769536', '2022-01-08 06:43:48.000000', 3, '0852f15a398345c6a0ce08926816cffd');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (47, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MTg2NDMzMywiaWF0IjoxNjQxNzc3OTMzLCJqdGkiOiI2YWI2MGY4MmExYjY0MDhmYTM2N2MxNWEyMTE1MmRmZSIsInVzZXJfaWQiOjN9.Po7AjP0YrdNQeRDeAF4BnYGZXlDVQRfIaqRbgVopv9U', '2022-01-10 01:25:33.080537', '2022-01-11 01:25:33.000000', 3, '6ab60f82a1b6408fa367c15a21152dfe');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (48, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MTg2OTIxMywiaWF0IjoxNjQxNzgyODEzLCJqdGkiOiIyN2M3ZmMyYjZmYWU0NjUyYmI5NmRlMmEwMWYxMDdhOCIsInVzZXJfaWQiOjN9.zAqthaBFgdtdNLCrUHJVg7EqXjc14_n8_-JFSeAFe_0', '2022-01-10 02:46:53.715366', '2022-01-11 02:46:53.000000', 3, '27c7fc2b6fae4652bb96de2a01f107a8');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (49, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MTk2NzE4NCwiaWF0IjoxNjQxODgwNzg0LCJqdGkiOiIyNjI3MzhlMDQ4Mzg0ZTFkOTE4NWY0YjU5NDExOWFkYSIsInVzZXJfaWQiOjN9.k7Cqxh4eMMJtapDq_1mM9GwvhzObfi8FqGDOdu0JkRM', '2022-01-11 05:59:44.204505', '2022-01-12 05:59:44.000000', 3, '262738e048384e1d9185f4b594119ada');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (50, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MTk3NzI0NCwiaWF0IjoxNjQxODkwODQ0LCJqdGkiOiI4MmU3OTAzMmY0OTM0OGJkOWNlNGVkYWRhNmY3OWNjZiIsInVzZXJfaWQiOjN9.SqM4nsdK_qarCngFbRdVW1lQ1gO3OpH5lS9QAmC_p7A', '2022-01-11 08:47:24.467738', '2022-01-12 08:47:24.000000', 3, '82e79032f49348bd9ce4edada6f79ccf');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (52, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MjAzNTIxNSwiaWF0IjoxNjQxOTQ4ODE1LCJqdGkiOiJkOTUwZDk4YWI5NzE0MDRiYmJjYTVhOTU3Yjk3ODlmYyIsInVzZXJfaWQiOjN9.IaIKcABxDG9HOu2bBVMqlHIFJTKS0BIPoKPpgGxOsvE', '2022-01-12 00:53:35.092713', '2022-01-13 00:53:35.000000', 3, 'd950d98ab971404bbbca5a957b9789fc');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (57, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MjA2MzExNCwiaWF0IjoxNjQxOTc2NzE0LCJqdGkiOiIwNzYyNjQ4YjQyOWU0NmJmODAwYzhhOTEzNzEwYjJhYyIsInVzZXJfaWQiOjN9.8DJnbUG6l2ANMoEDxukjzjksI7xVQ6BPl-c1UAhCO-0', '2022-01-12 08:38:34.711589', '2022-01-13 08:38:34.000000', 3, '0762648b429e46bf800c8a913710b2ac');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (58, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MjE0MjQ1MywiaWF0IjoxNjQyMDU2MDUzLCJqdGkiOiJjMTlkNjQ4YzI0NDA0YWMxYmJlMTI5MmY4N2RkMDFlMyIsInVzZXJfaWQiOjN9.DBzfw8_vvFttLhkjVgLxj8n-sLcIMwzLWT2Jw0smfEI', '2022-01-13 06:40:53.532948', '2022-01-14 06:40:53.000000', 3, 'c19d648c24404ac1bbe1292f87dd01e3');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (59, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MjIyODg2MiwiaWF0IjoxNjQyMTQyNDYyLCJqdGkiOiI3NzZkNTBlZTRlOTE0ZDE0YWM0MjVlYWY1MGQzZDI2NiIsInVzZXJfaWQiOjN9.Vk5h-kQ_zF3ddIYZIxk37Kyo-svLWVY6-3bLbi9i5UU', '2022-01-14 06:41:02.666950', '2022-01-15 06:41:02.000000', 3, '776d50ee4e914d14ac425eaf50d3d266');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (60, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MjQ2NzcxNSwiaWF0IjoxNjQyMzgxMzE1LCJqdGkiOiI0YzRiMjUzZDhiYzk0MWY1YTU2ODIxM2Y5ODczNzhmNCIsInVzZXJfaWQiOjN9.vEPfIlCkcUCkpuWfXycCMXxOS0Kuwtf1FPIcjkc0L84', '2022-01-17 01:01:55.123843', '2022-01-18 01:01:55.000000', 3, '4c4b253d8bc941f5a568213f987378f4');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (61, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MjUwNjc2OCwiaWF0IjoxNjQyNDIwMzY4LCJqdGkiOiI2MGRmZDhmZjkwY2I0NGFkYmE4M2UyY2ZlNTAwZDNmZCIsInVzZXJfaWQiOjN9.5zBaMeKIZGT6jLEEny2SRjmygWbnMF8G8oK-l-3JBHU', '2022-01-17 11:52:48.164370', '2022-01-18 11:52:48.000000', 3, '60dfd8ff90cb44adba83e2cfe500d3fd');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (62, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MjU1NDI4OCwiaWF0IjoxNjQyNDY3ODg4LCJqdGkiOiI4ZTcxYjllMTA2OWI0YzBhOWIwZTlhMGM4Zjk1NGE3OSIsInVzZXJfaWQiOjN9.Upo8f99-nNNd2Ps7SwiVdxMeXSXdVz6oXrAskN_pDHU', '2022-01-18 01:04:48.458382', '2022-01-19 01:04:48.000000', 3, '8e71b9e1069b4c0a9b0e9a0c8f954a79');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (63, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MjU1NTAyOSwiaWF0IjoxNjQyNDY4NjI5LCJqdGkiOiJmNWFhOGE5ZDY5ZjU0OTg3ODczOWUwMDc4MmYzMGYxMiIsInVzZXJfaWQiOjN9.M0tWQUf82n-kVqFDujFBKHVxcgqjdrFL-cbecdhPOOI', '2022-01-18 01:17:09.156783', '2022-01-19 01:17:09.000000', 3, 'f5aa8a9d69f549878739e00782f30f12');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (64, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MjY0MTYxNCwiaWF0IjoxNjQyNTU1MjE0LCJqdGkiOiJlMjk5YzY0ZDIwYzY0NTk4YThiNmViNWU5M2VjMTlmYiIsInVzZXJfaWQiOjN9.mbzcutAbTmSxo17DI7x7NrQTUAa2XAz4FM3sgGr7bic', '2022-01-19 01:20:14.964032', '2022-01-20 01:20:14.000000', 3, 'e299c64d20c64598a8b6eb5e93ec19fb');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (65, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MjY1MDUwNCwiaWF0IjoxNjQyNTY0MTA0LCJqdGkiOiI1MWQyZTc0MmFkYzY0YzllOTE5NTg3NjJhMDVhN2JiMyIsInVzZXJfaWQiOjN9.te9ejTLjoUBrNAQuEO1eGbZXGQqFAE2mA36E5VjhYgA', '2022-01-19 03:48:24.636628', '2022-01-20 03:48:24.000000', 3, '51d2e742adc64c9e91958762a05a7bb3');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (66, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MjcyOTAyNSwiaWF0IjoxNjQyNjQyNjI1LCJqdGkiOiI4Yjg0YzY1NTdmN2M0ZDEwYWQxYTAyZDFlMTJlYTgxZiIsInVzZXJfaWQiOjN9.oc6HMm9aKhzzZhLlalmfBPoCn9sYRHEWx4jIrCzr8wI', '2022-01-20 01:37:05.305160', '2022-01-21 01:37:05.000000', 3, '8b84c6557f7c4d10ad1a02d1e12ea81f');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (67, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MjczNDU2MiwiaWF0IjoxNjQyNjQ4MTYyLCJqdGkiOiIwMGVhMmU0MDkzOTE0MDQ5YmJlOWUxYzg3NWVlODBiMSIsInVzZXJfaWQiOjN9.B1NMulE88yjd4hBu2Kq6pDD2AkAVR7Py5WLqxdBoD_o', '2022-01-20 03:09:22.474063', '2022-01-21 03:09:22.000000', 3, '00ea2e4093914049bbe9e1c875ee80b1');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (68, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0Mjc1OTI1OCwiaWF0IjoxNjQyNjcyODU4LCJqdGkiOiI4MTY3NTgzYTEwMzg0N2EwYjZjZjQ5YmIzMjJkYzJiMyIsInVzZXJfaWQiOjN9.z4CUOuxYPpyJtcjUCp30uhrChWYLNG-b7f0zY0IPqo4', '2022-01-20 10:00:58.727917', '2022-01-21 10:00:58.000000', 3, '8167583a103847a0b6cf49bb322dc2b3');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (69, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MjgyMDQ2NSwiaWF0IjoxNjQyNzM0MDY1LCJqdGkiOiI0NDI2NGFiYjI0NTg0N2ZjYWZkNzA1ZmVkY2Q3ODc4NCIsInVzZXJfaWQiOjN9.i-UyQJ0vlnJfRu-8ZWTjKpPdsqGrsQ8Hvq3xPOLFeYs', '2022-01-21 03:01:05.881770', '2022-01-22 03:01:05.000000', 3, '44264abb245847fcafd705fedcd78784');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (70, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MzA3MTEzNywiaWF0IjoxNjQyOTg0NzM3LCJqdGkiOiJiNTJlMzZkYzE1ZmQ0NmUxODYxYWNhZmU2MjkwZjk5NiIsInVzZXJfaWQiOjN9.0r5q97c9BTV-4u6iqBPgAj_sbSeOXT8M6hfhRA9PJzg', '2022-01-24 00:38:57.522416', '2022-01-25 00:38:57.000000', 3, 'b52e36dc15fd46e1861acafe6290f996');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (71, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MzA5OTIxNiwiaWF0IjoxNjQzMDEyODE2LCJqdGkiOiIyOTljMzJhMGYyNGU0NGQ1ODUwNmZmMWQ3N2VhZmFlNSIsInVzZXJfaWQiOjN9.6_kfm5NqF1vvQaK1hTiDmdTYYd9FFj3mHxZc9pIp3Ec', '2022-01-24 08:26:56.657446', '2022-01-25 08:26:56.000000', 3, '299c32a0f24e44d58506ff1d77eafae5');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (72, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MzE1NzgzMSwiaWF0IjoxNjQzMDcxNDMxLCJqdGkiOiIxNWU0ZTdmNmZjMjA0ZjZiODZkYmQ4NTRmNjZkOTBiYiIsInVzZXJfaWQiOjN9.24bMey1c0de1bMBsQlBTIUoO24F8IdY_gls8oUSnSpE', '2022-01-25 00:43:51.908247', '2022-01-26 00:43:51.000000', 3, '15e4e7f6fc204f6b86dbd854f66d90bb');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (73, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MzE2MDY3OCwiaWF0IjoxNjQzMDc0Mjc4LCJqdGkiOiI2MDRhNWExNzRjZmQ0NWFjOWYzY2MxM2JlZWMzZTYxYiIsInVzZXJfaWQiOjN9.t5qFOB5NQmsfaZse_0l_yAEXV1nlsKbVCBxS2g4TLBA', '2022-01-25 01:31:18.110423', '2022-01-26 01:31:18.000000', 3, '604a5a174cfd45ac9f3cc13beec3e61b');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (74, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MzE2NzM2MywiaWF0IjoxNjQzMDgwOTYzLCJqdGkiOiJhYTAxYThlZDY5OWM0MTQ2ODU3ZmMyYzFlNTBkNGE5NSIsInVzZXJfaWQiOjN9.couyEZar6LsN9Eq-RBbk6NnlILFxSMKd4QiI3FPWsPc', '2022-01-25 03:22:43.219773', '2022-01-26 03:22:43.000000', 3, 'aa01a8ed699c4146857fc2c1e50d4a95');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (75, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MzI0NDIyMiwiaWF0IjoxNjQzMTU3ODIyLCJqdGkiOiJhZDk4ZWIzNzM0OGE0NDBiOGQ3ZTVmMzllM2YxYTY0NCIsInVzZXJfaWQiOjN9.tiHUgRlqt21PkAfSsBk0La5IgZIZam2jVhql9xEb3IQ', '2022-01-26 00:43:42.573390', '2022-01-27 00:43:42.000000', 3, 'ad98eb37348a440b8d7e5f39e3f1a644');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (76, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MzI0NzcyOSwiaWF0IjoxNjQzMTYxMzI5LCJqdGkiOiI5MmUwNDdjMWM4NTM0MzU5OGE5MDNmMGFkODc3MjA0ZSIsInVzZXJfaWQiOjN9.oURf4YqMGWkqAsr_us1H51IPEAV_eak39VGVTXDmDJk', '2022-01-26 01:42:09.902829', '2022-01-27 01:42:09.000000', 3, '92e047c1c85343598a903f0ad877204e');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (77, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MzMzMTMyNiwiaWF0IjoxNjQzMjQ0OTI2LCJqdGkiOiJkYmVmMzMxNGI3OGY0MzM0OTNlNzFhMDU1NDUzZDg2YiIsInVzZXJfaWQiOjN9.3BUj55riLhu89_9qYtgY6qZkbmIzEIc6ZWZ9a7mqQ5U', '2022-01-27 00:55:26.861163', '2022-01-28 00:55:26.000000', 3, 'dbef3314b78f433493e71a055453d86b');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (78, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MzMzODY1MSwiaWF0IjoxNjQzMjUyMjUxLCJqdGkiOiJmMWZiYTQ0YzBkNDg0MGQ4ODBiMWMxOGMwYjhmZjQ0OCIsInVzZXJfaWQiOjN9.GFmL097Tl3RfIsbgDw9Xbv0M6b7WtFAIZJ6Ms9cvE8E', '2022-01-27 02:57:31.648370', '2022-01-28 02:57:31.000000', 3, 'f1fba44c0d4840d880b1c18c0b8ff448');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (79, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MzQxNjY4MSwiaWF0IjoxNjQzMzMwMjgxLCJqdGkiOiJkNmYyM2JlYmM3ODk0NGYzYjIwOTQxY2Y4ZjQ1NzYwMiIsInVzZXJfaWQiOjN9.sMDstotOM-aXmFxX6VY3iRflGp1h0lgUW7yKULGtY-k', '2022-01-28 00:38:01.599613', '2022-01-29 00:38:01.000000', 3, 'd6f23bebc78944f3b20941cf8f457602');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (80, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MzQxOTUwMCwiaWF0IjoxNjQzMzMzMTAwLCJqdGkiOiJhMjI0MTFkOWQxZGM0MDM2ODM1ODJmNmVlZmZkNTI2MCIsInVzZXJfaWQiOjN9.4ZGiP4XMezR_m1rg1FDoZ6XCvXmos6rdq0Q6gg4rsTE', '2022-01-28 01:25:00.673702', '2022-01-29 01:25:00.000000', 3, 'a22411d9d1dc403683582f6eeffd5260');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (81, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0MzQ0NTk2MSwiaWF0IjoxNjQzMzU5NTYxLCJqdGkiOiI1MjIwMDI3ODg2OTg0N2JmOWRhYzRiZGJhYjI4ZjdiMSIsInVzZXJfaWQiOjN9.Odjz2K5ze_L9fVs2in_CFaxCeLaFIrcc1Hog2ULP2aw', '2022-01-28 08:46:01.011832', '2022-01-29 08:46:01.000000', 3, '52200278869847bf9dac4bdbab28f7b1');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (82, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NDU0MDY1NywiaWF0IjoxNjQ0NDU0MjU3LCJqdGkiOiJlZmYyMTFiYWI4M2Q0ODNhODNkMjU2NTQyNzU4ZTM4ZiIsInVzZXJfaWQiOjN9.nvwkQsHb-DrIW2-cf4ACSmmx0q7mNp3_xJ5W4CH7R_w', '2022-02-10 00:50:57.256343', '2022-02-11 00:50:57.000000', 3, 'eff211bab83d483a83d256542758e38f');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (83, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NDYyNjgwOCwiaWF0IjoxNjQ0NTQwNDA4LCJqdGkiOiJmZjI1ZjZmZWU4OGQ0OGI3OGM5ZTQ3ZWFmMDM1MjVkYSIsInVzZXJfaWQiOjN9.-ghnCK_XWDrSp9FnAPr4oF1Fx2I_cy6Aa-hGaBoFLQs', '2022-02-11 00:46:48.891233', '2022-02-12 00:46:48.000000', 3, 'ff25f6fee88d48b78c9e47eaf03525da');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (84, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NDY1ODAxMSwiaWF0IjoxNjQ0NTcxNjExLCJqdGkiOiIzZTUwOWNhMTA5ODc0ZjA2OTM3Nzk2ODBkNjJmMzU0YSIsInVzZXJfaWQiOjN9.AfwWCV3utju5buArwKEQ6dgPM50s8vFk-P7Dj7MK79I', '2022-02-11 09:26:51.493826', '2022-02-12 09:26:51.000000', 3, '3e509ca109874f0693779680d62f354a');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (85, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NDg4NTMzMywiaWF0IjoxNjQ0Nzk4OTMzLCJqdGkiOiJkNTI1NmRlMDQwOGM0NTcyODZhNTQ2NjQ4Y2UwNDViMyIsInVzZXJfaWQiOjN9.SmlFtxDCdN00n9BJL_X-v703_g1VjuaMXk2jZSAugJM', '2022-02-14 00:35:33.594862', '2022-02-15 00:35:33.000000', 3, 'd5256de0408c457286a546648ce045b3');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (86, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NDg4NTMzOSwiaWF0IjoxNjQ0Nzk4OTM5LCJqdGkiOiJmNWM2NTc3NWI1YjA0ZjIyYjFjMzUxY2NkMmZkMWZhOCIsInVzZXJfaWQiOjN9.jVhOZMW47nzpKjHDWMIPK3eyaWO-v1Dc9sDxT-rJx8Q', '2022-02-14 00:35:39.396528', '2022-02-15 00:35:39.000000', 3, 'f5c65775b5b04f22b1c351ccd2fd1fa8');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (87, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NDg4NTM0MSwiaWF0IjoxNjQ0Nzk4OTQxLCJqdGkiOiI4MTNjZGVlOTgwYjg0ZjA3YWU5MjYzZDczYzFmNzZjOSIsInVzZXJfaWQiOjN9.sGafhFEnPk_id8s0yGCpfl8igPAnx21Y-oNB_959Me8', '2022-02-14 00:35:41.431000', '2022-02-15 00:35:41.000000', 3, '813cdee980b84f07ae9263d73c1f76c9');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (88, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NDg4NjA1MiwiaWF0IjoxNjQ0Nzk5NjUyLCJqdGkiOiJiN2FlMzY4NzQ0MWY0Nzg5YTIyNDFmZWU3Y2M3YmQ1NyIsInVzZXJfaWQiOjN9.N0f5CeuCOvfO9jgYWi_sqSzxYcqaNo2HHk-P1--P8tI', '2022-02-14 00:47:32.749655', '2022-02-15 00:47:32.000000', 3, 'b7ae3687441f4789a2241fee7cc7bd57');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (89, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NDg4NjIxMCwiaWF0IjoxNjQ0Nzk5ODEwLCJqdGkiOiIwYTFkNDA2MDMyMDk0MDY2ODJiMGEyNWIxZGRjZThmOCIsInVzZXJfaWQiOjN9.Y1x9xYC-ifDQJxLBHumIgEoCScy_jM9hHxOyOI1cbMQ', '2022-02-14 00:50:10.346792', '2022-02-15 00:50:10.000000', 3, '0a1d40603209406682b0a25b1ddce8f8');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (90, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NDk3MTg0OSwiaWF0IjoxNjQ0ODg1NDQ5LCJqdGkiOiJiNmNlMDM4MmY3ZTQ0OTVjYTYwODQ1MTU0YjlhODMzNCIsInVzZXJfaWQiOjN9.wQemgG6wVu4lT1GeTPK6JYanVMRLo8PTfLqDPkxwzq8', '2022-02-15 00:37:29.200637', '2022-02-16 00:37:29.000000', 3, 'b6ce0382f7e4495ca60845154b9a8334');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (91, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NDk5MDc0MCwiaWF0IjoxNjQ0OTA0MzQwLCJqdGkiOiJlMjhkNDU5NThkMzg0OTQ2YWEwY2FkNTBmODFiYTcxYSIsInVzZXJfaWQiOjN9.PgSRVJgLJK9KTgbWpPozyqNpqiT-zJsOoS_rnwR5ZYA', '2022-02-15 05:52:20.830722', '2022-02-16 05:52:20.000000', 3, 'e28d45958d384946aa0cad50f81ba71a');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (92, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NDk5MTU4MiwiaWF0IjoxNjQ0OTA1MTgyLCJqdGkiOiIyNWFmZjlhYmRiZDM0MGQzODRjYmNmMmVmN2ViNDRkMCIsInVzZXJfaWQiOjN9.Hhd3UeJlWLIYyyZnWKPqDaUn8Iw5CDQjTJ33_rp8aPw', '2022-02-15 06:06:22.534331', '2022-02-16 06:06:22.000000', 3, '25aff9abdbd340d384cbcf2ef7eb44d0');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (93, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NDk5NzE4MCwiaWF0IjoxNjQ0OTEwNzgwLCJqdGkiOiIwZDc2Y2Y4YWRjZGQ0ZjU4YjAyOTBjODZlMjczZTgyNCIsInVzZXJfaWQiOjN9.g6uOZy6wTQY1KFW7QmFZjCZMvz_56yBgcSvU1pzjWBk', '2022-02-15 07:39:40.975606', '2022-02-16 07:39:40.000000', 3, '0d76cf8adcdd4f58b0290c86e273e824');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (94, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NTA4NjcwNCwiaWF0IjoxNjQ1MDAwMzA0LCJqdGkiOiI4NWFjNDQ5MjYzNmY0YTJiYTA4NTQ5YmI3NzdhMDYwMCIsInVzZXJfaWQiOjN9.fVKCTEAT6Iz5dCn_rVkWpmcdgSh3JpVuOF3APgwkSH0', '2022-02-16 08:31:44.756551', '2022-02-17 08:31:44.000000', 3, '85ac4492636f4a2ba08549bb777a0600');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (95, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NTE0NjYxNSwiaWF0IjoxNjQ1MDYwMjE1LCJqdGkiOiIxNmIwNTk4MTQ4Mzc0YThmOWZlMTM1ODNkZjQxYWMzNSIsInVzZXJfaWQiOjN9.amKAFhs-ZFaVkAMr8Aah1XVVGX4VR_JTAEymxtYBFCo', '2022-02-17 01:10:15.369726', '2022-02-18 01:10:15.000000', 3, '16b0598148374a8f9fe13583df41ac35');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (96, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NTE3MjYzMiwiaWF0IjoxNjQ1MDg2MjMyLCJqdGkiOiI1YjM1MjQyNDMzNWQ0OWZhYWY3ZDVlZTNmMTllNDQ2ZiIsInVzZXJfaWQiOjN9.Maz25_1rmr5wWrjIXTMayVhUPyju7ZO1n-cZRRm_RBQ', '2022-02-17 08:23:52.066542', '2022-02-18 08:23:52.000000', 3, '5b352424335d49faaf7d5ee3f19e446f');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (97, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NTI1MzY4MywiaWF0IjoxNjQ1MTY3MjgzLCJqdGkiOiIxNGJmMTYwNGY1Nzg0ZWVlYTI1NGI0YmM3OTRkZTljMiIsInVzZXJfaWQiOjN9.Hbu_7VnTHsxLTIHviTInnnVPPxSCTVEAxiLAjRByaf0', '2022-02-18 06:54:43.841494', '2022-02-19 06:54:43.000000', 3, '14bf1604f5784eeea254b4bc794de9c2');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (98, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NTI2Mzc4OCwiaWF0IjoxNjQ1MTc3Mzg4LCJqdGkiOiIzOTZjMWRkODZjNGE0MDg5OTBmNWU3MTllZDI4Zjk1NyIsInVzZXJfaWQiOjN9.WtEAqZjjGWI4io_YcIOuAcua411OglSzqbPOP-tCg1s', '2022-02-18 09:43:08.777029', '2022-02-19 09:43:08.000000', 3, '396c1dd86c4a408990f5e719ed28f957');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (99, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NTUxMzE3NywiaWF0IjoxNjQ1NDI2Nzc3LCJqdGkiOiIyMjBhNjQ1ZGM5YzY0OGJiYWJhNWMxOTBiMDNjZTM2NiIsInVzZXJfaWQiOjN9.CoZiqlk7d42z8eKoG43tZ8DWYjHzrPZkdcj8x0Dqf4Q', '2022-02-21 06:59:37.421778', '2022-02-22 06:59:37.000000', 3, '220a645dc9c648bbaba5c190b03ce366');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (100, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NTU3NTkwMCwiaWF0IjoxNjQ1NDg5NTAwLCJqdGkiOiIyZWQyMmFkNmIwMTA0M2JjYmIzZGM0YzMyNDViZWVhYSIsInVzZXJfaWQiOjN9.uatVjzC0D5cwd8lCGGXrNQOZpvEKJ0LL5Wt8b5W5Sv8', '2022-02-22 00:25:00.690101', '2022-02-23 00:25:00.000000', 3, '2ed22ad6b01043bcbb3dc4c3245beeaa');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (101, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NTU5Nzk3NywiaWF0IjoxNjQ1NTExNTc3LCJqdGkiOiI2MTdiNGVlMzk0N2Y0ZTkxODc5ZDYzYzc4M2E4YjhkNyIsInVzZXJfaWQiOjN9.b7Dw4BX0_Vt3MLAteZ3g59MSWW8yMGH1v4JdQEh0HWk', '2022-02-22 06:32:57.772413', '2022-02-23 06:32:57.000000', 3, '617b4ee3947f4e91879d63c783a8b8d7');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (102, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NTc3NDUyMywiaWF0IjoxNjQ1Njg4MTIzLCJqdGkiOiI3YzkzYjc2Nzg5NjY0MDk3YmE3OWE0MmQwOWMzOWIzYyIsInVzZXJfaWQiOjN9.Kxc4LlzkwhIugYKScBqlR-6rycmqK6lwRQ_0tacibLo', '2022-02-24 07:35:23.720553', '2022-02-25 07:35:23.000000', 3, '7c93b76789664097ba79a42d09c39b3c');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (103, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NTc3NjYyNSwiaWF0IjoxNjQ1NjkwMjI1LCJqdGkiOiI3YzA4MWRjOGYxYzY0ODcyYjdlMGI3NWY2N2RjOTg2MyIsInVzZXJfaWQiOjN9.pEuMQc1NWTEIe3qYvdbJ9SS6KGhdSoOq3JdF_DdmFVg', '2022-02-24 08:10:25.936701', '2022-02-25 08:10:25.000000', 3, '7c081dc8f1c64872b7e0b75f67dc9863');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (104, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NTg0NTQ5NCwiaWF0IjoxNjQ1NzU5MDk0LCJqdGkiOiI2OWQ3ZmM2MmQyNGU0YWIyOTMyNzYzYjg1YzI1ZTc0NyIsInVzZXJfaWQiOjN9.mYGlMv4Nxk4AIlAIUFM4Rm7fRa2Td82Vmkz3xjmWjKQ', '2022-02-25 03:18:14.179252', '2022-02-26 03:18:14.000000', 3, '69d7fc62d24e4ab2932763b85c25e747');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (105, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NTg2MzczMywiaWF0IjoxNjQ1Nzc3MzMzLCJqdGkiOiJjNDY4ODdjNzgyMGY0ODZjODRkY2Q1OGIwNTMzYzEwYSIsInVzZXJfaWQiOjN9.w6bhfg_1ukJKeUW9H3ZEHkzyEaene33qqoazrt5e51A', '2022-02-25 08:22:13.306814', '2022-02-26 08:22:13.000000', 3, 'c46887c7820f486c84dcd58b0533c10a');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (106, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NjA5NjYyNSwiaWF0IjoxNjQ2MDEwMjI1LCJqdGkiOiJiMWUxOTJiZDE3ZjQ0YzM4YWI3YmJhMTgxNjdlYTcxYyIsInVzZXJfaWQiOjN9.6eKb2kEI59DIvBmztmEvwSy7S7222Mugw4NU-lQb20I', '2022-02-28 01:03:45.055851', '2022-03-01 01:03:45.000000', 3, 'b1e192bd17f44c38ab7bba18167ea71c');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (107, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NjExNDUyNywiaWF0IjoxNjQ2MDI4MTI3LCJqdGkiOiJmM2NmMjIyMmVlODU0MzA1YjBjOGM0MzdmODI2YmEyZCIsInVzZXJfaWQiOjN9.KchyZU_wdd99HHg1oBpR_wKIDv7GrL0Mp92f4TgBGaU', '2022-02-28 06:02:07.902342', '2022-03-01 06:02:07.000000', 3, 'f3cf2222ee854305b0c8c437f826ba2d');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (108, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NjIwMjY5NCwiaWF0IjoxNjQ2MTE2Mjk0LCJqdGkiOiIxMGExNTlmNjdmYWI0MmQ1ODhkMGFiMTM3MTExNDJmMSIsInVzZXJfaWQiOjN9.ra8WLogrUhf3KYodl-uqs3rvE9V_KWftAlhO46RNYDo', '2022-03-01 06:31:34.417446', '2022-03-02 06:31:34.000000', 3, '10a159f67fab42d588d0ab13711142f1');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (109, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NjIwMjcxNSwiaWF0IjoxNjQ2MTE2MzE1LCJqdGkiOiJiNjk3YTFkYzNiNTY0MjQ1OTBmYzYzMDEyMzhlMDdiOCIsInVzZXJfaWQiOjN9.ClrQqmCEqgt7KZ3e4UcbOHQ25zB1K9ZDdoSkhyMopac', '2022-03-01 06:31:55.400963', '2022-03-02 06:31:55.000000', 3, 'b697a1dc3b56424590fc6301238e07b8');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (112, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NjI4OTg4NiwiaWF0IjoxNjQ2MjAzNDg2LCJqdGkiOiI0OGQ0YWNlMzZiMmU0ZWFjYmI0NDljMWM5N2NlZGM0NyIsInVzZXJfaWQiOjN9.z6mIaDA2mbHycTmWTOEY9QFJNG1RETyn-NZiY9k3hxc', '2022-03-02 06:44:46.456278', '2022-03-03 06:44:46.000000', 3, '48d4ace36b2e4eacbb449c1c97cedc47');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (118, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NjM4NzMyMSwiaWF0IjoxNjQ2MzAwOTIxLCJqdGkiOiJmM2YzODc0YmI5YjU0MjhhYjE3OWE3MzViNGFiNjdmMiIsInVzZXJfaWQiOjN9.wFl06BokfAgWeoqrn3N1nB_IlTot01mcu5avYjI38WU', '2022-03-03 09:48:41.851338', '2022-03-04 09:48:41.000000', 3, 'f3f3874bb9b5428ab179a735b4ab67f2');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (119, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NjM4ODIyMCwiaWF0IjoxNjQ2MzAxODIwLCJqdGkiOiI0MzUyYjQzZTNlMGI0ZTcyYTA5ODJiNmM3NjY1OWMxYiIsInVzZXJfaWQiOjN9.25ciKsoGiUIa_GlXm9LAZQHZIwL-382zxOaGc5XzpJg', '2022-03-03 10:03:40.397104', '2022-03-04 10:03:40.000000', 3, '4352b43e3e0b4e72a0982b6c76659c1b');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (120, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NjQ2MDg0NiwiaWF0IjoxNjQ2Mzc0NDQ2LCJqdGkiOiIxMWYwMzI3MTlhNzg0YjJlOGZkNWU0N2FhYjQ3OTE5ZiIsInVzZXJfaWQiOjN9.nDWY2ElWNi36jjAK0e0Um5Jy-7Q-bDP8cfx8mtm9cuw', '2022-03-04 06:14:06.339012', '2022-03-05 06:14:06.000000', 3, '11f032719a784b2e8fd5e47aab47919f');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (121, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NjY0MDU2MiwiaWF0IjoxNjQ2NTU0MTYyLCJqdGkiOiI5NWJjYWJkNmIzMTY0OTZjYmI0ZjRkZDkzYTEwZjRmNCIsInVzZXJfaWQiOjN9.jlZTkF4g8Q-GF-MnmD9AWjpjZeeCzpa-e9jn1jA4WAA', '2022-03-06 08:09:22.393038', '2022-03-07 08:09:22.000000', 3, '95bcabd6b316496cbb4f4dd93a10f4f4');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (122, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NjY5OTY5MiwiaWF0IjoxNjQ2NjEzMjkyLCJqdGkiOiI4MTU1NmQzN2EwYTc0NjU4OTgyNjA1ZjEwNWYyY2FjMyIsInVzZXJfaWQiOjN9.JhVryPlzlKqk4-Vo2zDzd9iIezUttdE0cXtWVmiM-pU', '2022-03-07 00:34:52.820167', '2022-03-08 00:34:52.000000', 3, '81556d37a0a74658982605f105f2cac3');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (123, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NjczMzkyMSwiaWF0IjoxNjQ2NjQ3NTIxLCJqdGkiOiJhN2M0OWJhMGMzZmE0MDY0YTUxMzY4Zjk0ZmVmZWZmNCIsInVzZXJfaWQiOjN9.nP73XLiYw5WctHXx0NLHbxdEJ-z3qdiOcvgf4KHwo70', '2022-03-07 10:05:21.179318', '2022-03-08 10:05:21.000000', 3, 'a7c49ba0c3fa4064a51368f94fefeff4');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (124, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NjczNDA4NiwiaWF0IjoxNjQ2NjQ3Njg2LCJqdGkiOiJmZjgzYjlkOTQyYTU0ZDJlYjM5ZTY1ODMzYWFlNjNiOSIsInVzZXJfaWQiOjN9.DTRxUnBCRCMcgnDsJ08USiGkTyacC9xr7kBoaqruCW8', '2022-03-07 10:08:06.045811', '2022-03-08 10:08:06.000000', 3, 'ff83b9d942a54d2eb39e65833aae63b9');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (125, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0Njc4NTU3MywiaWF0IjoxNjQ2Njk5MTczLCJqdGkiOiIyZTZhNTJiNzI1MjQ0ODVhODgzMDcyMjdmNzVmNmRlYyIsInVzZXJfaWQiOjN9.LItztrEWuxTjaINLaBpj7to7fO6NLVzzyBZC-JX0uV0', '2022-03-08 00:26:13.066937', '2022-03-09 00:26:13.000000', 3, '2e6a52b72524485a88307227f75f6dec');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (126, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0Njc4NTU3NywiaWF0IjoxNjQ2Njk5MTc3LCJqdGkiOiIzMDY4MWRiNmU0MzU0MjI4ODdlZTRiMzgzZTQxY2MxOCIsInVzZXJfaWQiOjN9.RDjnWSZ47WRX7uVK6gEMQWzji63BevsaYN7_MflAbdA', '2022-03-08 00:26:17.220406', '2022-03-09 00:26:17.000000', 3, '30681db6e435422887ee4b383e41cc18');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (127, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NjkwMDcyNiwiaWF0IjoxNjQ2ODE0MzI2LCJqdGkiOiI0YjVjYTkxMDU4ZWU0ZmMxYWE2OWUyOGIxMGEyMGUzMSIsInVzZXJfaWQiOjN9.kJObZc4jI-_eX2GyuETFVbckKxagZhbsGuslmND6lO8', '2022-03-09 08:25:26.291715', '2022-03-10 08:25:26.000000', 3, '4b5ca91058ee4fc1aa69e28b10a20e31');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (128, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0Njk2MDI3OSwiaWF0IjoxNjQ2ODczODc5LCJqdGkiOiIyNjJhMzNlNjQxODQ0NTA5OTJhNWZiNmEyNDdkMDY1MCIsInVzZXJfaWQiOjN9.kHlBreaPCMn59pzFkDV2Ly-fwx9KwFSRNyAJESZ6-Gw', '2022-03-10 00:57:59.120034', '2022-03-11 00:57:59.000000', 3, '262a33e64184450992a5fb6a247d0650');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (129, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0Njk2NzA2OSwiaWF0IjoxNjQ2ODgwNjY5LCJqdGkiOiJjOTRkMjY3ZThlMjc0YzMwOTRkZGUwNjMzMzc1N2NjMyIsInVzZXJfaWQiOjN9.IyisW3_tODtaUvGeorW9R2GNeXturqlZd7_oGjRfx0E', '2022-03-10 02:51:09.112022', '2022-03-11 02:51:09.000000', 3, 'c94d267e8e274c3094dde06333757cc3');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (130, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0Njk3NzkyOSwiaWF0IjoxNjQ2ODkxNTI5LCJqdGkiOiJhNTIyMmQ5N2MwYWM0Nzg2YjY0MjljYTAyZTU1MDY0YiIsInVzZXJfaWQiOjN9.rIObdPeXnipve2lla4D4pCHEyEdoMlNm0xHfG0cQWCs', '2022-03-10 05:52:09.452996', '2022-03-11 05:52:09.000000', 3, 'a5222d97c0ac4786b6429ca02e55064b');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (131, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0Njk4MzgxMywiaWF0IjoxNjQ2ODk3NDEzLCJqdGkiOiIzMjY4N2QzZWJlMzA0MGI0YTFmOTYwMjljY2YwODhmYiIsInVzZXJfaWQiOjN9.g1K_-cWZ-35fiFmsoIY21sPPURF3KLiiZjeiXiyxd_g', '2022-03-10 07:30:13.078615', '2022-03-11 07:30:13.000000', 3, '32687d3ebe3040b4a1f96029ccf088fb');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (132, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NzMxMzU0NywiaWF0IjoxNjQ3MjI3MTQ3LCJqdGkiOiJhNDFiOTdhNDZkYWY0Yjg1YWYzODgzMDBlMTQ2MDVhZCIsInVzZXJfaWQiOjN9.jQEc6lOzc2OjWkiGzaK82S5MjkNXu75lNqa_id3VRpM', '2022-03-14 03:05:47.975478', '2022-03-15 03:05:47.000000', 3, 'a41b97a46daf4b85af388300e14605ad');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (133, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NzMyMzMxMiwiaWF0IjoxNjQ3MjM2OTEyLCJqdGkiOiIxYzY1YWQ0NjcyNzQ0NDhmOTNhZmMyOGM2NTlkYWU4OSIsInVzZXJfaWQiOjN9.biXfp9_I3lDKdfVr135piwHbqQ0RGxu6eg5hgQzEAos', '2022-03-14 05:48:32.810823', '2022-03-15 05:48:32.000000', 3, '1c65ad467274448f93afc28c659dae89');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (134, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NzMzNzMzMCwiaWF0IjoxNjQ3MjUwOTMwLCJqdGkiOiIyZWFjYzkyZTc5OTk0N2RlODk2YmZmNDg3ZWVlYzEyMiIsInVzZXJfaWQiOjN9.rRBzvs6JvUduUa_bltUWUtx8ivAunDnXVDWJSgTF8V4', '2022-03-14 09:42:10.881534', '2022-03-15 09:42:10.000000', 3, '2eacc92e799947de896bff487eeec122');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (135, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NzMzODQ5MSwiaWF0IjoxNjQ3MjUyMDkxLCJqdGkiOiIzZWVhNzdlMTEyMzc0OGY4YWE4OGJlN2Y5Njk5NjRjYyIsInVzZXJfaWQiOjN9.qqm3oBaXntEce0BZWzDLo8cuEGPCmOx1Q2PIrVO5q6Y', '2022-03-14 10:01:31.075990', '2022-03-15 10:01:31.000000', 3, '3eea77e1123748f8aa88be7f969964cc');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (136, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NzM0MDY5OCwiaWF0IjoxNjQ3MjU0Mjk4LCJqdGkiOiJjNjExZTI0Zjg4OWY0ZDhiYWEwZDRjOWM0NTUyNGJhZSIsInVzZXJfaWQiOjN9.IX-_r9ybCYldsDwrw2Nz6x7OUDrXnwMjcfB1nxe9GZo', '2022-03-14 10:38:18.716733', '2022-03-15 10:38:18.000000', 3, 'c611e24f889f4d8baa0d4c9c45524bae');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (137, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NzM0NDY0OSwiaWF0IjoxNjQ3MjU4MjQ5LCJqdGkiOiJmY2MyODc5MmU1YzI0YzJlOTA2NDk1MWViNjRkN2Q1ZiIsInVzZXJfaWQiOjN9.fepFKvJoJWdLiE1heD2qU_m9amRQUQS_ref_RYZkfP0', '2022-03-14 11:44:09.423755', '2022-03-15 11:44:09.000000', 3, 'fcc28792e5c24c2e9064951eb64d7d5f');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (138, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NzM0NDY2NCwiaWF0IjoxNjQ3MjU4MjY0LCJqdGkiOiIyZjZlM2E1YjZhYzc0NGIxYjlkNWJiYWQzOTQ3NjMzMiIsInVzZXJfaWQiOjN9.hSfwptMAKy3qR0a2DbwPIzSEjMLp9I8ZzogadsJunHg', '2022-03-14 11:44:24.551587', '2022-03-15 11:44:24.000000', 3, '2f6e3a5b6ac744b1b9d5bbad39476332');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (139, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NzUwMzc2OSwiaWF0IjoxNjQ3NDE3MzY5LCJqdGkiOiJhOTAwMmQ4ZGExMWY0NGIxYWY0YmUxNWYwNzU3MzEyYiIsInVzZXJfaWQiOjN9.t-0OG_pnR7UdMqRZG9ITpd5vHIcIKV-ln5vTSEphKpA', '2022-03-16 07:56:09.039609', '2022-03-17 07:56:09.000000', 3, 'a9002d8da11f44b1af4be15f0757312b');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (141, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NzU5NTMwMSwiaWF0IjoxNjQ3NTA4OTAxLCJqdGkiOiJmMzdhMWI2OWJmNjc0OGIyOTllYjExMTExNjg5MDNlNCIsInVzZXJfaWQiOjN9.MCC7eaMCNBekGYnselImlP3OaE0cpTZaXZOJuZvi3jk', '2022-03-17 09:21:41.385924', '2022-03-18 09:21:41.000000', 3, 'f37a1b69bf6748b299eb1111168903e4');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (142, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NzY3MDc5NSwiaWF0IjoxNjQ3NTg0Mzk1LCJqdGkiOiI1NmE0Y2YzYzczNjA0ZTM5YmVhYmYyYWM3NmY1ZjAzNiIsInVzZXJfaWQiOjN9.ATZLQuzwQouJpt3thfiLiNEpT1nWVPPst1XDxpUKlJs', '2022-03-18 06:19:55.649817', '2022-03-19 06:19:55.000000', 3, '56a4cf3c73604e39beabf2ac76f5f036');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (143, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NzY3MTIyNSwiaWF0IjoxNjQ3NTg0ODI1LCJqdGkiOiJhNzhmNDRhYjBmZmQ0OGUxOTQ3YmM2ZDE0ZDkwYWNhYSIsInVzZXJfaWQiOjN9.clzvKh-RzOynZXYb09Rn6Jx4l0eYE3-CzRnfGwNTfmU', '2022-03-18 06:27:05.716834', '2022-03-19 06:27:05.000000', 3, 'a78f44ab0ffd48e1947bc6d14d90acaa');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (144, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NzY5NDM5MSwiaWF0IjoxNjQ3NjA3OTkxLCJqdGkiOiI2NGJjNWQ2MWI0NDM0YjhhYWQ1NzkwN2I4NTQ5ZjUwYSIsInVzZXJfaWQiOjN9.vzQMWiJ3rnty7BPW1PjwVTa5rzF2F_IDAoj0mHF6-04', '2022-03-18 12:53:11.344234', '2022-03-19 12:53:11.000000', 3, '64bc5d61b4434b8aad57907b8549f50a');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (145, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0Nzc3MjU2MSwiaWF0IjoxNjQ3Njg2MTYxLCJqdGkiOiIwZTQyMjY0ZDBmYjE0ODcwOThlM2U4ZWI0OGQzMjRkMCIsInVzZXJfaWQiOjN9.0XwBt040aL347XyU6kWhqzSNjIz2_Q95Ftq1iqrx_Rk', '2022-03-19 10:36:01.840061', '2022-03-20 10:36:01.000000', 3, '0e42264d0fb1487098e3e8eb48d324d0');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (146, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0Nzc3MzUwOCwiaWF0IjoxNjQ3Njg3MTA4LCJqdGkiOiIwNGI1YTQ3MTU1MTc0NThiOTQxNjIzNWExYTc4OWIzOSIsInVzZXJfaWQiOjN9.IBvC6aMPVbk7dcacg9N9eOW1RdtOowZ38GATUgXdhEk', '2022-03-19 10:51:48.308297', '2022-03-20 10:51:48.000000', 3, '04b5a4715517458b9416235a1a789b39');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (147, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0Nzc3NTQ3NSwiaWF0IjoxNjQ3Njg5MDc1LCJqdGkiOiIzODgxMGRkZmVlZGM0NTM5YTlhOTMxOThmOGRjOGY4OSIsInVzZXJfaWQiOjN9.1b8yaSYmoxcN3-jSrV4ioVVic6JTwNzaTq_c_75Ga8Y', '2022-03-19 11:24:35.353166', '2022-03-20 11:24:35.000000', 3, '38810ddfeedc4539a9a93198f8dc8f89');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (148, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NzkyOTM4MywiaWF0IjoxNjQ3ODQyOTgzLCJqdGkiOiJhYzZjZGZjODIwMGY0ZjQ1OWMxYTQ0ZTFkM2I0ZTc4MSIsInVzZXJfaWQiOjN9.AEI5Oc1B8Q-HEdZVe2DoZB-VuJ9tURBNzehChQUd0Is', '2022-03-21 06:09:43.093600', '2022-03-22 06:09:43.000000', 3, 'ac6cdfc8200f4f459c1a44e1d3b4e781');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (149, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NzkyOTM5MSwiaWF0IjoxNjQ3ODQyOTkxLCJqdGkiOiI1ZWUzMTBlYWZjMzg0MzQyODI0OTcxZjYwN2FjYzAwOCIsInVzZXJfaWQiOjN9.hN1M4wOtFIBIusmpbErG0rTgaiSyJ9tR7AWurqKMHpI', '2022-03-21 06:09:51.616699', '2022-03-22 06:09:51.000000', 3, '5ee310eafc384342824971f607acc008');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (150, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NzkyOTM5NiwiaWF0IjoxNjQ3ODQyOTk2LCJqdGkiOiJlNzlkNzIxMjQ0Zjc0NjQyOGUxNGJhMjZkOGU3YTBjZSIsInVzZXJfaWQiOjN9.qOSXVtxjHvmgY6msg6-03zuxtboyh1EH2jOvh0gEkK4', '2022-03-21 06:09:56.852032', '2022-03-22 06:09:56.000000', 3, 'e79d721244f746428e14ba26d8e7a0ce');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (152, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NzkzODM1NCwiaWF0IjoxNjQ3ODUxOTU0LCJqdGkiOiIyMDdiMzE5NDhmNGY0MDgzODRmZTRmNWRkMTlhMjhhNiIsInVzZXJfaWQiOjN9.GujXnjrknu0T8_jMSh6M3_wcTFebDpPHpEzs_z5SnK0', '2022-03-21 08:39:14.290323', '2022-03-22 08:39:14.000000', 3, '207b31948f4f408384fe4f5dd19a28a6');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (154, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0Nzk0MTQzNCwiaWF0IjoxNjQ3ODU1MDM0LCJqdGkiOiJiODU0YWIwNGU5M2U0NThmYjk1NTMxYTQzOGY2Zjg1NSIsInVzZXJfaWQiOjN9.pepy84YjmPS_c70b9SDhd1nFIOfKfoQwueFe5J9j7eE', '2022-03-21 09:30:34.125194', '2022-03-22 09:30:34.000000', 3, 'b854ab04e93e458fb95531a438f6f855');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (158, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0ODAyOTYyNywiaWF0IjoxNjQ3OTQzMjI3LCJqdGkiOiIwYWZlMjA5MmY1Mzg0OTFhYmUyZWEyOWFkYjkyOTUwZCIsInVzZXJfaWQiOjE0fQ.PkzCTuCdy1kmWlFKaLyqwCjTKYj_xlFotFBTHBFjtSI', '2022-03-22 10:00:27.526057', '2022-03-23 10:00:27.000000', 14, '0afe2092f538491abe2ea29adb92950d');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (159, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0ODEwNDk2OCwiaWF0IjoxNjQ4MDE4NTY4LCJqdGkiOiJlN2EzMWJlMjExNWE0MjYwODZjZWRmMTljNDBmOWEwOCIsInVzZXJfaWQiOjN9.qI3Sa9Lt3-7_NOmcXoyXy5ohcRSjMf_f9uCMuVFRCnw', '2022-03-23 06:56:08.240731', '2022-03-24 06:56:08.000000', 3, 'e7a31be2115a426086cedf19c40f9a08');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (160, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0ODEwNzEwMiwiaWF0IjoxNjQ4MDIwNzAyLCJqdGkiOiI1YjRhZTM2NDlkZTg0YzAwYjc1MTI0MGY1YjAzNTFlZSIsInVzZXJfaWQiOjN9.0TX2b8ve6hgQ6wEKjMhBEPm84_b7ll1ZwW4XMCK_yjg', '2022-03-23 07:31:42.386368', '2022-03-24 07:31:42.000000', 3, '5b4ae3649de84c00b751240f5b0351ee');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (161, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0ODM2NTY2MiwiaWF0IjoxNjQ4Mjc5MjYyLCJqdGkiOiI5MmU4YWFiOWQxMzU0MWIyODEyMzMyNWFlNTM0OWJjMSIsInVzZXJfaWQiOjN9.Y8h5TwKuyyef9crGQ7how5mr9Gmv4cMRbdmx6eocFG8', '2022-03-26 07:21:02.745379', '2022-03-27 07:21:02.000000', 3, '92e8aab9d13541b28123325ae5349bc1');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (162, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0ODUyMDI0MCwiaWF0IjoxNjQ4NDMzODQwLCJqdGkiOiI4NDE1NjZkYjZjMWI0YzkzYjMyMzIxMWM5MmU1Mzc4YiIsInVzZXJfaWQiOjN9.Gd2qvXHWq94HP9Np99vV4RcgtYOXB3jAJZNFsdZuZdM', '2022-03-28 02:17:20.370495', '2022-03-29 02:17:20.000000', 3, '841566db6c1b4c93b323211c92e5378b');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (163, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0ODUyMjE0MywiaWF0IjoxNjQ4NDM1NzQzLCJqdGkiOiI4YTBiNGJiMjJjN2I0ZWJkYTg0MThjYjkxNmNlOWM1NiIsInVzZXJfaWQiOjN9.T6-1GxtN0C7ZtFAx0UK8_9o0d14UF3xyRJGI4me_Azw', '2022-03-28 02:49:03.006018', '2022-03-29 02:49:03.000000', 3, '8a0b4bb22c7b4ebda8418cb916ce9c56');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (164, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0ODUyMjUwMiwiaWF0IjoxNjQ4NDM2MTAyLCJqdGkiOiIxMjI4NDU5NzJlMTE0Mzk4ODdjNzM3NTc4YjQ2ZTlkYSIsInVzZXJfaWQiOjN9.5isREYLVTrIUEKgaquFXWZ9LTJRZnKzTvZx2a2j9_pg', '2022-03-28 02:55:02.375004', '2022-03-29 02:55:02.000000', 3, '122845972e11439887c737578b46e9da');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (165, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0ODU0NjE0NCwiaWF0IjoxNjQ4NDU5NzQ0LCJqdGkiOiJlNmNmYWM0OTg5ZmY0ZTRiODU3MDBkNjE3MDllNzUxNCIsInVzZXJfaWQiOjE2fQ.o0cQx-jfPUkivoRZ4K8d8XwbfDN-_gWjYiW98uAA5f4', '2022-03-28 09:29:04.322197', '2022-03-29 09:29:04.000000', 16, 'e6cfac4989ff4e4b85700d61709e7514');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (166, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0ODU0NjE2OCwiaWF0IjoxNjQ4NDU5NzY4LCJqdGkiOiJiNzkxMDNmYjNmZDQ0OWE3YTgyNTE4NjI2OTExYzhmNyIsInVzZXJfaWQiOjN9.4Fbzaujcph97KR5hsFBUW-RC4v1YLd1N0wL53TvKUEg', '2022-03-28 09:29:28.996749', '2022-03-29 09:29:28.000000', 3, 'b79103fb3fd449a7a82518626911c8f7');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (167, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0ODU0Njg2OCwiaWF0IjoxNjQ4NDYwNDY4LCJqdGkiOiI4YjVmOGRmOWI5OWM0NmE1YjAzZWUxOWY5N2U1NGE5NyIsInVzZXJfaWQiOjE3fQ.B265Uwz4_l0odgWePD_l9h-701EORLd1yrso6G8_xf4', '2022-03-28 09:41:08.383353', '2022-03-29 09:41:08.000000', 17, '8b5f8df9b99c46a5b03ee19f97e54a97');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (168, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0ODU1MDQ5MCwiaWF0IjoxNjQ4NDY0MDkwLCJqdGkiOiI0NTRlYjg2ZTExY2M0NTQ3YWE3NGFkMTA2NTViNWIwMyIsInVzZXJfaWQiOjN9.YRnplFPYkFeNQ3UFKD4Nll47_tfClvzhpAXYeoC1w9c', '2022-03-28 10:41:30.120593', '2022-03-29 10:41:30.000000', 3, '454eb86e11cc4547aa74ad10655b5b03');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (169, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0ODU1MzYxOCwiaWF0IjoxNjQ4NDY3MjE4LCJqdGkiOiI5OTEyNTBmMGQ0NjU0Y2FjODJjNDFkYzE1OWQyMTc1NCIsInVzZXJfaWQiOjE0fQ.2BTvZzitQ13X5jHrRqP8W6Iqzz1ggH6QvvZUpgnUUMk', '2022-03-28 11:33:38.740156', '2022-03-29 11:33:38.000000', 14, '991250f0d4654cac82c41dc159d21754');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (171, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0ODYyNTMwMiwiaWF0IjoxNjQ4NTM4OTAyLCJqdGkiOiJjN2ViZDM5MjMwOTY0NDg2ODk0YzM5NmM1MWVkYjdlMSIsInVzZXJfaWQiOjE0fQ.Xk_AR3QKnqRX9MhdT9pbleIuVcq7CvOnA1q8h8LiVeI', '2022-03-29 07:28:22.228527', '2022-03-30 07:28:22.000000', 14, 'c7ebd39230964486894c396c51edb7e1');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (172, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0OTEzNzI3MiwiaWF0IjoxNjQ5MDUwODcyLCJqdGkiOiIwYjgzYTYxODY4MDA0ZWViODY0MzdhNmY3ZjM2OTQ0OSIsInVzZXJfaWQiOjN9.k_cMwTkHdnGrA_FUf2kt-KRw5FUc94iPIqq2Q8s9-2Q', '2022-04-04 05:41:12.081868', '2022-04-05 05:41:12.000000', 3, '0b83a61868004eeb86437a6f7f369449');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (173, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0OTIyMDYxMiwiaWF0IjoxNjQ5MTM0MjEyLCJqdGkiOiI0OTgwMDliMDk3Zjk0OGMzYTlmOTU2NmM1ZjJkMjQ3ZSIsInVzZXJfaWQiOjN9.seXoly5vfFMIbeACQLeAi4fAO6TcfqOiTL8b7vdHwl8', '2022-04-05 04:50:12.054340', '2022-04-06 04:50:12.000000', 3, '498009b097f948c3a9f9566c5f2d247e');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (174, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0OTIyMDg3MCwiaWF0IjoxNjQ5MTM0NDcwLCJqdGkiOiIxNGViMDBkYjgxOGE0MDhmODVkYjJjYjMxYWQ0MzlhOCIsInVzZXJfaWQiOjN9.RTVfYspp3nTouGVnq8nhjEKPeWbK4w24VspXOImxweE', '2022-04-05 04:54:30.542768', '2022-04-06 04:54:30.000000', 3, '14eb00db818a408f85db2cb31ad439a8');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (175, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0OTI5MzQ3NCwiaWF0IjoxNjQ5MjA3MDc0LCJqdGkiOiJlNzExMDZjN2UwNTQ0OGQ2OWQ3ODAxYmRjOTJiY2EwZiIsInVzZXJfaWQiOjN9.OzPbd1EBw36TWsMzfcOhgHPMT91fe-F0GUk0oswJPME', '2022-04-06 01:04:34.920629', '2022-04-07 01:04:34.000000', 3, 'e71106c7e05448d69d7801bdc92bca0f');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (176, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0OTMyNTE5MiwiaWF0IjoxNjQ5MjM4NzkyLCJqdGkiOiIwYjEzZjFmMzE1NTY0MjlkODdhZGE1MzMxOGUwZjBjZSIsInVzZXJfaWQiOjN9.dAxj7YZsmY-6kN4rN9V4QuVM9ZJIYVpg6WwCoNqROv4', '2022-04-06 09:53:12.862863', '2022-04-07 09:53:12.000000', 3, '0b13f1f31556429d87ada53318e0f0ce');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (177, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0OTM4MzY5MiwiaWF0IjoxNjQ5Mjk3MjkyLCJqdGkiOiI2NTFiNzMyYWY4YWQ0YWZkYmIwMTEyNGYzMmM4ZjRlZiIsInVzZXJfaWQiOjN9.ejaCnOti1H1AdVvWXBeopTavecxVc1J9toe4BgROrpU', '2022-04-07 02:08:12.778773', '2022-04-08 02:08:12.000000', 3, '651b732af8ad4afdbb01124f32c8f4ef');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (178, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0OTgxODU5NCwiaWF0IjoxNjQ5NzMyMTk0LCJqdGkiOiI3NTk3NDljNTU3Y2E0OTcxYjdlMmY0MTAxMDQwNDc2MiIsInVzZXJfaWQiOjN9.tewLh114TvUpitLO_GDXNIi6MSLovGDm3bqHLb2iHOc', '2022-04-12 02:56:34.175775', '2022-04-13 02:56:34.000000', 3, '759749c557ca4971b7e2f41010404762');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (179, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0OTkyMjQxMiwiaWF0IjoxNjQ5ODM2MDEyLCJqdGkiOiJhNzRhMTUzNzU5ZTc0N2ViODQ5NTRkMTgxMTI3OGFjZiIsInVzZXJfaWQiOjN9.mpZWz5Lg4c3ohOU6n66je2jEtT3_gTcyrJS7nzv4S3w', '2022-04-13 07:46:52.439279', '2022-04-14 07:46:52.000000', 3, 'a74a153759e747eb84954d1811278acf');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (180, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0OTk4NTEwMCwiaWF0IjoxNjQ5ODk4NzAwLCJqdGkiOiJiOWMzM2NiOTJlNmU0MTFmOTRiYTI1ZmVkNzlhODAxZCIsInVzZXJfaWQiOjN9.vm3sMh1t-MeSHL2cTpQ8_PmixtCZ7bPW4bcIJrQvtPg', '2022-04-14 01:11:40.417618', '2022-04-15 01:11:40.000000', 3, 'b9c33cb92e6e411f94ba25fed79a801d');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (181, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0OTk4NzE5MiwiaWF0IjoxNjQ5OTAwNzkyLCJqdGkiOiJiOWI5NThiZDA0OWE0NWJlYmIxOTUxMDc3NWZmZGRhOSIsInVzZXJfaWQiOjN9.A1sJzR5Kq6FcSBVy7U8kGfnvD9ogZNGdeHS4CsjgH88', '2022-04-14 01:46:32.135774', '2022-04-15 01:46:32.000000', 3, 'b9b958bd049a45bebb19510775ffdda9');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (182, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MDUyNjQ1NiwiaWF0IjoxNjUwNDQwMDU2LCJqdGkiOiIwNzJkMjg4ZGU3ZDc0MzExYjZmNzVmZmI5NGU1ODBlMyIsInVzZXJfaWQiOjN9.U4S2cQGwY9WcjaU1wyo4BpHlJS2DUmq4dkqkg1OAyic', '2022-04-20 07:34:16.006678', '2022-04-21 07:34:16.000000', 3, '072d288de7d74311b6f75ffb94e580e3');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (183, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MDUzNjU2NCwiaWF0IjoxNjUwNDUwMTY0LCJqdGkiOiJiYTdhNGQwZmQ1NGQ0MTY3YWI4MTQ0ODdiMzYyZmZiYyIsInVzZXJfaWQiOjN9.YCURX7iN6q9NizO7M8unUio6a5oAUbEpwItcIzrgTlQ', '2022-04-20 10:22:44.347392', '2022-04-21 10:22:44.000000', 3, 'ba7a4d0fd54d4167ab814487b362ffbc');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (184, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MDY3NjcxNiwiaWF0IjoxNjUwNTkwMzE2LCJqdGkiOiIxMWMyM2Q5ZTg0YTk0ZTQ5YmVhNTVkOGY3ZDhjM2EzZSIsInVzZXJfaWQiOjN9.NI-gWc_oBsqAov8QVcpyeHU4Cm5nLA8XtuiB0y6PrOE', '2022-04-22 01:18:36.573277', '2022-04-23 01:18:36.000000', 3, '11c23d9e84a94e49bea55d8f7d8c3a3e');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (185, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTM5MzIyNywiaWF0IjoxNjUxMzA2ODI3LCJqdGkiOiI0ZDY5ZTNlM2EwYTY0YjM5YmMwNDQwMjljOGQ2MWNmNCIsInVzZXJfaWQiOjN9.Ysg_5ahFliToIEGkAMYQpG3WbqHIFQ-zDLP7K7SIXSo', '2022-04-30 08:20:27.798722', '2022-05-01 08:20:27.000000', 3, '4d69e3e3a0a64b39bc044029c8d61cf4');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (186, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTQ4NjAzNSwiaWF0IjoxNjUxMzk5NjM1LCJqdGkiOiJmNDg1MzQzNTgzMjQ0M2NjYjQ2ODI0M2FjMGNmNmE4MSIsInVzZXJfaWQiOjN9.LYi3SfrlCWqSe2aSamR-2geRDeiG5ShWaQmtb2CUeLg', '2022-05-01 10:07:15.737623', '2022-05-02 10:07:15.000000', 3, 'f4853435832443ccb468243ac0cf6a81');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (188, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTQ4NjI5MywiaWF0IjoxNjUxMzk5ODkzLCJqdGkiOiJkMDU1Y2QwOWQxMzQ0YTg1ODM2YmY0Yjg5MjMyZTRhNiIsInVzZXJfaWQiOjN9.Z9qZfF3bB3ebtJPPS9s-bdrjLrqTHkG3IaTmzexohD4', '2022-05-01 10:11:33.264384', '2022-05-02 10:11:33.000000', 3, 'd055cd09d1344a85836bf4b89232e4a6');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (189, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTQ4NjQwMywiaWF0IjoxNjUxNDAwMDAzLCJqdGkiOiIzZjFiODY2OGVmNmU0NWMyODZiNzJjNzQ5YmVmZTI1NCIsInVzZXJfaWQiOjN9.RVDYkUDY1VcluCVgVBDGVtQoq8dfMH4D4XNr1hb_t40', '2022-05-01 10:13:23.128543', '2022-05-02 10:13:23.000000', 3, '3f1b8668ef6e45c286b72c749befe254');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (190, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTUwMjc3MSwiaWF0IjoxNjUxNDE2MzcxLCJqdGkiOiI5Y2ExZjdlOTQ1MmM0YzdiYmEwNzVjMDQ4YTI5MjIxMyIsInVzZXJfaWQiOjN9.tdjjPjCX1z6_e3EG3B7sXoZw3WrBwv2JJbhsqyTlX30', '2022-05-01 14:46:11.825583', '2022-05-02 14:46:11.000000', 3, '9ca1f7e9452c4c7bba075c048a292213');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (191, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTUzNTQ5MywiaWF0IjoxNjUxNDQ5MDkzLCJqdGkiOiI1NjRlMzQ0OTQ0OWE0YjVhOTRiZGFiZWUxNmQ2ZWYzOCIsInVzZXJfaWQiOjN9.o9YcE0hjUCL_7Xgu-qHLMxNY2fr58l_xEcqFqvSMKXM', '2022-05-01 23:51:33.082465', '2022-05-02 23:51:33.000000', 3, '564e3449449a4b5a94bdabee16d6ef38');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (192, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTUzNTkwMywiaWF0IjoxNjUxNDQ5NTAzLCJqdGkiOiI3MDFiM2NlMzQzMmM0YWJjOTMxYWU0MzY1NmY4OWI4ZSIsInVzZXJfaWQiOjN9.4OR3RmSyzWLF7mcyz-HvB_EqA5m-Vut9mpKAvf_sQ8Y', '2022-05-01 23:58:23.968243', '2022-05-02 23:58:23.000000', 3, '701b3ce3432c4abc931ae43656f89b8e');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (193, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTUzODAyMiwiaWF0IjoxNjUxNDUxNjIyLCJqdGkiOiJkYzFkODVlYjhiZjg0ZTNlODA1NzI3ZjRjNWU0MmRhMyIsInVzZXJfaWQiOjN9.vnoqt-G8eTvt_JSoFoJZfqTRrsE3ruPeTqCMKpU7yGc', '2022-05-02 00:33:42.295736', '2022-05-03 00:33:42.000000', 3, 'dc1d85eb8bf84e3e805727f4c5e42da3');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (194, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTU0NDIwMiwiaWF0IjoxNjUxNDU3ODAyLCJqdGkiOiI2YTcyNjVkNDVmZTI0NTY3YjIzZmU2OTc0MTYzZTdmNSIsInVzZXJfaWQiOjN9.CDXSHVxmZIqswIQAVKog4Si-UKbl-En-4Oecbn0QbbY', '2022-05-02 02:16:42.069394', '2022-05-03 02:16:42.000000', 3, '6a7265d45fe24567b23fe6974163e7f5');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (195, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTU0NDc0MywiaWF0IjoxNjUxNDU4MzQzLCJqdGkiOiJmYTM1N2YxMzFlMjM0ZThkOGMwZDNlYWY5ZWM1OWQ5NSIsInVzZXJfaWQiOjN9.pwQ4GBkmD0JF-14FVf5TFd37mbSHFe57GyOFHNClgyM', '2022-05-02 02:25:43.732060', '2022-05-03 02:25:43.000000', 3, 'fa357f131e234e8d8c0d3eaf9ec59d95');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (196, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTU0NjMzMSwiaWF0IjoxNjUxNDU5OTMxLCJqdGkiOiI1YzI0OWJhZjI2YWY0M2NlYjVmZDMyMWE2NTI2N2E4MyIsInVzZXJfaWQiOjN9.8Ryrv_nqa593ZWu9emtz-jY9WFnN8YnG9rxjufxq6ro', '2022-05-02 02:52:11.626555', '2022-05-03 02:52:11.000000', 3, '5c249baf26af43ceb5fd321a65267a83');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (197, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTU1MDA3NywiaWF0IjoxNjUxNDYzNjc3LCJqdGkiOiIxY2E3ZGUwMTY2ZmQ0OThlOTU3MTY0OGQxMjMxYjhlNyIsInVzZXJfaWQiOjN9.jySV0-oMvSFX3rjFyLg11XwGfW2B6ak002qgEy4cEoU', '2022-05-02 03:54:37.495823', '2022-05-03 03:54:37.000000', 3, '1ca7de0166fd498e9571648d1231b8e7');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (198, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTU1MDA3OCwiaWF0IjoxNjUxNDYzNjc4LCJqdGkiOiIwZmI4YjdkZGM5Nzg0YzEyOWJjZGVmY2RjNWI1ZjhkZSIsInVzZXJfaWQiOjN9.f3a3uC0juceeHggHjLIyB4kCCN-fRbfntSiJWeXcul4', '2022-05-02 03:54:38.264145', '2022-05-03 03:54:38.000000', 3, '0fb8b7ddc9784c129bcdefcdc5b5f8de');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (199, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTU1MDgzNCwiaWF0IjoxNjUxNDY0NDM0LCJqdGkiOiJkYzBiMWJhNzA1M2I0NzQ0OWMzMGUzNWVlYWJiYWZkYSIsInVzZXJfaWQiOjN9.J7e1oUEPp8DEkg2-Q2JUfyh-L2rlK09DsWFYhDxcG2s', '2022-05-02 04:07:14.339797', '2022-05-03 04:07:14.000000', 3, 'dc0b1ba7053b47449c30e35eeabbafda');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (200, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTcyNTQ5NSwiaWF0IjoxNjUxNjM5MDk1LCJqdGkiOiJiMWM1ZmNjNmI2YzU0NDRkOTZiNGY3NjFkYzdlNDU5MCIsInVzZXJfaWQiOjE2fQ.VSODmk5_ucKKRMCMfqW2kan7eCHSD_JJJF0K8pR6LQg', '2022-05-04 04:38:15.939800', '2022-05-05 04:38:15.000000', 16, 'b1c5fcc6b6c5444d96b4f761dc7e4590');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (201, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTczMTM2NSwiaWF0IjoxNjUxNjQ0OTY1LCJqdGkiOiJiNTAwOWFkZDg1YWU0YWJjOWFmMjE1ZjMwN2RiODI4OCIsInVzZXJfaWQiOjN9.o0xYThdTIcRGSXThpgxxrFSN1sc3zwlqodLxMuAo2NQ', '2022-05-04 06:16:05.968353', '2022-05-05 06:16:05.000000', 3, 'b5009add85ae4abc9af215f307db8288');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (202, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTczMTM2NywiaWF0IjoxNjUxNjQ0OTY3LCJqdGkiOiI2YzA0ZTM5NGE1Yjg0ZWI1OGFhNDUwZDU0YjNkZThjMCIsInVzZXJfaWQiOjN9.L5VjkYOs4_PDJvRD6zbjSMxySMeckbQWhsOmClwGUy4', '2022-05-04 06:16:07.326643', '2022-05-05 06:16:07.000000', 3, '6c04e394a5b84eb58aa450d54b3de8c0');
INSERT INTO `token_blacklist_outstandingtoken` VALUES (203, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY1MTczMTQ5OCwiaWF0IjoxNjUxNjQ1MDk4LCJqdGkiOiIzNDliNzJkMDAzZmY0MTg4ODg0YzNiN2JhNWFjNzZmYiIsInVzZXJfaWQiOjE2fQ.7tqTcQANgkU5Zpw4Rc7LQveobJwvVQmz8bdp2-5fCm0', '2022-05-04 06:18:18.808840', '2022-05-05 06:18:18.000000', 16, '349b72d003ff4188884c3b7ba5ac76fb');

-- ----------------------------
-- Table structure for traffic_state_eta_pred
-- ----------------------------
DROP TABLE IF EXISTS `traffic_state_eta_pred`;
CREATE TABLE `traffic_state_eta_pred`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `MAE` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `MAPE` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `MSE` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `RMSE` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `masked_MAE` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `masked_MAPE` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `masked_MSE` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `masked_RMSE` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `R2` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `EVAR` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `Precision` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `Recall` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `F1_Score` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `MAP` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `PCC` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `task_id` bigint(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `traffic_state_eta_pred_task_id_96b439cf`(`task_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of traffic_state_eta_pred
-- ----------------------------

-- ----------------------------
-- Table structure for traj_loc_pred
-- ----------------------------
DROP TABLE IF EXISTS `traj_loc_pred`;
CREATE TABLE `traj_loc_pred`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `Recall` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `task_id` bigint(0) NOT NULL,
  `F1` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `MAP` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `MRR` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `NDCG` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `Precision` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `traj_loc_pred_task_id_57c3338c`(`task_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of traj_loc_pred
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
