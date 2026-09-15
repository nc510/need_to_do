/*
 Navicat MySQL Data Transfer

 Source Server         : p
 Source Server Type    : MySQL
 Source Server Version : 50743
 Source Host           : localhost:3306
 Source Schema         : need_to_do

 Target Server Type    : MySQL
 Target Server Version : 50743
 File Encoding         : 65001

 Date: 14/09/2026 10:41:14
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_group
-- ----------------------------

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id`, `permission_id`) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id`, `codename`) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 93 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

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
INSERT INTO `auth_permission` VALUES (25, 'Can add 学科', 7, 'add_subject');
INSERT INTO `auth_permission` VALUES (26, 'Can change 学科', 7, 'change_subject');
INSERT INTO `auth_permission` VALUES (27, 'Can delete 学科', 7, 'delete_subject');
INSERT INTO `auth_permission` VALUES (28, 'Can view 学科', 7, 'view_subject');
INSERT INTO `auth_permission` VALUES (29, 'Can add 章节', 8, 'add_chapter');
INSERT INTO `auth_permission` VALUES (30, 'Can change 章节', 8, 'change_chapter');
INSERT INTO `auth_permission` VALUES (31, 'Can delete 章节', 8, 'delete_chapter');
INSERT INTO `auth_permission` VALUES (32, 'Can view 章节', 8, 'view_chapter');
INSERT INTO `auth_permission` VALUES (33, 'Can add 小节', 9, 'add_section');
INSERT INTO `auth_permission` VALUES (34, 'Can change 小节', 9, 'change_section');
INSERT INTO `auth_permission` VALUES (35, 'Can delete 小节', 9, 'delete_section');
INSERT INTO `auth_permission` VALUES (36, 'Can view 小节', 9, 'view_section');
INSERT INTO `auth_permission` VALUES (37, 'Can add 知识点', 10, 'add_knowledgepoint');
INSERT INTO `auth_permission` VALUES (38, 'Can change 知识点', 10, 'change_knowledgepoint');
INSERT INTO `auth_permission` VALUES (39, 'Can delete 知识点', 10, 'delete_knowledgepoint');
INSERT INTO `auth_permission` VALUES (40, 'Can view 知识点', 10, 'view_knowledgepoint');
INSERT INTO `auth_permission` VALUES (41, 'Can add 题目', 11, 'add_question');
INSERT INTO `auth_permission` VALUES (42, 'Can change 题目', 11, 'change_question');
INSERT INTO `auth_permission` VALUES (43, 'Can delete 题目', 11, 'delete_question');
INSERT INTO `auth_permission` VALUES (44, 'Can view 题目', 11, 'view_question');
INSERT INTO `auth_permission` VALUES (45, 'Can add 试卷', 12, 'add_testpaper');
INSERT INTO `auth_permission` VALUES (46, 'Can change 试卷', 12, 'change_testpaper');
INSERT INTO `auth_permission` VALUES (47, 'Can delete 试卷', 12, 'delete_testpaper');
INSERT INTO `auth_permission` VALUES (48, 'Can view 试卷', 12, 'view_testpaper');
INSERT INTO `auth_permission` VALUES (49, 'Can add 会员信息', 13, 'add_profile');
INSERT INTO `auth_permission` VALUES (50, 'Can change 会员信息', 13, 'change_profile');
INSERT INTO `auth_permission` VALUES (51, 'Can delete 会员信息', 13, 'delete_profile');
INSERT INTO `auth_permission` VALUES (52, 'Can view 会员信息', 13, 'view_profile');
INSERT INTO `auth_permission` VALUES (53, 'Can add 答题记录', 14, 'add_testrecord');
INSERT INTO `auth_permission` VALUES (54, 'Can change 答题记录', 14, 'change_testrecord');
INSERT INTO `auth_permission` VALUES (55, 'Can delete 答题记录', 14, 'delete_testrecord');
INSERT INTO `auth_permission` VALUES (56, 'Can view 答题记录', 14, 'view_testrecord');
INSERT INTO `auth_permission` VALUES (57, 'Can add 每题答题记录', 15, 'add_answerrecord');
INSERT INTO `auth_permission` VALUES (58, 'Can change 每题答题记录', 15, 'change_answerrecord');
INSERT INTO `auth_permission` VALUES (59, 'Can delete 每题答题记录', 15, 'delete_answerrecord');
INSERT INTO `auth_permission` VALUES (60, 'Can view 每题答题记录', 15, 'view_answerrecord');
INSERT INTO `auth_permission` VALUES (61, 'Can add 错题本', 16, 'add_wrongquestion');
INSERT INTO `auth_permission` VALUES (62, 'Can change 错题本', 16, 'change_wrongquestion');
INSERT INTO `auth_permission` VALUES (63, 'Can delete 错题本', 16, 'delete_wrongquestion');
INSERT INTO `auth_permission` VALUES (64, 'Can view 错题本', 16, 'view_wrongquestion');
INSERT INTO `auth_permission` VALUES (65, 'Can add 班级', 17, 'add_class');
INSERT INTO `auth_permission` VALUES (66, 'Can change 班级', 17, 'change_class');
INSERT INTO `auth_permission` VALUES (67, 'Can delete 班级', 17, 'delete_class');
INSERT INTO `auth_permission` VALUES (68, 'Can view 班级', 17, 'view_class');
INSERT INTO `auth_permission` VALUES (69, 'Can add 班级管理员', 18, 'add_classadmin');
INSERT INTO `auth_permission` VALUES (70, 'Can change 班级管理员', 18, 'change_classadmin');
INSERT INTO `auth_permission` VALUES (71, 'Can delete 班级管理员', 18, 'delete_classadmin');
INSERT INTO `auth_permission` VALUES (72, 'Can view 班级管理员', 18, 'view_classadmin');
INSERT INTO `auth_permission` VALUES (73, 'Can add 班级申请', 19, 'add_classapplication');
INSERT INTO `auth_permission` VALUES (74, 'Can change 班级申请', 19, 'change_classapplication');
INSERT INTO `auth_permission` VALUES (75, 'Can delete 班级申请', 19, 'delete_classapplication');
INSERT INTO `auth_permission` VALUES (76, 'Can view 班级申请', 19, 'view_classapplication');
INSERT INTO `auth_permission` VALUES (77, 'Can add 班级作业', 20, 'add_classassignment');
INSERT INTO `auth_permission` VALUES (78, 'Can change 班级作业', 20, 'change_classassignment');
INSERT INTO `auth_permission` VALUES (79, 'Can delete 班级作业', 20, 'delete_classassignment');
INSERT INTO `auth_permission` VALUES (80, 'Can view 班级作业', 20, 'view_classassignment');
INSERT INTO `auth_permission` VALUES (81, 'Can add 班级作业记录', 21, 'add_classassignmentrecord');
INSERT INTO `auth_permission` VALUES (82, 'Can change 班级作业记录', 21, 'change_classassignmentrecord');
INSERT INTO `auth_permission` VALUES (83, 'Can delete 班级作业记录', 21, 'delete_classassignmentrecord');
INSERT INTO `auth_permission` VALUES (84, 'Can view 班级作业记录', 21, 'view_classassignmentrecord');
INSERT INTO `auth_permission` VALUES (85, 'Can add 答题草稿', 22, 'add_testdraft');
INSERT INTO `auth_permission` VALUES (86, 'Can change 答题草稿', 22, 'change_testdraft');
INSERT INTO `auth_permission` VALUES (87, 'Can delete 答题草稿', 22, 'delete_testdraft');
INSERT INTO `auth_permission` VALUES (88, 'Can view 答题草稿', 22, 'view_testdraft');
INSERT INTO `auth_permission` VALUES (89, 'Can add 通知', 23, 'add_notification');
INSERT INTO `auth_permission` VALUES (90, 'Can change 通知', 23, 'change_notification');
INSERT INTO `auth_permission` VALUES (91, 'Can delete 通知', 23, 'delete_notification');
INSERT INTO `auth_permission` VALUES (92, 'Can view 通知', 23, 'view_notification');

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_user
-- ----------------------------
INSERT INTO `auth_user` VALUES (1, 'pbkdf2_sha256$260000$u71ZOcs8zXVlP92iwYZM7x$9pzbZXfySfN7ZwvGZVX99BwtdSW5hFGa6upJDMww0PE=', '2026-09-13 15:26:03.789604', 1, 'sky510', '', '', '', 1, 1, '2026-09-13 06:01:28.702807');
INSERT INTO `auth_user` VALUES (2, 'pbkdf2_sha256$260000$naysm3H8H4CCEcKaqzvx3p$hCiWXVwRPc0xlUfSwYkltNtd7LxC7vfNEPK5uR+6QwE=', '2026-09-13 10:18:51.383748', 0, '菁', '廖伟家', '', '1706558460@qq.com', 1, 1, '2026-09-13 06:07:00.000000');
INSERT INTO `auth_user` VALUES (3, 'pbkdf2_sha256$260000$cDtQCywoRDTbE7J7V8bUuY$60GA4QFdAB6ox4M3uGnkQ56XJodwY0SrXJq0YEyDUwQ=', '2026-09-13 10:21:11.062216', 0, '琳', '喻紫琳', '', '3773006816@qq.com', 0, 1, '2026-09-13 10:09:47.717219');
INSERT INTO `auth_user` VALUES (4, 'pbkdf2_sha256$260000$3LyNxliSpHnutNNB8IvDc0$v73IA0Cs/uhGAEdK1PTLWA5CF23hygCuZkEv/gHRPC0=', '2026-09-13 10:18:28.540590', 0, '李晨园', '李晨园', '', 'yuanyay@126.com', 0, 1, '2026-09-13 10:18:04.387954');
INSERT INTO `auth_user` VALUES (5, 'pbkdf2_sha256$260000$DABfIImp7N4hUVSavc2nPB$sYbCVpBltg6OQmphZA5ZFcSkQ3U7IXgNPyVGdGzfpYc=', '2026-09-13 10:21:01.860316', 0, '婷', '徐婷', '', 'xt20081007@qq.com', 0, 1, '2026-09-13 10:19:02.258358');
INSERT INTO `auth_user` VALUES (6, 'pbkdf2_sha256$260000$Dm2j1JKD0uPZMxZpRTGhbD$Ih14xjNECyIVmQB1ap3fsoQ7Ry+g5you/h/68NGqQuU=', '2026-09-13 10:19:56.992671', 0, '陈欣怡', '陈欣怡', '', '196214775@qq.com', 0, 1, '2026-09-13 10:19:36.824180');
INSERT INTO `auth_user` VALUES (7, 'pbkdf2_sha256$260000$BhEheI0cka4eDBMDtTGDbh$DE2Tnv5Qnvn/vFkVOrjDMrwNZLpNndNNKGNPJdg7zn0=', '2026-09-13 10:20:00.966427', 0, '李乐瑶', '李乐瑶', '', '2199214529@qq.com', 0, 1, '2026-09-13 10:19:43.926150');
INSERT INTO `auth_user` VALUES (8, 'pbkdf2_sha256$260000$zAeURHhS0DJSWzttYMfs13$yWsLHU58eXd287Gt4xttBa/26xArunntv0MIopGlg18=', '2026-09-13 10:25:42.021478', 0, '张昊煜', '张昊煜', '', '3764783436@qq.com', 0, 1, '2026-09-13 10:20:41.344202');
INSERT INTO `auth_user` VALUES (9, 'pbkdf2_sha256$260000$xuwgBqLOym2JZaKmbqvKyr$3w0VLvfSYNkvAS6e0F2IYzcddpPV1Ho15J4f5DWnykQ=', '2026-09-13 10:21:39.051598', 0, '黄智彬', '黄智彬', '', '676099561@qq.com', 0, 1, '2026-09-13 10:21:19.817468');
INSERT INTO `auth_user` VALUES (10, 'pbkdf2_sha256$260000$4vf5rPrpktJCXjIqvLxDS3$AgbK4VY911YJUFNpLob5CzNC6UcDfNC1wmFKD7ZupSo=', '2026-09-13 10:21:33.211983', 0, '谢紫豪', '谢紫豪', '', '3314604749@qq.com', 0, 1, '2026-09-13 10:21:20.583679');
INSERT INTO `auth_user` VALUES (11, 'pbkdf2_sha256$260000$DJAcgcw4LbI9BTaj5MRlDs$wzontlmcn83JZdnakqHeHvCTj0+y0j90nmcOaqSWRoc=', '2026-09-13 10:21:50.500557', 0, '于龙', '于龙', '', '3858168685@qq.com', 0, 1, '2026-09-13 10:21:23.784335');
INSERT INTO `auth_user` VALUES (12, 'pbkdf2_sha256$260000$nd25KQLWtWMCAtKo9qC6RU$qPmgWkyCQwFbCuc5pf1j0OHyKIUUrDZfkM2NisWV3v8=', '2026-09-13 10:21:57.337767', 0, '徐若琪', '徐若琪', '', '2303700471@qq.com', 0, 1, '2026-09-13 10:21:30.238834');
INSERT INTO `auth_user` VALUES (13, 'pbkdf2_sha256$260000$hydYAPQSpyL8aSTvi7xHRl$5jubdipomukEULWbrV20pznM/W4UAtpO06XO8YrsKrw=', '2026-09-13 10:23:28.378228', 0, 'fkejjqi', '袁昌乐', '', '414443862@qq.com', 0, 1, '2026-09-13 10:21:40.527644');
INSERT INTO `auth_user` VALUES (14, 'pbkdf2_sha256$260000$uewzXPdiChakO4b0C8KBhH$/IYRmFJzp1xXhfrqBQ5wxSXsosbeMjHbk8UJXeG4y9w=', '2026-09-13 10:22:45.204873', 0, 'AAA', '祝一豪', '', '2829515611@qq.com', 0, 1, '2026-09-13 10:21:49.433870');
INSERT INTO `auth_user` VALUES (15, 'pbkdf2_sha256$260000$2O6I2LXjxNw612G5TrqIl5$dujbst/EkCOVrL2+rxMZKeFz0+AmQwSQhAFx59Ho/vg=', '2026-09-13 10:23:22.747491', 0, '黄广奥', '黄广奥', '', '2704988576@qq.com', 0, 1, '2026-09-13 10:21:49.490718');
INSERT INTO `auth_user` VALUES (16, 'pbkdf2_sha256$260000$9lyRGnVJ8wLzDAt5bJp4cu$2LhneiZr1CUErySRnYg0gSGBtnt/yvg0mxTFBrnldvU=', '2026-09-13 10:22:17.853401', 0, '202405', '丛子涵', '', 'kuromi0vOhan@qq.co', 0, 1, '2026-09-13 10:22:01.290049');
INSERT INTO `auth_user` VALUES (17, 'pbkdf2_sha256$260000$bUj5nhVa8C49FVKdrmc0ik$twnDuQc0OEyry85BkshoolVBOMV8q7el8uZxU+rTlEI=', '2026-09-13 10:23:23.586426', 0, '臆想', '王焕', '', '2039403805@qq.com', 0, 1, '2026-09-13 10:22:38.678313');
INSERT INTO `auth_user` VALUES (18, 'pbkdf2_sha256$260000$vreIu5WNfwFQOwxYe3PBAG$trWYBDDwaXY6OIC71Z4S54O+GkEpV/VsoaLMBPsNZp8=', '2026-09-13 10:25:00.000000', 0, '吴敬梓', '吴敬梓', '', '2213535814@qq.com', 0, 1, '2026-09-13 10:24:00.000000');
INSERT INTO `auth_user` VALUES (19, 'pbkdf2_sha256$260000$kH6NQB9zU7L6P007CPH0ye$unzozoaLEiAsiz1B3SzKSg6ToI5zciIkAlDm9bCkNs4=', '2026-09-13 10:29:44.412386', 0, '叶思宇', '叶思宇', '', '2136425705@qq.com', 0, 1, '2026-09-13 10:29:26.288427');
INSERT INTO `auth_user` VALUES (20, 'pbkdf2_sha256$260000$H7DZbZKvqSlUwXJGXhK0fR$5R8zNb9+Bb4MD88zSh+QbYJMSywaCeF9Busk+edkBu4=', '2026-09-13 10:33:51.701444', 0, '小小', '潘安晴', '', '1775923527@qq.com', 0, 1, '2026-09-13 10:31:05.002944');
INSERT INTO `auth_user` VALUES (21, 'pbkdf2_sha256$260000$U05Wm6Y8OYYo3GzENC4Wek$pcZYRTVDOA7xUTKiBfCCEeT1bm318fyEV9vX13+Fl/A=', '2026-09-13 10:32:37.021605', 0, '蒋献林', '蒋献林', '', '2260729530@qq.com', 0, 1, '2026-09-13 10:31:37.703386');
INSERT INTO `auth_user` VALUES (22, 'pbkdf2_sha256$260000$Pjx9TH3tNkVQPtOKAaefrG$74kEzQ6DwOL0HVw5sX7D/jV0Z5UAL74Yb4iUTf0Iv7E=', '2026-09-13 10:35:00.000000', 0, '严家豪', '严家豪', '', '1530813265@qq.com', 0, 1, '2026-09-13 10:35:00.000000');
INSERT INTO `auth_user` VALUES (23, 'pbkdf2_sha256$260000$Yr4YZQu2OVy6VZhR1G0GRc$VXU/uMjc5Rm0sUflrwk8BDzoTSNu9rly982JzjX+XrY=', '2026-09-13 10:36:39.465200', 0, '钱山', '钱山', '', '749568148.@qq.com', 0, 1, '2026-09-13 10:36:05.249994');
INSERT INTO `auth_user` VALUES (24, 'pbkdf2_sha256$260000$BiIcbcUZhJIDRVu63B5E5P$XCQKDWz5MEFha6psMw6J76KCREW8riYRYB64b9UP2dk=', '2026-09-13 10:37:11.771541', 0, '黎祀', '徐梓梦', '', '3435577498@qq.com', 0, 1, '2026-09-13 10:36:47.552318');
INSERT INTO `auth_user` VALUES (25, 'pbkdf2_sha256$260000$b9TKsMYtYrj7MM9o2a6lPl$7LOYthoVbn0B/aLmz9EitZFezzEtWtmysTJPf5V+0d4=', '2026-09-13 10:49:52.128617', 0, '黎砚宁', 'xxy', '', '3761085337@qq.com', 0, 1, '2026-09-13 10:37:14.395884');
INSERT INTO `auth_user` VALUES (26, 'pbkdf2_sha256$260000$vQX2XfGdJn26CaTl4DtP2e$fFj1ZNuKF1sIa8Cj1ykeFCzIClolb+Gff8q1Ea+HPrM=', '2026-09-13 10:44:12.025446', 0, '黄雅欣', '黄雅欣', '', '2739788762@qq.com', 0, 1, '2026-09-13 10:40:39.133651');
INSERT INTO `auth_user` VALUES (27, 'pbkdf2_sha256$260000$EQBYPIiwkp6DdvY1O3ckN2$4an0zFErexza29bkVLM7g3+B4rnmZfCMYoEQgwsaaz4=', '2026-09-13 10:42:21.226184', 0, 'WJZ', '吴敬梓', '', '2771664655@qq.com', 0, 1, '2026-09-13 10:41:50.751407');

-- ----------------------------
-- Table structure for auth_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_groups_user_id_group_id_94350c0c_uniq`(`user_id`, `group_id`) USING BTREE,
  INDEX `auth_user_groups_group_id_97559544_fk_auth_group_id`(`group_id`) USING BTREE,
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_user_groups
-- ----------------------------

-- ----------------------------
-- Table structure for auth_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq`(`user_id`, `permission_id`) USING BTREE,
  INDEX `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 93 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of auth_user_user_permissions
-- ----------------------------
INSERT INTO `auth_user_user_permissions` VALUES (1, 2, 1);
INSERT INTO `auth_user_user_permissions` VALUES (2, 2, 2);
INSERT INTO `auth_user_user_permissions` VALUES (3, 2, 3);
INSERT INTO `auth_user_user_permissions` VALUES (4, 2, 4);
INSERT INTO `auth_user_user_permissions` VALUES (17, 2, 17);
INSERT INTO `auth_user_user_permissions` VALUES (18, 2, 18);
INSERT INTO `auth_user_user_permissions` VALUES (19, 2, 19);
INSERT INTO `auth_user_user_permissions` VALUES (20, 2, 20);
INSERT INTO `auth_user_user_permissions` VALUES (21, 2, 21);
INSERT INTO `auth_user_user_permissions` VALUES (22, 2, 22);
INSERT INTO `auth_user_user_permissions` VALUES (23, 2, 23);
INSERT INTO `auth_user_user_permissions` VALUES (24, 2, 24);
INSERT INTO `auth_user_user_permissions` VALUES (25, 2, 25);
INSERT INTO `auth_user_user_permissions` VALUES (26, 2, 26);
INSERT INTO `auth_user_user_permissions` VALUES (27, 2, 27);
INSERT INTO `auth_user_user_permissions` VALUES (28, 2, 28);
INSERT INTO `auth_user_user_permissions` VALUES (29, 2, 29);
INSERT INTO `auth_user_user_permissions` VALUES (30, 2, 30);
INSERT INTO `auth_user_user_permissions` VALUES (31, 2, 31);
INSERT INTO `auth_user_user_permissions` VALUES (32, 2, 32);
INSERT INTO `auth_user_user_permissions` VALUES (33, 2, 33);
INSERT INTO `auth_user_user_permissions` VALUES (34, 2, 34);
INSERT INTO `auth_user_user_permissions` VALUES (35, 2, 35);
INSERT INTO `auth_user_user_permissions` VALUES (36, 2, 36);
INSERT INTO `auth_user_user_permissions` VALUES (37, 2, 37);
INSERT INTO `auth_user_user_permissions` VALUES (38, 2, 38);
INSERT INTO `auth_user_user_permissions` VALUES (39, 2, 39);
INSERT INTO `auth_user_user_permissions` VALUES (40, 2, 40);
INSERT INTO `auth_user_user_permissions` VALUES (41, 2, 41);
INSERT INTO `auth_user_user_permissions` VALUES (42, 2, 42);
INSERT INTO `auth_user_user_permissions` VALUES (43, 2, 43);
INSERT INTO `auth_user_user_permissions` VALUES (44, 2, 44);
INSERT INTO `auth_user_user_permissions` VALUES (45, 2, 45);
INSERT INTO `auth_user_user_permissions` VALUES (46, 2, 46);
INSERT INTO `auth_user_user_permissions` VALUES (47, 2, 47);
INSERT INTO `auth_user_user_permissions` VALUES (48, 2, 48);
INSERT INTO `auth_user_user_permissions` VALUES (49, 2, 49);
INSERT INTO `auth_user_user_permissions` VALUES (50, 2, 50);
INSERT INTO `auth_user_user_permissions` VALUES (51, 2, 51);
INSERT INTO `auth_user_user_permissions` VALUES (52, 2, 52);
INSERT INTO `auth_user_user_permissions` VALUES (53, 2, 53);
INSERT INTO `auth_user_user_permissions` VALUES (54, 2, 54);
INSERT INTO `auth_user_user_permissions` VALUES (55, 2, 55);
INSERT INTO `auth_user_user_permissions` VALUES (56, 2, 56);
INSERT INTO `auth_user_user_permissions` VALUES (57, 2, 57);
INSERT INTO `auth_user_user_permissions` VALUES (58, 2, 58);
INSERT INTO `auth_user_user_permissions` VALUES (59, 2, 59);
INSERT INTO `auth_user_user_permissions` VALUES (60, 2, 60);
INSERT INTO `auth_user_user_permissions` VALUES (61, 2, 61);
INSERT INTO `auth_user_user_permissions` VALUES (62, 2, 62);
INSERT INTO `auth_user_user_permissions` VALUES (63, 2, 63);
INSERT INTO `auth_user_user_permissions` VALUES (64, 2, 64);
INSERT INTO `auth_user_user_permissions` VALUES (65, 2, 65);
INSERT INTO `auth_user_user_permissions` VALUES (66, 2, 66);
INSERT INTO `auth_user_user_permissions` VALUES (67, 2, 67);
INSERT INTO `auth_user_user_permissions` VALUES (68, 2, 68);
INSERT INTO `auth_user_user_permissions` VALUES (69, 2, 69);
INSERT INTO `auth_user_user_permissions` VALUES (70, 2, 70);
INSERT INTO `auth_user_user_permissions` VALUES (71, 2, 71);
INSERT INTO `auth_user_user_permissions` VALUES (72, 2, 72);
INSERT INTO `auth_user_user_permissions` VALUES (73, 2, 73);
INSERT INTO `auth_user_user_permissions` VALUES (74, 2, 74);
INSERT INTO `auth_user_user_permissions` VALUES (75, 2, 75);
INSERT INTO `auth_user_user_permissions` VALUES (76, 2, 76);
INSERT INTO `auth_user_user_permissions` VALUES (77, 2, 77);
INSERT INTO `auth_user_user_permissions` VALUES (78, 2, 78);
INSERT INTO `auth_user_user_permissions` VALUES (79, 2, 79);
INSERT INTO `auth_user_user_permissions` VALUES (80, 2, 80);
INSERT INTO `auth_user_user_permissions` VALUES (81, 2, 81);
INSERT INTO `auth_user_user_permissions` VALUES (82, 2, 82);
INSERT INTO `auth_user_user_permissions` VALUES (83, 2, 83);
INSERT INTO `auth_user_user_permissions` VALUES (84, 2, 84);
INSERT INTO `auth_user_user_permissions` VALUES (85, 2, 85);
INSERT INTO `auth_user_user_permissions` VALUES (86, 2, 86);
INSERT INTO `auth_user_user_permissions` VALUES (87, 2, 87);
INSERT INTO `auth_user_user_permissions` VALUES (88, 2, 88);
INSERT INTO `auth_user_user_permissions` VALUES (89, 2, 89);
INSERT INTO `auth_user_user_permissions` VALUES (90, 2, 90);
INSERT INTO `auth_user_user_permissions` VALUES (91, 2, 91);
INSERT INTO `auth_user_user_permissions` VALUES (92, 2, 92);

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content_type_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id`) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_auth_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------
INSERT INTO `django_admin_log` VALUES (1, '2026-09-13 06:08:01.500042', '2', '菁', 2, '[{\"changed\": {\"fields\": [\"Staff status\", \"Superuser status\", \"User permissions\", \"Last login\"]}}]', 4, 1);
INSERT INTO `django_admin_log` VALUES (2, '2026-09-13 06:08:11.197319', '2', '菁', 2, '[{\"changed\": {\"fields\": [\"\\u7528\\u6237\\u89d2\\u8272\"]}}]', 13, 1);
INSERT INTO `django_admin_log` VALUES (3, '2026-09-13 06:09:04.273827', '2', '菁', 2, '[{\"changed\": {\"fields\": [\"Superuser status\", \"User permissions\"]}}]', 4, 1);
INSERT INTO `django_admin_log` VALUES (4, '2026-09-13 06:30:58.695846', '1', '第01章 信息与数据、通信基础、计算机发展、特点、分类等', 2, '[{\"changed\": {\"fields\": [\"\\u662f\\u5426\\u53d1\\u5e03\"]}}]', 12, 2);
INSERT INTO `django_admin_log` VALUES (5, '2026-09-13 06:33:37.111342', '2', '第01章 信息与数据、通信基础、计算机发展、特点、分类等（2）', 2, '[{\"changed\": {\"fields\": [\"\\u662f\\u5426\\u53d1\\u5e03\"]}}]', 12, 2);
INSERT INTO `django_admin_log` VALUES (6, '2026-09-13 09:42:42.437953', '7', '第01章 通讯基本概念、分类、特征', 2, '[{\"changed\": {\"fields\": [\"\\u8bd5\\u5377\\u6807\\u9898\"]}}]', 12, 2);
INSERT INTO `django_admin_log` VALUES (7, '2026-09-13 09:56:09.580386', '12', '第01章 计算机应用领域及发展趋势', 3, '', 12, 2);
INSERT INTO `django_admin_log` VALUES (8, '2026-09-13 15:27:25.228607', '18', '吴敬梓', 2, '[{\"changed\": {\"fields\": [\"First name\", \"Last login\"]}}]', 4, 1);
INSERT INTO `django_admin_log` VALUES (9, '2026-09-13 15:27:38.989169', '22', '严家豪', 2, '[{\"changed\": {\"fields\": [\"First name\", \"Last login\"]}}]', 4, 1);

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label`, `model`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (4, 'auth', 'user');
INSERT INTO `django_content_type` VALUES (5, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (15, 'quiz', 'answerrecord');
INSERT INTO `django_content_type` VALUES (8, 'quiz', 'chapter');
INSERT INTO `django_content_type` VALUES (17, 'quiz', 'class');
INSERT INTO `django_content_type` VALUES (18, 'quiz', 'classadmin');
INSERT INTO `django_content_type` VALUES (19, 'quiz', 'classapplication');
INSERT INTO `django_content_type` VALUES (20, 'quiz', 'classassignment');
INSERT INTO `django_content_type` VALUES (21, 'quiz', 'classassignmentrecord');
INSERT INTO `django_content_type` VALUES (10, 'quiz', 'knowledgepoint');
INSERT INTO `django_content_type` VALUES (23, 'quiz', 'notification');
INSERT INTO `django_content_type` VALUES (13, 'quiz', 'profile');
INSERT INTO `django_content_type` VALUES (11, 'quiz', 'question');
INSERT INTO `django_content_type` VALUES (9, 'quiz', 'section');
INSERT INTO `django_content_type` VALUES (7, 'quiz', 'subject');
INSERT INTO `django_content_type` VALUES (22, 'quiz', 'testdraft');
INSERT INTO `django_content_type` VALUES (12, 'quiz', 'testpaper');
INSERT INTO `django_content_type` VALUES (14, 'quiz', 'testrecord');
INSERT INTO `django_content_type` VALUES (16, 'quiz', 'wrongquestion');
INSERT INTO `django_content_type` VALUES (6, 'sessions', 'session');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'contenttypes', '0001_initial', '2025-11-13 15:04:11.656036');
INSERT INTO `django_migrations` VALUES (2, 'auth', '0001_initial', '2025-11-13 15:04:11.896562');
INSERT INTO `django_migrations` VALUES (3, 'admin', '0001_initial', '2025-11-13 15:04:11.957569');
INSERT INTO `django_migrations` VALUES (4, 'admin', '0002_logentry_remove_auto_add', '2025-11-13 15:04:11.962953');
INSERT INTO `django_migrations` VALUES (5, 'admin', '0003_logentry_add_action_flag_choices', '2025-11-13 15:04:11.968921');
INSERT INTO `django_migrations` VALUES (6, 'contenttypes', '0002_remove_content_type_name', '2025-11-13 15:04:12.008526');
INSERT INTO `django_migrations` VALUES (7, 'auth', '0002_alter_permission_name_max_length', '2025-11-13 15:04:12.033764');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0003_alter_user_email_max_length', '2025-11-13 15:04:12.045648');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0004_alter_user_username_opts', '2025-11-13 15:04:12.064068');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0005_alter_user_last_login_null', '2025-11-13 15:04:12.085926');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0006_require_contenttypes_0002', '2025-11-13 15:04:12.088390');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0007_alter_validators_add_error_messages', '2025-11-13 15:04:12.092776');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0008_alter_user_username_max_length', '2025-11-13 15:04:12.118172');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0009_alter_user_last_name_max_length', '2025-11-13 15:04:12.142828');
INSERT INTO `django_migrations` VALUES (15, 'auth', '0010_alter_group_name_max_length', '2025-11-13 15:04:12.154155');
INSERT INTO `django_migrations` VALUES (16, 'auth', '0011_update_proxy_permissions', '2025-11-13 15:04:12.159095');
INSERT INTO `django_migrations` VALUES (17, 'auth', '0012_alter_user_first_name_max_length', '2025-11-13 15:04:12.184758');
INSERT INTO `django_migrations` VALUES (18, 'sessions', '0001_initial', '2025-11-13 15:04:12.205726');
INSERT INTO `django_migrations` VALUES (19, 'questions', '0001_initial', '2025-11-13 15:05:50.689330');
INSERT INTO `django_migrations` VALUES (20, 'exams', '0001_initial', '2025-11-13 15:10:10.119593');
INSERT INTO `django_migrations` VALUES (21, 'records', '0001_initial', '2025-11-13 15:22:44.748773');
INSERT INTO `django_migrations` VALUES (22, 'quiz', '0001_initial', '2025-11-13 16:06:14.327868');
INSERT INTO `django_migrations` VALUES (23, 'quiz', '0002_auto_20251114_0014', '2025-11-13 16:14:44.775298');
INSERT INTO `django_migrations` VALUES (24, 'quiz', '0003_testpaper', '2025-11-14 16:02:32.980210');
INSERT INTO `django_migrations` VALUES (25, 'quiz', '0004_answerrecord_profile_testrecord_wrongquestion', '2025-11-17 15:54:00.005928');
INSERT INTO `django_migrations` VALUES (26, 'quiz', '0005_alter_question_options', '2025-11-17 16:17:15.290647');
INSERT INTO `django_migrations` VALUES (27, 'quiz', '0006_alter_answerrecord_user_answer', '2025-11-17 16:54:12.936404');
INSERT INTO `django_migrations` VALUES (28, 'quiz', '0007_wrongquestion_user_answer', '2026-04-26 14:06:18.046380');
INSERT INTO `django_migrations` VALUES (29, 'quiz', '0008_auto_20251118_2217', '2026-04-26 14:06:18.243420');
INSERT INTO `django_migrations` VALUES (30, 'quiz', '0009_auto_20251118_2250', '2026-04-26 14:06:18.341159');
INSERT INTO `django_migrations` VALUES (31, 'quiz', '0010_alter_profile_phone_number', '2026-04-26 14:06:18.362101');
INSERT INTO `django_migrations` VALUES (32, 'quiz', '0011_profile_name', '2026-04-26 14:06:18.436901');
INSERT INTO `django_migrations` VALUES (33, 'quiz', '0012_profile_last_login', '2026-04-26 14:06:18.487766');
INSERT INTO `django_migrations` VALUES (34, 'quiz', '0011_profile_plain_password', '2026-05-24 13:37:44.022265');
INSERT INTO `django_migrations` VALUES (36, 'quiz', '0012_auto_20260524_2207', '2026-05-24 14:10:14.207688');
INSERT INTO `django_migrations` VALUES (37, 'quiz', '0013_auto_20260524_2225', '2026-05-24 14:26:28.637090');
INSERT INTO `django_migrations` VALUES (38, 'quiz', '0014_add_class_assignment', '2026-05-24 14:53:12.297154');
INSERT INTO `django_migrations` VALUES (40, 'quiz', '0015_auto_20260525_0028', '2026-05-24 16:28:45.796667');
INSERT INTO `django_migrations` VALUES (41, 'quiz', '0016_auto_20260525_0055', '2026-05-24 16:55:24.124920');
INSERT INTO `django_migrations` VALUES (42, 'quiz', '0017_remove_profile_plain_password', '2026-05-24 17:10:08.964324');
INSERT INTO `django_migrations` VALUES (43, 'quiz', '0018_auto_20260525_2215', '2026-05-25 14:15:30.991962');
INSERT INTO `django_migrations` VALUES (44, 'quiz', '0019_auto_20260530_0102', '2026-05-29 17:02:15.946968');
INSERT INTO `django_migrations` VALUES (45, 'quiz', '0020_auto_20260530_0126', '2026-05-29 17:26:13.735954');
INSERT INTO `django_migrations` VALUES (46, 'quiz', '0021_add_profile_session_key', '2026-05-29 17:38:12.263125');
INSERT INTO `django_migrations` VALUES (47, 'quiz', '0022_add_testpaper_is_public', '2026-05-31 14:45:45.834212');
INSERT INTO `django_migrations` VALUES (48, 'quiz', '0023_auto_20260531_2355', '2026-05-31 17:13:27.693395');
INSERT INTO `django_migrations` VALUES (49, 'quiz', '0024_auto_20260601_0156', '2026-05-31 17:57:55.354536');
INSERT INTO `django_migrations` VALUES (50, 'quiz', '0025_auto_20260602_0741', '2026-06-01 23:42:42.529946');
INSERT INTO `django_migrations` VALUES (51, 'quiz', '0025_auto_20260602_1705', '2026-06-02 09:08:57.610030');
INSERT INTO `django_migrations` VALUES (52, 'quiz', '0026_add_wrongquestion_correct_answer', '2026-06-03 16:13:02.293538');
INSERT INTO `django_migrations` VALUES (53, 'quiz', '0027_add_profile_stats', '2026-06-03 16:16:32.692148');
INSERT INTO `django_migrations` VALUES (57, 'quiz', '0028_auto_20260825_1756', '2026-08-25 09:59:32.058948');
INSERT INTO `django_migrations` VALUES (58, 'quiz', '0029_auto_20260825_1827', '2026-08-25 10:27:51.830355');
INSERT INTO `django_migrations` VALUES (59, 'quiz', '0030_notification', '2026-08-25 10:33:59.586137');
INSERT INTO `django_migrations` VALUES (60, 'quiz', '0031_p2_3_exam_control', '2026-08-25 11:09:52.073299');
INSERT INTO `django_migrations` VALUES (61, 'quiz', '0032_classassignment_random_fields', '2026-08-26 10:56:25.676023');
INSERT INTO `django_migrations` VALUES (62, 'quiz', '0033_auto_20260827_1516', '2026-08-27 07:19:50.731061');
INSERT INTO `django_migrations` VALUES (63, 'quiz', '0034_auto_20260827_1520', '2026-08-27 07:20:15.482473');
INSERT INTO `django_migrations` VALUES (64, 'quiz', '0035_profile_plain_password', '2026-08-27 08:53:29.611572');

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of django_session
-- ----------------------------
INSERT INTO `django_session` VALUES ('2j7m4punnarw44nw1cnszys5iudxilf8', '.eJxVjMsOwiAURP-FtSFAkIdL934DuQ-QqoGktCvjv9smXegs55yZt0iwLjWtI89pYnERUZx-OwR65rYDfkC7d0m9LfOEclfkQYe8dc6v6-H-HVQYdVtbw7FAUZDZemXQUnBnMMya0TtitiZ41ECFNBgdkJwzFqxTcQs58fkCCoA4Yw:1x5hL9:4SMpYDRU4vRTnoFi-567uAPB6FeA27TqewPLC7O37AE', '2026-09-14 10:21:39.054590');
INSERT INTO `django_session` VALUES ('2sbzsdtvgc3zwqnjdh45w6l5movjbzsu', 'eyJjYXB0Y2hhX3RleHQiOiJSRXpBIn0:1x5hWH:NwVPHuvP75ccc7dE7IZQ_oYRNlkB1WFRziXD4uKmIiQ', '2026-09-14 10:33:09.863563');
INSERT INTO `django_session` VALUES ('4show4h8y3qp7uhzcdeyfeg38xysy9qp', '.eJxVjDsOwjAQBe_iGlnr-JdQ0nMGa9de4wCypTipEHeHSCmgfTPzXiLgtpawdV7CnMRZDE6cfkfC-OC6k3THemsytrouM8ldkQft8toSPy-H-3dQsJdvnSkzeIpZZUoZJw3RZ_ZKgXHeGyZlLDkL3oIelXEwTaNJw4DJMCoN4v0BJk03zA:1x5hgy:Uo_hlkBpqpxgSVvgHpm_uNTNwU9q94_E_wXark-ez2k', '2026-09-14 10:44:12.031431');
INSERT INTO `django_session` VALUES ('5pr7w1c9txmytlb170o5jnoizl8llpgd', '.eJxVjMEOwiAQBf-FsyHAQgGP3vsNZBeoVA0kpT0Z_9026UGvM_PemwXc1hK2npcwJ3Zljl1-GWF85nqI9MB6bzy2ui4z8SPhp-18bCm_bmf7d1Cwl30tBu3Jk5mSwclkbdFRBAWI5HS0ktyghNQGPAptaccSpMqeACJRIvb5Au2BOEk:1x5hP4:l3gtn0zuivCXCUPO5FA21l-v_lbgBmQWYZF9wGv1etE', '2026-09-14 10:25:42.026465');
INSERT INTO `django_session` VALUES ('6npdn988f13wn8owjse3k8ftdj0egu8d', '.eJxVjMEOwiAQRP-FsyEgsKhH734D2WW3UjWQlPZk_HfbpAc9TTLvzbxVwmUuaekypZHVRYE6_HaE-Sl1A_zAem86tzpPI-lN0Tvt-tZYXtfd_Tso2Mu6dp5itmCCxwjARvIJrcV8XCMPxICBnEEkAEKGEM9DZEGiYL0XR-rzBfXBONU:1x5hJU:7uyDImYhW5WToYCRg4dBw53dfniwFtqQErxSR90iqqI', '2026-09-14 10:19:56.996661');
INSERT INTO `django_session` VALUES ('6qgrcjzylvly1yp3hezr8vxqh8reiv2q', 'eyJjYXB0Y2hhX3RleHQiOiJtU1JaIn0:1x5hib:1UQIsCJoISKIzqVvwsF-4D_OcJWpYUf30dbwkvfzTlg', '2026-09-14 10:45:53.894535');
INSERT INTO `django_session` VALUES ('8wkq6yggkya3wzad5rg8f23zzfjn1c8c', '.eJxVjEEOwiAQRe_C2pAiAxSX7nsGMjOAVA0kpV0Z765NutDtf-_9lwi4rSVsPS1hjuIiFIjT70jIj1R3Eu9Yb01yq-syk9wVedAupxbT83q4fwcFe_nWbMjYhGgUKfZOj4ZRQ7bARBZ9ggHHCDo7DUZF47MCjGkgPLNTrLV4fwAdOziC:1x5hMD:8LRW5IcfH25woZcRFIgiS3Gl0nPEOXJWONGMjHWPIJY', '2026-09-14 10:22:45.207865');
INSERT INTO `django_session` VALUES ('a4cylebmb8julta8okqrfs4rkp5t88f3', '.eJxVjDsOwjAQBe_iGlmr-E9JzxmsXXuNA8iW4qRC3B0ipYD2zcx7iYjbWuM2eIlzFmcxOXH6HQnTg9tO8h3brcvU27rMJHdFHnTIa8_8vBzu30HFUb-1AltyIkigkdFSsK5QKA41GMfgOBMaNREGQwDe2aC1V5itNczeJ_H-ACP-OHE:1x5hfB:ucXRJMAwWAqgB5wF0QkTwEnf3TbJrkr7plLgoQjnaSQ', '2026-09-14 10:42:21.230172');
INSERT INTO `django_session` VALUES ('a7o2lcsin02csdic47cai4ukil8jeu89', '.eJxVjEEOwiAQRe_C2pAplFJcuu8ZyAwDUjWQlHZlvLtt0oVu_3vvv4XHbc1-a3HxM4urUEpcfkfC8IzlIPzAcq8y1LIuM8lDkSdtcqocX7fT_TvI2PJeGzA92kTEXRgsJGQYtXZsNeNglHMG0RpLIwXcFWBm1YMFlzRAx058vhCuOCQ:1x5hYw:y1NciqFBt70Q__UXhMdgIajxu6Je-1DwcZ9hedN5x7M', '2026-09-14 10:35:54.202991');
INSERT INTO `django_session` VALUES ('abutk4ft1ddce2m8zcwbwo8xdw2tyozs', '.eJzNlstymzAUhl_FwzrYCHQjy-77BHXHoxu2GoyIBONMM3n3SuA0KWDZbjddyUZC5ztH__nFa7JjfXfY9U7ZnZbJY5InD5-fcSaeVBMm5A_W7M1amKazmq_DkvV51q2_GqnqL-e1f2xwYO7g30acsAoSSinPMRSkZCUCvAAVYlgKAHKelbnkfkPKBKeIZ5UoCkgxKyDCJQybHlXTO7_Xt9dt0rCj2iaPq22y3faSFjIMAqOVHwnKqR9wXpDwjzMQBpjhbfLgX9A-hfHViqXO1Fqu_I8A68YFx5CMC0sikeA8EspBGCjF9FqktFXNuKa39bgklGwT5jbjhNIyTIAsy98eVvelrAS8SrC3pm-XGIaJGUSxDCHCUDEeIGAFWCgDRHT4p0LdcYarGIuWqWBWTkCee_1z01pT6VrNUODb9z8fgFiBpAxsJS0DFFJlcbsmuDFPqfl9VLfoQsBP0QhW6vZoIde01o1yS8V47pXrtGlm1cCx5NWgDsSrcE4IYBT0ySV6Z7yGo4-tsd2EZzMAMXnUzWZcsHunczM8EsMTo25UxgNXReQMFrN8UBEhURUNsMxac0qlOU1bKwrcqWNbs24uMzqVGbqeyrm2qCB3WM8A36mX7naZSTGPdqP9OGFNXS9JrPMlaVk7dyCQXW8wBDM1sFTZuwOdySIsvrXSzqTuuWdWRQ5NWOVPaHcZMOoAkSa4BnhXE1zGizr4aBn_ZxOAYtoEZTQVNlxGHMEPE6ScB0WgCqEYvDgw2w32d4fZ0n8Mx5m91AhWCWPlrB5LHpCTbFAY5qL6ZP5_g1Vr13k2JZ6WuFjjTspeIFu6B3ICB6Pw31rlBwsmuYjWRlvhlaReRM2OLAhkCeZkTbO_dCsBMtENgLHvBzWYJymUHLyD3WGeThyMqW_RzDlUNg91o3PyXtdSN_ulavhSudnlB6LNMvrmJGlUFINaquu25PS-YV0_M84PHta2tRZs6YDybHpA_rpL3n4BZ_LLmA:1x5hMZ:v5W2JIxzRrgiK4ZCQep8v4vPP3uZpnhUn4tX2-wd8cQ', '2026-09-14 10:23:07.429325');
INSERT INTO `django_session` VALUES ('ba53rihp9cnuyxzvfvstjdjx270h7gpx', 'eyJjYXB0Y2hhX3RleHQiOiJKQXFiIn0:1x5hLR:ztubP8l0AWgLUA9NvYGbNRtTl_xmjLJHb8CxIcV7ffY', '2026-09-14 10:21:57.792943');
INSERT INTO `django_session` VALUES ('brxgus6dmko8j4kl5zr9xkgbhe35zpc8', 'eyJjYXB0Y2hhX3RleHQiOiJNeVdUIn0:1x5hOV:_vK72iPjOFsRo7ypId9SV1yoSJipOGzv1pOc1KfKcZ4', '2026-09-14 10:25:07.940675');
INSERT INTO `django_session` VALUES ('c484xierqk0415uopxtz5rddpe9942xl', '.eJxVjMsOwiAQRf-FtSEMb1y69xsIA4NUDU1KuzL-uzbpQrf3nHNfLKZtbXEbtMSpsDMz7PS7YcoP6jso99RvM89zX5cJ-a7wgw5-nQs9L4f7d9DSaN-65opaSCwebABXpSvSaCmCRgWBJCQbjBKKitOOggcU2XplFRD5AMjeH8ywNu0:1x5hKX:jSzh4DgJZiAmbhKsXRUOMHbeHzuzy-LO9j-StiLuGIE', '2026-09-14 10:21:01.864318');
INSERT INTO `django_session` VALUES ('cax1b3bk3ft7lflvrxdyav60jsy7djm1', '.eJxVjEEOwiAURO_C2pAPCBSX7j0D-fBBqgaS0q6Md2-bdFGXM-_NfJnHZS5-6WnyI7Ebk4JdzmXA-E51J_TC-mw8tjpPY-C7wg_a-aNR-twP9--gYC_bGi1kSVYTBMhxIKMwk3NbIhBqsBmuZHRSiVy2QoMw0mqMSqIz6GRkvxUQ9jf8:1x5hVl:iOlPpPjGSl-tGSjtB6PFr8Xaondqm1qxxGLNG8UU46s', '2026-09-14 10:32:37.025596');
INSERT INTO `django_session` VALUES ('dfz6h6bd926mt6ahq35rzx6imq2agaf6', 'eyJjYXB0Y2hhX3RleHQiOiJBNkNaIn0:1x5hIp:wXIcxlVb6j_I0mumGMofRmm82tV860ynV3VHg6OoSh8', '2026-09-14 10:19:15.717452');
INSERT INTO `django_session` VALUES ('g2qxyxucqqvkh1fk72bky90cofnxw6fh', '.eJxVjDsOwjAQBe_iGlnOJvhDSZ8zWLveNQ4gR4qTCnF3iJQC2jcz76UibmuJW5MlTqwuquvV6XckTA-pO-E71tus01zXZSK9K_qgTY8zy_N6uH8HBVv51pgo5AEsATG4ngyyTYJJfE5DALFgh0DesQfoPPbnEAw75zOLMZ5QvT8sTDie:1x5hMu:kxA_UgrXjbNIMPO5IMnw6DryGADWkgUKpbThr8-NyJQ', '2026-09-14 10:23:28.382217');
INSERT INTO `django_session` VALUES ('g9h4tq8uxhd82grdmszd7wyc9vpyvgdz', '.eJxVjMsOwiAQRf-FtSEMMJRx6d5vIFMeUjU0Ke3K-O_apAvd3nPOfYnA21rD1vMSpiTOApw4_Y4jx0duO0l3brdZxrmtyzTKXZEH7fI6p_y8HO7fQeVev7XJgyKMSlm0lHzSngitRva6mBJRKYhAnpzTuRiwBIYHAMcGs7EUxfsDzGA2ZQ:1x5hLl:Q_rH6qh1Y_cdpXEzFbg50eFMtftAd5oXu31go7wm-Lw', '2026-09-14 10:22:17.857390');
INSERT INTO `django_session` VALUES ('hcf0bzc9dvt1zrawk9o9xjvd42clavan', 'eyJjYXB0Y2hhX3RleHQiOiJiang4In0:1x5hZz:cnm9VShWkNRLFX34Vc8pNB9O8qMnBgHmiDJ-22D7T0A', '2026-09-14 10:36:59.180148');
INSERT INTO `django_session` VALUES ('izarjezux4pib5b7y5g3jarmwcq0m302', 'eyJjYXB0Y2hhX3RleHQiOiJtQVl5In0:1x5hJe:ROl2ZUc_fLMGIDdNKczBZEKgPfM8h9_zybj-TDX0o-A', '2026-09-14 10:20:06.614063');
INSERT INTO `django_session` VALUES ('kh72p6wyvpkpr1e9lq02mpj8yz2kcu58', '.eJxVjEEOwiAQRe_C2hCmFgZcuu8ZyMBQqRpISrsy3l1JutDtf-_9l_C0b9nvLa1-YXERgOL0OwaKj1Q64TuVW5Wxlm1dguyKPGiTU-X0vB7u30Gmlns9J4f2TENAClaDQVIAyqkvILaKmDlCiGnUQDCjMWoctErsMAASivcHIw44hg:1x5hMp:ciXWYKN39QywFJ9wOTlgQyam9NchsPMVuPuNBn2a53Y', '2026-09-14 10:23:23.589417');
INSERT INTO `django_session` VALUES ('kpkce0dd6lr8oamzy2ev3pg3g2pba9nx', '.eJxVjEEOwiAQRe_C2pCWQVpcuvcMZIYZpGpoUtqV8e7SpAvdvvf-f6uA25rDVmUJE6uLMqBOv5AwPqXshh9Y7rOOc1mXifSe6MNWfZtZXtej_TvIWHNbJ0_E3gIb9AmHrnNo8AzOWM_9GIU9MUWgyK7xsQljh6bEpR5QQH2-Ilg4kA:1x5hZf:hrymQdBn_h-UyGVCS3zl8uHE6TQa5Lt-Pv7JBCK36VU', '2026-09-14 10:36:39.469190');
INSERT INTO `django_session` VALUES ('ktgsch3zihavtohw9785anplgdxdi5dk', '.eJxVjEsKwjAUAO-StYQ0aR7GpXvPUN4vpioJNO1KvLsUutDtzDBvM-G2lmnrukyzmIsZnDn9QkJ-at2NPLDem-VW12Umuyf2sN3emujrerR_g4K97N8AQMCYvKowJBqyc5QACaLjzAASfVZIY4BRCF32PghHz0nOEdV8vhp6OL8:1x5hL3:s2m_uIxJ_AMqAr1zOR7BCtIcn0oBOpAfpRTT4y-ZXZo', '2026-09-14 10:21:33.215975');
INSERT INTO `django_session` VALUES ('kyc2ilyaqlu9b1opopw2myizetr6cx99', '.eJxVjDkOwjAUBe_iGlnebSjpcwbrLw4OIEeKkwpxd4iUAto3M-8lMmxrzVsvS55YXITW4vQ7ItCjtJ3wHdptljS3dZlQ7oo8aJfDzOV5Pdy_gwq9fmuVtPJkwYDXESMn5LONEHSiFNkap4gcRm2iQT-CceyQfKCAYbTJOfH-AO9aN5U:1x5hLK:6Us5wsRPgAVwiAr0IwdIz5aPsafMO5bbc160Kf7biJE', '2026-09-14 10:21:50.504546');
INSERT INTO `django_session` VALUES ('m157apf609ijtmcjmv0dcp6z9r1qoebf', 'eyJjYXB0Y2hhX3RleHQiOiJYNjRGIn0:1x5hNB:6Bklht11B9dIS3kTKSfiUSqcZaUxoJheACRVwgHAKpE', '2026-09-14 10:23:45.270747');
INSERT INTO `django_session` VALUES ('ndv4skyjy02e83yncplavnwk857pul3w', 'eyJjYXB0Y2hhX3RleHQiOiJsbklrIn0:1x5kD5:yxkyx9B83Oq65FpHTpTXtdenqx9FFrxuIW0cJIHjoFY', '2026-09-14 13:25:31.567984');
INSERT INTO `django_session` VALUES ('onc8i4zrd7c474pemz5iosglvh7gcvwh', 'eyJjYXB0Y2hhX3RleHQiOiJIczNCIn0:1x5jQE:ONFcZVzCuyr-KwzPpIJSsH-Oy_LuPhhGwYMokeoioEU', '2026-09-14 12:35:02.788404');
INSERT INTO `django_session` VALUES ('pxlizktdih3ad1uqtg8ph7d2w42aqapl', '.eJxVjEEOwiAQRe_C2hA6Qju4dN8zkGEYpGpoUtqV8e7apAvd_vfef6lA21rC1mQJU1IXNajT7xaJH1J3kO5Ub7Pmua7LFPWu6IM2Pc5JntfD_Tso1Mq3Bg_MgzgQIHPOOWYvyRnwaBx36DKS7fqMMUdjMVrqiQkBUIxDY1m9P_GaOAU:1x5hJY:xnagrFjuDM0D9kajtiA-t8qlIk1lxnFUrfuhMurzuJo', '2026-09-14 10:20:00.969419');
INSERT INTO `django_session` VALUES ('q1lo3ikeeep9c369ln9lophfimnjtlma', 'eyJjYXB0Y2hhX3RleHQiOiJrRklaIn0:1x5hL8:LMls2bl0X0RVkCaUCg5eSQTdTvYOlzVMxK1qf8TUPYY', '2026-09-14 10:21:38.217369');
INSERT INTO `django_session` VALUES ('qrdf833mukkyw14tygcagdulm4u4kixd', '.eJxVjEEOwiAQRe_C2hAoZcq4dO8ZyACDVA0kpV0Z765NutDtf-_9l_C0rcVvnRc_J3EW2orT7xgoPrjuJN2p3pqMra7LHOSuyIN2eW2Jn5fD_Tso1Mu3HlxGo5zKDq2hDDZaUnEChU5hNAyMwRgdR7BIyYyDY2ZQYIOGABOK9wfnijc0:1x5hMo:fU1Mk_JXiuEwnIxs7lHBphvx_M_WeZ-n6y7xbIRvff8', '2026-09-14 10:23:22.750511');
INSERT INTO `django_session` VALUES ('qxqb8o5kcr1jb455f8fzy6s1qj1l1e6c', 'eyJjYXB0Y2hhX3RleHQiOiJ1QmFwIn0:1x5hJY:eE1hGkaUFEUOtZfn-1GYT_8num2F1DFGSiS_MeJ6esg', '2026-09-14 10:20:00.429590');
INSERT INTO `django_session` VALUES ('rrt4g0y1lac9gt0vhb5ua4q7l2tr22rk', '.eJxVjDsOwjAQBe_iGlnr9WdjSnrOYPmLA8iW4qRC3B0ipYD2zcx7Mee3tbpt5MXNiZ2ZsOz0OwYfH7ntJN19u3Uee1uXOfBd4Qcd_NpTfl4O9--g-lG_NYkYKU4GCkjQqCloS9ICENpgpEbSCoXSIKmUgKAIlABEmeUkAhn2_gC7SjWM:1x5hSy:H92iasltuKsj98Q1B1G8IShsexT6OulEjPwH2A9ivPM', '2026-09-14 10:29:44.416376');
INSERT INTO `django_session` VALUES ('shwh9h50wkkvdcj4zk59qcmbr3bealjt', 'eyJjYXB0Y2hhX3RleHQiOiJKRUFRIn0:1x5hLe:wpQypqTb9uVNuoSIxbMa9HRMX-9zNVMdnpRoX8MfNJ8', '2026-09-14 10:22:10.304660');
INSERT INTO `django_session` VALUES ('synomospog36wwr3e8pomsmf11hg2ljx', '.eJxVjMEOgjAQRP-lZ9MUWNrFo3e-odlutxY1JaFwMv67kHDQ22Tem3krT9ua_VZl8VNUVwXq8tsF4qeUA8QHlfuseS7rMgV9KPqkVY9zlNftdP8OMtW8r22HTnpjTdOSMKMDDthhnzAZsk3kloDQDG5PA6cklhESgYQULEJUny_kVTil:1x5hI4:jFFspnYUz4p8e2BDZh3KEfCZu5-GiGAhlAkSzBSyEhA', '2026-09-14 10:18:28.543582');
INSERT INTO `django_session` VALUES ('t5nap1gnrrxbdgzsvowe4h86tmxpvqf8', '.eJzNlttymzAQhl_Fw3WwEUIcctn7PkHd8eiwstVgRCQYZ5rJuxcJp0kBy3Z70ysZJLTfrv795ddoR_vusOstmJ0S0WOEoofP7xjlT9C4CfGDNnu95rrpjGJrt2R9nrXrr1pA_eW89o8NDtQehq8lx1zkSSmQQEmKS5SmKXApK1wKIfKKkZRXBctYklSYYcRzwESCpBWSlHPuNj1C09thr2-v26ihR9hGj6tttN32osTCDTwnq2EsSFoOQ57iwj0xityQJfk2ehg-UEMK46eSxlbXSqyGHw7WjguOLhnrlgQiZfNIJEVuKMu8vBYpbqEZ1_SmHpe4km3c3GacACXcBEqS9O1hdV_KwLOrBHuj-3aJwU_MIPAyBHeDpMxBZBJRV4aMlP4JXN3zJJchFiViTo2YgDz36uemNVqqGmYo2dv3P1-gUIGEcGxVWTkoAhW-XRNM66dY_z6qW3TBs0_Rihzg9mgu17hWDdilYjz3YDulm1k18lDy4NVBmHTnRFBOnD6ZIO-M13DUsdWmm_BsPBAVR9VsxgW7dzo7wytCeHzUDSTMcclCzGBzmnoVFUVQRR6WGqNPsdCnaWsFgTs4tjXt5jIrpzIj11M515bg4g7r8fAdvHS3y0zwebQb7cdyo-t6SWLdUJKWtnMHQsn1BiNZAp5FJu8OdCYLsAytFXc6ts89NRA4NG5gOKHdZcCgAwSa4BrgXU1wGS_o4KNl_J9NgPC0CapgKtRfRoxkHyZYMuYUQSQhIXh-oKbz9neH2Zb_GI5Rc6kRDHBtxKweSx6QFolXWM64_GT-f4NVK9sNbMCflrhoY09gLpAt3QNpkXmjqAiqPljyIuXB2ijDByXBC6_pkTqBLMGcjG72l24lVEx0g7LQ_wfw5llgEN476B3maflB6_oWzZxDJfNQNzon61UtVLNfqsZQKju7_FCwWUbfnCRNMPZqkddtyap9Q7t-ZpwfPLRta8Xp0gGlyfSAhusuevsFrmzMfg:1x5m5o:1pIElVhjgiqDYi1cixCrhJkvxRRngYBYuAQQLnluYbU', '2026-09-14 15:26:08.408702');
INSERT INTO `django_session` VALUES ('thyxpptdvkvdozmwlk0cx7ck35av19pv', '.eJxVjEEOwiAQRe_C2hAqjIBL956hmWEYqRpISrsy3l2bdKHb_977LzXiupRx7XkeJ1ZnZdXhdyNMj1w3wHest6ZTq8s8kd4UvdOur43z87K7fwcFe_nWJwyAkMDIUZglhAgxohEbQcgAM7HL1nhHzofEVmBIAwt4wUDOsnp_APrGOKg:1x5hKh:wTktDCtZN7WonFGv3-z6XuDbrY7Y222JM8Bzcr1LVQc', '2026-09-14 10:21:11.066206');
INSERT INTO `django_session` VALUES ('tvtshw4m6u4dbrfb1ai12a5f52mh2hwc', '.eJxVjEEOwiAQRe_C2pBhSim4dO8ZyMBMpWpoUtqV8e7apAvd_vfef6lI21ri1mSJE6uzQlCn3zFRfkjdCd-p3mad57ouU9K7og_a9HVmeV4O9--gUCvf2khKDtBgL14cWhs6JgKLA1AYOIcgMiKjiLfA0BnyDhNCtuxHl3r1_gD9dTf0:1x5hWx:vM-CW931vwcEUzrpSmN0Gaf3tqqtpzsdasaatT5MPuk', '2026-09-14 10:33:51.705429');
INSERT INTO `django_session` VALUES ('u8mk94az77f18jo2vvsx0u8cs9rhtbd7', 'eyJjYXB0Y2hhX3RleHQiOiJCbkVBIn0:1x5v9t:aB4bRg0SNJVZGvV0Xh1PrxQPtT6guAZuczOmTu1XYBg', '2026-09-15 01:06:57.417194');
INSERT INTO `django_session` VALUES ('uekaug1zeqm3u69fuomt5deaxnhtrjwa', '.eJxVjEsOwiAUAO_C2hDK5wEu3XsG8oBXqRpISrsy3l1JutDtzGReLOC-lbB3WsOS2ZlJzU6_MGJ6UB0m37HeGk-tbusS-Uj4YTu_tkzPy9H-DQr2Mr5IkQxI5dBKgyYmm5wWGmTSSkGcBWYxAXyN8d55Z0GS9oCzIy3jxN4f_GQ3fg:1x5haB:3Nc0LSUpOBnkeZkuKaM3BcA6bHmFIhLTtG1zWlGMjEg', '2026-09-14 10:37:11.775530');
INSERT INTO `django_session` VALUES ('v640t1byjf5z1petlieim88nscuvo5e1', '.eJxVjEEOwiAQRe_C2hAKMlCX7j0DmWGmUjU0Ke3KeHdD0oVu_3vvv1XCfStpb7KmmdVFWa9OvyNhfkrthB9Y74vOS93WmXRX9EGbvi0sr-vh_h0UbKXXDnj04HM0hocBgkdD4PJkgz8HkckSBusiOzJohSCHCI5G8iKWo1GfL_rXOAU:1x5hmS:lRuj6_HwPHTKX0Egp3MjjxkaNDE-hfx7hJoCfIK3Qog', '2026-09-14 10:49:52.131608');
INSERT INTO `django_session` VALUES ('ynnl9zixyo2lzwis3mk84lz3qggt23b7', 'eyJjYXB0Y2hhX3RleHQiOiJOb0xaIn0:1x5hKh:AdMfSDiPgoTdjCx1edoIjSBAUXlhN3YwnXYj12pzD8I', '2026-09-14 10:21:11.897220');
INSERT INTO `django_session` VALUES ('yu5crix9djyegwygilrug5ntwricpogz', '.eJxVjDsOwjAQRO_iGlmszfpDSc8ZrF17wQHkSHFSIe5OIqWAbjTvzbxVomWuaekypaGoswKjDr8lU35K20h5ULuPOo9tngbWm6J32vV1LPK67O7fQaVe1zWeyHtrGCmIY5Cbw-KPwUAQQggWGGOOjA4iWxHJYCEg8xqhlADq8wX7lDg3:1x5hLR:597xIWmW-_-YKVNQ3wf0Iryzm-f7werrG7CqwwGOvls', '2026-09-14 10:21:57.340759');

-- ----------------------------
-- Table structure for exams_exam
-- ----------------------------
DROP TABLE IF EXISTS `exams_exam`;
CREATE TABLE `exams_exam`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `exam_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `duration` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_by_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `exams_exam_created_by_id_41730b16_fk_auth_user_id`(`created_by_id`) USING BTREE,
  CONSTRAINT `exams_exam_created_by_id_41730b16_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of exams_exam
-- ----------------------------

-- ----------------------------
-- Table structure for exams_paper
-- ----------------------------
DROP TABLE IF EXISTS `exams_paper`;
CREATE TABLE `exams_paper`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `total_score` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `generation_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_by_id` int(11) NOT NULL,
  `exam_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `exams_paper_created_by_id_5aeb170c_fk_auth_user_id`(`created_by_id`) USING BTREE,
  INDEX `exams_paper_exam_id_91e397e4_fk_exams_exam_id`(`exam_id`) USING BTREE,
  CONSTRAINT `exams_paper_created_by_id_5aeb170c_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `exams_paper_exam_id_91e397e4_fk_exams_exam_id` FOREIGN KEY (`exam_id`) REFERENCES `exams_exam` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of exams_paper
-- ----------------------------

-- ----------------------------
-- Table structure for exams_paperquestion
-- ----------------------------
DROP TABLE IF EXISTS `exams_paperquestion`;
CREATE TABLE `exams_paperquestion`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `score` int(11) NOT NULL,
  `order` int(11) NOT NULL,
  `paper_id` bigint(20) NOT NULL,
  `question_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `exams_paperquestion_paper_id_803a21b9_fk_exams_paper_id`(`paper_id`) USING BTREE,
  INDEX `exams_paperquestion_question_id_5cdb7a14_fk_questions`(`question_id`) USING BTREE,
  CONSTRAINT `exams_paperquestion_paper_id_803a21b9_fk_exams_paper_id` FOREIGN KEY (`paper_id`) REFERENCES `exams_paper` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `exams_paperquestion_question_id_5cdb7a14_fk_questions` FOREIGN KEY (`question_id`) REFERENCES `questions_question` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of exams_paperquestion
-- ----------------------------

-- ----------------------------
-- Table structure for questions_question
-- ----------------------------
DROP TABLE IF EXISTS `questions_question`;
CREATE TABLE `questions_question`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `options` json NOT NULL,
  `correct_answer` json NOT NULL,
  `difficulty` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `creator_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `questions_question_creator_id_67567768_fk_auth_user_id`(`creator_id`) USING BTREE,
  CONSTRAINT `questions_question_creator_id_67567768_fk_auth_user_id` FOREIGN KEY (`creator_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of questions_question
-- ----------------------------

-- ----------------------------
-- Table structure for quiz_answerrecord
-- ----------------------------
DROP TABLE IF EXISTS `quiz_answerrecord`;
CREATE TABLE `quiz_answerrecord`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_answer` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `correct_answer` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_correct` tinyint(1) NOT NULL,
  `question_id` bigint(20) NOT NULL,
  `test_record_id` bigint(20) NOT NULL,
  `original_explanation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `original_options` json NOT NULL,
  `original_question_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `original_question_type` int(11) NULL DEFAULT NULL,
  `answered_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `quiz_answerrecord_question_id_ccbd4beb_fk_quiz_question_id`(`question_id`) USING BTREE,
  INDEX `quiz_answerrecord_test_record_id_361fd638_fk_quiz_testrecord_id`(`test_record_id`) USING BTREE,
  CONSTRAINT `quiz_answerrecord_question_id_ccbd4beb_fk_quiz_question_id` FOREIGN KEY (`question_id`) REFERENCES `quiz_question` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_answerrecord_test_record_id_361fd638_fk_quiz_testrecord_id` FOREIGN KEY (`test_record_id`) REFERENCES `quiz_testrecord` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_answerrecord
-- ----------------------------
INSERT INTO `quiz_answerrecord` VALUES (1, 'A', 'A', 1, 700, 1, '解析：ENIAC（埃尼阿克）于1946年诞生于美国，被公认为世界上第一台通用电子计算机，因此正确答案是A。', '{\"A\": \"ENIAC\", \"B\": \"EDVAC\", \"C\": \"EDSAC\", \"D\": \"MARK-II\"}', '()是世界上第一台电子计算机英文缩写名', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (2, 'B', 'B', 1, 699, 1, '解析：计算机的发展历程通常划分为四个阶段，分别以电子管、晶体管、中小规模集成电路和大规模超大规模集成电路为标志，因此正确答案是B。', '{\"A\": \"3\", \"B\": \"4\", \"C\": \"5\", \"D\": \"6\"}', '从第一台计算机诞生到现在的半个多世纪里计算机的发展经历了()个阶段。', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (3, 'B', 'B', 1, 698, 1, '解析：第一代计算机（1946-1958年）主要逻辑元件采用电子管，主存储器使用磁鼓或延迟线，速度较慢，主要应用于军事和科学计算，因此选项B正确。', '{\"A\": \"主要逻辑元件采用的是集成电路\", \"B\": \"主要应用领域以军事和科学计算为主\", \"C\": \"主存储器采用半导体存储器\", \"D\": \"第一代计算机速度快\"}', '下列关于第一代计算机叙述正确的是()', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (4, 'D', 'D', 1, 697, 1, '解析：计算机的发展阶段依据电子元器件的更新划分为电子管、晶体管、中小规模集成电路、大规模和超大规模集成电路四个时代，选项D准确对应这一划分标准，其他选项均不符合。', '{\"A\": \"低档计算机、中档计算机、高档计算机、手提计算机\", \"B\": \"微型计算机、小型计算机、中型计算机、大型计算机\", \"C\": \"光子计算机、生物计算机、量子计算机、纳米计算机\", \"D\": \"电子管、晶体管、MSI和SSI、LSI和VLSI\"}', '根据使用电子元器件的不同，计算机的发展经历了以下()四个时代。', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (5, 'B', 'B', 1, 696, 1, '解析：计算机发展过程中，电子元器件趋于更先进、更可靠、更省电，而成本（价格）通常下降而非上升，因此“越来越昂贵”不符合趋势，故选B。', '{\"A\": \"电子元器件越来越先进\", \"B\": \"电子元器件越来越昂贵\", \"C\": \"电子元器件越来越可靠\", \"D\": \"电子元器件越来越省电\"}', '以下()不是计算机发展过程中的趋势', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (6, 'D', 'D', 1, 695, 1, '解析：计算机自诞生以来，虽然电子器件、工作速度和存储容量经历了巨大变革，但其基于“存储程序控制”的核心工作原理始终未变，因此选D。', '{\"A\": \"工作速度\", \"B\": \"采用的电子器件\", \"C\": \"存储容量\", \"D\": \"工作原理\"}', '计算机自诞生以来,()基本没有发生变化', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (7, 'A', 'A', 1, 694, 1, '解析：冯·诺依曼首次提出了“存储程序”计算机体系结构，这一概念是现代计算机设计的基础，因此正确选项为A。', '{\"A\": \"冯·诺依曼\", \"B\": \"莱布尼茨\", \"C\": \"香农\", \"D\": \"布尔\"}', '()首次提出\"存储程序\"计算机体系结构', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (8, 'B', 'B', 1, 693, 1, '解析：ENIAC（电子数字积分计算机）于1946年在美国宾夕法尼亚大学研制成功，是世界上第一台通用电子计算机，因此选择B选项。', '{\"A\": \"1956\", \"B\": \"1946\", \"C\": \"1949\", \"D\": \"1964\"}', '第一台电子计算机ENIAC是()年在美国研制的.', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (9, 'D', 'B', 0, 692, 1, '解析：ENIAC的全称为“Electronic Numerical Integrator and Computer”，中文译为“电子数字积分计算机”，因此选项B正确。其他选项均与ENIAC的实际名称不符。', '{\"A\": \"电子延迟存储自动计算机\", \"B\": \"电子数字积分计算机\", \"C\": \"离散变量自动电子计算机\", \"D\": \"电子存储通用计算机\"}', '世界上诞生的第一台电子计算机ENIAC的全名是()', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (10, 'D', 'D', 1, 691, 1, '解析：中国第一枚通用CPU“Godson”的中文名称是“龙芯”，由中国科学院计算技术研究所研制，因此正确答案为D。其他选项中，“深腾”是联想的高性能计算机，“鸿蒙”是华为的操作系统，“长城”是中国的航天或计算机品牌，均与CPU名称不符。', '{\"A\": \"深腾\", \"B\": \"鸿蒙\", \"C\": \"长城\", \"D\": \"龙芯\"}', '中国第一枚通用CPU(godson)的中文名字叫()', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (11, 'A', 'D', 0, 690, 1, '解析：超算属于第四代计算机，因为第四代计算机采用大规模集成电路和超大规模集成电路技术，而“银河”“神威”等超算正是基于这类技术实现的高性能计算系统。', '{\"A\": \"一\", \"B\": \"二\", \"C\": \"三\", \"D\": \"四\"}', '我们以前经常所说的“银河”“神威”,都是超算，它们都属于第()代计算机。', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (12, 'D', 'D', 1, 689, 1, '解析：第三代计算机（1964-1971年）以中小规模集成电路（MSI和SSI）为核心，采用半导体存储器，并出现了分时操作系统，但应用领域进入工业生产的过程控制和AI领域是第四代计算机的特征，因此D选项错误。', '{\"A\": \"采用半导体存储器\", \"B\": \"出现了分时操作系统\", \"C\": \"使用MSI和SSI\", \"D\": \"应用领域开始进入工业生产的过程控制和AI领域\"}', '下列关于第三代计算机的特点,下列选项中错误的是()', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (13, 'A', 'A', 1, 688, 1, '解析：冯·诺依曼提出了存储程序和采用二进制系统的设想，这一思想奠定了现代计算机体系结构的基础，因此选项A正确。', '{\"A\": \"冯.诺依曼\", \"B\": \"比尔.盖茨\", \"C\": \"莫里埃\", \"D\": \"香农\"}', '()提出了存储程序和采用二进制系统的设想', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (14, 'C', 'D', 0, 687, 1, '解析：双核处理器属于第四代计算机（超大规模集成电路）的典型特征，第一代至第三代分别采用电子管、晶体管和小规模集成电路，因此选D。', '{\"A\": \"第一代\", \"B\": \"第二代\", \"C\": \"第三代\", \"D\": \"第四代\"}', '配有双核处理器的个人计算机属于()计算机', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (15, 'D', 'D', 1, 686, 1, '解析：第四代计算机（约1970年代至1980年代）以大规模集成电路为特征，期间诞生了面向对象语言（如Smalltalk），而机器语言、高级语言和数据库语言均在此前出现，因此选D。', '{\"A\": \"机器语言\", \"B\": \"高级语言\", \"C\": \"数据库语言\", \"D\": \"面向对象语言\"}', '下列()语言在第四代计算机期间内诞生', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (16, 'D', 'D', 1, 685, 1, '解析：选项D“龙芯”通用CPU是中国科学院计算所自主研发的通用CPU，符合题目描述；其他选项如A是DSP芯片、B是操作系统、C是移动操作系统，均非通用CPU。', '{\"A\": \"“华睿1号”DSP芯片\", \"B\": \"麒麟服务器操作系统\", \"C\": \"华为鸿蒙系统(HUAWEIHarmonyOS）\", \"D\": \"“龙芯”通用CPU\"}', '()是中国科学院计算所自主研发的通用CPU', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (17, 'B', 'B', 1, 684, 1, '解析：计算机根据处理数据的方式或类型不同，可分为数字计算机（处理离散数据）、模拟计算机（处理连续数据）和数模混合计算机，因此选项B正确。', '{\"A\": \"功能\", \"B\": \"处理数据的方式或类型\", \"C\": \"性能\", \"D\": \"使用范围\"}', '计算机依据()的不同可分为数字计算机、模拟计算机和数模混合计算机', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (18, 'C', 'C', 1, 683, 1, '解析：无人驾驶汽车、无人驾驶公交、自动化工厂等应用依赖计算机模拟人类智能进行决策与操作，因此智能化是未来计算机发展的总趋势，其他选项不符题意。', '{\"A\": \"微型化\", \"B\": \"巨型化\", \"C\": \"智能化\", \"D\": \"数字化\"}', '随着无人驾驶汽车、无人驾驶公交、自动化工厂等出现,说明了()是未来计算机发展的总趋势', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (19, 'C', 'C', 1, 682, 1, '解析：第四代计算机采用大规模和超大规模集成电路，而上一代（第三代）采用中小规模集成电路，电子器件发生了变化；运算速度和程序设计语言随技术发展显著提升和更新，唯有计算机的体系结构（如冯·诺依曼结构）自诞生以来基本保持不变，因此选C。', '{\"A\": \"电子器件\", \"B\": \"运算速度\", \"C\": \"体系结构\", \"D\": \"所采用的程序设计语言\"}', '第四代计算机与上一代计算机相比,所采用的()一直没有发生变化.', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (20, 'C', 'C', 1, 681, 1, '解析：计算机发展的特点是体积减小、应用领域扩大、运算速度加快，但计算机元器件数量并未减少，而是集成度提高，因此C选项错误。', '{\"A\": \"微型计算机体积越来越小\", \"B\": \"计算机应用领域越来越多\", \"C\": \"计算机元器件越来越少\", \"D\": \"计算机运算速度越来越快\"}', '下列关于计算机发展的特点的叙述错误的是()', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (21, 'C', 'C', 1, 680, 1, '解析：计算机发展按代际划分，第一代是电子管计算机，第二代是晶体管计算机，第三代是小、中规模集成电路计算机，第四代是大规模和超大规模集成电路计算机，选项C准确对应了这一顺序。', '{\"A\": \"光子计算机,电子管计算机,纳米计算机,集成电路计算机\", \"B\": \"机械计算机,集成电路计算机,大规模集成电路计算机,量子计算机\", \"C\": \"电子管计算机,晶体管计算机,小、中规模集成电路计算机,大规模和超大规模集成电路计算机\", \"D\": \"晶体管计算机,电动机械计算机,电子管计算机,集成电路计算机\"}', '一至四代的计算机依次是()', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (22, 'A', 'A', 1, 679, 1, '解析：现代电子计算机的发展阶段主要依据其核心电子元器件的演变来划分，如从电子管到晶体管、集成电路等，因此电子元器件是区分各个阶段的标志。', '{\"A\": \"电子元器件\", \"B\": \"性价比\", \"C\": \"存储器\", \"D\": \"功能\"}', '()是区分现代电子计算机发展的各个阶段的标志', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (23, 'D', 'C', 0, 678, 1, '解析：第二代计算机（约1956-1963年）以晶体管为主要元件，出现了批处理操作系统和高级程序设计语言（如FORTRAN），而汞延迟线是第一代计算机（电子管时代）使用的存储技术，因此与第二代计算机无关。', '{\"A\": \"使用了晶体管\", \"B\": \"出现了批处理操作系统\", \"C\": \"采用汞延迟线作为主存储器\", \"D\": \"出现了高级程序设计语言\"}', '下列哪一项与第二代计算机无关()', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (24, 'B', 'D', 0, 677, 1, '解析：第四代计算机（约1970年代至今）以大规模和超大规模集成电路为基础，软件技术成熟，主要使用高级语言（如C、Java等）进行编程，提高了开发效率和可移植性，因此选D。', '{\"A\": \"机器语言\", \"B\": \"汇编语言\", \"C\": \"二进制\", \"D\": \"高级语言\"}', '第四代计算机在语言方面主要使用()', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (25, 'A', 'A', 1, 676, 1, '解析：ENIAC（埃尼阿克）于1946年在美国研制成功，最初目的是为美国陆军计算弹道和射击表，属于军事用途，故A正确。它未使用分时操作系统（B错），主要元器件是电子管（C错），且未采用半导体存储器（D错）。', '{\"A\": \"ENIAC是为了军事用途进行研制的\", \"B\": \"它使用了分时操作系统\", \"C\": \"ENIAC上没有采用电子管作为主要元器件\", \"D\": \"采用半导体存储器\"}', '下列关于国际公认的第一台计算机ENIAC的叙述中,正确的是()', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (26, 'C', 'B', 0, 675, 1, '解析：第二代计算机（约1956-1963年）使用晶体管，并开始使用高级程序设计语言（如FORTRAN、COBOL），因此选项B正确。其他选项中，分时操作系统属于第三代计算机，半导体存储器属于第四代计算机，过程控制和人工智能主要从第三代开始应用。', '{\"A\": \"采用分时操作系统\", \"B\": \"使用的是高级程序设计语言\", \"C\": \"采用半导体存储器\", \"D\": \"应用领域开始步入过程控制、人工智能\"}', '下列关于第二代计算机说法正确的选项是()', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (27, 'C', 'C', 1, 674, 1, '解析：摩尔定律由戈登·摩尔提出，核心内容是芯片上集成的晶体管数量大约每18-24个月翻一番，同时计算能力也相应提升，因此选项C正确。', '{\"A\": \"芯片集成晶体管的能力每年增长一倍，其计算能力也增长一倍\", \"B\": \"芯片集成晶体管的能力每五年增长一倍，其计算能力也增长一倍\", \"C\": \"芯片集成晶体管的能力每18-24个月增长一倍，其计算能力也增长一倍\", \"D\": \"芯片集成晶体管的能力每6个月增长一倍，其计算能力也增长一倍\"}', '人们常用“摩尔定律”来比喻当代科学技术的进步与发展日新月异,这里“摩尔定律”指的是()', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (28, 'A', 'A', 1, 673, 1, '解析：摩尔定律是经验观察而非自然科学定律，主要揭示了信息技术进步的速度，A选项表述准确。B、D选项错误，因为摩尔定律并非永久适用；C选项错误，摩尔定律不是系统设计的定量原理。', '{\"A\": \"摩尔定律并非自然科学定律，它一定程度揭示了信息技术进步的速度。\", \"B\": \"摩尔定律和Amdahl定律一样，将一直指导计算机系统的设计\", \"C\": \"摩尔定律是重要的计算机系统设计定量原理\", \"D\": \"摩尔定律将一直适用于描述器件技术的发展\"}', '摩尔定律是内行人摩尔的经验之谈，以下关于摩尔定律的叙述,正确的是()。', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (29, 'C', 'C', 1, 672, 1, '解析：计算机的工作原理（如冯·诺依曼体系）自早期至今基本一致，并非导致体积大、耗电多、速度慢的原因，因此C项不正确。', '{\"A\": \"电子元器件的制造工艺不成熟\", \"B\": \"计算机的存储器容量有限\", \"C\": \"计算机的工作原理不合理\", \"D\": \"制造计算机的技术水平落后\"}', '早期的计算机体积大、耗电多、速度慢，其原因不包括()。', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (30, 'B', 'C', 0, 671, 1, '解析：MSI（中规模集成电路）和SSI（小规模集成电路）是第三代计算机（1965-1970年）的核心技术，因此选C。', '{\"A\": \"第一代\", \"B\": \"第二代\", \"C\": \"第三代\", \"D\": \"第四代\"}', '使用MSI和SSI的计算机属于()计算机', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (31, 'B', 'B', 1, 670, 1, '解析：微型计算机的发展以微处理器技术的更新换代为主要特征标志，因为微处理器的性能直接决定了计算机的处理能力和系统架构，而操作系统、磁盘和软件属于辅助或应用层面。', '{\"A\": \"操作系统\", \"B\": \"微处理器\", \"C\": \"磁盘\", \"D\": \"软件\"}', '从1971年至今，微型计算机迅猛发展，微机以()技术为特征标志。', 1, '2026-09-13 10:32:15.839412');
INSERT INTO `quiz_answerrecord` VALUES (32, 'B', 'B', 1, 669, 1, '解析：冯诺依曼体系结构采用二进制表示指令和数据，而非十进制，因此选项B错误，而其他选项均符合其设计思想。', '{\"A\": \"计算机由运算器、控制器、存储器和输入输出设备组成\", \"B\": \"计算机内部采用十进制表示指令和数据\", \"C\": \"将程序和数据存储在计算机中,启动程序运行时自动逐条执行指令\", \"D\": \"计算机内部采用二进制表示指令和数据\"}', '关于冯诺依曼体系结构设计思想,错误的是()。', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (33, 'B', 'A', 0, 668, 1, '解析：ENIAC（电子数字积分计算机）是世界上第一台通用电子计算机，于1946年在美国宾夕法尼亚大学研制成功，因此正确答案是A。', '{\"A\": \"宾夕法尼亚\", \"B\": \"斯坦福\", \"C\": \"普林斯顿\", \"D\": \"哈佛\"}', 'ENIAC于1946年在美国()大学研制成功的', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (34, 'C', 'C', 1, 667, 1, '解析：龙芯一号是我国首款自主研发的CPU芯片，它的诞生打破了国外技术垄断，结束了中国近二十年无自主芯片的历史。因此正确答案是C。', '{\"A\": \"龙芯二号\", \"B\": \"“申威”CPU\", \"C\": \"龙芯一号\", \"D\": \"海思芯片\"}', '()的诞生，打破了国外的长期技术垄断，结束了中国近二十年无“芯”的历史。', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (35, 'C', 'C', 1, 666, 1, '解析：中国首台巨型计算机是1983年在国防科技大学研制成功的“银河I号”，运算速度达每秒1亿次，而其他选项（神威I、派-曙光、天河1号）均不属于1983年研制的首台巨型机，因此选C。', '{\"A\": \"神威I\", \"B\": \"派-曙光\", \"C\": \"“银河I号\", \"D\": \"天河1号\"}', '1983年,中国首台巨型计算机()在长沙国防科技大学研制成功,运算速度达每秒1亿次。', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (36, 'A', 'C', 0, 665, 1, '解析：曙光系列超级计算机是由中科院计算技术研究所研制，该所承担了该系列计算机的研发任务，因此正确答案为C。', '{\"A\": \"国防科技大学计算机研究所\", \"B\": \"国家并行计算机工程技术中心\", \"C\": \"中科院计算技术研究所\", \"D\": \"联想集团\"}', '曙光系列超级计算机是由()研制', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (37, 'C', 'B', 0, 664, 1, '解析：神威系列超级计算机是由国家并行计算机工程技术中心研制，该中心是我国高性能计算机研发的主要机构之一，选项B正确。其他选项（如国防科技大学计算机研究所研制的是天河系列，中科院计算技术研究所和联想集团不负责神威系列）均不符合事实。', '{\"A\": \"国防科技大学计算机研究所\", \"B\": \"国家并行计算机工程技术中心\", \"C\": \"中科院计算技术研究所\", \"D\": \"联想集团\"}', '神威系列超级计算机是由()研制', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (38, 'B', 'C', 0, 663, 1, '解析：龙芯一号是中国科学研究院计算技术研究所研制的中国首个拥有自主知识产权的通用高性能CPU，因此正确答案是C。', '{\"A\": \"龙芯二号\", \"B\": \"“申威”CPU\", \"C\": \"龙芯一号\", \"D\": \"海思芯片\"}', '由中国科学研究院计算技术研究所研制的中国首个拥有自主知识产权的通用高性能CPU是()。', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (39, 'A', 'C', 0, 662, 1, '解析：2002年8月10日，我国成功制造出首枚高性能通用CPU，其名称为“龙芯一号”，这是我国自主研发的首款通用CPU，因此正确答案是C。', '{\"A\": \"银河飞腾处理器\", \"B\": \"“申威”CPU\", \"C\": \"龙芯一号\", \"D\": \"海思芯片\"}', '2002年8月10日，我国成功制造出首枚高性能通用CPU，名字是()', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (40, 'C', 'C', 1, 661, 1, '解析：2017年6月19日，国际高性能计算机大会公布全球超级计算机榜单，我国研制的“神威·太湖之光”超级计算机凭借其高性能再次夺得冠军，因此正确答案为C。', '{\"A\": \"神威蓝光\", \"B\": \"派-曙光\", \"C\": \"神威·太湖之光\", \"D\": \"天河1号\"}', '2017年6月19日，德国法兰克福召开的国际高性能计算机大会公布了新一期全球超级计算机的榜单,我国研制的超级计算机()再次夺得了冠军。', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (41, 'D', 'D', 1, 660, 1, '解析：119型计算机是我国第一台自行研制的大型数字计算机，它成功完成了我国第一颗氢弹研制的计算任务，因此正确答案是D。', '{\"A\": \"103型\", \"B\": \"104型\", \"C\": \"331型\", \"D\": \"119型\"}', '在我国第一台自行研制的()大型数字计算机完成了我国第一颗氢弹研制的计算任务。', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (42, 'C', 'C', 1, 659, 1, '解析：麒麟操作系统是我国自主研发的第一套服务器操作系统，由国防科技大学等单位研制，而龙芯是CPU芯片、统信UOS是桌面操作系统、鸿蒙是物联网操作系统，因此正确答案是C。', '{\"A\": \"龙芯\", \"B\": \"统信UOS\", \"C\": \"麒麟\", \"D\": \"鸿蒙\"}', '目前我国自主研发了第一套服务器操作系统,它的名字是()操作系统。', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (43, 'C', 'C', 1, 658, 1, '解析：①错误，银河系列、天河系列是由国防科技大学研制，而非中科院计算技术研究所；②正确，1983年中国成功研制出“银河—Ⅰ号”计算机；③正确，1992年中国成功研制出“银河—Ⅱ号”巨型计算机；④正确，20世纪50年代中国开始了计算机研制工作。因此，正确表述为②③④，故选C。', '{\"A\": \"①②\", \"B\": \"②③\", \"C\": \"②③④\", \"D\": \"①②③\"}', '下列有关我国计算机方面的成就,表述正确的是()①银河系列、天河系列是中科院计算技术研究所研制②1983年,中国成功研制出“银河—Ⅰ号”计算机③1992年,中国成功研制出“银河一Ⅱ号”巨型计算机④20世纪50年代,中国开始了计算机研制工作', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (44, 'C', 'C', 1, 657, 1, '解析：神威·太湖之光是我国首台全部采用国产处理器（申威26010众核处理器）构建的超级计算机，并连续多年在全球超级计算机500强榜单中排名第一。因此正确答案是C。', '{\"A\": \"神威蓝光\", \"B\": \"曙光·星云\", \"C\": \"神威·太湖之光\", \"D\": \"天河二号\"}', '()是我国第一台全部采用国产处理器构建的连续多年在全球超级计算机500强榜单中位列第一的超级计算机。', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (45, 'A', 'A', 1, 656, 1, '解析：中国第一台亿次巨型计算机“银河I”由国防科技大学于1983年研制成功，因此正确答案是A。', '{\"A\": \"国防科技大学\", \"B\": \"清华大学\", \"C\": \"武汉大学\", \"D\": \"西北工业大学\"}', '中国第一台被命名为“银河I”的亿次巨型电子计算机历经5年研制,在()诞生。', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (46, 'D', 'D', 1, 655, 1, '解析：ENIAC（电子数字积分计算机）于1946年诞生，是世界上第一台通用电子计算机，它的问世标志着计算机时代的到来，因此正确答案是D。其他选项EDVAC、EDSAC和UNIVACI均为后续发展的计算机。', '{\"A\": \"EDVAC\", \"B\": \"EDSAC\", \"C\": \"UNIVACI\", \"D\": \"ENIAC\"}', '世界上第一台计算机()的问世标志着计算机时代的到来，具有划时代的伟大意义。', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (47, 'C', 'D', 0, 654, 1, '解析：莱布尼兹是世界上首次提出二进制的人，而冯诺依曼最早提出在计算机中采用二进制，因此选项D正确。', '{\"A\": \"牛顿、比尔·盖茨\", \"B\": \"爱因斯坦、香农\", \"C\": \"冯诺依曼、莱布尼兹\", \"D\": \"莱布尼兹、冯诺依曼\"}', '世界上首次提出二进制和最早提出在计算机中采用二进制的科学家分别是()', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (48, 'D', 'D', 1, 653, 1, '解析：第一代计算机（约1946-1957年）采用电子管、磁鼓或汞延迟线存储器，输入输出依赖穿孔卡片，但操作系统尚未出现，计算机通过人工插拔线路或机器语言手动控制，无法自动运行。因此D项错误。', '{\"A\": \"采用电子管作基础元件\", \"B\": \"使用汞延迟线作存储设备，后来逐渐过渡到用磁芯存储器\", \"C\": \"输入、输出设备主要是用穿孔卡片，用户使用起来很不方便\", \"D\": \"软件上有了操作系统使得计算机可以自动运行\"}', '下列关于第一代计算机的叙述中错误的是()。', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (49, 'B', 'B', 1, 652, 1, '解析：选项B错误，因为第四代计算机的CPU主要采用超大规模集成电路，而非中小规模集成电路；中小规模集成电路是第三代计算机的特征。因此，B项论述有误。', '{\"A\": \"数字电子计算机诞生于20世纪40年代，个人计算机（微型计算机）产生于20世纪80年代初\", \"B\": \"第四代计算机的CPU主要采用中小规模集成电路，第五代计算机采用超大规模集成电路\", \"C\": \"计算机按其内部逻辑结构分类一般分为16位机、32位机或64位机等，目前使用的PC机大多是32位机或64位机\", \"D\": \"巨型计算机一般采用大规模并行解决的体系构造，国防科技大学研制的“天河2号”就是巨型计算机\"}', '下列有关计算机发展与分类的论述中，错误的是()。', 1, '2026-09-13 10:32:15.840410');
INSERT INTO `quiz_answerrecord` VALUES (50, 'C', 'C', 1, 651, 1, '解析：第四代计算机与第三代相比，主要采用了大规模和超大规模集成电路，但两者都基于冯·诺依曼体系结构，因此体系结构未发生变化。', '{\"A\": \"主要元器件\", \"B\": \"主存储器的材料\", \"C\": \"体系结构\", \"D\": \"所配置的操作系统\"}', '第四代计算机和第三代相比，所采用的()一直没有发生变化。', 1, '2026-09-13 10:32:15.840410');

-- ----------------------------
-- Table structure for quiz_chapter
-- ----------------------------
DROP TABLE IF EXISTS `quiz_chapter`;
CREATE TABLE `quiz_chapter`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `number` int(11) NOT NULL,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `subject_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `quiz_chapter_subject_id_number_b533ff9f_uniq`(`subject_id`, `number`) USING BTREE,
  CONSTRAINT `quiz_chapter_subject_id_bb20bcd4_fk_quiz_subject_id` FOREIGN KEY (`subject_id`) REFERENCES `quiz_subject` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_chapter
-- ----------------------------
INSERT INTO `quiz_chapter` VALUES (1, 1, '第一章 信息与数据、通信基础、计算机发展、特点、分类等', NULL, 1);
INSERT INTO `quiz_chapter` VALUES (2, 2, '信息与数据、通信基础、计算机发展、特点、分类等', NULL, 1);

-- ----------------------------
-- Table structure for quiz_class
-- ----------------------------
DROP TABLE IF EXISTS `quiz_class`;
CREATE TABLE `quiz_class`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `join_rule` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_class
-- ----------------------------
INSERT INTO `quiz_class` VALUES (1, '2024级重点二班', '胜人者有力，自胜者强。惟手熟尔！', '2026-09-13 06:19:32.959796', '2026-09-13 06:19:32.959796', 'CLASS001', 'approval');

-- ----------------------------
-- Table structure for quiz_classadmin
-- ----------------------------
DROP TABLE IF EXISTS `quiz_classadmin`;
CREATE TABLE `quiz_classadmin`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `class_obj_id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `quiz_classadmin_class_obj_id_user_id_a31928f6_uniq`(`class_obj_id`, `user_id`) USING BTREE,
  INDEX `quiz_classadmin_user_id_5483749e_fk_auth_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `quiz_classadmin_class_obj_id_8b407865_fk_quiz_class_id` FOREIGN KEY (`class_obj_id`) REFERENCES `quiz_class` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_classadmin_user_id_5483749e_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_classadmin
-- ----------------------------
INSERT INTO `quiz_classadmin` VALUES (1, 1, 1);
INSERT INTO `quiz_classadmin` VALUES (2, 1, 2);

-- ----------------------------
-- Table structure for quiz_classapplication
-- ----------------------------
DROP TABLE IF EXISTS `quiz_classapplication`;
CREATE TABLE `quiz_classapplication`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `status` int(11) NOT NULL,
  `message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `created_at` datetime(6) NOT NULL,
  `reviewed_at` datetime(6) NULL DEFAULT NULL,
  `class_obj_id` bigint(20) NOT NULL,
  `reviewed_by_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `quiz_classapplication_class_obj_id_user_id_23d9dfa0_uniq`(`class_obj_id`, `user_id`) USING BTREE,
  INDEX `quiz_classapplication_reviewed_by_id_33b6f126_fk_auth_user_id`(`reviewed_by_id`) USING BTREE,
  INDEX `quiz_classapplication_user_id_93af2411_fk_auth_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `quiz_classapplication_class_obj_id_37ce5d19_fk_quiz_class_id` FOREIGN KEY (`class_obj_id`) REFERENCES `quiz_class` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_classapplication_reviewed_by_id_33b6f126_fk_auth_user_id` FOREIGN KEY (`reviewed_by_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_classapplication_user_id_93af2411_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_classapplication
-- ----------------------------
INSERT INTO `quiz_classapplication` VALUES (1, 1, '', '2026-09-13 06:25:44.161821', NULL, 1, 2, 2);
INSERT INTO `quiz_classapplication` VALUES (2, 1, '', '2026-09-13 10:11:49.933366', NULL, 1, 2, 3);
INSERT INTO `quiz_classapplication` VALUES (3, 1, '', '2026-09-13 10:19:55.332083', NULL, 1, 1, 5);
INSERT INTO `quiz_classapplication` VALUES (4, 1, '', '2026-09-13 10:20:16.680094', NULL, 1, 2, 4);
INSERT INTO `quiz_classapplication` VALUES (5, 1, '', '2026-09-13 10:20:44.429530', NULL, 1, 2, 7);
INSERT INTO `quiz_classapplication` VALUES (6, 1, '陈欣怡', '2026-09-13 10:20:59.388548', NULL, 1, 2, 6);
INSERT INTO `quiz_classapplication` VALUES (7, 1, '袁昌乐', '2026-09-13 10:22:26.967161', NULL, 1, 2, 13);
INSERT INTO `quiz_classapplication` VALUES (8, 1, '我是于龙', '2026-09-13 10:22:56.158089', NULL, 1, 2, 11);
INSERT INTO `quiz_classapplication` VALUES (9, 1, '', '2026-09-13 10:23:19.672801', NULL, 1, 2, 8);
INSERT INTO `quiz_classapplication` VALUES (10, 1, '王焕', '2026-09-13 10:23:42.250366', NULL, 1, 2, 17);
INSERT INTO `quiz_classapplication` VALUES (11, 1, '', '2026-09-13 10:24:00.893055', NULL, 1, 2, 9);
INSERT INTO `quiz_classapplication` VALUES (12, 1, '', '2026-09-13 10:24:02.373496', NULL, 1, 2, 15);
INSERT INTO `quiz_classapplication` VALUES (13, 1, '祝一豪', '2026-09-13 10:24:40.538415', NULL, 1, 2, 14);
INSERT INTO `quiz_classapplication` VALUES (14, 1, '我是丛子涵', '2026-09-13 10:25:57.471838', NULL, 1, 2, 16);
INSERT INTO `quiz_classapplication` VALUES (15, 1, '', '2026-09-13 10:26:11.964009', NULL, 1, 2, 18);
INSERT INTO `quiz_classapplication` VALUES (16, 1, '蒋献林', '2026-09-13 10:34:47.123648', NULL, 1, 2, 21);
INSERT INTO `quiz_classapplication` VALUES (17, 1, '徐梓梦', '2026-09-13 10:38:06.590477', NULL, 1, 2, 24);
INSERT INTO `quiz_classapplication` VALUES (18, 1, '钱山', '2026-09-13 10:38:22.728801', NULL, 1, 2, 23);
INSERT INTO `quiz_classapplication` VALUES (19, 1, '', '2026-09-13 10:42:52.362118', NULL, 1, 2, 27);
INSERT INTO `quiz_classapplication` VALUES (20, 1, '黄雅欣', '2026-09-13 10:45:45.718512', NULL, 1, 1, 26);

-- ----------------------------
-- Table structure for quiz_classassignment
-- ----------------------------
DROP TABLE IF EXISTS `quiz_classassignment`;
CREATE TABLE `quiz_classassignment`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `type` int(11) NOT NULL,
  `deadline` datetime(6) NOT NULL,
  `status` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `published_at` datetime(6) NULL DEFAULT NULL,
  `class_obj_id` bigint(20) NOT NULL,
  `created_by_id` int(11) NULL DEFAULT NULL,
  `test_paper_id` bigint(20) NULL DEFAULT NULL,
  `time_limit` int(11) NULL DEFAULT NULL,
  `is_allow_exam` tinyint(1) NULL DEFAULT 1,
  `is_random` tinyint(1) NOT NULL,
  `random_config` json NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `quiz_classassignment_class_obj_id_f9928e10_fk_quiz_class_id`(`class_obj_id`) USING BTREE,
  INDEX `quiz_classassignment_created_by_id_63d65484_fk_auth_user_id`(`created_by_id`) USING BTREE,
  INDEX `quiz_classassignment_test_paper_id_9c225f35_fk_quiz_testpaper_id`(`test_paper_id`) USING BTREE,
  CONSTRAINT `quiz_classassignment_class_obj_id_f9928e10_fk_quiz_class_id` FOREIGN KEY (`class_obj_id`) REFERENCES `quiz_class` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_classassignment_created_by_id_63d65484_fk_auth_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_classassignment_test_paper_id_9c225f35_fk_quiz_testpaper_id` FOREIGN KEY (`test_paper_id`) REFERENCES `quiz_testpaper` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_classassignment
-- ----------------------------

-- ----------------------------
-- Table structure for quiz_classassignmentrecord
-- ----------------------------
DROP TABLE IF EXISTS `quiz_classassignmentrecord`;
CREATE TABLE `quiz_classassignmentrecord`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_submitted` tinyint(1) NOT NULL,
  `score` int(11) NULL DEFAULT NULL,
  `submitted_at` datetime(6) NULL DEFAULT NULL,
  `assignment_id` bigint(20) NOT NULL,
  `test_record_id` bigint(20) NULL DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `attempt` int(11) NOT NULL,
  `start_time` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `quiz_classassignment_test_record_id_94b4bec1_fk_quiz_test`(`test_record_id`) USING BTREE,
  INDEX `quiz_classassignmentrecord_user_id_c32c9273_fk_auth_user_id`(`user_id`) USING BTREE,
  INDEX `quiz_classassignmentrecord_assignment_id_0dc218a0`(`assignment_id`) USING BTREE,
  CONSTRAINT `quiz_classassignment_assignment_id_0dc218a0_fk_quiz_clas` FOREIGN KEY (`assignment_id`) REFERENCES `quiz_classassignment` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_classassignment_test_record_id_94b4bec1_fk_quiz_test` FOREIGN KEY (`test_record_id`) REFERENCES `quiz_testrecord` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_classassignmentrecord_user_id_c32c9273_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_classassignmentrecord
-- ----------------------------

-- ----------------------------
-- Table structure for quiz_knowledgepoint
-- ----------------------------
DROP TABLE IF EXISTS `quiz_knowledgepoint`;
CREATE TABLE `quiz_knowledgepoint`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `difficulty` int(11) NOT NULL,
  `section_id` bigint(20) NULL DEFAULT NULL,
  `subject_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `quiz_knowledgepoint_subject_id_name_b05702eb_uniq`(`subject_id`, `name`) USING BTREE,
  INDEX `quiz_knowledgepoint_section_id_b4c23b56_fk_quiz_section_id`(`section_id`) USING BTREE,
  CONSTRAINT `quiz_knowledgepoint_section_id_b4c23b56_fk_quiz_section_id` FOREIGN KEY (`section_id`) REFERENCES `quiz_section` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_knowledgepoint_subject_id_00d440da_fk_quiz_subject_id` FOREIGN KEY (`subject_id`) REFERENCES `quiz_subject` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_knowledgepoint
-- ----------------------------
INSERT INTO `quiz_knowledgepoint` VALUES (1, '信息与数据、信息技术', NULL, 2, 1, 1);
INSERT INTO `quiz_knowledgepoint` VALUES (2, '通讯基本概念、分类、特征', NULL, 2, 2, 1);
INSERT INTO `quiz_knowledgepoint` VALUES (3, '计算机特点及分类', NULL, 2, 3, 1);
INSERT INTO `quiz_knowledgepoint` VALUES (4, '计算机发展史、我国计算机发展历程', NULL, 2, 4, 1);
INSERT INTO `quiz_knowledgepoint` VALUES (5, '计算机应用领域及发展趋势', NULL, 2, 5, 1);

-- ----------------------------
-- Table structure for quiz_notification
-- ----------------------------
DROP TABLE IF EXISTS `quiz_notification`;
CREATE TABLE `quiz_notification`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `link` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_read` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `recipient_id` int(11) NOT NULL,
  `sender_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `quiz_notification_recipient_id_8bc7f92a_fk_auth_user_id`(`recipient_id`) USING BTREE,
  INDEX `quiz_notification_sender_id_4dda358d_fk_auth_user_id`(`sender_id`) USING BTREE,
  CONSTRAINT `quiz_notification_recipient_id_8bc7f92a_fk_auth_user_id` FOREIGN KEY (`recipient_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_notification_sender_id_4dda358d_fk_auth_user_id` FOREIGN KEY (`sender_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 62 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of quiz_notification
-- ----------------------------
INSERT INTO `quiz_notification` VALUES (1, 'approval', '新申请：菁 申请加入 2024级重点二班', '菁 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 06:25:44.176782', 1, 2);
INSERT INTO `quiz_notification` VALUES (2, 'approval', '新申请：菁 申请加入 2024级重点二班', '菁 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 06:25:44.176782', 2, 2);
INSERT INTO `quiz_notification` VALUES (3, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 1, '2026-09-13 06:26:27.468657', 2, 2);
INSERT INTO `quiz_notification` VALUES (4, 'approval', '新申请：琳 申请加入 2024级重点二班', '琳 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:11:49.948326', 1, 3);
INSERT INTO `quiz_notification` VALUES (5, 'approval', '新申请：琳 申请加入 2024级重点二班', '琳 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:11:49.948326', 2, 3);
INSERT INTO `quiz_notification` VALUES (6, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:12:13.528609', 3, 2);
INSERT INTO `quiz_notification` VALUES (7, 'approval', '新申请：婷 申请加入 2024级重点二班', '婷 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:19:55.336072', 1, 5);
INSERT INTO `quiz_notification` VALUES (8, 'approval', '新申请：婷 申请加入 2024级重点二班', '婷 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:19:55.336072', 2, 5);
INSERT INTO `quiz_notification` VALUES (9, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:20:11.153337', 5, 2);
INSERT INTO `quiz_notification` VALUES (10, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:20:13.255675', 5, 1);
INSERT INTO `quiz_notification` VALUES (11, 'approval', '新申请：李晨园 申请加入 2024级重点二班', '李晨园 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:20:16.694029', 1, 4);
INSERT INTO `quiz_notification` VALUES (12, 'approval', '新申请：李晨园 申请加入 2024级重点二班', '李晨园 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:20:16.694029', 2, 4);
INSERT INTO `quiz_notification` VALUES (13, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:20:26.330204', 4, 2);
INSERT INTO `quiz_notification` VALUES (14, 'approval', '新申请：李乐瑶 申请加入 2024级重点二班', '李乐瑶 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:20:44.433519', 1, 7);
INSERT INTO `quiz_notification` VALUES (15, 'approval', '新申请：李乐瑶 申请加入 2024级重点二班', '李乐瑶 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:20:44.433519', 2, 7);
INSERT INTO `quiz_notification` VALUES (16, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:20:54.572528', 7, 2);
INSERT INTO `quiz_notification` VALUES (17, 'approval', '新申请：陈欣怡 申请加入 2024级重点二班', '陈欣怡 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:20:59.401513', 1, 6);
INSERT INTO `quiz_notification` VALUES (18, 'approval', '新申请：陈欣怡 申请加入 2024级重点二班', '陈欣怡 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:20:59.401513', 2, 6);
INSERT INTO `quiz_notification` VALUES (19, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:21:16.584164', 6, 2);
INSERT INTO `quiz_notification` VALUES (20, 'approval', '新申请：fkejjqi 申请加入 2024级重点二班', 'fkejjqi 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:22:26.970153', 1, 13);
INSERT INTO `quiz_notification` VALUES (21, 'approval', '新申请：fkejjqi 申请加入 2024级重点二班', 'fkejjqi 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:22:26.971150', 2, 13);
INSERT INTO `quiz_notification` VALUES (22, 'approval', '新申请：于龙 申请加入 2024级重点二班', '于龙 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:22:56.204964', 1, 11);
INSERT INTO `quiz_notification` VALUES (23, 'approval', '新申请：于龙 申请加入 2024级重点二班', '于龙 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:22:56.204964', 2, 11);
INSERT INTO `quiz_notification` VALUES (24, 'approval', '新申请：张昊煜 申请加入 2024级重点二班', '张昊煜 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:23:19.686764', 1, 8);
INSERT INTO `quiz_notification` VALUES (25, 'approval', '新申请：张昊煜 申请加入 2024级重点二班', '张昊煜 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:23:19.686764', 2, 8);
INSERT INTO `quiz_notification` VALUES (26, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:23:20.123007', 13, 2);
INSERT INTO `quiz_notification` VALUES (27, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:23:22.135475', 8, 2);
INSERT INTO `quiz_notification` VALUES (28, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:23:23.491678', 11, 2);
INSERT INTO `quiz_notification` VALUES (29, 'approval', '新申请：臆想 申请加入 2024级重点二班', '臆想 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:23:42.254355', 1, 17);
INSERT INTO `quiz_notification` VALUES (30, 'approval', '新申请：臆想 申请加入 2024级重点二班', '臆想 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:23:42.254355', 2, 17);
INSERT INTO `quiz_notification` VALUES (31, 'approval', '新申请：黄智彬 申请加入 2024级重点二班', '黄智彬 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:24:00.907539', 1, 9);
INSERT INTO `quiz_notification` VALUES (32, 'approval', '新申请：黄智彬 申请加入 2024级重点二班', '黄智彬 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:24:00.907539', 2, 9);
INSERT INTO `quiz_notification` VALUES (33, 'approval', '新申请：黄广奥 申请加入 2024级重点二班', '黄广奥 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:24:02.387458', 1, 15);
INSERT INTO `quiz_notification` VALUES (34, 'approval', '新申请：黄广奥 申请加入 2024级重点二班', '黄广奥 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:24:02.387458', 2, 15);
INSERT INTO `quiz_notification` VALUES (35, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:24:28.752040', 15, 2);
INSERT INTO `quiz_notification` VALUES (36, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:24:30.942818', 9, 2);
INSERT INTO `quiz_notification` VALUES (37, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:24:32.437540', 17, 2);
INSERT INTO `quiz_notification` VALUES (38, 'approval', '新申请：AAA 申请加入 2024级重点二班', 'AAA 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:24:40.552377', 1, 14);
INSERT INTO `quiz_notification` VALUES (39, 'approval', '新申请：AAA 申请加入 2024级重点二班', 'AAA 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:24:40.552377', 2, 14);
INSERT INTO `quiz_notification` VALUES (40, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:24:46.959068', 14, 2);
INSERT INTO `quiz_notification` VALUES (41, 'approval', '新申请：202405 申请加入 2024级重点二班', '202405 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:25:57.485801', 1, 16);
INSERT INTO `quiz_notification` VALUES (42, 'approval', '新申请：202405 申请加入 2024级重点二班', '202405 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:25:57.485801', 2, 16);
INSERT INTO `quiz_notification` VALUES (43, 'approval', '新申请：吴敬梓 申请加入 2024级重点二班', '吴敬梓 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:26:11.977972', 1, 18);
INSERT INTO `quiz_notification` VALUES (44, 'approval', '新申请：吴敬梓 申请加入 2024级重点二班', '吴敬梓 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:26:11.977972', 2, 18);
INSERT INTO `quiz_notification` VALUES (45, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:26:51.891177', 18, 2);
INSERT INTO `quiz_notification` VALUES (46, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:26:54.841092', 16, 2);
INSERT INTO `quiz_notification` VALUES (47, 'approval', '新申请：蒋献林 申请加入 2024级重点二班', '蒋献林 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:34:47.137357', 1, 21);
INSERT INTO `quiz_notification` VALUES (48, 'approval', '新申请：蒋献林 申请加入 2024级重点二班', '蒋献林 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:34:47.137357', 2, 21);
INSERT INTO `quiz_notification` VALUES (49, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:36:50.964670', 21, 2);
INSERT INTO `quiz_notification` VALUES (50, 'approval', '新申请：黎祀 申请加入 2024级重点二班', '黎祀 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:38:06.604440', 1, 24);
INSERT INTO `quiz_notification` VALUES (51, 'approval', '新申请：黎祀 申请加入 2024级重点二班', '黎祀 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:38:06.604440', 2, 24);
INSERT INTO `quiz_notification` VALUES (52, 'approval', '新申请：钱山 申请加入 2024级重点二班', '钱山 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:38:22.731793', 1, 23);
INSERT INTO `quiz_notification` VALUES (53, 'approval', '新申请：钱山 申请加入 2024级重点二班', '钱山 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:38:22.731793', 2, 23);
INSERT INTO `quiz_notification` VALUES (54, 'approval', '新申请：WJZ 申请加入 2024级重点二班', 'WJZ 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:42:52.365110', 1, 27);
INSERT INTO `quiz_notification` VALUES (55, 'approval', '新申请：WJZ 申请加入 2024级重点二班', 'WJZ 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:42:52.365110', 2, 27);
INSERT INTO `quiz_notification` VALUES (56, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:43:19.749058', 24, 2);
INSERT INTO `quiz_notification` VALUES (57, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:43:20.961121', 23, 2);
INSERT INTO `quiz_notification` VALUES (58, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 10:43:24.374024', 27, 2);
INSERT INTO `quiz_notification` VALUES (59, 'approval', '新申请：黄雅欣 申请加入 2024级重点二班', '黄雅欣 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 1, '2026-09-13 10:45:45.732979', 1, 26);
INSERT INTO `quiz_notification` VALUES (60, 'approval', '新申请：黄雅欣 申请加入 2024级重点二班', '黄雅欣 申请加入班级「2024级重点二班」，请前往班级管理审核。', '/quiz/class/1/applications/', 0, '2026-09-13 10:45:45.732979', 2, 26);
INSERT INTO `quiz_notification` VALUES (61, 'approval', '申请通过：已加入 2024级重点二班', '管理员已批准您加入班级「2024级重点二班」的申请，欢迎加入！', '/quiz/class/1/', 0, '2026-09-13 12:00:18.956730', 26, 1);

-- ----------------------------
-- Table structure for quiz_profile
-- ----------------------------
DROP TABLE IF EXISTS `quiz_profile`;
CREATE TABLE `quiz_profile`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `approval_status` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` int(11) NOT NULL,
  `phone_number` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `qq_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `class_obj_id` bigint(20) NULL DEFAULT NULL,
  `session_key` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `total_score` int(11) NOT NULL,
  `tests_taken` int(11) NOT NULL,
  `accuracy_rate` double NOT NULL,
  `role` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `plain_password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id`) USING BTREE,
  UNIQUE INDEX `quiz_profile_phone_number_32583dc4_uniq`(`phone_number`) USING BTREE,
  INDEX `quiz_profile_class_obj_id_aa608f86_fk_quiz_class_id`(`class_obj_id`) USING BTREE,
  CONSTRAINT `quiz_profile_class_obj_id_aa608f86_fk_quiz_class_id` FOREIGN KEY (`class_obj_id`) REFERENCES `quiz_class` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_profile_user_id_43955dd8_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_profile
-- ----------------------------
INSERT INTO `quiz_profile` VALUES (1, 1, '2026-09-13 06:01:29.033397', '2026-09-13 06:19:32.963782', 1, NULL, NULL, 'sky510', NULL, 1, 't5nap1gnrrxbdgzsvowe4h86tmxpvqf8', 0, 0, 0, 'admin', 'qq121666880');
INSERT INTO `quiz_profile` VALUES (2, 1, '2026-09-13 06:07:33.859747', '2026-09-13 06:26:27.467660', 2, '19871324162', '1706558460', NULL, NULL, 1, 'abutk4ft1ddce2m8zcwbwo8xdw2tyozs', 0, 0, 0, 'admin', '1706558460');
INSERT INTO `quiz_profile` VALUES (3, 1, '2026-09-13 10:09:47.900410', '2026-09-13 10:12:13.527612', 3, '18727826675', '3773006816', NULL, NULL, 1, 'thyxpptdvkvdozmwlk0cx7ck35av19pv', 0, 0, 0, 'student', 'qw2501649');
INSERT INTO `quiz_profile` VALUES (4, 1, '2026-09-13 10:18:04.570467', '2026-09-13 10:20:26.329208', 4, '15272684461', '', NULL, NULL, 1, 'synomospog36wwr3e8pomsmf11hg2ljx', 0, 0, 0, 'student', 'lcy123');
INSERT INTO `quiz_profile` VALUES (5, 1, '2026-09-13 10:19:02.441032', '2026-09-13 10:20:13.253680', 5, '18064206006', 'xt20081007', NULL, NULL, 1, 'c484xierqk0415uopxtz5rddpe9942xl', 111, 1, 0, 'student', 'xt18064206006');
INSERT INTO `quiz_profile` VALUES (6, 1, '2026-09-13 10:19:37.008781', '2026-09-13 10:21:16.583167', 6, '15334193075', '196214775', NULL, NULL, 1, '6npdn988f13wn8owjse3k8ftdj0egu8d', 0, 0, 0, 'student', 'mjq021212');
INSERT INTO `quiz_profile` VALUES (7, 1, '2026-09-13 10:19:44.107815', '2026-09-13 10:20:54.571531', 7, '19571253367', '', NULL, NULL, 1, 'pxlizktdih3ad1uqtg8ph7d2w42aqapl', 0, 0, 0, 'student', '010203');
INSERT INTO `quiz_profile` VALUES (8, 1, '2026-09-13 10:20:41.527272', '2026-09-13 10:23:22.133480', 8, '13997518697', '3764783436', NULL, NULL, 1, '5pr7w1c9txmytlb170o5jnoizl8llpgd', 0, 0, 0, 'student', '586935');
INSERT INTO `quiz_profile` VALUES (9, 1, '2026-09-13 10:21:20.011575', '2026-09-13 10:24:30.941821', 9, '13217152881', '676099561', NULL, NULL, 1, '2j7m4punnarw44nw1cnszys5iudxilf8', 0, 0, 0, 'student', '1q2w3e4r');
INSERT INTO `quiz_profile` VALUES (10, 1, '2026-09-13 10:21:20.766725', '2026-09-13 10:21:20.768691', 10, '15342619523', '3314604749', NULL, NULL, NULL, 'ktgsch3zihavtohw9785anplgdxdi5dk', 0, 0, 0, 'student', '281017');
INSERT INTO `quiz_profile` VALUES (11, 1, '2026-09-13 10:21:23.967079', '2026-09-13 10:23:23.490680', 11, '18324800154', '3858168685', NULL, NULL, 1, 'kyc2ilyaqlu9b1opopw2myizetr6cx99', 0, 0, 0, 'student', '202416');
INSERT INTO `quiz_profile` VALUES (12, 1, '2026-09-13 10:21:30.431800', '2026-09-13 10:21:30.433795', 12, '13813084482', '2303700471', NULL, NULL, NULL, 'yu5crix9djyegwygilrug5ntwricpogz', 0, 0, 0, 'student', 'xsx536188');
INSERT INTO `quiz_profile` VALUES (13, 1, '2026-09-13 10:21:40.710157', '2026-09-13 10:23:20.122010', 13, '19871323192', '', NULL, NULL, 1, 'g2qxyxucqqvkh1fk72bky90cofnxw6fh', 0, 0, 0, 'student', 'Yclyyds66');
INSERT INTO `quiz_profile` VALUES (14, 1, '2026-09-13 10:21:49.636842', '2026-09-13 10:24:46.958071', 14, '18671541330', '2829515611', NULL, NULL, 1, '8wkq6yggkya3wzad5rg8f23zzfjn1c8c', 0, 0, 0, 'student', '14253689AA');
INSERT INTO `quiz_profile` VALUES (15, 1, '2026-09-13 10:21:49.694687', '2026-09-13 10:24:28.751042', 15, '15827923550', '2704988576', NULL, NULL, 1, 'qrdf833mukkyw14tygcagdulm4u4kixd', 0, 0, 0, 'student', '147258huang');
INSERT INTO `quiz_profile` VALUES (16, 1, '2026-09-13 10:22:01.473572', '2026-09-13 10:26:54.840094', 16, '19972460757', '3864569842', NULL, NULL, 1, 'g9h4tq8uxhd82grdmszd7wyc9vpyvgdz', 0, 0, 0, 'student', '081016czh');
INSERT INTO `quiz_profile` VALUES (17, 1, '2026-09-13 10:22:38.863818', '2026-09-13 10:24:32.436542', 17, '19571253202', '2039403805', NULL, NULL, 1, 'kh72p6wyvpkpr1e9lq02mpj8yz2kcu58', 0, 0, 0, 'student', '090422');
INSERT INTO `quiz_profile` VALUES (18, 1, '2026-09-13 10:24:30.638029', '2026-09-13 10:43:38.310196', 18, '19307154252', '', NULL, NULL, NULL, 'a8dhwngtnxtg9b9vg5bv6ay8fxfn2kb6', 0, 0, 0, 'student', '20090909w');
INSERT INTO `quiz_profile` VALUES (19, 1, '2026-09-13 10:29:26.482907', '2026-09-13 10:29:26.484901', 19, '17371521127', '2136425705', NULL, NULL, NULL, 'rrt4g0y1lac9gt0vhb5ua4q7l2tr22rk', 0, 0, 0, 'student', 'jinitaimei');
INSERT INTO `quiz_profile` VALUES (20, 1, '2026-09-13 10:31:05.197424', '2026-09-13 10:31:05.199419', 20, '19171442140', '1775923527', NULL, NULL, NULL, 'tvtshw4m6u4dbrfb1ai12a5f52mh2hwc', 0, 0, 0, 'student', 'paq090814');
INSERT INTO `quiz_profile` VALUES (21, 1, '2026-09-13 10:31:37.901459', '2026-09-13 10:36:50.963673', 21, '13451083025', '', NULL, NULL, 1, 'cax1b3bk3ft7lflvrxdyav60jsy7djm1', 0, 0, 0, 'student', '@13451083025');
INSERT INTO `quiz_profile` VALUES (22, 1, '2026-09-13 10:35:36.831667', '2026-09-13 10:35:36.833631', 22, '13339879535', '1530813265', NULL, NULL, NULL, 'a7o2lcsin02csdic47cai4ukil8jeu89', 0, 0, 0, 'student', '234000');
INSERT INTO `quiz_profile` VALUES (23, 1, '2026-09-13 10:36:05.435281', '2026-09-13 10:43:20.959108', 23, '15926935610', '749568148', NULL, NULL, 1, 'kpkce0dd6lr8oamzy2ev3pg3g2pba9nx', 0, 0, 0, 'student', 'qs20091212');
INSERT INTO `quiz_profile` VALUES (24, 1, '2026-09-13 10:36:47.748793', '2026-09-13 10:43:19.748061', 24, '15271288592', '3435577498', NULL, NULL, 1, 'uekaug1zeqm3u69fuomt5deaxnhtrjwa', 0, 0, 0, 'student', '73115980902');
INSERT INTO `quiz_profile` VALUES (25, 1, '2026-09-13 10:37:14.580668', '2026-09-13 10:37:14.582635', 25, '13986636238', '3761085337', NULL, NULL, NULL, 'v640t1byjf5z1petlieim88nscuvo5e1', 0, 0, 0, 'student', 'lyn61018920');
INSERT INTO `quiz_profile` VALUES (26, 1, '2026-09-13 10:40:39.329465', '2026-09-13 12:00:18.954735', 26, '19571254697', '2739788762', NULL, NULL, 1, '4show4h8y3qp7uhzcdeyfeg38xysy9qp', 0, 0, 0, 'student', '123456');
INSERT INTO `quiz_profile` VALUES (27, 1, '2026-09-13 10:41:50.946916', '2026-09-13 10:43:24.372028', 27, '15549829882', '', NULL, NULL, 1, 'a4cylebmb8julta8okqrfs4rkp5t88f3', 0, 0, 0, 'student', '20090909w');

-- ----------------------------
-- Table structure for quiz_question
-- ----------------------------
DROP TABLE IF EXISTS `quiz_question`;
CREATE TABLE `quiz_question`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `options` json NOT NULL,
  `correct_answer` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `explanation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `score` int(11) NOT NULL,
  `chapter_id` bigint(20) NULL DEFAULT NULL,
  `section_id` bigint(20) NULL DEFAULT NULL,
  `subject_id` bigint(20) NULL DEFAULT NULL,
  `created_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `quiz_question_chapter_id_a1eec124_fk_quiz_chapter_id`(`chapter_id`) USING BTREE,
  INDEX `quiz_question_section_id_17c2678a_fk_quiz_section_id`(`section_id`) USING BTREE,
  INDEX `quiz_question_subject_id_741a7ccc_fk_quiz_subject_id`(`subject_id`) USING BTREE,
  CONSTRAINT `quiz_question_chapter_id_a1eec124_fk_quiz_chapter_id` FOREIGN KEY (`chapter_id`) REFERENCES `quiz_chapter` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_question_section_id_17c2678a_fk_quiz_section_id` FOREIGN KEY (`section_id`) REFERENCES `quiz_section` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_question_subject_id_741a7ccc_fk_quiz_subject_id` FOREIGN KEY (`subject_id`) REFERENCES `quiz_subject` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 751 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_question
-- ----------------------------
INSERT INTO `quiz_question` VALUES (1, 1, '为什么一条新闻的价值会随着时间的推移而降低（）', '{\"A\": \"因为信息具有时效性\", \"B\": \"因为信息具有依附性\", \"C\": \"因为信息具有共享性\", \"D\": \"因为信息具有传递性\"}', 'A', '2026-09-13 06:14:58.503180', '2026-09-13 06:14:58.503180', '解析：新闻的价值随时间降低，是因为信息具有时效性，即信息只在特定时间段内有效，超过后其使用价值会减弱。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (2, 1, '为什么我们在发送电子邮件时需要确认对方的邮箱地址是否正确（）', '{\"A\": \"为了确保信息的准确性\", \"B\": \"为了确保信息的时效性\", \"C\": \"为了确保信息的可传递性\", \"D\": \"为了确保信息的依附性\"}', 'C', '2026-09-13 06:14:58.517142', '2026-09-13 06:14:58.517142', '解析：确认对方的邮箱地址是否正确，是为了确保电子邮件能够成功送达至目标收件人，这直接关系到信息的可传递性，即信息能否通过媒介有效传递到指定对象。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (3, 1, '在信息技术中，哪一项最准确地描述了数据与信息的区别（）', '{\"A\": \"数据是抽象的，信息是具体的\", \"B\": \"数据是原始的，信息是经过处理的\", \"C\": \"数据是信息的缺乏\", \"D\": \"数据和信息可以互换使用\"}', 'B', '2026-09-13 06:14:58.526118', '2026-09-13 06:14:58.526118', '解析：数据是未经处理的原始材料，而信息是通过对数据进行加工、整理后得到的具有意义的内容，因此选项B准确描述了两者的区别。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (4, 1, '在信息技术中，信息的传递通常需要依赖于以下哪个要素（）', '{\"A\": \"信息源\", \"B\": \"传输媒介\", \"C\": \"接收者\", \"D\": \"以上所有\"}', 'D', '2026-09-13 06:14:58.534097', '2026-09-13 06:14:58.534097', '解析：信息的传递是一个完整的过程，必须同时具备信息源、传输媒介和接收者这三个基本要素，缺一不可，因此正确答案为D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (5, 1, '下列关于信息与数据的描述，哪一项是正确的（）', '{\"A\": \"数据是信息的载体，信息可以通过数据来表达\", \"B\": \"数据就是信息，两者没有区别\", \"C\": \"信息是数据的一种表现形式\", \"D\": \"数据是毫无意义的，只有信息才有价值\"}', 'A', '2026-09-13 06:14:58.541080', '2026-09-13 06:14:58.542104', '解析：选项A正确，因为数据是信息的载体，信息需要通过数据来表达和传递，两者虽有联系但不等同；其他选项混淆了数据与信息的概念或片面否定了数据的价值。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (6, 1, '在信息技术中，\"信息\"是指（）', '{\"A\": \"任何形式的数据\", \"B\": \"经过处理并具有意义的数据\", \"C\": \"存储在服务器上的数据\", \"D\": \"通过互联网传输的数据\"}', 'B', '2026-09-13 06:14:58.549085', '2026-09-13 06:14:58.549085', '解析：信息是经过处理并具有意义的数据，而其他选项仅描述数据的形式或存储方式，未体现“意义”这一核心特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (7, 1, '以下关于信息与数据的说法，哪个是正确的（）', '{\"A\": \"数据就是信息\", \"B\": \"信息可以独立于数据存在\", \"C\": \"数据是信息的表现形式\", \"D\": \"数据没有价值，信息才有价值\"}', 'C', '2026-09-13 06:14:58.558033', '2026-09-13 06:14:58.558033', '解析：数据是信息的载体和表现形式，信息是数据经过加工后赋予的意义。选项C正确描述了数据与信息的关系。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (8, 1, '按照使用方式分类，哪种计算机属于个人计算机范畴（）', '{\"A\": \"服务器\", \"B\": \"工作站\", \"C\": \"笔记本电脑\", \"D\": \"超级计算机\"}', 'C', '2026-09-13 06:14:58.565014', '2026-09-13 06:14:58.565014', '解析：笔记本电脑是一种便携式个人计算机，属于个人计算机范畴，而服务器、工作站和超级计算机主要用于专业或企业级任务，不属于个人计算机。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (9, 1, '信息与数据的主要区别在于什么（）', '{\"A\": \"数据是事实，信息是数据的含义\", \"B\": \"数据是二进制表示的，信息是十进制表示的\", \"C\": \"数据是信息的子集\", \"D\": \"数据是静态的，信息是动态的\"}', 'A', '2026-09-13 06:14:58.572993', '2026-09-13 06:14:58.572993', '解析：信息与数据的主要区别在于，数据是未经处理的原始事实，而信息是经过解释后赋予数据的具体含义，因此选项A准确概括了这一区别。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (10, 1, '在计算机科学中，二进制数制的主要优点是什么（）', '{\"A\": \"易于理解\", \"B\": \"运算简单\", \"C\": \"存储空间大\", \"D\": \"抗干扰能力差\"}', 'B', '2026-09-13 06:14:58.579975', '2026-09-13 06:14:58.579975', '解析：二进制数制在计算机科学中的主要优点是运算简单，因为其只有0和1两种状态，逻辑运算和算术运算规则简洁，适合电子电路实现，因此选B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (11, 1, '以下哪一项最准确地定义了“数据”（）', '{\"A\": \"经过处理并具有特定意义的信息\", \"B\": \"未经加工的原始事实或观察\", \"C\": \"计算机硬件的组成部分\", \"D\": \"用于存储信息的物理设备\"}', 'B', '2026-09-13 06:14:58.587953', '2026-09-13 06:14:58.587953', '解析：数据是未经加工的原始事实或观察，而信息是经过处理并具有特定意义的数据，因此B选项最准确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (12, 1, '以下哪个不属于信息传输的基本要素（）', '{\"A\": \"发送方\", \"B\": \"接收方\", \"C\": \"信道\", \"D\": \"服务器\"}', 'D', '2026-09-13 06:14:58.596928', '2026-09-13 06:14:58.596928', '解析：信息传输的基本要素包括发送方、接收方和信道，服务器不属于基本要素，因此选D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (13, 1, '什么是“信息技术”（InformationTechnology,IT）（）', '{\"A\": \"用于处理和传播信息的各种技术的总称\", \"B\": \"仅指计算机硬件技术\", \"C\": \"仅指互联网技术\", \"D\": \"仅指数据通信技术\"}', 'A', '2026-09-13 06:14:58.602912', '2026-09-13 06:14:58.602912', '解析：信息技术（IT）是涵盖计算机硬件、软件、网络、通信等多种技术的总称，用于信息的获取、处理、存储和传播，因此A项正确；B、C、D项仅涉及单一技术，定义片面。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (14, 1, '信息技术（IT）包括哪些方面（）', '{\"A\": \"计算机硬件与软件\", \"B\": \"通信技术\", \"C\": \"数据管理与分析\", \"D\": \"所有上述选项\"}', 'D', '2026-09-13 06:14:58.612885', '2026-09-13 06:14:58.612885', '解析：信息技术（IT）涵盖了计算机硬件与软件、通信技术以及数据管理与分析等多个方面，因此所有选项均正确，故选D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (15, 1, '以下哪项是信息技术中的“数字签名”的主要作用？', '{\"A\": \"增加数据存储容量\", \"B\": \"保护数据不被未授权访问\", \"C\": \"验证数据的完整性和来源\", \"D\": \"提供网络连接\"}', 'C', '2026-09-13 06:14:58.620865', '2026-09-13 06:14:58.620865', '解析：数字签名通过加密技术确保数据在传输过程中未被篡改，并验证发送者的身份，因此其主要作用是验证数据的完整性和来源，而非增加存储容量、保护访问权限或提供网络连接。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (16, 1, '以下哪项不是数据的类型？', '{\"A\": \"文本\", \"B\": \"图像\", \"C\": \"音频\", \"D\": \"算法\"}', 'D', '2026-09-13 06:14:58.627846', '2026-09-13 06:14:58.627846', '解析：文本、图像和音频都是常见的数据类型，而算法是处理数据的方法或步骤，不属于数据本身的类型，因此选D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (17, 1, '下列关于信息与数据的叙述中错误的是（）。', '{\"A\": \"信息是对数据的解释，是数据的合理体现\", \"B\": \"数据反映的是事物的表象，信息反映的是事物的本质\", \"C\": \"数据是信息的来源，信息是数据进行组织后形成的结果\", \"D\": \"信息的形式变化多端，而数据比较稳定，不随载体的性质随意变化\"}', 'D', '2026-09-13 06:14:58.635825', '2026-09-13 06:14:58.635825', '解析：选项D错误，因为数据本身并不稳定，其具体形式（如数值、符号、文字等）会随载体性质变化，而信息是对数据的解释，其意义相对稳定。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (18, 1, '作为IT社会不可缺少的资源，信息不同于物质、能源等的显著不同是()。', '{\"A\": \"转换性\", \"B\": \"共享性\", \"C\": \"传输性\", \"D\": \"价值性\"}', 'B', '2026-09-13 06:14:58.642806', '2026-09-13 06:14:58.642806', '解析：信息不同于物质和能源的显著特点是共享性，即信息可以被多人同时使用而不减少其内容，而物质和能源在使用中会消耗或转移。因此，正确答案是B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (19, 1, '下列关于信息与数据的关系说法不正确的是()。', '{\"A\": \"数据和信息是有区别的\", \"B\": \"数据和信息之间是相互联系的\", \"C\": \"数据是数据采集时提供的，信息是从采集的数据中获取的有用信息\", \"D\": \"数据量越大，其中包含的信息量就越多\"}', 'D', '2026-09-13 06:14:58.648790', '2026-09-13 06:14:58.648790', '解析：数据量越大，不一定包含的信息量就越多，因为可能存在大量冗余或无用的数据，信息量取决于数据的有效性和相关性，而非单纯的数量。因此D选项错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (20, 1, '下面关于数据和信息的说法中正确的是（）。', '{\"A\": \"数据是以二进制方式编码后才能存储在计算机中\", \"B\": \"大数据技术不能处理非结构化数据\", \"C\": \"同一数据经解释后产生的信息都是相同的\", \"D\": \"信息加工处理后不会产生更有价值的信息\"}', 'A', '2026-09-13 06:14:58.655771', '2026-09-13 06:14:58.655771', '解析：选项A正确，因为计算机只能识别二进制数据，所有数据（如文字、图像、声音）在存储前必须转换为二进制编码。选项B错误，大数据技术能处理非结构化数据（如文本、图片）。选项C错误，同一数据因解释者不同或背景差异可能产生不同信息。选项D错误，信息加工处理后往往能提炼出更有价值的信息。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (21, 1, '下列关于信息的说法中不正确的是（）。', '{\"A\": \"计算机只能处理数字化后的信息\", \"B\": \"虚假广告的出现，说明信息具有真伪性\", \"C\": \"数据灾备系统可以提高信息的安全性\", \"D\": \"通过计算机获取的信息都是真实可信的\"}', 'D', '2026-09-13 06:14:58.661756', '2026-09-13 06:14:58.661756', '解析：选项D错误，因为计算机获取的信息可能来自不可靠来源或经过篡改，并非所有信息都真实可信；其他选项A、B、C均正确描述了信息的相关特性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (22, 1, '下列关于信息与数据的说法中，不正确的是()。', '{\"A\": \"信息需要经过数字化转变成数据才能存储和传输\", \"B\": \"信息是现实世界事物的存在方式或运动状态的反映\", \"C\": \"信息和数据可以分离，是两个不同的概念\", \"D\": \"数据是反映客观事物属性的记录，是信息的具体表现形式\"}', 'C', '2026-09-13 06:14:58.668736', '2026-09-13 06:14:58.668736', '解析：C选项错误，因为信息和数据并非可以完全分离的独立概念，数据是信息的载体，信息需要通过数据来表达，两者紧密联系、相互依存。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (23, 1, '以下对信息的描述错误的是（）', '{\"A\": \"在计算机中表示信息的数据是可以压缩的\", \"B\": \"信息的价值不会发生改变\", \"C\": \"信息是可以在不同的载体间转换的\", \"D\": \"信息是可以处理加工的\"}', 'B', '2026-09-13 06:14:58.675718', '2026-09-13 06:14:58.675718', '解析：信息的价值会因时间、环境、需求等因素而发生变化，例如过时的新闻信息价值降低，因此B选项描述错误，其他选项均正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (24, 1, '下列关于数据和信息的关系，说法正确的是()。', '{\"A\": \"信息和数据是一样的\", \"B\": \"信息是数据的载体\", \"C\": \"数据是信息的载体\", \"D\": \"信息能反映事物特征，数据则反应信息的特征\"}', 'C', '2026-09-13 06:14:58.682699', '2026-09-13 06:14:58.682699', '解析：数据是信息的载体，信息是数据所表达的含义，因此选项C正确。选项A错误，信息和数据并非完全相同；选项B错误，信息不是数据的载体；选项D错误，数据反映事物特征，信息是数据的解释。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (25, 1, '关于信息，以下说法不正确的是()。', '{\"A\": \"需要依附于载体而存在\", \"B\": \"两个人进行交谈或讨论也是在互相传递信息\", \"C\": \"传递和获得信息的途径可以有很多种\", \"D\": \"信息必须通过载体传播，载体所传达的信息与载体种类也存在必然联系\"}', 'D', '2026-09-13 06:14:58.689680', '2026-09-13 06:14:58.689680', '解析：信息必须通过载体传播，但载体种类与所传达的信息没有必然联系，同一信息可通过不同载体传递，因此D选项说法不正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (26, 1, '下面关于信息和数据的叙述,错误的一个是()。', '{\"A\": \"只有经过处理、解释和赋予意义后，数据才转化为信息\", \"B\": \"信息是用来消除随机不确定性的东西\", \"C\": \"信息是数据的载体,是数据的具体表现形式\", \"D\": \"信息反映了客观事物的存在或运动状态\"}', 'C', '2026-09-13 06:14:58.696662', '2026-09-13 06:14:58.696662', '正确答案是C。解析：信息是数据的内容或意义，而数据是信息的载体和具体表现形式，因此C选项颠倒了信息与数据的关系，表述错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (27, 1, '下列关于信息与数据的叙述中错误的是(）。', '{\"A\": \"信息是对数据的解释，是数据的合理体现\", \"B\": \"数据反映的是事物的表象，信息反映的是事物的本质\", \"C\": \"信息的形式变化多端，而数据的形式比较稳定，不随载体的性质随意变化\", \"D\": \"数据只有对实体行为产生影响时才成为信息\"}', 'C', '2026-09-13 06:14:58.702646', '2026-09-13 06:14:58.702646', '解析：选项C错误，因为数据的形式并非稳定不变，它同样会随载体的性质（如文字、图像、声音等）而改变，而信息则相对稳定，不随表现形式变化。因此选C。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (28, 1, '数据是信息的（）。', '{\"A\": \"载体\", \"B\": \"内涵\", \"C\": \"表现形式\", \"D\": \"抽象概括\"}', 'A', '2026-09-13 06:14:58.709627', '2026-09-13 06:14:58.709627', '解析：数据是信息的具体表现形式和物理载体，信息需要通过数据来记录、存储和传递，因此数据是信息的载体，故选A。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (29, 1, '计算机中的信息以数据的形式出现,（）是信息的载体。', '{\"A\": \"云储存\", \"B\": \"数据\", \"C\": \"存储介质\", \"D\": \"计算机\"}', 'C', '2026-09-13 06:14:58.715640', '2026-09-13 06:14:58.715640', '解析：存储介质是直接承载数据的物理材料（如硬盘、光盘），信息以数据形式存在，必须依赖存储介质作为载体才能被保存和读取。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (30, 1, '关于数据和信息，说法错误的是（）。', '{\"A\": \"同样的数据，不同人解读可能产生不同的信息\", \"B\": \"数据量越大，从中获取的信息一定越多\", \"C\": \"数据可以被存储、传输，信息也具备同样的特性\", \"D\": \"信息可以辅助决策，而孤立的数据较难做到\"}', 'B', '2026-09-13 06:14:58.722593', '2026-09-13 06:14:58.722593', '解析：B选项错误，因为数据量增大并不必然导致信息增多，数据可能冗余或无效，信息的获取取决于数据的质量、解读方式及上下文，而非单纯数量。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (31, 1, '同样一班级学生参加万维的模拟考试，数学老师和班主任根据考试成绩分析后得出不同结论，这说明（）。', '{\"A\": \"数据不可靠\", \"B\": \"信息不唯一\", \"C\": \"数据和信息无关联\", \"D\": \"信息的主观性强\"}', 'D', '2026-09-13 06:14:58.729574', '2026-09-13 06:14:58.729574', '解析：同一数据（考试成绩）被不同分析者（数学老师与班主任）得出不同结论，说明信息受个人理解、经验和角度影响，体现了信息具有主观性，因此选D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (32, 1, '下列关于信息的叙述不正确的是（）。', '{\"A\": \"信息往往反映的是事物某一特定时间内的状态\", \"B\": \"信息的传播和储存必须依附于某种载体\", \"C\": \"信息在重复使用中会产生损耗\", \"D\": \"信息无处不在，且呈现形式多样\"}', 'C', '2026-09-13 06:14:58.735586', '2026-09-13 06:14:58.736556', '解析：信息在重复使用中不会像物质那样产生损耗，其内容可以无损复制和传播，因此C选项错误。其他选项均正确描述了信息的特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (33, 1, '下列描述错误的是（）。', '{\"A\": \"数据是信息的符号表示\", \"B\": \"信息是未经处理的数据\", \"C\": \"信息可以被多次加工利用\", \"D\": \"数据是客观事物的记录\"}', 'B', '2026-09-13 06:14:58.742539', '2026-09-13 06:14:58.742539', '解析：信息是经过加工处理后的数据，而未经处理的数据是原始数据，因此“信息是未经处理的数据”表述错误，故选B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (34, 1, '关于信息与数据的关系，下列说法正确的是（）。', '{\"A\": \"信息就是数据，数据也是信息，二者没有区别\", \"B\": \"数据是对信息的解释，信息是数据的载体\", \"C\": \"信息是有意义的数据，数据是信息的表现形式\", \"D\": \"信息与数据之间没有必然联系\"}', 'C', '2026-09-13 06:14:58.748551', '2026-09-13 06:14:58.748551', '解析：信息是有意义的数据，数据是信息的表现形式，二者相互关联但不等同。C选项准确描述了信息与数据的本质关系，即数据经过解释后成为信息。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (35, 1, '对各种数据进行收集、存储、整理、分类、统计、加工、利用、传播等一系列活动的统称()。', '{\"A\": \"数据处理\", \"B\": \"过程控制\", \"C\": \"信息处理\", \"D\": \"计算机辅助\"}', 'A', '2026-09-13 06:14:58.755533', '2026-09-13 06:14:58.755533', '解析：该题目描述的是对数据进行收集、存储、整理、分类、统计、加工、利用、传播等一系列活动的统称，而数据处理正是涵盖这些操作的综合概念，因此选项A正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (36, 1, '现如今我们经常能从各个地方听到IT行业各种各样的信息,这里的\"IT\"指的是()', '{\"A\": \"网络技术\", \"B\": \"信息技术\", \"C\": \"控制技术\", \"D\": \"计算机技术\"}', 'B', '2026-09-13 06:14:58.761516', '2026-09-13 06:14:58.761516', '解析：IT是Information Technology的缩写，中文意为“信息技术”，涵盖计算机、网络、通信等领域，而其他选项（网络技术、控制技术、计算机技术）仅为IT的一部分或相关概念，因此正确答案是B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (37, 1, 'U盘是人们常用的携带方便的存储器,请问U盘上的文件属于()', '{\"A\": \"模拟信息\", \"B\": \"数字信息\", \"C\": \"仿真信息\", \"D\": \"广播信息\"}', 'B', '2026-09-13 06:14:58.767500', '2026-09-13 06:14:58.767500', '解析：U盘存储文件时，数据以二进制（0和1）形式编码，属于数字信息，而非模拟、仿真或广播信息。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (38, 1, '翻译软件能让手机在通话中将对方语言即时翻译成用户所需的语言.以下4种技术中.①机器翻译②模式识别③计算机博弈④机器证明,翻译软件主要应用的技术是()', '{\"A\": \"①②\", \"B\": \"①③\", \"C\": \"①②④\", \"D\": \"①②③④\"}', 'A', '2026-09-13 06:14:58.773485', '2026-09-13 06:14:58.773485', '解析：翻译软件的核心功能是将一种语言即时翻译成另一种语言，这主要依赖机器翻译技术；同时，翻译过程涉及语音或文字的识别与处理，因此也应用了模式识别技术。计算机博弈和机器证明与语言翻译无直接关联，故正确选项为A。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (39, 1, '下面关于计算机发展、应用等的论断中，正确的一项是()。', '{\"A\": \"中国的超级计算机曙光系列是由国家并行计算机工程技术中心研制的\", \"B\": \"以数据库管理系统为基础，辅助管理者提高决策水平，改善运营策略的应用领域属于计算机辅助\", \"C\": \"现代电子计算机由于采用了二进制形式来表示各种数据，所以自动化程度高\", \"D\": \"信息是按照一定的方式排列起来的信号序列所揭示的内容\"}', 'D', '2026-09-13 06:14:58.780466', '2026-09-13 06:14:58.780466', '解析：选项D正确，因为信息是信号序列所揭示的内容，符合信息的基本定义；A错误，曙光系列由中科院计算所研制，非国家并行计算机工程技术中心；B错误，该应用属于决策支持系统，而非计算机辅助；C错误，自动化程度高源于程序存储和自动执行，非二进制本身。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (40, 1, '下面关于计算机知识的论断中，不正确的一项是()。', '{\"A\": \"1956年，第一次有关人工智能的会议在Dartmouth学院召开\", \"B\": \"1994年正式公布了Unicode编码，它是专门用于Internet的统一码，现在的版本是UTF-8\", \"C\": \"兼容机的概念最早是由IBM提出来的，最早揭示信息技术进步趋势的是冯·诺依曼\", \"D\": \"信息隐藏技术的原理是利用了载体信息的冗余性，它不属于信息加密技术\"}', 'C', '2026-09-13 06:14:58.786450', '2026-09-13 06:14:58.786450', '解析：选项C中，“兼容机的概念最早是由IBM提出来的”正确，但“最早揭示信息技术进步趋势的是冯·诺依曼”错误，冯·诺依曼主要贡献是计算机体系结构，而非信息技术进步趋势，因此C项不正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (41, 1, '下列关于信息的叙述正确的是()', '{\"A\": \"信息即是物质,也是能量和能源\", \"B\": \"所有的信息都可以直接被人们利用\", \"C\": \"信息的表现方式单一\", \"D\": \"信息必须借助某种载体才能进行传递\"}', 'D', '2026-09-13 06:14:58.792434', '2026-09-13 06:14:58.793431', '解析：信息本身不是物质、能量或能源（排除A），并非所有信息都能被直接利用（排除B），信息的表现方式多样（排除C），信息必须依附于载体才能传递，因此D正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (42, 1, '以下属于信息的是()', '{\"A\": \"声音、文字、数字\", \"B\": \"编码、信号、符号\", \"C\": \"档案、文件、书籍\", \"D\": \"论文、新闻、情报\"}', 'D', '2026-09-13 06:14:58.801382', '2026-09-13 06:14:58.801382', '解析：信息是经过加工处理、具有意义的数据或知识，选项D中的论文、新闻、情报均直接传递具体内容和知识，属于信息；而A、B、C选项主要描述信息的载体或表现形式，并非信息本身。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (43, 1, '人类经历的五次信息技术革命,第一次是()', '{\"A\": \"语言的产生\", \"B\": \"文字的创造\", \"C\": \"印刷术的发明\", \"D\": \"电报、电话、广播、电视的发明和普及应用\"}', 'A', '2026-09-13 06:14:58.807395', '2026-09-13 06:14:58.807395', '解析：人类第一次信息技术革命是语言的产生，因为语言的出现使人类能够通过声音传递信息，实现了信息从个体到群体的共享，这是信息传递的首次重大突破。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (44, 1, '关于信息的特征,下列说法错误的是()', '{\"A\": \"信息可以传递\", \"B\": \"信息可以处理\", \"C\": \"信息可以和载体分开\", \"D\": \"信息可以共享\"}', 'C', '2026-09-13 06:14:58.813378', '2026-09-13 06:14:58.813378', '解析：信息不能脱离载体而独立存在，必须依附于文字、图像、声音等载体，因此选项C错误；其他选项均正确描述了信息的特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (45, 1, '下列关于信息的说法，错误的是()', '{\"A\": \"信息必须依附于载体，但可以脱离它所反映的事物被存储、保存和传播\", \"B\": \"信息可以从一种形态转换为另一种形态\", \"C\": \"信息在传递和共享过程中可以重复使用，不会产生损耗\", \"D\": \"信息具有时效性，过期的信息没有任何价值\"}', 'D', '2026-09-13 06:14:58.819363', '2026-09-13 06:14:58.819363', '解析：D选项错误，因为信息虽然具有时效性，但过期的信息可能仍有历史、研究或参考价值，并非“没有任何价值”。其他选项均正确描述了信息的特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (46, 1, '下列选项中,不属于信息的是()', '{\"A\": \"老师教授的知识内容\", \"B\": \"电视机\", \"C\": \"书籍中的文字\", \"D\": \"试卷\"}', 'B', '2026-09-13 06:14:58.826344', '2026-09-13 06:14:58.826344', '解析：信息是指通过载体传递的有意义的内容，而电视机只是传递信息的载体或设备本身，不属于信息本身。其他选项均为信息的具体表现形式或内容。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (47, 1, '下列不是数据的选项是()', '{\"A\": \"数字\", \"B\": \"汉字\", \"C\": \"图片\", \"D\": \"文件夹\"}', 'D', '2026-09-13 06:14:58.832328', '2026-09-13 06:14:58.832328', '解析：数字、汉字和图片均为数据的不同表现形式，而文件夹是用于存储和组织数据的容器，本身不是数据，因此选D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (48, 1, '下列选项中不属于数据的是()', '{\"A\": \"防汛期间测量的水位\", \"B\": \"旅行时拍下的照片\", \"C\": \"钟表上显示的时间\", \"D\": \"旅行时用的背包\"}', 'D', '2026-09-13 06:14:58.838311', '2026-09-13 06:14:58.838311', '解析：数据是记录信息的载体，如数字、文字、图像等。选项A、B、C均为记录或表达信息的载体，而背包是实物物品，不承载信息，因此不属于数据。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (49, 1, '杜甫在《春望》中的诗句“烽火连三月，家书抵万金”,主要体现了信息的()', '{\"A\": \"传递性\", \"B\": \"真伪性\", \"C\": \"价值性\", \"D\": \"时效性\"}', 'C', '2026-09-13 06:14:58.844295', '2026-09-13 06:14:58.844295', '解析：诗句中“家书抵万金”强调家书在战乱时期具有极高的价值，因此体现了信息的价值性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (50, 1, '看到蚂蚁搬家就知道快下雨了。这是信息的()特征', '{\"A\": \"传递性\", \"B\": \"依附性\", \"C\": \"价值性\", \"D\": \"时效性\"}', 'B', '2026-09-13 06:14:58.851249', '2026-09-13 06:14:58.851249', '解析：蚂蚁搬家这一现象作为信息载体，依附于蚂蚁的行为表现出来，因此体现了信息的依附性特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (51, 1, '下面有关信息特征的描述，不正确的是()', '{\"A\": \"信息不会随着时间的推移而变化，信息具有永恒性\", \"B\": \"“一传十，十传百”引出信息的传递性\", \"C\": \"“增兵减灶”引出信息的真伪性\", \"D\": \"天气预报、情报等引出信息的时效性\"}', 'A', '2026-09-13 06:33:29.426771', '2026-09-13 06:33:29.426771', '解析：信息会随着时间的推移而变化，例如过时的信息可能失去价值，因此信息不具有永恒性，A选项描述错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (52, 1, '人类经历的五次信息技术革命,第二次是()', '{\"A\": \"语言的产生\", \"B\": \"文字的创造\", \"C\": \"印刷术的发明\", \"D\": \"电报、电话、广播、电视的发明和普及应用\"}', 'B', '2026-09-13 06:33:29.434749', '2026-09-13 06:33:29.434749', '解析：第二次信息技术革命是文字的创造，它使得信息能够被记录和跨时空传递，标志着人类从口头交流进入书面记录阶段，因此选项B正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (53, 1, '“瞬息万变”和“皮之不存毛将安附焉”分别体现出信息的()', '{\"A\": \"时效性、载体依附性\", \"B\": \"传递性、共享性\", \"C\": \"独立性、广泛性\", \"D\": \"真伪性、共享性\"}', 'A', '2026-09-13 06:33:29.441732', '2026-09-13 06:33:29.441732', '解析：“瞬息万变”强调信息随时间快速变化，体现了信息的**时效性**；“皮之不存毛将安附焉”比喻事物失去基础就无法存在，体现了信息依附于载体而存在的**载体依附性**。因此，正确答案是A。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (54, 1, '信息的表现形式多种多样，信息可以从一种形态转换为另一种形态,而不改变其()', '{\"A\": \"本质\", \"B\": \"状态\", \"C\": \"特征\", \"D\": \"内容\"}', 'D', '2026-09-13 06:33:29.448713', '2026-09-13 06:33:29.448713', '解析：信息在转换形态时，其核心要素——所承载的具体含义或数据（即内容）保持不变，而形态、状态或特征可能改变，因此正确答案是D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (55, 1, '1941年12月7日，日军成功突袭了珍珠港后，美军才收到情报，情报滞后，导致美军毫无防备，这主要说明了信息具有的()特征', '{\"A\": \"时效性\", \"B\": \"价值性\", \"C\": \"真伪性\", \"D\": \"依附性\"}', 'A', '2026-09-13 06:33:29.455694', '2026-09-13 06:33:29.455694', '解析：信息具有时效性，即信息的价值随时间推移而降低。珍珠港事件中，美军因情报滞后而无法及时应对，体现了信息在特定时间内有效，过时则失去作用，因此选A。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (56, 1, '小刘同学写了一份发言稿，她自己字斟句酌，反复修改，还请语文老师审核，这充分说明信息具有()。', '{\"A\": \"共享性\", \"B\": \"普遍性\", \"C\": \"依附性\", \"D\": \"可处理性\"}', 'D', '2026-09-13 06:33:29.462675', '2026-09-13 06:33:29.462675', '解析：小刘同学对发言稿进行字斟句酌、反复修改，体现了对信息内容进行加工、优化和处理的过程，这符合信息可被加工和改造的特性，即可处理性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (57, 1, '人类经历的五次信息技术革命依次为：语言的使用、文字的使用，()，电报、电话、广播、电视的使用和计算机的普及应用及其与通信技术的结合。', '{\"A\": \"火的使用\", \"B\": \"指南针的使用\", \"C\": \"印刷技术的应用\", \"D\": \"蒸汽机的发明和使用\"}', 'C', '2026-09-13 06:33:29.469657', '2026-09-13 06:33:29.469657', '解析：人类五次信息技术革命中，第三次是印刷技术的应用，它使知识可以大规模复制和传播，符合题干中从文字到电子通信的演进顺序，因此选C。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (58, 1, '2023年7月28日成都大运会开幕，世界各地的人们足不出户就能通过卫星电视观赏到精彩纷呈的大运会节目，这体现了信息具有()的特征?', '{\"A\": \"共享性和传递性\", \"B\": \"价值性和时效性\", \"C\": \"时效性和真伪性\", \"D\": \"依附性和可加工性\"}', 'A', '2026-09-13 06:33:29.477636', '2026-09-13 06:33:29.477636', '解析：卫星电视将大运会节目传输到世界各地，体现了信息可以从一方传递到另一方（传递性），并且能够被多人同时接收和使用（共享性）。其他选项如价值性、时效性、真伪性或依附性等，在此情境中并非直接体现的核心特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (59, 1, '人类经历的五次信息技术革命,第三次是()', '{\"A\": \"语言的产生\", \"B\": \"文字的创造\", \"C\": \"印刷术的发明\", \"D\": \"电报、电话、广播、电视的发明和普及应用\"}', 'C', '2026-09-13 06:33:29.483619', '2026-09-13 06:33:29.483619', '解析：人类信息技术的五次革命依次为：语言产生、文字创造、印刷术发明、电报电话广播电视的发明普及、计算机与互联网的诞生。第三次革命是印刷术的发明，它使信息得以大规模复制和传播。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (60, 1, '下列关于信息和数据的叙述中，正确的是()', '{\"A\": \"数据只有经过处理和解释，并赋予一定的意义后才成为信息\", \"B\": \"数据和信息是相互独立的，没有任何联系\", \"C\": \"任何数据都能够表示成为信息\", \"D\": \"信息和数据都不随载荷它的物理介质改变而变化\"}', 'A', '2026-09-13 06:33:29.490601', '2026-09-13 06:33:29.490601', '解析：数据是原始事实，只有经过处理和解释并赋予意义后才成为信息，因此A正确；B错误，因为数据和信息相互关联；C错误，因为并非所有数据都能直接成为信息，需结合上下文；D错误，信息和数据可能随物理介质变化而改变。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (61, 1, '人类经历的五次信息技术革命,第五次是()', '{\"A\": \"计算机应用的普及、计算机与现代通信技术的结合\", \"B\": \"文字的创造\", \"C\": \"印刷术的发明\", \"D\": \"电报、电话、广播、电视的发明和普及应用\"}', 'A', '2026-09-13 06:33:29.496585', '2026-09-13 06:33:29.496585', '解析：第五次信息技术革命以计算机的普及和计算机与现代通信技术的结合为核心，标志着信息处理与传输的深度融合，而其他选项分别对应前四次革命（文字创造、印刷术、电报电话等）。因此选A。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (62, 1, '到目前为止，人类一共经历了5次信息技术革命，其中()是从猿进化到人的重要标志。', '{\"A\": \"语言的产生\", \"B\": \"文字的创造\", \"C\": \"印刷术的发明\", \"D\": \"电报、电话、广播、电视的发明和普及应用\"}', 'A', '2026-09-13 06:33:29.503566', '2026-09-13 06:33:29.503566', '解析：语言的产生使人类能够进行复杂的信息交流和知识传递，促进了社会协作与思维发展，是从猿进化到人的重要标志。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (63, 1, '人类经历的五次信息技术革命,其中()为知识的积累和传播提供了更可靠的保证。', '{\"A\": \"语言的使用\", \"B\": \"文字的创造\", \"C\": \"印刷术的发明\", \"D\": \"计算机技术的普及\"}', 'C', '2026-09-13 06:33:29.509550', '2026-09-13 06:33:29.509550', '解析：印刷术的发明使书籍和文献能够大规模复制与传播，克服了手抄本的易错和稀缺问题，从而为知识的积累和传播提供了更可靠的保证。因此选C。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (64, 1, '《三国演义》的“赤壁之战”中，蒋干从周瑜那里盗得伪造的蔡瑁、张允投降书，致使曹操将这二人斩首，这说明信息具有()', '{\"A\": \"载体依附性\", \"B\": \"传递性\", \"C\": \"时效性\", \"D\": \"真伪性\"}', 'D', '2026-09-13 06:33:29.515534', '2026-09-13 06:33:29.515534', '解析：蒋干盗取的伪造投降书是虚假信息，导致曹操误判并错杀蔡瑁、张允，这直接体现了信息可能被伪造或歪曲，从而具有真伪性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (65, 1, '出门旅游拍下风景照片，回家给家人观赏，这种通过照片记录旅游信息的方式，主要体现信息具有()', '{\"A\": \"真伪性\", \"B\": \"载体依附性\", \"C\": \"时效性\", \"D\": \"客观性\"}', 'B', '2026-09-13 06:33:29.522516', '2026-09-13 06:33:29.522516', '解析：照片是信息的载体，旅游信息通过照片这一载体呈现给家人，体现了信息必须依附于某种载体才能被传递和接收的特性，即载体依附性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (66, 1, '下列关于信息的说法，不正确的是()。', '{\"A\": \"信息是事物的运动状态及其状态变化的方式\", \"B\": \"凡是在一种情况下能减少不确定性的任何事物都叫信息\", \"C\": \"信息是一成不变的东西\", \"D\": \"没有物质的世界是虚无的世界；没有能源的世界是死寂的世界；没有信息的世界是混乱的世界\"}', 'C', '2026-09-13 06:33:29.528500', '2026-09-13 06:33:29.528500', '解析：选项C“信息是一成不变的东西”是错误的，因为信息具有动态性，会随着事物的运动状态和变化而更新，并非固定不变。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (67, 1, '“一字千金”这说明信息具有()', '{\"A\": \"时效性\", \"B\": \"真伪性\", \"C\": \"价值性\", \"D\": \"共享性\"}', 'C', '2026-09-13 06:33:29.535044', '2026-09-13 06:33:29.535044', '解析：“一字千金”形容文字价值极高，强调信息的珍贵与重要性，直接体现了信息具有价值性，即信息能够满足人们某种需求并带来效益。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (68, 1, '下列关于信息搜集与处理叙述正确的是()', '{\"A\": \"因特网给我们带来了大量的信息，这些信息都是可信的，可以直接使用。\", \"B\": \"在因特网上，可以利用搜索引擎查找到我们所需要的一切信息。\", \"C\": \"有效获取信息后，要对其进行分类、整理并保存。\", \"D\": \"保存在计算机中的信息是永远不会丢失和损坏的。\"}', 'C', '2026-09-13 06:33:29.541028', '2026-09-13 06:33:29.542026', '解析：选项C正确，因为有效获取信息后进行分类、整理和保存是信息处理的基本步骤，有助于提高信息利用效率；选项A错误，因特网信息并非全部可信，需甄别；选项B错误，搜索引擎无法找到一切信息；选项D错误，计算机中信息可能因硬件故障、病毒等原因丢失或损坏。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (69, 1, '“不要轻信道听途说的小道消息”，这说明要从()进行慎重判断信息的真实性。', '{\"A\": \"信息的价值取向\", \"B\": \"信息的价值性\", \"C\": \"信息的来源\", \"D\": \"信息的时效性\"}', 'C', '2026-09-13 06:33:29.548009', '2026-09-13 06:33:29.548009', '解析：题干强调“道听途说”，即信息来自非正规、不可靠的渠道，因此判断真实性应优先考察信息的来源是否可信，故选C。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (70, 1, '同一信息对有的人有用，对有的人无用，这说明()。', '{\"A\": \"信息具有时效性\", \"B\": \"信息来源的权威性\", \"C\": \"信息来源的多样性\", \"D\": \"信息价值的相对性\"}', 'D', '2026-09-13 06:33:29.554991', '2026-09-13 06:33:29.554991', '解析：同一信息对不同的人作用不同，说明信息的价值因人而异，取决于接收者的需求和判断，因此体现了信息价值的相对性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (71, 1, '敦煌壁画，具有极高的历史、社会和艺术价值，这些刻在石窟壁上的绘画，说明信息具有()', '{\"A\": \"价值性\", \"B\": \"载体依附性\", \"C\": \"时效性\", \"D\": \"客观性\"}', 'B', '2026-09-13 06:33:29.560974', '2026-09-13 06:33:29.560974', '解析：信息不能独立存在，必须依附于某种载体（如纸张、壁画、电子设备等）才能被记录和传播。敦煌壁画刻在石窟壁上，正是信息依附于物质载体的典型体现，因此说明信息具有载体依附性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (72, 1, '同样一条信息对有的人有价值大，对有的人价值小。这说明信息有()特征。', '{\"A\": \"真伪性\", \"B\": \"时效性\", \"C\": \"共享性\", \"D\": \"价值相对性\"}', 'D', '2026-09-13 06:33:29.567955', '2026-09-13 06:33:29.567955', '解析：题目指出同一条信息对不同人价值大小不同，这体现了信息价值的主观性和相对性，即信息价值依赖于接受者的需求和情境，因此对应“价值相对性”特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (73, 1, '不属于信息的主要特征是()。', '{\"A\": \"真伪性\", \"B\": \"科学性\", \"C\": \"依附性\", \"D\": \"共享性\"}', 'B', '2026-09-13 06:33:29.573940', '2026-09-13 06:33:29.573940', '解析：信息的主要特征包括真伪性、依附性和共享性，而科学性不属于信息的基本特征，因此选项B正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (74, 1, '判断信息的价值可以从信息的()进行判断。', '{\"A\": \"共享性、时效性\", \"B\": \"准确性、客观性\", \"C\": \"时效性、依附性\", \"D\": \"共享性、权威性\"}', 'B', '2026-09-13 06:33:29.579924', '2026-09-13 06:33:29.579924', '解析：信息的价值主要取决于其准确性和客观性，准确的信息能真实反映事实，客观的信息则避免主观偏差，这两者是判断信息是否可靠、有用的核心标准。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (75, 1, '获取信息的来源决定了信息的可靠程度，获得的信息最可靠的来源是()', '{\"A\": \"报刊杂志\", \"B\": \"朋友、同学\", \"C\": \"亲自进行科学实验\", \"D\": \"因特网\"}', 'C', '2026-09-13 06:33:29.586906', '2026-09-13 06:33:29.586906', '解析：科学实验通过严谨的操作和重复验证，能直接获取客观数据，排除人为干扰和虚假信息，因此可靠性最高。其他来源如报刊、朋友或网络可能存在主观偏见或错误传播。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (76, 1, '信息的特征不包括()。', '{\"A\": \"载体依附性\", \"B\": \"价值相对性\", \"C\": \"决策性\", \"D\": \"共享性\"}', 'C', '2026-09-13 06:33:29.592890', '2026-09-13 06:33:29.592890', '解析：信息的特征包括载体依附性、价值相对性和共享性，而决策性不属于信息的基本特征，因此选C。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (77, 1, '信息的特征不包括()', '{\"A\": \"永久性\", \"B\": \"可加工性\", \"C\": \"传递性\", \"D\": \"共享性\"}', 'A', '2026-09-13 06:33:29.598874', '2026-09-13 06:33:29.598874', '解析：信息的特征包括可加工性、传递性和共享性，而永久性不是信息的固有特征，信息可能随时间或载体消失而丢失。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (78, 1, '信息的载体依附性指()', '{\"A\": \"信息可存储、可传递和可转换\", \"B\": \"信息与信息可以集合在一起形成新的信息\", \"C\": \"可供多人多次使用\", \"D\": \"依托各种表现形式传播\"}', 'D', '2026-09-13 06:33:29.605855', '2026-09-13 06:33:29.605855', '解析：信息的载体依附性是指信息必须依附于某种载体（如文字、声音、图像等）才能存在和传播，选项D“依托各种表现形式传播”准确体现了这一特性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (79, 1, '对信息的特征之一共享性理解正确的有()', '{\"A\": \"信息只有共同拥有才有价值\", \"B\": \"信息一旦出现,一定是被传者和受者同时拥有的\", \"C\": \"信息在交换或交流过程中,可以同时为众多的接受者所接收和利用\", \"D\": \"信息传给了一个人,其他人的信息可能会因之而减少\"}', 'C', '2026-09-13 06:33:29.611839', '2026-09-13 06:33:29.611839', '解析：共享性是指信息在传递过程中，可以被多个接收者同时获取和使用，而不会因分享而减少，选项C准确描述了这一特征。其他选项错误：A过于绝对，信息单独拥有也有价值；B中“一定”不严谨，信息可能单向传递；D错误，信息共享不会导致他人信息减少。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (80, 1, '信息的特征之一时效性是指()。', '{\"A\": \"信息会随着时间推移而消失\", \"B\": \"信息价值会随着时间推移而消失\", \"C\": \"信息价值会随时间下降、变化\", \"D\": \"信息的使用时间有限\"}', 'C', '2026-09-13 06:33:29.617823', '2026-09-13 06:33:29.617823', '解析：信息的时效性是指信息的价值会随着时间推移而下降或发生变化，因此选项C准确描述了这一特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (81, 1, '“根据没有升级的旧导航去指导出行会误事”、“一千个读者，一千个‘哈姆雷特’”、“孙膑‘增兵减灶退敌’”分别体现了信息的()。①真伪性②时效性③依附性和可处理性④价值相对性', '{\"A\": \"②③①\", \"B\": \"②④①\", \"C\": \"①③④\", \"D\": \"④③①\"}', 'B', '2026-09-13 06:33:29.623806', '2026-09-13 06:33:29.623806', '选B。第一句“旧导航误事”体现信息的**时效性**（②），因过时信息失效；第二句“不同读者不同哈姆雷特”体现信息的**价值相对性**（④），因人而异；第三句“增兵减灶”体现信息的**真伪性**（①），利用假信息迷惑敌人。故顺序为②④①。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (82, 1, '信息的特征真伪性是指()', '{\"A\": \"同一则信息，对有的人来说是真实的，对有的人来说是虚假的\", \"B\": \"同一则信息既是真实的，又是虚假的。\", \"C\": \"并非所有的信息都是对事物的真实反映，有真假之分\", \"D\": \"同一则信息既有真实的一面也有虚假的一面。\"}', 'C', '2026-09-13 06:33:29.630788', '2026-09-13 06:33:29.630788', '解析：信息的真伪性指信息并非全部真实反映客观事物，存在真假之分，因此C选项准确描述了这一特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (83, 1, '下列事例中,说明信息具有“真伪性”特征的是()', '{\"A\": \"结绳记事\", \"B\": \"烽火告急\", \"C\": \"凿壁借光\", \"D\": \"兵不厌诈\"}', 'D', '2026-09-13 06:33:29.637769', '2026-09-13 06:33:29.637769', '解析：兵不厌诈强调通过虚假信息迷惑对手，体现了信息可能被故意伪造或误导，从而具有真伪性特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (84, 1, '以下历史典故中能说明信息具有真伪性的是()。', '{\"A\": \"盲人摸象\", \"B\": \"减灶退敌\", \"C\": \"画蛇添足\", \"D\": \"围魏救赵\"}', 'B', '2026-09-13 06:33:29.643753', '2026-09-13 06:33:29.643753', '解析：减灶退敌中，孙膑通过减少灶台数量制造假象，诱使庞涓误判齐军兵力，体现了信息的真伪性，即信息可能被伪造或误导。其他选项未涉及信息真伪的辨别。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (85, 1, '同一则信息，在不同的时间内，价值是不同的，这是指信息的()', '{\"A\": \"真伪性\", \"B\": \"时效性\", \"C\": \"共享性\", \"D\": \"价值相对性\"}', 'B', '2026-09-13 06:33:29.649738', '2026-09-13 06:33:29.649738', '解析：信息的价值随时间变化而改变，这体现了信息的时效性，即信息只在特定时间段内有效或有用，因此正确答案是B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (86, 1, '同一则信息，对不同的人来说，价值不同,这是指信息的()', '{\"A\": \"真伪性\", \"B\": \"时效性\", \"C\": \"共享性\", \"D\": \"价值相对性\"}', 'D', '2026-09-13 06:33:29.656719', '2026-09-13 06:33:29.656719', '解析：信息对不同的人价值不同，体现了信息价值因接收者需求、认知或情境而异，即价值相对性，而非真伪、时效或共享特性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (87, 1, '信息可以被多个接收者接收并加以利用。例如，互联网上的信息被下载和利用。这是指信息的()', '{\"A\": \"真伪性\", \"B\": \"时效性\", \"C\": \"共享性\", \"D\": \"价值相对性\"}', 'C', '2026-09-13 06:33:29.662703', '2026-09-13 06:33:29.662703', '解析：信息可以被多个接收者同时接收和利用，互联网上的信息被多人下载和使用，体现了信息在共享过程中不会因使用而减少，这是信息的共享性特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (88, 1, '信息是事物的特征和变化的客观反映,信息所反映的内容不依人的意志为转移,这是指信息的()', '{\"A\": \"真伪性\", \"B\": \"客观性\", \"C\": \"共享性\", \"D\": \"不可处理性\"}', 'B', '2026-09-13 06:33:29.668691', '2026-09-13 06:33:29.668691', '解析：题干强调信息“不依人的意志为转移”，说明信息是客观存在的，不因主观意识而改变，这直接对应信息的客观性特征，因此选B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (89, 1, '要告诉某人一件事，可以用多种方法，比如写信、打电话或者发电子邮件给他，这说明信息有()特征', '{\"A\": \"载体依附性\", \"B\": \"载体多样性\", \"C\": \"载体唯一性\", \"D\": \"可处理性\"}', 'B', '2026-09-13 06:33:29.675672', '2026-09-13 06:33:29.675672', '解析：题干中写信、打电话、发电子邮件是三种不同的信息传递方式，体现了信息可以依附于多种载体（纸张、电话信号、电子数据），因此信息具有载体多样性特征，故选B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (90, 1, '下列关于信息与载体关系的理解,错误的是()', '{\"A\": \"信息的传输和表示离不开载体\", \"B\": \"不同的信息不能依附于同一载体\", \"C\": \"同一信息可以依附于不同一个载体\", \"D\": \"信息不能脱离载体独立存在\"}', 'B', '2026-09-13 06:33:29.681656', '2026-09-13 06:33:29.681656', '解析：信息与载体的关系是，信息必须依附于载体才能传输和表示，同一信息可以依附于不同载体（如文字、声音），不同信息也可以依附于同一载体（如一张纸可写多种内容），因此B选项“不同的信息不能依附于同一载体”错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (91, 1, '下列有关信息的叙述中正确的是()', '{\"A\": \"信息是具有价值的\", \"B\": \"信息与载体种类也存在必然关系\", \"C\": \"信息是永远有效的\", \"D\": \"信息是无法进行加工、处理的\"}', 'A', '2026-09-13 06:33:29.687640', '2026-09-13 06:33:29.687640', '解析：信息具有价值性，能够满足人们的需求，因此A正确。信息与载体种类无关，同一信息可通过不同载体传递，B错误。信息可能随时间失效，并非永远有效，C错误。信息可以被加工和处理，如整理、分析等，D错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (92, 1, '下列有关信息与载体的表述错误的是()。', '{\"A\": \"一个信息同一时间只能加载到一个载体上\", \"B\": \"信息是无法脱离载体而单独存在的\", \"C\": \"载体本身不是信息，其中所传达的事物状态或事件真相才是信息\", \"D\": \"信息不会随着载体的物理形式变化而变化\"}', 'A', '2026-09-13 06:33:29.694622', '2026-09-13 06:33:29.694622', '解析：A选项表述错误，因为一个信息可以同时加载到多个载体上，例如同一段文字可同时印刷在书本和显示在屏幕上，信息并不限于单一载体。其他选项均正确描述了信息与载体的关系。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (93, 1, '载体和信息的关系不应该是()', '{\"A\": \"信息是无法脱离载体而单独存在的,必须依靠载体来记录、表达和传递\", \"B\": \"信息必须通过载体才能体现\", \"C\": \"载体的物理形式变化会影响信息\", \"D\": \"同样的信息，可以加载于不同的载体之上\"}', 'C', '2026-09-13 06:33:29.700605', '2026-09-13 06:33:29.700605', '解析：选项C错误，因为载体的物理形式变化不一定影响信息本身，信息具有独立性，可保持内容不变；而A、B、D均正确描述了载体与信息的依存关系。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (94, 1, '下列有关数据和信息的知识理解，错误的是()', '{\"A\": \"离开了载体，信息一样可以展示、传播、存储\", \"B\": \"数据是用符号表示客观事物\", \"C\": \"一种信息可以在任一时间被不同的接收者获取\", \"D\": \"同样的信息对于不同的人群、不同的时间，其价值可能有所不同\"}', 'A', '2026-09-13 06:33:29.706590', '2026-09-13 06:33:29.706590', '解析：信息必须依附于载体才能展示、传播和存储，离开载体信息无法独立存在，因此A选项表述错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (95, 1, '下列关于信息的理解正确的是（）', '{\"A\": \"信息随着客观事物的变化而变化\", \"B\": \"所有信息都是对事物的真实反映\", \"C\": \"信息被使用后就不再具有价值了\", \"D\": \"语言的产生使信息的传递打破了时间和空间的限制\"}', 'A', '2026-09-13 06:33:29.713571', '2026-09-13 06:33:29.713571', '解析：A选项正确，因为信息是对客观事物运动状态和方式的反映，因此会随客观事物的变化而变化；B选项错误，信息不一定都是真实的，可能存在虚假信息；C选项错误，信息具有共享性，使用后价值不会消失；D选项错误，语言的产生打破了时间限制，但文字的出现才打破了空间限制。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (96, 1, '第五次信息革命的标志是()', '{\"A\": \"文字的产生\", \"B\": \"计算机的发明\", \"C\": \"电报电话的发明及应用\", \"D\": \"印刷技术的应用\"}', 'B', '2026-09-13 06:33:29.719555', '2026-09-13 06:33:29.719555', '解析：第五次信息革命的标志是计算机的发明，因为它实现了信息的数字化处理和高速运算，推动了信息技术的全面革新，而其他选项分别属于更早的信息革命阶段。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (97, 1, '我们日常交流用到的语言、文字等都是信息的()', '{\"A\": \"内容\", \"B\": \"载体\", \"C\": \"能量\", \"D\": \"表象\"}', 'B', '2026-09-13 06:33:29.725539', '2026-09-13 06:33:29.725539', '解析：语言和文字是传递信息的具体形式或媒介，它们承载信息内容而非信息本身，因此属于信息的载体。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (98, 1, '下面对于信息与载体的理解错误的是()', '{\"A\": \"载体本身不是信息，其中所传达的事物状态或事件真相才是信息\", \"B\": \"同样的信息，可以加载于不同的载体之上\", \"C\": \"打电话与写信告诉某人同一件事，这二种方式信息不同，载体相同\", \"D\": \"信息是无法脱离载体而单独存在\"}', 'C', '2026-09-13 06:33:29.732520', '2026-09-13 06:33:29.732520', '解析：选项C错误，因为打电话与写信告诉某人同一件事，信息内容相同，只是载体不同（电话与信件），而非信息不同。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (99, 1, '信息技术是有关信息的收集、识别、提取、变换、存储、处理、检索、检测分析利用等的技术,简称()', '{\"A\": \"IP\", \"B\": \"IE\", \"C\": \"IT\", \"D\": \"AI\"}', 'C', '2026-09-13 06:33:29.739502', '2026-09-13 06:33:29.739502', '解析：信息技术（Information Technology）的英文缩写是IT，因此正确答案是C。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (100, 1, '关于信息技术的理解错误的是().', '{\"A\": \"信息技术是有关信息的收集、识别、提取、变换、存储、处理、检索、检测分析利用等的技术\", \"B\": \"信息技术主要包括传感技术、计算机技术和通信技术、微电子技术\", \"C\": \"信息技术简称为IT\", \"D\": \"信息技术就是指利用计算机处理信息的技术\"}', 'D', '2026-09-13 06:33:29.745486', '2026-09-13 06:33:29.745486', '解析：信息技术是一个广泛的概念，不仅限于计算机处理信息，还包括传感、通信、微电子等多种技术，因此选项D缩小了信息技术的范围，理解错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (101, 1, '所谓3C技术是指()的合称,3C技术是信息技术的主体。', '{\"A\": \"通信技术、计算机技术、控制技术\", \"B\": \"通信技术、数字技术、计算机技术\", \"C\": \"数字技术、计算机技术、控制技术\", \"D\": \"信息技术、通信技术、控制技术\"}', 'A', '2026-09-13 06:45:26.951047', '2026-09-13 06:45:26.951047', '解析：3C技术是通信技术、计算机技术和控制技术的合称，这三个领域是信息技术的主体，因此选项A正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (102, 1, '下列关于信息技术的叙述，错误的有()', '{\"A\": \"信息技术是对信息进行采集、处理、传输、存储、表达和使用的技术\", \"B\": \"信息技术是伴随着计算机和互联网技术的发展而诞生的\", \"C\": \"现代信息技术包含微电子技术、通信技术、计算机技术和传感技术等\", \"D\": \"量子计算机、生物计算机、智能机器人、物联网都是当前信息技术发展的热点\"}', 'B', '2026-09-13 06:45:26.958028', '2026-09-13 06:45:26.958028', '解析：选项B错误，因为信息技术并非伴随计算机和互联网技术诞生，而是自古就有，如结绳记事、烽火传信等都属于信息技术，计算机和互联网只是现代信息技术的典型代表。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (103, 1, '下列有关信息与信息技术描述错误的是()', '{\"A\": \"微电子技术是现代信息技术的基石\", \"B\": \"信息的表示、传播存储必须依附于某种载体,但信息也可以脱离它所反映的事物被存储和传播。\", \"C\": \"信息是看不见摸不着的,我们日常交流用到的语言文字都是信息的载体\", \"D\": \"信息技术从古到今一直都存在并不断发展,如电影、电视技术属于现代信息技术\"}', 'D', '2026-09-13 06:45:26.965010', '2026-09-13 06:45:26.965010', '解析：电影、电视技术属于现代通信与传播技术，而非现代信息技术范畴，现代信息技术主要指以计算机和网络为核心的技术，因此D项描述错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (104, 1, '教师在教学时，将知识转换为通俗易懂的内容，这一例子主要体现了信息的().', '{\"A\": \"价值性\", \"B\": \"可处理性\", \"C\": \"共享性\", \"D\": \"真伪性\"}', 'B', '2026-09-13 06:45:26.972988', '2026-09-13 06:45:26.972988', '解析：教师将知识转换为通俗易懂的内容，是对原始信息进行加工、改编的过程，体现了信息可以根据需要被处理、变换形式的特性，因此选B可处理性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (105, 1, '现代信息技术不包括()。', '{\"A\": \"无线电技术\", \"B\": \"计算机技术\", \"C\": \"微电子技术\", \"D\": \"通信技术\"}', 'A', '2026-09-13 06:45:26.979044', '2026-09-13 06:45:26.979044', '解析：现代信息技术以计算机技术、微电子技术和通信技术为核心，而无线电技术是通信技术的一个分支，并非独立的信息技术核心组成部分，因此不包含在内。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (106, 1, '下列不属于信息的是()。', '{\"A\": \"网页上的新闻\", \"B\": \"MP3播放器\", \"C\": \"手机拍的照片\", \"D\": \"抖音视频\"}', 'B', '2026-09-13 06:45:26.986027', '2026-09-13 06:45:26.987025', '解析：信息是数据经过加工处理后具有意义的内容，而MP3播放器是承载信息的硬件设备，本身并非信息本身。网页新闻、照片和抖音视频均包含有意义的内容，属于信息。因此选B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (107, 1, '从信息科学的角度看,信息的载体是(),它是信息的具体表现形式。', '{\"A\": \"大脑的思维\", \"B\": \"数据\", \"C\": \"大脑\", \"D\": \"人的意识\"}', 'B', '2026-09-13 06:45:26.993009', '2026-09-13 06:45:26.993009', '解析：从信息科学的角度，信息是抽象内容，必须依附于具体载体才能被表示和处理，而数据（如数字、文字、符号等）正是信息的物理或数字表现形式，因此选B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (108, 1, '信息是指消息中有意义的内容,信息特征不包括()', '{\"A\": \"传递性\", \"B\": \"依附性\", \"C\": \"共享性\", \"D\": \"准确性\"}', 'D', '2026-09-13 06:45:27.000705', '2026-09-13 06:45:27.000705', '解析：信息的特征包括传递性、依附性和共享性，而准确性并非信息固有的基本特征，因为信息可能失真，故正确答案为D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (109, 1, '信息技术是应用信息科学的原理和方法有效地利用信息资源的技术体系。它由()组成。', '{\"A\": \"微电子技术和计算机\", \"B\": \"光电子技术和控制技术\", \"C\": \"计算机技术、通信技术、微电子技术、传感技术\", \"D\": \"微电子和光电子技术\"}', 'C', '2026-09-13 06:45:27.007686', '2026-09-13 06:45:27.007686', '解析：信息技术是一个综合性的技术体系，其核心组成部分包括计算机技术、通信技术、微电子技术和传感技术，这些技术共同支撑信息的获取、处理、传输和应用，因此选项C正确。其他选项仅涉及部分技术，不完整。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (110, 1, '信息处理的基本流程主要包括().', '{\"A\": \"信息的获得、收集、加工、传递、应用\", \"B\": \"信息的收集、加工、存储、传递、应用\", \"C\": \"信息的收集、加工、存储、接收、应用\", \"D\": \"信息的收集、获得、存储、加工、发送\"}', 'B', '2026-09-13 06:45:27.014057', '2026-09-13 06:45:27.014057', '解析：信息处理的基本流程通常包括信息的收集、加工、存储、传递和应用，选项B完整覆盖了这些核心环节，而其他选项缺少必要步骤（如存储或传递）或包含冗余术语（如“获得”重复“收集”），因此B正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (111, 1, '下说法有关信息、载体的说法不正确的是().', '{\"A\": \"信息不能独立存在,需要依附于一定的载体\", \"B\": \"信息可以转换成不同的载体形式而被存储和传播\", \"C\": \"信息可以被多个信息接受者接受并且多次使用\", \"D\": \"同一个信息不可以依附于多种载体\"}', 'D', '2026-09-13 06:45:27.021038', '2026-09-13 06:45:27.021038', '解析：选项D错误，因为同一个信息可以依附于多种载体，例如文字、图像、声音等，因此D说法不正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (112, 1, '信息技术出现的时间是()', '{\"A\": \"20世纪60年代\", \"B\": \"跟人类的出现同步\", \"C\": \"跟语言的出现同步\", \"D\": \"计算机诞生时\"}', 'C', '2026-09-13 06:45:27.027022', '2026-09-13 06:45:27.027022', '解析：信息技术包括语言、文字、印刷术、电报电话和计算机等，其最早形式是语言，因此信息技术与语言的出现同步，故正确答案为C。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (113, 1, '关于信息处理的论述中正确的是().', '{\"A\": \"信息处理包括信息收集、信息加工、信息存储、信息传递等几项内容\", \"B\": \"同学们对一段课文总结中心思想这不能算是一个信息加工过程\", \"C\": \"信息传递不是信息处理\", \"D\": \"信息的存储只能使用计算机的磁盘\"}', 'A', '2026-09-13 06:45:27.033006', '2026-09-13 06:45:27.033006', '解析：A选项正确，因为信息处理的过程通常包括信息收集、信息加工、信息存储和信息传递等环节，符合信息处理的完整定义。B选项错误，总结中心思想是对课文内容进行分析和提炼，属于信息加工过程。C选项错误，信息传递是信息处理的重要组成部分，例如将处理后的信息发送给接收者。D选项错误，信息存储可以使用多种介质，如纸张、磁带、光盘等，并非只能使用计算机磁盘。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (114, 1, '下列关于信息与数据的关系说法不正确的是().', '{\"A\": \"数据是物理的，而信息是释义的\", \"B\": \"数据反映事物的表象，信息反映事物的本质\", \"C\": \"数据是信息的重要来源\", \"D\": \"信息是数据的重要来源\"}', 'D', '2026-09-13 06:45:27.040985', '2026-09-13 06:45:27.040985', '解析：选项D错误，因为信息来源于对数据的解释和加工，而非数据来源于信息；数据是信息的原始材料，信息是数据经过处理后的结果。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (115, 1, '获取信息一般需要经历以下的基本过程:确定信息需求->()—>采集信息->保存信息.', '{\"A\": \"确定信息来源\", \"B\": \"确定信息类型\", \"C\": \"确定信息采集方法\", \"D\": \"确定成果目标\"}', 'A', '2026-09-13 06:45:27.046969', '2026-09-13 06:45:27.046969', '解析：在获取信息的基本过程中，确定信息需求后，下一步需要明确从哪里获取信息，因此应选择“确定信息来源”，这是信息采集前的必要步骤。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (116, 1, '下列有关信息的描述中不正确的是().', '{\"A\": \"只有以书本的形式才能长期保存信息\", \"B\": \"模拟信号比数字信号易受干扰而导致失真\", \"C\": \"计算机以数字化的方式对各种信息进行处理\", \"D\": \"信息来源于社会又作用于社会\"}', 'A', '2026-09-13 06:45:27.053950', '2026-09-13 06:45:27.053950', '解析：A选项错误，因为信息不仅可以通过书本长期保存，还可以通过电子存储、光盘、胶片等多种形式保存，因此“只有以书本的形式才能长期保存信息”的说法不准确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (117, 1, '孙滨“增兵减灶”斗庞涓，反映了信息的()特征.', '{\"A\": \"时效性\", \"B\": \"共享性\", \"C\": \"真伪性\", \"D\": \"传递性\"}', 'C', '2026-09-13 06:45:27.059934', '2026-09-13 06:45:27.059934', '解析：孙滨“增兵减灶”故意制造假象迷惑庞涓，体现了信息可能被伪造或误导，因此反映了信息的真伪性特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (118, 1, '传播地域最广、最快捷、最经济、最能满足人们视觉和听觉效果的信息发布方式是()', '{\"A\": \"广播\", \"B\": \"电影\", \"C\": \"电视网络\", \"D\": \"计算机网络\"}', 'D', '2026-09-13 06:45:27.066915', '2026-09-13 06:45:27.066915', '解析：计算机网络能够同时传输文字、图像、音频和视频，覆盖全球，传播速度快且成本低，满足视觉和听觉需求，因此是最符合题目描述的传播方式。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (119, 1, '以下是信息的特征序号的是()①可开发、可存储到计算机中②不可利用、不能增值③.可传递、共享、可压缩④不可处理、不可再生', '{\"A\": \"①④\", \"B\": \"①③\", \"C\": \"②④\", \"D\": \"②③\"}', 'B', '2026-09-13 06:45:27.073897', '2026-09-13 06:45:27.073897', '解析：信息的特征包括可开发、可存储、可传递、可共享、可压缩等，而“不可利用、不能增值”和“不可处理、不可再生”均不符合信息的基本特征，因此只有①和③正确，故选择B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (120, 1, '下列关于信息与数据的关系说法中,不正确的是().', '{\"A\": \"信息不需要数据来表现\", \"B\": \"数据输入计算机都要转换成二进制才能存储和传输.\", \"C\": \"信息必须通过数据才能传播，才能对人类有影响\", \"D\": \"数据是反映客观事物属性的记录,是信息的具体表现形式.\"}', 'A', '2026-09-13 06:45:27.080878', '2026-09-13 06:45:27.080878', '解析：信息需要数据作为载体来表现和传播，选项A说“信息不需要数据来表现”与事实相反，因此不正确。其他选项均正确描述了信息与数据的关系。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (121, 1, '\"烽火狼烟\"，狼烟一起，各诸侯就知道有外敌入侵，主要体现了信息哪个特征().', '{\"A\": \"可处理性\", \"B\": \"传递性\", \"C\": \"真伪性\", \"D\": \"时效性\"}', 'B', '2026-09-13 06:45:27.087859', '2026-09-13 06:45:27.087859', '解析：狼烟通过烽火台传递，使各诸侯接收外敌入侵的信息，体现了信息从发送者到接收者的传递过程，因此主要属于传递性特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (122, 1, '用计算机技术处理信息，将原有的信息通过系统化的数据处理技术，将其转换成另一种新的、有用的信息，以便于快速有效地提取所需要的信息是指()', '{\"A\": \"信息处理\", \"B\": \"信息储存\", \"C\": \"信息加工\", \"D\": \"信息采集\"}', 'C', '2026-09-13 06:45:27.093843', '2026-09-13 06:45:27.093843', '解析：题目描述的是将原有信息通过系统化技术转换成另一种新的有用信息，这符合信息加工的定义，即对原始信息进行变换、整理和提炼以产生新信息。信息处理范围更广，信息储存侧重保存，信息采集侧重收集，因此选C。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (123, 1, '朋友亲友之间可以通过微信、QQ交流,此时微信、QQ是信息的()', '{\"A\": \"载体\", \"B\": \"时效\", \"C\": \"价值\", \"D\": \"传递\"}', 'A', '2026-09-13 06:45:27.099828', '2026-09-13 06:45:27.099828', '解析：微信、QQ作为交流工具，承载了信息的内容，因此它们是信息的载体。选项A正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (124, 1, '不同的人对同一信息可能有不同的价值判断。同一信息对于不同人的价值不同，甚至可能对于某些人没有价值。这说明信息有()特征', '{\"A\": \"真伪性\", \"B\": \"可处理性\", \"C\": \"载体依附性\", \"D\": \"价值相对性\"}', 'D', '2026-09-13 06:45:27.106809', '2026-09-13 06:45:27.106809', '解析：题干中“不同人对同一信息价值判断不同”及“同一信息对某些人可能无价值”，直接体现了信息价值因人而异的特点，因此对应信息的**价值相对性**特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (125, 1, '信息来源于客观世界，具有一定的利用价值，用来指导人类认识世界、改造世界,信息处理的六个基本环节是()', '{\"A\": \"采集、传输、转换、存储、输入、输出\", \"B\": \"采集、输入、加工、存储、传输、输出\", \"C\": \"采集、传输、加工、存储、输入、输出\", \"D\": \"采集、分类、加工、存储、输入、输出\"}', 'C', '2026-09-13 06:45:27.112793', '2026-09-13 06:45:27.112793', '解析：信息处理的六个基本环节包括采集、传输、加工、存储、输入和输出，选项C准确列出了这些环节，而其他选项存在环节遗漏或顺序错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (126, 1, '在信息科学中,信息是指音讯、消息、通讯系统传输和处理的对象,泛指人类社会()的一切内容。', '{\"A\": \"生产\", \"B\": \"活动\", \"C\": \"传播\", \"D\": \"创造\"}', 'C', '2026-09-13 06:45:27.119775', '2026-09-13 06:45:27.119775', '解析：题目中“信息”的定义强调其作为通讯系统传输和处理的对象，而“传播”直接对应信息在人类社会中的传递与交换过程，其他选项（生产、活动、创造）未突出信息传递的核心特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (127, 1, '千千万万的人们可以通过电视了解到发生在远方的消息,这体现了信息可以在()上被传送.', '{\"A\": \"时间\", \"B\": \"通信\", \"C\": \"信道\", \"D\": \"空间\"}', 'D', '2026-09-13 06:45:27.125758', '2026-09-13 06:45:27.125758', '解析：电视通过电磁波将远方的消息传送到千家万户，体现了信息在空间上的远程传输，因此选D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (128, 1, '以下不属于信息的是().', '{\"A\": \"大学录取通知\", \"B\": \"高考成绩\", \"C\": \"一个机顶盒\", \"D\": \"投档线数据\"}', 'C', '2026-09-13 06:45:27.132739', '2026-09-13 06:45:27.132739', '解析：信息是数据经过加工后具有意义的内容，而“一个机顶盒”属于具体的物理设备，不是信息。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (129, 1, '“明修栈道、暗渡陈仓”、“空城计”反映的是信息具有()特征.', '{\"A\": \"价值性\", \"B\": \"共享性\", \"C\": \"真伪性\", \"D\": \"传递性\"}', 'C', '2026-09-13 06:45:27.138724', '2026-09-13 06:45:27.138724', '解析：这两个典故中，一方通过虚假信息（明修栈道、空城计）迷惑对方，导致对方做出错误判断，体现了信息可能真实也可能虚假的特征，因此正确答案是C：真伪性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (130, 1, '关于信息来源的叙述,不正确是().', '{\"A\": \"网络上信息多,还很可靠\", \"B\": \"在网络上可以收集大量信息，但要甄别\", \"C\": \"尽量选择可靠的信息源\", \"D\": \"网络信息来源具有多样性和代表性\"}', 'A', '2026-09-13 06:45:27.144708', '2026-09-13 06:45:27.144708', '解析：A项错误，因为网络信息虽然丰富，但并非所有信息都可靠，存在虚假和不准确的内容，需要甄别。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (131, 1, '报纸、新闻节目,今天听了是新闻,明天听了就是旧闻，这说明信息具有()', '{\"A\": \"共享性\", \"B\": \"时效性\", \"C\": \"无限性\", \"D\": \"可转换性\"}', 'B', '2026-09-13 06:45:27.151689', '2026-09-13 06:45:27.151689', '解析：信息随着时间的推移会失去价值，今天为新闻，明天即变为旧闻，体现了信息对时间敏感的特性，因此正确答案为B，时效性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (132, 1, '世界卫生组织2023年5月5日宣布,新冠疫情不再构成“国际关注的突发公共卫生事件”。这个决定通过电视、网络发布世界各地，这说明信息有()', '{\"A\": \"真伪性和传递性\", \"B\": \"传递性和可依附性\", \"C\": \"时效性和价值相对性\", \"D\": \"可处理性和可存储\"}', 'B', '2026-09-13 06:45:27.157673', '2026-09-13 06:45:27.157673', '解析：题干中“通过电视、网络发布世界各地”体现了信息可以从一个地方传递到另一个地方，即传递性；同时，信息需要依附在电视、网络等载体上才能传播，体现了可依附性。因此选B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (133, 1, '下列信息说法错误的是()。', '{\"A\": \"信息是反映现实世界的运动、发展和变化状态及规律的信号与消息\", \"B\": \"过时的信息不算信息\", \"C\": \"信息具有时效性\", \"D\": \"信息有共享性、传递性、真伪性特征\"}', 'B', '2026-09-13 06:45:27.163657', '2026-09-13 06:45:27.163657', '解析：B选项错误，因为过时的信息虽然时效性降低，但依然属于信息范畴，只是价值可能减弱，而非“不算信息”。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (134, 1, '下列关于信息的共享性的说法中，不正确的是()', '{\"A\": \"信息的共享不会产生损耗\", \"B\": \"信息共享时需要依附于载体\", \"C\": \"信息的共享性可以简单地表述为一个信源、多个信宿\", \"D\": \"信息的共享性与物质和能源的共享性一样\"}', 'D', '2026-09-13 06:45:27.170638', '2026-09-13 06:45:27.170638', '解析：信息的共享性不会像物质和能源那样因共享而减少或损耗，因此选项D错误，其他选项均正确描述信息共享的特性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (135, 1, '关于信息的说法，错误的是()。', '{\"A\": \"信息的英文是Information，不需要载体也能传输\", \"B\": \"信息有多种传播形式\", \"C\": \"信息不随载体的物理形式的改变而改变\", \"D\": \"信息是用文字、数字、符号、语言、图像等介质来表示事件、事物、现象等的内容、数量或特征，从而向人们（或系统）提供关于现实世界新的事实和知识，作为生产、建设、经营、管理、分析和决策的依据。\"}', 'A', '2026-09-13 06:45:27.176623', '2026-09-13 06:45:27.176623', '解析：信息必须依附于载体才能传输，选项A说“不需要载体也能传输”是错误的，因此正确答案是A。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (136, 1, '()是通过传输媒介实现信息转移的一种技术,其主要功能是实现信息快速、可靠、安全的转移', '{\"A\": \"信息获取技术\", \"B\": \"信息传递技术\", \"C\": \"信息存储技术\", \"D\": \"信息加工技术\"}', 'B', '2026-09-13 06:45:27.183604', '2026-09-13 06:45:27.183604', '解析：信息传递技术是通过传输媒介实现信息转移的技术，其核心功能是确保信息快速、可靠、安全地转移，因此选项B正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (137, 1, '下列对数据的概念理解错误一项是()', '{\"A\": \"数据可以用于科学研究、设计、查证等\", \"B\": \"数据有很多种，最简单的就是数字\", \"C\": \"数据有很多种，如数字、字符、图片\", \"D\": \"数据越复杂越易获得有用的内容\"}', 'D', '2026-09-13 06:45:27.189588', '2026-09-13 06:45:27.189588', '解析：选项D“数据越复杂越易获得有用的内容”说法错误，因为数据的复杂程度与获取有用内容的难易程度并不成正比，复杂数据往往需要更多处理和分析才能提取价值，而非更易获得有用内容。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (138, 1, '关于信息的认识,下列选项中不正确的是().', '{\"A\": \"信息是一种重要资源,它能提供的是知识和智慧\", \"B\": \"一则消息一定含有丰富的信息\", \"C\": \"信息在时间上的传递称为存储\", \"D\": \"信息有多种表现形式\"}', 'B', '2026-09-13 06:45:27.195572', '2026-09-13 06:45:27.195572', '解析：B选项错误，因为一则消息可能包含很少甚至无用的信息，信息量取决于内容的新颖性和不确定性，而非消息本身的存在。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (139, 1, '下列关于信息的说法错误的是().', '{\"A\": \"信息是人类社会发展的重要资源\", \"B\": \"信息本身是无形的\", \"C\": \"信息的价值因人而异\", \"D\": \"信息可以不依附于任何载体\"}', 'D', '2026-09-13 06:45:27.201555', '2026-09-13 06:45:27.201555', '解析：信息必须依附于载体才能存在和传递，如文字、声音、图像等，因此“信息可以不依附于任何载体”是错误的。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (140, 1, '李大妈8月5日顺手拿起一张报纸浏览，看到一条信息“今明两天到国美电器购买空调一台，即获300元现金券。”于是，李大妈便前往国美商场，却被告知活动时间已过，他不能享受优惠，李大妈不解，找出报纸一看，发现报纸是8月1日的，这件事体现了信息的().', '{\"A\": \"共享性\", \"B\": \"价值性\", \"C\": \"时效性\", \"D\": \"依附性\"}', 'C', '2026-09-13 06:45:27.208537', '2026-09-13 06:45:27.208537', '解析：报纸信息发布于8月1日，而李大妈在8月5日才看到并前往，导致优惠活动已过期，这说明信息的价值会随时间推移而减弱或失效，因此体现了信息的时效性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (141, 1, '古时候打仗“鸣锣收兵”，其主要的信息载体形式是()', '{\"A\": \"文字\", \"B\": \"图片\", \"C\": \"声音\", \"D\": \"动画\"}', 'C', '2026-09-13 06:45:27.214521', '2026-09-13 06:45:27.214521', '解析：鸣锣收兵通过敲锣发出的声音传递撤退指令，因此主要信息载体是声音。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (142, 1, '下列信息传播途径中速度最快、传播范围最广的是()。', '{\"A\": \"人传人\", \"B\": \"网络传播\", \"C\": \"网络通知\", \"D\": \"电话媒介\"}', 'B', '2026-09-13 06:45:27.220505', '2026-09-13 06:45:27.220505', '解析：网络传播依托互联网技术，能够瞬间将信息发送至全球各地，覆盖范围极广且传播速度最快，而人传人、电话媒介和网络通知在速度和范围上均受限于人际或技术节点，因此B选项正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (143, 1, '在下面关于信息处理的说法中错误的是()', '{\"A\": \"计算机可以处理数值、文字、图形、图像和声音等信息。\", \"B\": \"信息只能通过计算机处理\", \"C\": \"信息处理主要包括原始数据的采集、存储、传输、加工和输出\", \"D\": \"计算机是现代信息处理的重要工具。\"}', 'B', '2026-09-13 06:45:27.226489', '2026-09-13 06:45:27.226489', '解析：选项B“信息只能通过计算机处理”的说法是错误的，因为信息处理还可以通过人脑、其他设备或传统方式完成，计算机只是重要工具之一，并非唯一途径。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (144, 1, '同样的信息，可以加载于不同的载体之上，关于信息、载体和数据的说法正确的是()。', '{\"A\": \"数据不随载荷它的物理介质改变而变化\", \"B\": \"信息随载体改变而变化\", \"C\": \"信息不因载体变化而改变\", \"D\": \"数据和信息都不随载荷它的物理介质改变而变化\"}', 'C', '2026-09-13 06:45:27.233470', '2026-09-13 06:45:27.233470', '解析：信息是数据所表达的含义，其本质不依赖于具体载体，因此信息不随载体变化而改变；而数据是信息的符号表示，可能因载体不同而形式变化。选项C正确反映了这一特性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (145, 1, '信息技术就是人们()、传递、处理以及开发和利用信息的所有技术。', '{\"A\": \"统计、分析\", \"B\": \"输入、加工\", \"C\": \"获取、存储\", \"D\": \"输入、输出\"}', 'C', '2026-09-13 06:45:27.239454', '2026-09-13 06:45:27.239454', '解析：信息技术的基本流程包括信息的获取、存储、传递、处理及开发利用，选项C中的“获取、存储”完整覆盖了信息处理的前两个关键环节，符合定义。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (146, 1, '下列不属于采集信息工具的是()。', '{\"A\": \"照相机\", \"B\": \"扫描仪\", \"C\": \"电视机\", \"D\": \"摄像机\"}', 'C', '2026-09-13 06:45:27.246435', '2026-09-13 06:45:27.246435', '解析：照相机、扫描仪和摄像机均能直接采集图像或文字信息，而电视机仅用于接收和显示信息，不具备采集功能，因此不是采集信息工具。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (147, 1, '搜集信息，进行整理，反映了信息的()特征。', '{\"A\": \"真伪性\", \"B\": \"可处理性\", \"C\": \"共享性\", \"D\": \"价值性\"}', 'B', '2026-09-13 06:45:27.252420', '2026-09-13 06:45:27.252420', '解析：信息的可处理性指的是信息可以被搜集、整理、加工和转换，题干中“搜集信息，进行整理”正是对信息进行处理的过程，因此反映的是可处理性特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (148, 1, '关于信息特征，下列说法正确的是()', '{\"A\": \"信息能够独立存在\", \"B\": \"信息需要依附于一定的载体\", \"C\": \"信息不能分享\", \"D\": \"信息反映的是时间永久状态\"}', 'B', '2026-09-13 06:45:27.258404', '2026-09-13 06:45:27.258404', '解析：信息必须依附于文字、图像、声音等载体才能存在和传递，因此选项B正确；信息不能独立存在（A错误），可以分享（C错误），且反映事物状态而非永久状态（D错误）。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (149, 1, '当今社会信息到处都是，这句话表明了信息具有()。', '{\"A\": \"多样性\", \"B\": \"普遍性\", \"C\": \"变化性\", \"D\": \"储存性\"}', 'B', '2026-09-13 06:45:27.265385', '2026-09-13 06:45:27.265385', '解析：题干中“信息到处都是”强调信息在空间或时间上的广泛存在，即信息无处不在、无时不有，这符合信息普遍性的特征，因此选择B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (150, 1, '写信，以文字、信纸为载体，这体现了信息的()。', '{\"A\": \"依附性\", \"B\": \"共享性\", \"C\": \"时效性\", \"D\": \"价值性\"}', 'A', '2026-09-13 06:45:27.271369', '2026-09-13 06:45:27.271369', '解析：写信时，文字和信纸是信息的载体，信息必须依附于某种物质形式才能存在和传递，这体现了信息的依附性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (151, 1, '在信息科学里，信宿指的是()。', '{\"A\": \"信息的产生者\", \"B\": \"信息的接收者\", \"C\": \"信息的传播者\", \"D\": \"信息的编码形式\"}', 'B', '2026-09-13 06:46:24.315517', '2026-09-13 06:46:24.315517', '解析：在信息科学中，“信宿”是信息传递的终点，指信息的接收者，因此正确答案是B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (152, 1, '下列关于信息技术的叙述,错误的是()', '{\"A\": \"计算机技术是信息处理的核心\", \"B\": \"传感技术已被广泛应用于生产、生活等诸多领域\", \"C\": \"通信技术的发展加快了信息传递的速度\", \"D\": \"有了计算机才有信息技术\"}', 'D', '2026-09-13 06:46:24.330477', '2026-09-13 06:46:24.330477', '解析：信息技术包括计算机技术、通信技术、传感技术等，计算机只是信息处理的核心工具，并非信息技术的起源或必要条件，因此“有了计算机才有信息技术”是错误的。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (153, 1, '信息必须通过载体才能体现，()是信息的载体。', '{\"A\": \"网络\", \"B\": \"数据\", \"C\": \"存储介质\", \"D\": \"计算机\"}', 'B', '2026-09-13 06:46:24.337459', '2026-09-13 06:46:24.337459', '解析：信息必须通过载体才能体现，而数据是信息的载体，因为数据是信息的具体表现形式，例如文字、数字或符号等，网络、存储介质和计算机只是传输或存储数据的工具，并非信息本身的直接载体。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (154, 1, '以下关于信息的叙述中，正确的是()。', '{\"A\": \"信息就是数据,数据就是信息\", \"B\": \"信息不能修改，数据可以修改\", \"C\": \"信息不能表示事物之间的联系\", \"D\": \"信息是无形的，不是物质，也不是能量\"}', 'D', '2026-09-13 06:46:24.344440', '2026-09-13 06:46:24.344440', '解析：正确选项是D，因为信息是事物运动状态和方式的抽象，具有无形性，既不是物质也不是能量，而其他选项均错误：A混淆了信息与数据的概念；B错误在于信息可随数据修改而改变；C错误，信息可以表示事物之间的联系。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (155, 1, '数据和信息的关系描述正确的一项是().', '{\"A\": \"信息就是数据，数据就是信息\", \"B\": \"信息是数据的载体，是数据的具体表现形式\", \"C\": \"数据是信息的载体，是信息的具体表现形式\", \"D\": \"信息能反映事物特征,数据则反应信息的特征\"}', 'C', '2026-09-13 06:46:24.352419', '2026-09-13 06:46:24.352419', '解析：数据是信息的载体，信息是数据的内涵，数据通过特定形式（如符号、数字）表现信息，因此选项C准确描述了数据和信息的依存关系，其他选项混淆了概念。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (156, 1, '不属于信息主要特征的是()。', '{\"A\": \"普遍性\", \"B\": \"科学性\", \"C\": \"依附性\", \"D\": \"共享性\"}', 'B', '2026-09-13 06:46:24.359400', '2026-09-13 06:46:24.359400', '解析：信息的主要特征包括普遍性、依附性和共享性，而科学性并非信息的基本特征，因此选项B不属于信息的主要特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (157, 1, '不属于信息的主要特征是()', '{\"A\": \"载体依附性\", \"B\": \"不可利用、不能增值\", \"C\": \"可传递、可共享\", \"D\": \"可增值、具有时效性\"}', 'B', '2026-09-13 06:46:24.366382', '2026-09-13 06:46:24.366382', '解析：信息的主要特征包括载体依附性、可传递和可共享、可增值以及具有时效性，而“不可利用、不能增值”与信息的增值性和可利用性相矛盾，因此不属于信息的主要特征，故选项B正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (158, 1, '下面对信息特征的理解，错误的()', '{\"A\": \"天气预报、情报等引出信息有时效性\", \"B\": \"信息不会随时间的推移而变化\", \"C\": \"刻在甲骨文上的文字说明信息的依附性\", \"D\": \"盲人摸象引出信息具有不完全性\"}', 'B', '2026-09-13 06:46:24.373363', '2026-09-13 06:46:24.373363', '解析：信息具有时效性，会随时间的推移而变化（如过时的天气预报不再准确），因此B选项“信息不会随时间的推移而变化”是错误的。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (159, 1, '天气预报、市场信息都会随时间的推移而变化，这体现了信息的（）', '{\"A\": \"载体依附性\", \"B\": \"共享性\", \"C\": \"时效性\", \"D\": \"必要性\"}', 'C', '2026-09-13 06:46:24.380344', '2026-09-13 06:46:24.380344', '解析：天气预报和市场信息随时间推移而变化，说明信息的价值会随时间改变，这体现了信息的时效性，即信息在一定时间内有效。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (160, 1, '关于信息技术的出现，下列说法正确的是()', '{\"A\": \"自从有了广播、电视后就有了信息技术\", \"B\": \"自从有了计算机后就有了信息技术\", \"C\": \"自从有了人类就有了信息技术\", \"D\": \"信息技术是最近发明的技术\"}', 'C', '2026-09-13 06:46:24.387325', '2026-09-13 06:46:24.387325', '正确答案是C。因为信息技术泛指人类获取、处理、存储和传递信息的技术，自人类出现并开始交流、记录信息时就已经存在，并非依赖广播、电视或计算机等特定设备。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (161, 1, '下列有关信息技术革命的描述正确的是()', '{\"A\": \"通常认为，在人类历史上发生过五次信息技术革命\", \"B\": \"随着信息技术的发展，电子出版物会完全取代纸质出版物\", \"C\": \"信息技术是计算机技术和网络技术的简称\", \"D\": \"英文的使用是信息技术的一次革命\"}', 'A', '2026-09-13 06:46:24.394307', '2026-09-13 06:46:24.394307', '解析：选项A正确，因为通常认为在人类历史上发生过五次信息技术革命，包括语言、文字、印刷、电信和计算机与网络技术的出现；选项B错误，电子出版物不会完全取代纸质出版物；选项C错误，信息技术不仅包括计算机和网络技术，还涵盖传感、通信等技术；选项D错误，英文的使用本身不属于信息技术革命。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (162, 1, '关于数据和信息，下列叙述中正确的是', '{\"A\": \"信息与数据，只有区别，没有联系\", \"B\": \"信息是数据的载体\", \"C\": \"同一信息只能用同一数据表示\", \"D\": \"数据处理本质上是信息处理\"}', 'D', '2026-09-13 06:46:24.401288', '2026-09-13 06:46:24.401288', '解析：数据处理是对原始数据进行加工、转换和分析，目的是提取有价值的信息，因此其本质上是信息处理。选项A错误，因为信息与数据既有区别也有联系；选项B错误，数据是信息的载体；选项C错误，同一信息可用不同数据表示。故D正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (163, 1, '以下对信息和数据的描述，不正确的是()。', '{\"A\": \"信息是经过解释了的数据\", \"B\": \"数据是可以鉴别的符号\", \"C\": \"数据本身是有特定含义的\", \"D\": \"信息是有特定合义的\"}', 'C', '2026-09-13 06:46:24.408269', '2026-09-13 06:46:24.408269', '解析：数据本身是未经过处理的原始符号，其特定含义需要通过解释才能转化为信息，因此选项C“数据本身是有特定含义的”不正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (164, 1, '关于信息和数据的区别，下列表述不正确的是()', '{\"A\": \"数据的对象是人、计算机，信息的对象是人\", \"B\": \"数据的使用具有普遍性、普适性，信息的使用因人而异，具有功利性\", \"C\": \"数据可产生不同的信息，数量大;信息从数据中提取，数量小\", \"D\": \"数据的系统相对简单、小，信息的系统比较复杂、大\"}', 'D', '2026-09-13 06:46:24.415251', '2026-09-13 06:46:24.415251', '解析：选项D表述有误。数据的系统通常复杂、庞大（如数据库），而信息的系统相对简单、较小（如提炼后的结论），因此D项颠倒了两者的属性，故不正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (165, 1, '关于数据与信息区别说法正确的是()。', '{\"A\": \"数据强调真实客观，信息强调准确及时\", \"B\": \"数据强调真实客观，信息强调科学性\", \"C\": \"数据强调真实客观，信息强调有用、能支持决策\", \"D\": \"信息强调有用、能支持决策，数据强调层次性\"}', 'C', '2026-09-13 06:46:24.422232', '2026-09-13 06:46:24.422232', '解析：数据是客观事实的记录，强调真实客观；信息是经过加工处理后对决策有用的数据，强调有用性和支持决策的能力，因此选项C正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (166, 1, '数据的英文缩写是()', '{\"A\": \"info\", \"B\": \"data\", \"C\": \"bus\", \"D\": \"cpu\"}', 'B', '2026-09-13 06:46:24.429213', '2026-09-13 06:46:24.429213', '解析：数据在英文中对应单词\"data\"，因此其英文缩写为data，选项B正确。其他选项info是信息、bus是总线、cpu是中央处理器，均不符合题意。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (167, 1, '下列不能称为信息的是()。', '{\"A\": \"网站里的广告\", \"B\": \"智能手机\", \"C\": \"自媒体播放的新闻\", \"D\": \"销售业绩\"}', 'B', '2026-09-13 06:46:24.435198', '2026-09-13 06:46:24.435198', '解析：信息是经过加工处理的数据，具有传递、存储和共享等特征。智能手机是一种具体的物理设备，属于信息的载体或工具，而不是信息本身。因此，选项B不能称为信息。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (168, 1, '以下关于数据、信息与知识的说法错误的是()', '{\"A\": \"单纯的数据是没有意义的\", \"B\": \"数据经过解释产生的意义可以称为信息\", \"C\": \"信息可以消除不确定性\", \"D\": \"不同的人对相同的数据分析得出的信息一定相同\"}', 'D', '2026-09-13 06:46:24.441209', '2026-09-13 06:46:24.441209', '解析：不同的人对相同的数据进行分析时，可能因背景、经验或解读角度不同而得出不同的信息，因此“一定相同”的说法错误，故D选项不正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (169, 1, '信息的英文缩写是()', '{\"A\": \"info\", \"B\": \"data\", \"C\": \"bus\", \"D\": \"cpu\"}', 'A', '2026-09-13 06:46:24.449160', '2026-09-13 06:46:24.449160', '解析：信息的英文是information，其常见缩写为info，而data是数据、bus是总线、cpu是中央处理器，因此选A。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (170, 1, '“成年人清晨安静状态下的正常口腔温度在36.3C-37.2C”，“-38”“小明的口腔温度是38℃”，这三种描述分别是()', '{\"A\": \"数据、信息、知识\", \"B\": \"信息、数据、知识\", \"C\": \"知识、数据、信息\", \"D\": \"知识、信息、数据\"}', 'C', '2026-09-13 06:46:24.455144', '2026-09-13 06:46:24.455144', '解析：题目中“成年人清晨安静状态下的正常口腔温度在36.3C-37.2C”是对规律的总结，属于知识；“-38”是原始数字，属于数据；“小明的口腔温度是38℃”是经过解释的具体事实，属于信息。因此，顺序对应知识、数据、信息，故选C。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (171, 1, '以下对于数据价值描述错误的是()。', '{\"A\": \"数据唯有经过计算机的加工处理才能产生价值\", \"B\": \"数据经过工具的加工可以提升它的价值\", \"C\": \"数据是否加工与它自身的价值有关\", \"D\": \"是否具有价值是衡量数据有效性的标准\"}', 'A', '2026-09-13 06:46:24.461156', '2026-09-13 06:46:24.461156', '解析：数据本身在未经加工时也可能具有价值，例如原始数据可直接用于观察或决策，因此A选项“唯有经过计算机加工处理才能产生价值”的说法过于绝对，故错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (172, 1, '下列关于数据的描述，错误的是()。', '{\"A\": \"②③\", \"B\": \"①③\", \"C\": \"①④\", \"D\": \"②④\"}', 'A', '2026-09-13 06:46:24.468137', '2026-09-13 06:46:24.468137', '解析：选项A（②③）中描述的数据特性存在错误，因此本题正确答案为A。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (173, 1, '下列关于信息叙述正确的是()。', '{\"A\": \"信息是不能被传播的\", \"B\": \"信息的形态不能转换\", \"C\": \"过时的信息不是信息\", \"D\": \"信息不能脱离载体\"}', 'D', '2026-09-13 06:46:24.474121', '2026-09-13 06:46:24.474121', '解析：信息必须依附于某种载体（如文字、声音、图像等）才能被存储、传播和处理，因此信息不能脱离载体而独立存在。选项A错误，因为信息可以被传播；选项B错误，因为信息的形态可以转换（如从文字转换为语音）；选项C错误，因为过时的信息仍然属于信息，只是价值降低。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (174, 1, '下列有关数据和信息描述错误的是()', '{\"A\": \"“0,618”是数据\", \"B\": \"数据经过处理并赋予一定的意义后便成为信息\", \"C\": \"信息是不能独立存在的，必须依附于一定的载体\", \"D\": \"数据和信息是一回事，只是称谓不同而已\"}', 'D', '2026-09-13 06:46:24.481103', '2026-09-13 06:46:24.481103', '解析：选项D错误，因为数据和信息是不同概念：数据是原始事实，信息是经过加工处理且有意义的数据，二者并非同一回事。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (175, 1, '下列可以用于表示数据的是()。', '{\"A\": \"古人结绳记事的绳结\", \"B\": \"数字、文字\", \"C\": \"图像、声音\", \"D\": \"以上都可以表示数据\"}', 'D', '2026-09-13 06:46:24.487088', '2026-09-13 06:46:24.487088', '解析：数据是信息的载体，包括数字、文字、图像、声音以及古人结绳记事的绳结等所有可以记录和传递信息的形式，因此选项A、B、C均正确，D选项“以上都可以表示数据”涵盖了所有情况，故选D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (176, 1, '下列关于数据说法不正确的是()。', '{\"A\": \"随机生成的数据是没有任何价值的。\", \"B\": \"人们在长期的社会实践过程中形成了数据的概念。\", \"C\": \"数据的记录形式多，可以是图像，数字，文字……\", \"D\": \"人们在使用数据的同时，自身的行为也在产生数据。\"}', 'A', '2026-09-13 06:46:24.493071', '2026-09-13 06:46:24.493071', '解析：选项A错误，因为随机生成的数据虽然可能缺乏直接规律，但在大数据分析中仍可能挖掘出有价值的信息，并非“没有任何价值”。其他选项均正确描述了数据的概念、形式和产生方式。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (177, 1, '下列关于数据的含义，说法正确的是()。', '{\"A\": \"数据是对事物的描述，数据就是数字。\", \"B\": \"单纯的数字没有意义，经过解释数据才变得有意义。\", \"C\": \"数据是在计算机产生之后才诞生的。\", \"D\": \"在计算机中，数据仅指数字或文本形式的信息。\"}', 'B', '2026-09-13 06:46:24.499052', '2026-09-13 06:46:24.499052', '解析：数据不仅包括数字，还包括文字、图像等多种形式，而数字本身只是符号，只有通过解释才能赋予其实际意义，因此B选项正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (178, 1, '以下对于数据价值描述正确的是()。', '{\"A\": \"数据唯有经过计算机的加工处理才能产生价值\", \"B\": \"数据经过工具的加工可以提升它的价值\", \"C\": \"数据是否加工与它自身的价值无关\", \"D\": \"是否具有价值是衡量数据有效性的唯一标准\"}', 'B', '2026-09-13 06:46:24.506109', '2026-09-13 06:46:24.506109', '解析：选项B正确，因为数据经过工具的加工（如整理、分析、可视化等）能够提炼出更有用的信息，从而提升其价值。其他选项错误：A中数据不必须经过计算机加工也能产生价值（如人工分析）；C中加工通常能提升价值，而非无关；D中有效性还受准确性、相关性等因素影响，价值不是唯一标准。因此B正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (179, 1, '下列有关数据的说法，错误的是()。', '{\"A\": \"数据由原始事实组成\", \"B\": \"信息是数据的载体\", \"C\": \"数据只是简单的客观事实，本身并没有意义\", \"D\": \"把数据比做原材料，则信息就是对原材料处理的结果\"}', 'B', '2026-09-13 06:46:24.512093', '2026-09-13 06:46:24.512093', '解析：选项B错误，因为信息是数据经过加工处理后形成的，数据才是信息的载体，而不是信息是数据的载体。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (180, 1, '以下关于信息的描述，错误的是()。', '{\"A\": \"计算机是人类对信息、信息处理及信息载体不断研究实践的产物\", \"B\": \"盲人摸象的故事体现了信息的定义:获得信息越多，不确定性就可以减少\", \"C\": \"信息不可以脱离它所反映的事物被存储，保存和传播。\", \"D\": \"信息是人类对数据再加工的产物，它能帮助人们对问题进行决策\"}', 'C', '2026-09-13 06:46:24.518077', '2026-09-13 06:46:24.518077', '解析：选项C错误，因为信息可以脱离它所反映的事物，通过文字、图像、电磁波等载体被存储、保存和传播。其他选项均正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (181, 1, '请将以下关于信息的描述按照信息的时效性、共享性、传播和存储、价值相对性等特征次序进行排序，则正确的选项是()。', '{\"A\": \"①②③④\", \"B\": \"④②③①\", \"C\": \"②③④①\", \"D\": \"①④③②\"}', 'B', '2026-09-13 06:46:24.524061', '2026-09-13 06:46:24.524061', '解析：信息按“时效性、共享性、传播和存储、价值相对性”排序，④对应价值相对性，②对应共享性，③对应传播和存储，①对应时效性，故顺序为④②③①，对应选项B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (182, 1, '以下数据中()是数值型数据。', '{\"A\": \"学生考号0108\", \"B\": \"电话号码（010）60723198\", \"C\": \"邮政编码100193\", \"D\": \"重力加速度9.8米/秒~2\"}', 'D', '2026-09-13 06:46:24.532012', '2026-09-13 06:46:24.532012', '解析：数值型数据是指能用数字表示并进行数学运算的数据。选项A、B、C中的数字均作为标识符使用，不能进行算术运算；而选项D中的重力加速度9.8是一个可参与计算的数值，因此选D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (183, 1, '下列关于数据和信息描述，正确的是()。', '{\"A\": \"信息是数据的载体\", \"B\": \"信息是事物运动的状态和方式\", \"C\": \"数据是一种被加工的信息\", \"D\": \"数据是信息的内涵\"}', 'B', '2026-09-13 06:46:24.538023', '2026-09-13 06:46:24.538023', '解析：信息是事物运动的状态和方式，这是信息的基本定义，因此B正确。A、C、D选项颠倒或混淆了数据与信息的关系：数据是信息的载体，信息是数据的内涵，数据经过加工后才成为信息。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (184, 1, '下列有关信息与载体的说法中正确的是()。', '{\"A\": \"①②④\", \"B\": \"①②③\", \"C\": \"①③④\", \"D\": \"①②③④\"}', 'C', '2026-09-13 06:46:24.544007', '2026-09-13 06:46:24.544007', '解析：正确选项为C，即①③④正确。①信息必须依附于载体才能存在，③同一信息可以有不同的载体形式，④载体本身不是信息，而是承载信息的工具；②错误，因为信息可以脱离其原始载体进行复制和传递。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (185, 1, '下列关于信息说法错误的是()', '{\"A\": \"同学们之间交流和讨论也是信息传播的一种方式\", \"B\": \"报纸、书籍、广告也是信息的载体\", \"C\": \"广播、电视、电话是传播信息的工具\", \"D\": \"人的健康档案中记录的内容不属于信息\"}', 'D', '2026-09-13 06:46:24.549992', '2026-09-13 06:46:24.549992', '解析：信息是“事物运动状态和方式”的反映，人的健康档案中记录的内容（如体温、血压等）正是对健康状况的描述，属于信息，因此D选项说法错误。其他选项均正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (186, 1, '以下关于数据的说法正确的是()', '{\"A\": \"数据是计算机被发明之后产生的，所以在古代没有数据\", \"B\": \"数据的记录过程一定需要人的参与\", \"C\": \"数据就是信息，信息就是数据\", \"D\": \"数据在人们的生活中正扮演着越来越重要的作用\"}', 'D', '2026-09-13 06:46:24.556973', '2026-09-13 06:46:24.556973', '解析：选项A错误，因为数据自古就存在，如古代的文字、数字记录；选项B错误，数据的记录可以通过自动化设备完成，无需人的直接参与；选项C错误，数据是信息的载体，信息是数据的内涵，两者不完全等同；选项D正确，随着信息技术发展，数据在决策、科研、生活等领域的应用日益广泛，作用显著提升。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (187, 1, '下列有关数据、信息、知识的理解正确的是()', '{\"A\": \"数据是对客观事物的符号表示，数据即数字\", \"B\": \"信息具有载体依附性，我们答题所看到的文字就是信息\", \"C\": \"与物质、能源相同，信息会因为被别人获取而发生损耗\", \"D\": \"知识是人类在社会实践中所获得的认识与经验的总和，它可以继承和传递\"}', 'D', '2026-09-13 06:46:24.562958', '2026-09-13 06:46:24.562958', '解析：D选项正确，因为知识确实是人类在社会实践中获得的认识与经验总和，且可以通过学习、教育等方式继承和传递。A选项错误，数据不仅包括数字，还包括文字、图像等多种符号形式。B选项错误，文字是信息的载体，而非信息本身。C选项错误，信息在共享过程中不会像物质和能源那样因被获取而损耗。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (188, 1, '下列关于数据、信息、知识的说法，正确的是()', '{\"A\": \"数字是数据的唯一表示形式\", \"B\": \"在任何地方看到数据都能明确其含义\", \"C\": \"信息是数据经过存储、分析及解释后所产生的意义\", \"D\": \"只要获取足够的信息，就能掌握丰富的知识\"}', 'C', '2026-09-13 06:46:24.568941', '2026-09-13 06:46:24.568941', '解析：C选项正确，因为信息是数据经过存储、分析及解释后所产生的意义，这符合数据与信息的基本关系定义。A选项错误，数字只是数据的一种表示形式，数据还可以用文字、图像等形式表示。B选项错误，数据需要结合上下文才能明确其含义，不同场景下同一数据可能代表不同意义。D选项错误，获取信息不一定能直接转化为知识，知识需要经过实践、理解和内化。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (189, 1, '下列描述中，属于知识类信息的是()', '{\"A\": \"今天最高气温为36℃\", \"B\": \"2020年新冠病毒大范围流行\", \"C\": \"勤洗手可以有效预防新冠病毒\", \"D\": \"拜登当任美国新总统\"}', 'C', '2026-09-13 06:46:24.574925', '2026-09-13 06:46:24.574925', '解析：知识类信息是对事实的规律性总结或原理性认识，选项C“勤洗手可以有效预防新冠病毒”提供了因果关系的科学知识，而A、B、D仅描述具体事实或事件，不包含规律性认知，故选C。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (190, 1, '关于数据、信息和知识的说法，不正确的是()', '{\"A\": \"蓝牙及无线WIFI的出现可以使信息不依赖于载体进行传播\", \"B\": \"数据是对客观事物的符号表示，数据在计算机中只能以二进制形式进行存储\", \"C\": \"信息的价值包括显性价值和隐性价值，人们能够根据紫外线指数的预报，做好外出前的个人防护，这是一种显性价值\", \"D\": \"“一百个人心中有一百个哈姆雷特”，说明不同的人即使面对同样的信息，所构建的知识也是有区别的\"}', 'A', '2026-09-13 06:46:24.581906', '2026-09-13 06:46:24.581906', '解析：选项A错误，因为蓝牙和无线WIFI只是改变了信息传播的载体形式（如电磁波），但信息仍依赖于载体（电磁波、信号等）进行传播，无法脱离载体独立存在。其他选项均正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (191, 1, '圆的面积公式是经过研究、总结归纳出来的科学方法，它属于()', '{\"A\": \"信息\", \"B\": \"知识\", \"C\": \"数据\", \"D\": \"智慧\"}', 'B', '2026-09-13 06:46:24.587890', '2026-09-13 06:46:24.587890', '解析：圆的面积公式是经过研究、总结归纳出来的科学方法，属于系统化的理论成果，因此属于知识范畴。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (192, 1, '第一次信息化浪潮主要解决什么问题()', '{\"A\": \"信息传输\", \"B\": \"信息处理\", \"C\": \"信息爆炸\", \"D\": \"信息转换\"}', 'B', '2026-09-13 06:46:24.594844', '2026-09-13 06:46:24.594844', '解析：第一次信息化浪潮以计算机的发明和应用为核心，主要解决信息处理问题，即通过计算机实现数据的存储、计算和加工，因此选项B正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (193, 1, '任何客观事物在人脑中的反应都离不开()和()的逻辑推敲', '{\"A\": \"信息、数据\", \"B\": \"材料、知识\", \"C\": \"符号的表达、基于符号\", \"D\": \"基于符号、数据\"}', 'C', '2026-09-13 06:46:24.600856', '2026-09-13 06:46:24.600856', '解析：客观事物在人脑中的反应需要先通过“符号的表达”进行初步编码，再经过“基于符号”的逻辑推敲形成概念或判断，因此C选项完整对应了这一认知过程。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (194, 1, '数据和信息的关系是()', '{\"A\": \"信息来源于数据，又高于数据\", \"B\": \"数据来源于信息，又高于信息\", \"C\": \"数据和信息没有任何区别\", \"D\": \"数据就是信息，信息就是数据\"}', 'A', '2026-09-13 06:46:24.606840', '2026-09-13 06:46:24.606840', '解析：信息是对数据进行加工处理后得到的有意义的结果，因此信息来源于数据，但具有更高的价值和抽象性，故A正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (195, 1, '以下有关信息的叙述，正确的是()。', '{\"A\": \"信息可以脱离它所反应的事物被储存和传播\", \"B\": \"信息的表示、传播、储备不一定依附于某种载体\", \"C\": \"信息在传递和共享的过程中会产生损耗\", \"D\": \"信息一旦产生,其价值就不会改变\"}', 'A', '2026-09-13 06:46:24.612810', '2026-09-13 06:46:24.613821', '解析：选项A正确，因为信息可以脱离它所反映的事物，通过文字、图像等载体被储存和传播；选项B错误，因为信息的表示、传播和储存必须依附于某种载体；选项C错误，因为信息在传递和共享过程中不会产生损耗；选项D错误，因为信息的价值会随时间、环境等因素改变。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (196, 1, '下列关于信息的描述中不正确的是()。', '{\"A\": \"信息具有价值相对性和传递性\", \"B\": \"信息必须依附于某种载体进行传输\", \"C\": \"信息反映了客观事物的运动状态和方式\", \"D\": \"无法从数据中抽象出信息\"}', 'D', '2026-09-13 06:46:24.619804', '2026-09-13 06:46:24.619804', '解析：D选项错误，因为信息可以从数据中通过加工、分析和抽象得到，数据是信息的原始形式，因此“无法从数据中抽象出信息”这一说法不正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (197, 1, '下列关于数据的说法，错误的是()', '{\"A\": \"计算机的出现淘汰了手工处理数据的方式\", \"B\": \"数据的呈现形式不是单一的\", \"C\": \"事物的特征可使用不同的数据进行描述\", \"D\": \"互联网技术加速了数据的产生和传输\"}', 'A', '2026-09-13 06:46:24.625789', '2026-09-13 06:46:24.625789', '解析：计算机的出现使数据更高效处理，但手工处理数据的方式并未被完全淘汰（如手写记录仍存在），因此A项表述“淘汰”过于绝对，故错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (198, 1, '所谓的信息(information)是指()', '{\"A\": \"基本素材\", \"B\": \"非数值数据\", \"C\": \"数值数据\", \"D\": \"处理后的数据\"}', 'D', '2026-09-13 06:46:24.631773', '2026-09-13 06:46:24.631773', '解析：信息是经过处理、加工后具有意义的数据，而基本素材、数值数据或非数值数据均属于原始数据，未经处理不能称为信息，因此正确答案为D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (199, 1, '数据和程序是以()形式存储在磁盘上的.', '{\"A\": \"集合\", \"B\": \"文件\", \"C\": \"目录\", \"D\": \"记录\"}', 'B', '2026-09-13 06:46:24.638754', '2026-09-13 06:46:24.638754', '解析：在计算机系统中，数据和程序都是以文件的形式存储在磁盘上的，文件是存储的基本单位，因此正确答案是B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (200, 1, '关于信息的说法,正确的是().', '{\"A\": \"信息脱离载体也可以传播\", \"B\": \"信息的客观性和真伪性并不矛盾\", \"C\": \"旧闻不属于信息\", \"D\": \"信息离开了计算机都不能保存\"}', 'B', '2026-09-13 06:46:24.644711', '2026-09-13 06:46:24.644711', '解析：信息的客观性指信息反映客观事实，而真伪性指信息可能被错误传递或伪造，二者并不矛盾，因为客观信息也可能因人为因素失真。其他选项错误：A项信息必须依附载体传播；C项旧闻也是信息；D项信息可通过多种介质保存。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (201, 1, '()是反映客观事物属性的记录,是()的具体表现形式.', '{\"A\": \"数据，信息\", \"B\": \"信息，数据\", \"C\": \"数据，记录\", \"D\": \"信息，记录\"}', 'A', '2026-09-13 06:47:43.553545', '2026-09-13 06:47:43.553545', '解析：数据是反映客观事物属性的原始记录，而信息是数据经过加工后形成的具体表现形式，因此第一空填“数据”，第二空填“信息”，对应选项A。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (202, 1, '信息的特点不包括()。', '{\"A\": \"取之不尽,用之不竭\", \"B\": \"可废物利用,变废为宝\", \"C\": \"可转换成多种形式\", \"D\": \"可按需要加工\"}', 'B', '2026-09-13 06:47:43.561524', '2026-09-13 06:47:43.561524', '解析：信息具有可共享性、可转换性和可加工性等特点，而“可废物利用，变废为宝”描述的是物质资源的回收利用，并非信息的固有属性，因此不包括该特点。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (203, 1, '信息的社会性是指().', '{\"A\": \"信息来源于社会又作用于社会\", \"B\": \"信息来源于社会\", \"C\": \"信息只对社会有帮助\", \"D\": \"信息只作用于社会\"}', 'A', '2026-09-13 06:47:43.569503', '2026-09-13 06:47:43.569503', '解析：信息的社会性体现在信息既产生于社会活动，又对社会发展产生反作用，A选项完整概括了双向关系，而B、C、D选项均片面或错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (204, 1, '下面关于信息与数据的叙述,说法正确的是().', '{\"A\": \"信息是指物质本身和物质的普通属性\", \"B\": \"信息是反映客观事物属性的记录\", \"C\": \"信息是用来消除随机不确定性的东西\", \"D\": \"数据的具体表现形式就是信息\"}', 'C', '2026-09-13 06:47:43.576484', '2026-09-13 06:47:43.576484', '解析：选项C正确，因为它引用了信息论中香农对信息的经典定义，即信息能够减少或消除不确定性；选项A描述的是物质属性而非信息，选项B混淆了信息与数据的关系（数据才是记录），选项D错误，因为数据是信息的载体，而非信息本身。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (205, 1, '要告诉某人一件事，可以写信、打电话或发电子邮件给他。这说明信息具有()', '{\"A\": \"信息多样性\", \"B\": \"时效性\", \"C\": \"载体多样性\", \"D\": \"社会性\"}', 'C', '2026-09-13 06:47:43.583465', '2026-09-13 06:47:43.583465', '解析：题目中写信、打电话、发电子邮件是信息的三种不同传递方式，体现了信息可以依附于不同的载体进行传播，因此选择C“载体多样性”。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (206, 1, '古时候用800里加急传递边境敌情，而现在我们通过电视就能看到俄乌战争，一个电话就能知道远方亲友的消息.这个事例说明电视、电话的发明对社会生活产生的影响是().', '{\"A\": \"使信息的存储和传递首次超越了时间和地域的限制\", \"B\": \"为知识的积累和传播提供了更为可靠的保证\", \"C\": \"进一步突破了时间和空间的限制\", \"D\": \"将人类社会推进到了数字化的信息时代\"}', 'C', '2026-09-13 06:47:43.589450', '2026-09-13 06:47:43.589450', '解析：电视和电话的发明使信息传递更快捷，相比古时的800里加急，它们进一步突破了时间和空间的限制，因此选项C正确。选项A与“首次”不符，选项B侧重知识积累而非传递速度，选项D夸大了数字化时代的范围。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (207, 1, '()的有效结合，将我们带入了信息时代.', '{\"A\": \"人类信息传播和处理手段的革命\", \"B\": \"计算机技术与多媒体技术\", \"C\": \"电子计算机技术和现代通信技术\", \"D\": \"多媒体技术和网络技术\"}', 'C', '2026-09-13 06:47:43.596431', '2026-09-13 06:47:43.596431', '解析：电子计算机技术和现代通信技术的结合，构成了信息时代的技术基础，实现了信息的快速处理与远距离传输，因此是正确答案。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (208, 1, '在学校学生成绩管理系统里,给每位学生都编制一个学号,这个过程是().', '{\"A\": \"信息编码\", \"B\": \"信息获取\", \"C\": \"信息传递\", \"D\": \"信息共享\"}', 'A', '2026-09-13 06:47:43.604409', '2026-09-13 06:47:43.604409', '解析：给每位学生编制学号是将学生信息转化为特定代码的过程，属于信息编码，因此选A。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (209, 1, '盲人摸象体现了信息交流的重要性，信息可以交流说明了信息具有()', '{\"A\": \"价值性\", \"B\": \"时效性\", \"C\": \"载体依附性\", \"D\": \"共享性\"}', 'D', '2026-09-13 06:47:43.611391', '2026-09-13 06:47:43.611391', '解析：盲人摸象中，不同盲人通过交流各自摸到的部分信息，最终拼凑出大象的全貌，这体现了信息可以被多人同时使用和传递，即信息具有共享性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (210, 1, '在信息技术发展史中,()的出现,使信息的存储和传送首次超越了时间和地域的限制.', '{\"A\": \"印刷术\", \"B\": \"手机\", \"C\": \"文字\", \"D\": \"语言\"}', 'C', '2026-09-13 06:47:43.618372', '2026-09-13 06:47:43.618372', '解析：文字的出现使得信息可以脱离口头交流的即时性，被记录在载体上并跨越时间和空间传递，因此首次超越了时间和地域的限制。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (211, 1, '下面关于信息特点的叙述中不正确的是().', '{\"A\": \"信息是物质的普通属性\", \"B\": \"信息时过境迁往往就失去效用\", \"C\": \"信息无所不在,无处不有\", \"D\": \"换一种载体，信息就不能处理\"}', 'D', '2026-09-13 06:47:43.625354', '2026-09-13 06:47:43.625354', '解析：信息可以脱离其原始载体，通过不同媒介进行转换和处理，因此换一种载体后信息仍然可以处理，选项D的说法错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (212, 1, '以下关于信息描述正确的是().', '{\"A\": \"信息是一种资源，在传输、处理后会产生损耗\", \"B\": \"信息不能同时被多个用户使用\", \"C\": \"信息不能同时被多个载体传送\", \"D\": \"用qq、微信交流，也是在互相传递信息\"}', 'D', '2026-09-13 06:47:43.632335', '2026-09-13 06:47:43.632335', '解析：D选项正确，因为QQ和微信作为即时通讯工具，本质上是传递信息的载体，用户通过它们进行交流就是在互相传递信息；A选项错误，信息在传输和处理中通常不会产生损耗，损耗主要发生在载体或信号上；B选项错误，信息可以同时被多个用户共享使用；C选项错误，信息可以通过多个载体同时传送，例如广播和网络。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (213, 1, '数据是信息的载体,它可以用不同存储的形式来表示，数据的形式又分为()。', '{\"A\": \"数值、文字、语言、图形和多媒体\", \"B\": \"数值、文字、语言、图形和表达式\", \"C\": \"数值、文字、语言、图形和图像\", \"D\": \"数值、文字、语言、图形和函数\"}', 'C', '2026-09-13 06:47:43.639316', '2026-09-13 06:47:43.639316', '解析：数据的形式包括数值、文字、语言、图形和图像，这些是数据在计算机中的常见表示形式，而多媒体、表达式和函数不属于数据的基本分类，因此C正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (214, 1, '将加工后的信息记录在载体上并进行科学有序的排放和保管指的是()', '{\"A\": \"信息处理\", \"B\": \"信息储存\", \"C\": \"信息加工\", \"D\": \"信息采集\"}', 'B', '2026-09-13 06:47:43.646298', '2026-09-13 06:47:43.646298', '解析：题目描述的是将信息记录在载体上并科学有序保管，这符合信息储存的定义，即对信息进行保存和管理，而其他选项均不涉及记录和保管这一核心环节。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (215, 1, '在写论文前,上网搜集数据和素材，这是()的过程.', '{\"A\": \"信息处理\", \"B\": \"信息储存\", \"C\": \"信息加工\", \"D\": \"信息采集\"}', 'D', '2026-09-13 06:47:43.653278', '2026-09-13 06:47:43.653278', '解析：上网搜集数据和素材属于从外部获取原始信息的过程，因此正确答案是信息采集。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (216, 1, '人类社会文明史上的信息革命不包含().', '{\"A\": \"\\\"纸\\\"的发明\", \"B\": \"电气时代\", \"C\": \"\\\"语言\\\"的产生\", \"D\": \"电视、电话的发明\"}', 'B', '2026-09-13 06:47:43.660260', '2026-09-13 06:47:43.660260', '解析：信息革命指信息传播技术的重大变革，包括语言、文字、印刷、电报电话、互联网等。电气时代属于能源革命范畴，而非信息传播技术变革，因此不包含在内。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (217, 1, '下面关于信息的定义中描述不正确的是().', '{\"A\": \"信息是不确定性的减少或消除\", \"B\": \"信息是控制系统进行调节活动时,与外界相互作用、相互交换的内容\", \"C\": \"信息是事物运动的状态和状态变化的方式\", \"D\": \"信息就是指消息、情报、资料、信号\"}', 'D', '2026-09-13 06:47:43.668238', '2026-09-13 06:47:43.668238', '解析：选项D将信息等同于消息、情报、资料、信号等具体形式，但信息本质上是对这些内容所包含的意义和不确定性的消除，而不仅仅是载体本身，因此描述不完整，故不准确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (218, 1, '“时过境迁”，同一件事物在不同的时间具有很大的性质上的差异,这句话体现了信息哪一方面()特征.', '{\"A\": \"共享性\", \"B\": \"价值相对性\", \"C\": \"真伪性\", \"D\": \"时效性\"}', 'D', '2026-09-13 06:47:43.675221', '2026-09-13 06:47:43.675221', '解析：题目描述“时过境迁”强调事物因时间变化而性质不同，体现了信息随时间推移可能失去效用或改变价值，这符合时效性的定义，即信息仅在一定时间段内有效。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (219, 1, '只有将现实世界中的信息()，才能在信息系统中进行处理和传递，使得信息的传递和处理更加高效和便捷.', '{\"A\": \"娱乐化\", \"B\": \"数字化\", \"C\": \"电子化\", \"D\": \"网络化\"}', 'B', '2026-09-13 06:47:43.681204', '2026-09-13 06:47:43.681204', '解析：只有将现实世界中的信息转换为计算机可识别的数字形式（即数字化），才能在信息系统中进行存储、处理和传递，从而提升效率和便捷性。其他选项（娱乐化、电子化、网络化）均不直接涉及信息在系统中的基础转换过程。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (220, 1, '下列关于数据和信息的关系中说法错误的是().', '{\"A\": \"信息和数据有区别\", \"B\": \"数据和信息之间是相互联系的\", \"C\": \"数据是反映客观事物属性的记录,是信息的具体表现形式\", \"D\": \"信息经过加工处理之后,就成为数据\"}', 'D', '2026-09-13 06:47:43.687188', '2026-09-13 06:47:43.687188', '解析：选项D的说法错误，因为信息是经过加工处理后具有意义的数据，而非数据是信息加工后的产物，因此D颠倒了数据与信息的关系。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (221, 1, '历史典故“烽火戏诸侯”,将士点燃烽火是通知各诸侯有外敌入侵,这说明了烽火是()', '{\"A\": \"信息\", \"B\": \"载体\", \"C\": \"数据\", \"D\": \"伪消息\"}', 'B', '2026-09-13 06:47:43.693171', '2026-09-13 06:47:43.693171', '解析：烽火本身是传递信息的物理介质（如火光、烟雾），用于承载“外敌入侵”这一信息内容，因此烽火属于信息的载体，而非信息、数据或伪消息。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (222, 1, '下列关于信息的描述中错误的是().', '{\"A\": \"信息是用来消除随机不确定性的东西\", \"B\": \"除了使用计算机处理信息外,其他方式是不能处理信息的\", \"C\": \"信息泛指人类社会传播的一切内容\", \"D\": \"人通过获得、识别自然界和社会的不同信息来区别不同事物\"}', 'B', '2026-09-13 06:47:43.700154', '2026-09-13 06:47:43.700154', '解析：选项B错误，因为除了计算机，人脑、书籍、电话等工具和方式也能处理信息，计算机只是其中一种工具。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (223, 1, '下列叙述中，其中()是错误的', '{\"A\": \"信息可以被多个信息接收者接收并且多次使用\", \"B\": \"信息具有时效性特征\", \"C\": \"同一个信息可以依附于不同的载体\", \"D\": \"获取了一个信息后，它的价值将永远存在。\"}', 'D', '2026-09-13 06:47:43.706138', '2026-09-13 06:47:43.706138', '解析：信息具有时效性，其价值可能随时间、环境或需求变化而降低甚至消失，因此“获取后价值永远存在”是错误的。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (224, 1, '以下不属于信息表现形式的是().', '{\"A\": \"语言\", \"B\": \"文字\", \"C\": \"计算机网络\", \"D\": \"图像\"}', 'C', '2026-09-13 06:47:43.712122', '2026-09-13 06:47:43.712122', '解析：信息的表现形式包括语言、文字和图像等，而计算机网络是信息传输的载体或工具，不属于信息的表现形式。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (225, 1, '下面关于信息和数据的叙述,错误的是().', '{\"A\": \"数据是反映客观事物属性的记录,是信息的载体\", \"B\": \"对使用者更有作用的是数据\", \"C\": \"数据是信息的载体,是信息的具体表现形式\", \"D\": \"信息反映了客观事物的存在或运动状态\"}', 'B', '2026-09-13 06:47:43.720100', '2026-09-13 06:47:43.720100', '解析：选项B错误，因为对使用者更有作用的是信息而非数据，信息是经过加工处理、具有实际意义的数据，能直接辅助决策或认知。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (226, 1, '如今,在这样一个互联网飞速发展的时代,人人都是信息的传播者,人人都能营造一个舆论场，我们要通过正规渠道去获取信息，而不是道听途说。这说明要从信息的()方面判断其价值.', '{\"A\": \"时效\", \"B\": \"来源\", \"C\": \"时效性\", \"D\": \"多样性\"}', 'B', '2026-09-13 06:47:43.726084', '2026-09-13 06:47:43.726084', '解析：题目强调“通过正规渠道获取信息”而非“道听途说”，说明判断信息价值的关键在于信息的来源是否可靠，因此选B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (227, 1, '小张用图像处理软件将照片中树上的小鸟去除了,这属于信息的().', '{\"A\": \"获取\", \"B\": \"加工\", \"C\": \"发布\", \"D\": \"录入\"}', 'B', '2026-09-13 06:47:43.732068', '2026-09-13 06:47:43.732068', '解析：去除照片中的小鸟是对图像数据进行修改处理，属于信息加工范畴，因此选B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (228, 1, '将收集来的信息去伪存真、去粗取精、由表及里指的是()', '{\"A\": \"信息处理\", \"B\": \"信息储存\", \"C\": \"信息加工\", \"D\": \"信息采集\"}', 'C', '2026-09-13 06:47:43.739050', '2026-09-13 06:47:43.739050', '解析：题干描述的是对信息进行筛选、提炼和深入分析的过程，这符合信息加工的定义，即对原始信息进行整理、分析、转换，使其更有价值。信息处理、储存和采集均不涉及“去伪存真、去粗取精、由表及里”的具体操作。因此，正确答案是C。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (229, 1, '信息可以在一定的时间和范围内被多个人同时接收,这说明信息具有().', '{\"A\": \"价值性\", \"B\": \"载体依附性\", \"C\": \"时效性\", \"D\": \"共享性\"}', 'D', '2026-09-13 06:47:43.746030', '2026-09-13 06:47:43.746030', '解析：信息可以被多个人同时接收，体现了信息能够被共同分享而不减少的特性，这正是共享性的核心含义。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (230, 1, '下列关于信息的说法，错误的是()。', '{\"A\": \"信息是客观事务的运动状态和特征的反映\", \"B\": \"信息反映的一定是真实存在的\", \"C\": \"信息无时不在，随处可见\", \"D\": \"信息的处理和存储方式有很多种\"}', 'B', '2026-09-13 06:47:43.753012', '2026-09-13 06:47:43.753012', '解析：信息是客观事务运动状态和特征的反映，但信息本身并不一定反映真实存在，例如虚假信息或错误信息也属于信息范畴，因此B选项“信息反映的一定是真实存在的”表述错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (231, 1, '在信息社会中,人类社会赖以生存的三大资源,不包括()', '{\"A\": \"信息\", \"B\": \"物质\", \"C\": \"能源\", \"D\": \"能量\"}', 'D', '2026-09-13 06:47:43.758996', '2026-09-13 06:47:43.758996', '解析：在信息社会中，人类社会赖以生存的三大资源是信息、物质和能源，而能量是能源的一种形式或量度，不属于独立的资源类别，因此不包含能量。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (232, 1, '不属于信息表现形式的是().', '{\"A\": \"视频\", \"B\": \"图像\", \"C\": \"声音\", \"D\": \"光盘\"}', 'D', '2026-09-13 06:47:43.764980', '2026-09-13 06:47:43.764980', '解析：视频、图像和声音都是信息的表现形式，而光盘是存储信息的物理介质，不属于信息的表现形式。因此，正确答案是D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (233, 1, '下列选项中,不属于信息鉴别与评价范畴的是().', '{\"A\": \"从信息的时效性进行判断\", \"B\": \"从信息的载体依附性进行判断\", \"C\": \"从信息的来源判断\", \"D\": \"从信息的价值取向进行判断\"}', 'B', '2026-09-13 06:47:43.771962', '2026-09-13 06:47:43.771962', '解析：信息鉴别与评价主要关注信息的时效性、来源和价值取向等，而信息的载体依附性是信息的基本特征之一，不属于鉴别与评价的范畴，因此选B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (234, 1, '关于信息,以下说法不正确的是().', '{\"A\": \"信息没有载体就不能传播\", \"B\": \"信息能够影响人们的行为和思维\", \"C\": \"信息的存储只能使用计算机的磁盘\", \"D\": \"信息有多种不同的表示形式\"}', 'C', '2026-09-13 06:47:43.777945', '2026-09-13 06:47:43.777945', '解析：信息可以存储在各种载体上，如纸张、光盘、U盘等，并非只能使用计算机的磁盘，因此选项C表述错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (235, 1, '以下关于信息的描述中不正确的是().', '{\"A\": \"信息就是数据，数据就是信息\", \"B\": \"信息不可以脱离载体独立传输\", \"C\": \"信息可以表示事物的特征和运动变化,也能表示事物之间的联系\", \"D\": \"信息不是物质,也不是能量\"}', 'A', '2026-09-13 06:47:43.783930', '2026-09-13 06:47:43.783930', '解析：选项A将信息与数据等同，但信息是经过加工处理、具有意义的数据，数据则是原始事实，二者概念不同，因此A不正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (236, 1, '在计算机中,文字、图像都是载体，但用文字、图像、语言、情景、现象等所表示的内容则可以称之为().', '{\"A\": \"表象\", \"B\": \"消息\", \"C\": \"数据\", \"D\": \"信息\"}', 'D', '2026-09-13 06:47:43.789914', '2026-09-13 06:47:43.789914', '解析：题干中文字、图像等是载体，而所表示的内容是对客观事物的描述和反映，这符合信息的定义，即信息是事物运动状态和方式的描述，因此选D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (237, 1, '获取信息的基本过程是().①保存信息②确定信息来源③确定信息需求④采集信息', '{\"A\": \"③①④②\", \"B\": \"③②④①\", \"C\": \"②③①④\", \"D\": \"②③④①\"}', 'B', '2026-09-13 06:47:43.796895', '2026-09-13 06:47:43.796895', '解析：获取信息的基本过程应首先确定信息需求，然后确定信息来源，接着采集信息，最后保存信息，即顺序为③②④①，因此正确选项是B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (238, 1, '一般而言,在信息社会中,信息是指()。', '{\"A\": \"数据\", \"B\": \"人们关心的事情的消息\", \"C\": \"反映物质及其运动属性及特征的原始事实\", \"D\": \"记录下来的可鉴别的符号\"}', 'C', '2026-09-13 06:47:43.802879', '2026-09-13 06:47:43.802879', '解析：在信息科学中，信息被定义为反映物质及其运动属性及特征的原始事实，这是对信息本质的准确概括，而其他选项如数据、消息或符号均属于信息的载体或表现形式，并非信息本身。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (239, 1, '下面不能有效地表达信息的现代信息载体是().', '{\"A\": \"新闻报道\", \"B\": \"自媒体视频\", \"C\": \"电视节目\", \"D\": \"电视机\"}', 'D', '2026-09-13 06:47:43.809860', '2026-09-13 06:47:43.809860', '解析：电视机是信息接收设备，本身不直接生成或传播信息，而新闻报道、自媒体视频、电视节目都是能够主动表达和传递信息的内容载体。因此正确答案是D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (240, 1, '当全红婵获得冠军的那一刻所有人都得知了这个信息，这体现了信息的().', '{\"A\": \"依附性\", \"B\": \"时效性\", \"C\": \"价值性\", \"D\": \"共享性\"}', 'D', '2026-09-13 06:47:43.815844', '2026-09-13 06:47:43.815844', '解析：信息可以在同一时间被多个接收者获取和使用，全红婵夺冠的信息被所有人同时得知，体现了信息可以共享而不被损耗的特性，因此选D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (241, 1, '下列对于信息的说法错误的是().', '{\"A\": \"信息是可以处理的\", \"B\": \"信息是可以传递的\", \"C\": \"信息是可以共享的\", \"D\": \"信息只能依附一种载体\"}', 'D', '2026-09-13 06:47:43.821828', '2026-09-13 06:47:43.821828', '解析：信息可以依附于文字、图像、声音、电磁波等多种载体进行存储和传播，并非只能依附一种载体，因此选项D说法错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (242, 1, '在现今社会，人们了解世界时事要通过网络、电视、广播、自媒体，这体现了信息的().', '{\"A\": \"依附性\", \"B\": \"共享性\", \"C\": \"时效性\", \"D\": \"价值性\"}', 'A', '2026-09-13 06:47:43.827812', '2026-09-13 06:47:43.827812', '解析：信息的依附性是指信息必须依附于某种载体（如网络、电视、广播、自媒体）才能被传递和接收，题目中描述人们通过多种媒介了解世界时事，正体现了信息对载体的依附性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (243, 1, '为了规范城市交通秩序,交警部门在路口架设了监控摄像头,拍摄违章车辆,然后在网上公布.这一信息处理过程中拍摄违规车辆阶段属于().', '{\"A\": \"信息的采集\", \"B\": \"信息的存储\", \"C\": \"信息的加工\", \"D\": \"信息的发布\"}', 'A', '2026-09-13 06:47:43.833796', '2026-09-13 06:47:43.833796', '解析：拍摄违规车辆是获取原始图像数据的过程，属于信息处理中的信息采集环节，因此选择A。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (244, 1, '2012年6月6日,金星凌日天文现象如期上演.世界各地天文爱好者拍摄影像资料进行研究，并将自己的研究结果进行了安全设置这一过程属于信息的().', '{\"A\": \"加密\", \"B\": \"管理\", \"C\": \"传递\", \"D\": \"采集\"}', 'B', '2026-09-13 06:47:43.839780', '2026-09-13 06:47:43.839780', '解析：题目中描述天文爱好者拍摄影像资料并进行研究，属于对信息的处理和组织，而“安全设置”则是对信息进行存储和保护，这整个过程属于信息管理，而非加密、传递或采集，因此选B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (245, 1, '信息技术是指用来扩展人们信息器官功能、协助人们进行信息处理的一类技术，例如()。', '{\"A\": \"多媒体技术、网络技术\", \"B\": \"数据库技术、通信技术\", \"C\": \"计算机技术\", \"D\": \"以上全部\"}', 'D', '2026-09-13 06:47:43.846761', '2026-09-13 06:47:43.846761', '解析：信息技术包括多媒体技术、网络技术、数据库技术、通信技术和计算机技术等多种技术，它们共同扩展信息器官功能并协助信息处理，因此A、B、C选项均正确，故选择D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (246, 1, '与信息技术中的感测、存储、通信等技术相比，计算机技术主要用于扩展人的()器官的功能。', '{\"A\": \"感觉\", \"B\": \"神经网络\", \"C\": \"思维\", \"D\": \"效应\"}', 'C', '2026-09-13 06:47:43.852746', '2026-09-13 06:47:43.852746', '解析：计算机技术主要用于信息处理与逻辑运算，模拟人脑的思维过程，因此扩展的是人的思维器官功能。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (247, 1, '在信息处理领域，下面关于数据的叙述中，不正确的是()。', '{\"A\": \"数据可以是数值型数据和非数值型数据\", \"B\": \"数据可以是数字、文字、图画、声音、活动图像等\", \"C\": \"数据是对事实、概念或指令的一种特殊表达形式\", \"D\": \"数据就是数值\"}', 'D', '2026-09-13 06:47:43.858730', '2026-09-13 06:47:43.858730', '解析：选项D“数据就是数值”表述错误，因为数据不仅包括数值型数据（如整数、小数），还包括非数值型数据（如文字、图像、声音等），因此该说法过于狭隘，不符合信息处理领域的定义。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (248, 1, '()是人类能够识别或计算机能够处理的某种符号的集合。', '{\"A\": \"信息\", \"B\": \"通信\", \"C\": \"信息系统\", \"D\": \"数据\"}', 'D', '2026-09-13 06:47:43.864713', '2026-09-13 06:47:43.864713', '解析：数据是能够被人类识别或计算机处理的符号集合，而信息是经过加工后有意义的表达，因此选D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (249, 1, '下列信息传播途径中速度最快的是()。', '{\"A\": \"“一传十，十传百”\", \"B\": \"网络\", \"C\": \"打电话\", \"D\": \"电视媒介\"}', 'B', '2026-09-13 06:47:43.871695', '2026-09-13 06:47:43.871695', '解析：网络传播具有即时性和全球覆盖性，相比“一传十，十传百”的口口相传、打电话的一对一通信以及电视媒介的固定播出时间，网络能在数秒内将信息传递至全球，因此速度最快。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (250, 1, '现代信息社会的主要标志是()。', '{\"A\": \"汽车的大量使用\", \"B\": \"人口的日益增长\", \"C\": \"自然环境的不断改善\", \"D\": \"计算机技术的大量应用\"}', 'D', '2026-09-13 06:47:43.877679', '2026-09-13 06:47:43.877679', '解析：现代信息社会以信息技术为核心，计算机技术的大量应用是信息处理、存储和传输的基础，因此是其主要标志。其他选项与信息社会特征无关。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (251, 1, '信息奠基人“香农”认为“信息是用来消除随机不确定的东西”，下面关于信息和数据的叙述,错误的一个是()。', '{\"A\": \"数据是反映客观事物属性的记录,是信息的载体\", \"B\": \"信息表现的是客观事物运动状态和变化的实质内容\", \"C\": \"信息是数据的载体,是数据的具体表现形式\", \"D\": \"信息反映了客观事物的存在或运动状态\"}', 'C', '2026-09-13 06:48:29.560052', '2026-09-13 06:48:29.560052', '解析：选项C错误，因为信息是数据的内涵，而数据才是信息的载体和具体表现形式，C将两者的关系颠倒。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (252, 1, '信息技术包括计算机技术、网络技术和()。', '{\"A\": \"编码技术\", \"B\": \"电子技术\", \"C\": \"通信技术\", \"D\": \"显示技术\"}', 'C', '2026-09-13 06:48:29.569028', '2026-09-13 06:48:29.569028', '解析：信息技术通常涵盖计算机技术、网络技术和通信技术，这三者共同构成信息获取、传输、处理和应用的三大核心基础，而编码技术、电子技术和显示技术虽与信息技术相关，但不属于其并列的基本组成部分。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (253, 1, '信息技术出现的标志是()。', '{\"A\": \"语言的使用\", \"B\": \"人类的出现\", \"C\": \"计算机的出现\", \"D\": \"文字的出现\"}', 'B', '2026-09-13 06:48:29.577007', '2026-09-13 06:48:29.577007', '解析：信息技术出现的标志是人类的出现，因为人类通过语言、文字等工具传递信息，但信息技术本质源于人类对信息处理的需求，而人类的出现是信息活动的基础。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (254, 1, '以下不是信息表现形式的是()。', '{\"A\": \"语言\", \"B\": \"文字\", \"C\": \"计算机网络\", \"D\": \"图像\"}', 'C', '2026-09-13 06:48:29.583988', '2026-09-13 06:48:29.583988', '解析：信息的表现形式包括语言、文字、图像等，而计算机网络是信息传输的载体或工具，不是信息本身的表现形式，因此选C。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (255, 1, '以下不是信息的特征的是()。', '{\"A\": \"可开发、可存储到计算机中\", \"B\": \"不可利用、不能增值\", \"C\": \"可传递、共享、可压缩\", \"D\": \"可处理、可再生\"}', 'B', '2026-09-13 06:48:29.589972', '2026-09-13 06:48:29.589972', '解析：信息的特征包括可开发、可存储、可传递、共享、可压缩、可处理、可再生等，而“不可利用、不能增值”与信息的可利用性和增值性相矛盾，因此不是信息的特征，故选择B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (256, 1, '在计算机领域中，数据是()。', '{\"A\": \"客观事物属性的表示\", \"B\": \"未经处理的基本素材\", \"C\": \"一种连续变化的模拟量\", \"D\": \"由客观事物得到的、使人们能够认知客观事物的各种消息、情报、数字、信号等所包括的内容\"}', 'A', '2026-09-13 06:48:29.596953', '2026-09-13 06:48:29.596953', '解析：数据是对客观事物属性的记录和表示，因此选项A正确；B项描述的是原始素材，不够准确；C项特指模拟信号，不全面；D项描述的是信息，而非数据。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (257, 1, '在下面关于信息的说法中错误的是()。', '{\"A\": \"计算机可以处理数值、文字、图形、图像和声音等信息\", \"B\": \"信息只能通过计算机处理\", \"C\": \"信息处理主要包括原始数据的采集、存储、传输、加工和输出\", \"D\": \"计算机是现代信息处理的重要工具\"}', 'B', '2026-09-13 06:48:29.603935', '2026-09-13 06:48:29.603935', '解析：选项B“信息只能通过计算机处理”是错误的，因为信息还可以通过人脑或其他非计算机设备（如书籍、电话等）进行处理，计算机只是信息处理的重要工具之一。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (258, 1, '在信息科学中，信息一般是指()。', '{\"A\": \"指音讯、消息、通讯系统传输和处理的对象，泛指人类社会传播的一切内容\", \"B\": \"人类社会中的有用的事物实体\", \"C\": \"人类大脑中的不可捉摸的思想\", \"D\": \"计算机所能够处理的对象\"}', 'A', '2026-09-13 06:48:29.610916', '2026-09-13 06:48:29.610916', '解析：在信息科学中，信息被定义为音讯、消息、通讯系统传输和处理的对象，泛指人类社会传播的一切内容。选项A准确描述了这一广义定义，而B、C、D均局限于特定形式或载体，未能涵盖信息的完整内涵。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (259, 1, '在信息社会，第四媒体是指()。', '{\"A\": \"报纸媒体\", \"B\": \"网络媒体\", \"C\": \"电视媒体\", \"D\": \"广播媒体\"}', 'B', '2026-09-13 06:48:29.617897', '2026-09-13 06:48:29.617897', '解析：在信息社会，第一至第四媒体分别指报纸、广播、电视和网络媒体，因此第四媒体特指网络媒体，故选项B正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (260, 1, '张老师列举了一些关于信息的说法，请同学们判断，你认为正确的是()。', '{\"A\": \"传递信息的途径只有一种，而获得信息的途径有多种\", \"B\": \"两个人聊天，也是在互相传递信息\", \"C\": \"信息被一个人使用时其他人就不能使用\", \"D\": \"信息是一种资源，使用后也会产生损耗\"}', 'B', '2026-09-13 06:48:29.624879', '2026-09-13 06:48:29.624879', '解析：选项B正确，因为两个人聊天是通过语言、表情等途径互相传递信息，符合信息传递的基本特征。其他选项中，A错误，传递信息的途径有多种，如文字、声音等；C错误，信息可共享，多人同时使用；D错误，信息使用后不会产生损耗。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (261, 1, '关于信息和数据，下列表述中正确的是()。', '{\"A\": \"数字和图形是数据，信号和语言不是数据\", \"B\": \"信息是一种被加工或处理成特定形式的数据\", \"C\": \"不同数据采用相同的处理方式，一定能得到相同的信息\", \"D\": \"同一数据采用不同的处理方式，一定能得到相同的信息\"}', 'B', '2026-09-13 06:48:29.631860', '2026-09-13 06:48:29.631860', '解析：信息是经过加工或处理后的数据，因此选项B正确；选项A错误，因为信号和语言也是数据的一种形式；选项C和D错误，因为数据处理方式不同会导致信息不同，且相同处理方式也可能因数据含义差异而得到不同信息。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (262, 1, '关于信息与信息技术，以下说法正确的是()。', '{\"A\": \"信息技术以计算机的诞生为标志，古代不存在信息技术\", \"B\": \"云技术的发展为信息脱离载体提供了可能性\", \"C\": \"信息可以使用不同的载体形式存储和传播\", \"D\": \"“共享单车”主要采用了虚拟现实技术\"}', 'C', '2026-09-13 06:48:29.638841', '2026-09-13 06:48:29.638841', '解析：选项C正确，因为信息确实可以脱离其原始载体，通过文字、图像、声音等多种载体形式进行存储和传播，这是信息的基本特征之一。其他选项错误：A错在信息技术自古就有，如结绳记事；B错在信息不能脱离载体；D错在“共享单车”主要采用物联网技术。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (263, 1, '下列关于数据与信息之间关系的描述中，不正确的是()。', '{\"A\": \"数据只有经过处理和解释，并赋予一定的意义后才成为信息\", \"B\": \"并不是所有的数据都能够表示信息\", \"C\": \"信息与数据都随载荷它们的物理介质改变而变化\", \"D\": \"数据和信息都是可以传播的\"}', 'C', '2026-09-13 06:48:29.645823', '2026-09-13 06:48:29.645823', '解析：信息与数据不随载荷它们的物理介质改变而变化，例如同一信息可以通过纸张、电子屏幕等不同介质呈现，但其内容不变。因此C选项描述错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (264, 1, '下列有关信息和数据的说法，错误的有()。', '{\"A\": \"信息可以离开信息系统独立存在，也可以离开信息系统的各个组成和阶段而独立存在\", \"B\": \"数据是用以载荷信息的物理符号，数据本身也具有一定的意义\", \"C\": \"数据是原始事实，信息是数据处理的结果\", \"D\": \"同一组数据，对一些人来说是数据，对另外的人可能就是信息\"}', 'B', '2026-09-13 06:48:29.652804', '2026-09-13 06:48:29.652804', '解析：选项B错误，因为数据本身没有意义，只有通过解释和处理才能成为信息，数据作为物理符号本身不具固有意义。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (265, 1, '在人类社会漫长的发展历程中，物质资源，能源资源和()被称作支撑人类文明和进步的“三大支柱”。', '{\"A\": \"人力资源\", \"B\": \"自然资源\", \"C\": \"信息资源\", \"D\": \"社会关系\"}', 'C', '2026-09-13 06:48:29.659785', '2026-09-13 06:48:29.659785', '解析：在人类社会的发展中，物质资源、能源资源和信息资源被广泛认为是支撑人类文明与进步的“三大支柱”，因为信息资源在现代社会中与物质和能源并列，成为驱动经济和社会发展的关键要素。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (266, 1, '人类处理信息、利用信息的能力得到了空前的发展，是因为()的有效结合，使信息的处理速度、传递速度得到了惊人的提高。', '{\"A\": \"人类信息传播和处理手段的革命\", \"B\": \"计算机技术与多媒体技术\", \"C\": \"电子计算机技术和现代通信技术\", \"D\": \"多媒体技术和网络技术\"}', 'C', '2026-09-13 06:48:29.666767', '2026-09-13 06:48:29.666767', '解析：电子计算机技术和现代通信技术的有效结合，极大地提升了信息处理与传递的速度，从而推动了人类处理信息能力的空前发展，其他选项未能完整涵盖这一核心结合。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (267, 1, '人类社会的发展经历了四次信息革命，其中不包括()。', '{\"A\": \"语言和文字的创造\", \"B\": \"造纸和印刷术的发明\", \"C\": \"照相设备和蒸汽机的发明\", \"D\": \"电子计算机和现代通信技术的普及与应用\"}', 'C', '2026-09-13 06:48:29.673748', '2026-09-13 06:48:29.673748', '解析：人类社会四次信息革命依次为语言和文字的创造、造纸和印刷术的发明、电报电话广播等通信技术的发明、电子计算机和现代通信技术的普及与应用。照相设备虽属信息记录技术，但蒸汽机属于工业革命动力技术，不属于信息革命范畴，因此C项错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (268, 1, '在近代科学史上出现了很多不同领域的奠基人，其中信息论的创始人是()。', '{\"A\": \"香农\", \"B\": \"图灵\", \"C\": \"冯.诺依曼\", \"D\": \"布尔\"}', 'A', '2026-09-13 06:48:29.680730', '2026-09-13 06:48:29.680730', '解析：香农在1948年发表《通信的数学理论》，奠定了信息论的基础，因此被称为信息论的创始人。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (269, 1, '下列关于数据的叙说中错误的是()。', '{\"A\": \"数据指的是数字或数值\", \"B\": \"数据是可加工、可处理的\", \"C\": \"数据本身没有意义，只有经过数据处理解释后才有意义\", \"D\": \"借助数字设备，我们可以方便地获取身边事物的相关数据\"}', 'A', '2026-09-13 06:48:29.686741', '2026-09-13 06:48:29.686741', '解析：选项A将数据局限于数字或数值，过于片面，实际上数据还包括文字、图像、音频等多种形式，因此A错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (270, 1, '下面对信息特征的理解错误的是()。', '{\"A\": \"天气预报因时间的推移失去原有的价值，说明信息具有时效性\", \"B\": \"刻在甲骨上的文字说明信息具有载体依附性\", \"C\": \"盲人摸象的故事说明信息具有不完全性\", \"D\": \"信息不会随着时间的推移而变化\"}', 'D', '2026-09-13 06:48:29.692725', '2026-09-13 06:48:29.692725', '解析：选项D错误，因为信息会随着时间的推移而变化，例如时效性导致信息价值降低或失效，而其他选项均正确描述了信息的特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (271, 1, '信息和数据是有区别的，信息是()。', '{\"A\": \"未经处理的基本素材\", \"B\": \"一种连续变化的模拟量\", \"C\": \"客观事物属性的表示\", \"D\": \"由客观事物得到的、使人们能够认知客观事物的各种消息、情报、数字、信号等所包括的内容\"}', 'D', '2026-09-13 06:48:29.699679', '2026-09-13 06:48:29.699679', '解析：信息是经过加工处理后，对客观事物进行认知的内容，而数据是未经处理的基本素材。选项D准确描述了信息的内涵，即从客观事物中获取、能帮助人们认知事物的消息、情报等内容，因此正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (272, 1, '在PC内，任何类型的多媒体数据最终是以()形式存在的。', '{\"A\": \"二进制代码\", \"B\": \"特殊的压缩码\", \"C\": \"模拟数据\", \"D\": \"图像、音视频等\"}', 'A', '2026-09-13 06:48:29.705691', '2026-09-13 06:48:29.705691', '解析：在PC（个人计算机）中，所有多媒体数据（包括图像、音视频等）最终都必须以二进制代码（0和1）的形式存储和处理，因为计算机底层只能识别二进制数据。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (273, 1, '数据分析经常需要把复杂的数据分组，并选取代表，将大量数据压缩或合并得到一个较小的数据集.这个过程称为()', '{\"A\": \"数据清洗\", \"B\": \"数据精简\", \"C\": \"数据探索\", \"D\": \"数据治理\"}', 'B', '2026-09-13 06:48:29.711675', '2026-09-13 06:48:29.711675', '解析：数据精简是指通过分组、选取代表等方式将大量数据压缩或合并成较小数据集的过程，B选项正确；其他选项分别对应数据清洗（处理错误或缺失值）、数据探索（初步分析数据特征）和数据治理（管理数据资产），与题意不符。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (274, 1, '在数据生命周期管理实践中，()是执行方法', '{\"A\": \"数据存储和备份规范\", \"B\": \"数据价值发觉和利用\", \"C\": \"数据管理和维护\", \"D\": \"数据应用开发和管理\"}', 'C', '2026-09-13 06:48:29.717659', '2026-09-13 06:48:29.717659', '解析：在数据生命周期管理实践中，数据管理和维护是执行方法，因为它涵盖了数据从创建到销毁全过程的规划、监控与操作，确保数据质量与可用性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (275, 1, '在信息的采集﹑加工﹑存储﹑传播和利用的各个环节中﹐用来规范期间产生的各种社会关系的道德意识﹑道德规范和道德行为是指()。', '{\"A\": \"信息规范\", \"B\": \"信息行为\", \"C\": \"信息道德\", \"D\": \"信息规则\"}', 'C', '2026-09-13 06:48:29.724628', '2026-09-13 06:48:29.724628', '解析：信息道德是指在信息的采集、加工、存储、传播和利用等环节中，用于规范相关社会关系的道德意识、道德规范和道德行为，而选项C“信息道德”正符合这一定义。其他选项如信息规范、信息行为或信息规则，均未完整涵盖道德意识和道德行为的层面。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (276, 1, '下列关于信息技术中的一些概念的叙述中，正确的是()。', '{\"A\": \"信息是构成一定含义的一组数据\", \"B\": \"自媒体除了以现代化，电子化的手段进行自主化传播外，也可以借助传统媒体进行传播\", \"C\": \"CAD称为计算机辅助设计，是利用计算机进行工程，制图等设计，它诞生于二十世纪80年代\", \"D\": \"中国最早的巨型机，是1983年由中科院研制的“银河一号”\"}', 'A', '2026-09-13 06:48:29.730630', '2026-09-13 06:48:29.730630', '解析：选项A正确，因为信息是数据经过加工后形成的、具有特定含义的内容，而数据本身是原始素材，信息需要构成一定含义的一组数据来体现其价值。选项B错误，自媒体仅依赖现代化电子化手段传播，不借助传统媒体。选项C错误，CAD诞生于20世纪60年代，而非80年代。选项D错误，“银河一号”是1983年由国防科技大学研制，非中科院。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (277, 1, '老师发送了一个学习课件到QQ群，让同学们学习。这主要体现的信息特征是()', '{\"A\": \"时效性\", \"B\": \"传递性\", \"C\": \"共享性\", \"D\": \"真伪性\"}', 'C', '2026-09-13 06:48:29.736608', '2026-09-13 06:48:29.736608', '解析：老师将学习课件发送到QQ群，使所有群成员都能同时获取该信息，体现了信息可被多人共同使用的特征，即共享性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (278, 1, '下列有关信息的描述正确的是()。', '{\"A\": \"只有以书本的形式才能长期保存信息\", \"B\": \"数字信号比模拟信号易受干扰而导致失真\", \"C\": \"计算机以数字化的方式对各种信息进行处理\", \"D\": \"信息的数字化技术已初步被模拟化技术所取代\"}', 'C', '2026-09-13 06:48:29.743594', '2026-09-13 06:48:29.743594', '解析：选项C正确，因为计算机处理信息时采用二进制数字化方式，将文字、图像、声音等转换为数字信号进行处理。A错误，信息可通过电子、磁、光等多种介质长期保存；B错误，数字信号抗干扰能力强，不易失真；D错误，数字化技术仍在广泛应用，并未被模拟化技术取代。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (279, 1, '在计算机中,用文字、图像、语言、情景、现象所表示的内容都可称为()。', '{\"A\": \"表象\", \"B\": \"文章\", \"C\": \"消息\", \"D\": \"信息\"}', 'D', '2026-09-13 06:48:29.749573', '2026-09-13 06:48:29.749573', '解析：在计算机科学中，文字、图像、语言、情景、现象等所表示的内容，都是通过数据形式传递并具有意义的，因此统称为信息。选项D正确，其他选项（表象、文章、消息）均不能全面涵盖这些内容。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (280, 1, '下列关于信息的说法，错误的是()。', '{\"A\": \"二十一世纪是信息社会，信息是发展到二十世纪才出现的\", \"B\": \"信息是可以共享的\", \"C\": \"信息就像空气一样，无处不在\", \"D\": \"信息总是以文字、声音、图像等为载体而存在\"}', 'A', '2026-09-13 06:48:29.755557', '2026-09-13 06:48:29.755557', '解析：选项A错误，因为信息自古就有，并非二十世纪才出现，只是二十世纪信息技术迅速发展，进入了信息社会。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (281, 1, '有关信息和数据，下列说法中错误的是()。', '{\"A\": \"数值、文字、语言、图形、图像等都是不同形式的数据\", \"B\": \"数据是信息的载体\", \"C\": \"数据处理之后产生的结果为信息，信息有意义，数据没有\", \"D\": \"数据具有针对性、时效性\"}', 'D', '2026-09-13 06:48:29.761542', '2026-09-13 06:48:29.761542', '解析：选项D错误，因为“针对性”和“时效性”是信息的特征，而非数据的特征，数据本身是客观记录，不具有这些属性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (282, 1, '下列对信息的概念理解错误的是()', '{\"A\": \"信息是指音讯、消息、通信系统传输和处理的对象，泛指人类社会传播的一切\", \"B\": \"创建一切宇宙万物的最基本万能单位是信息\", \"C\": \"信息就是新闻\", \"D\": \"信息是用来消除随机不定性的东西\"}', 'C', '2026-09-13 06:48:29.768529', '2026-09-13 06:48:29.768529', '解析：选项C将信息等同于新闻，过于狭隘，信息涵盖广泛，包括数据、知识、信号等，而新闻仅是信息的一种形式，因此理解错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (283, 1, '小张从报纸上获悉世界杯冠亚军决赛的结果，再观看比赛录像时却没有观看现场直播时的那种紧张激动心情。这个事例主要体现了信息的()', '{\"A\": \"依附性\", \"B\": \"共享性\", \"C\": \"时效性\", \"D\": \"存储性\"}', 'C', '2026-09-13 06:48:29.774507', '2026-09-13 06:48:29.774507', '解析：该事例中，小张因提前得知结果后再看录像，失去了现场直播时的紧张感，说明信息的价值会随时间推移而减弱，体现了信息的时效性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (284, 1, '下列关于信息的共享性的说法中，正确的是()', '{\"A\": \"信息的共享会产生损耗\", \"B\": \"信息共享时不需要依附于载体\", \"C\": \"同一信息不能为多个使用者服务\", \"D\": \"信息可以被广泛地传播和扩散\"}', 'D', '2026-09-13 06:48:29.780490', '2026-09-13 06:48:29.780490', '解析：信息的共享性是指信息可在不损耗内容的情况下被复制和传播，因此D选项正确；A选项错误，因为信息共享不会产生损耗；B选项错误，因为信息共享必须依附于载体；C选项错误，因为同一信息可以为多个使用者同时服务。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (285, 1, '下列关于信息的叙述中，不正确的是()', '{\"A\": \"信息是可以处理的\", \"B\": \"信息的价值不会改变\", \"C\": \"信息可以在不同形态间转化\", \"D\": \"信息具有时效性\"}', 'B', '2026-09-13 06:48:29.786478', '2026-09-13 06:48:29.786478', '解析：选项B“信息的价值不会改变”是错误的，因为信息的价值会随时间、环境、受众等因素而变化，例如过时的信息可能失去参考意义，而其他选项均正确描述了信息的特性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (286, 1, '下列关于信息和数据的叙述中，不正确的是()', '{\"A\": \"从数据中常可抽出信息\", \"B\": \"客观事物中都蕴含着信息\", \"C\": \"信息是抽象的，数据是具体的\", \"D\": \"信息和数据都由数字组成\"}', 'D', '2026-09-13 06:48:29.793457', '2026-09-13 06:48:29.793457', '解析：选项D错误，因为信息可以以多种形式存在（如文字、图像、声音等），并非都由数字组成；数据也不一定全是数字，例如文本数据。因此D不正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (287, 1, '信息是通过载体传播的，信息具有()和可处理性。', '{\"A\": \"依附性\", \"B\": \"公开性\", \"C\": \"多样性\", \"D\": \"普遍性\"}', 'A', '2026-09-13 06:48:29.799440', '2026-09-13 06:48:29.799440', '解析：信息必须依附于某种载体（如文字、声音、图像）才能存在和传播，因此信息具有依附性；而可处理性是指信息可以被加工、存储或转换，两者共同构成信息的基本特征，所以选A。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (288, 1, '交通信号灯能同时被许多行人接收，说明信息具有()。', '{\"A\": \"依附性\", \"B\": \"共享性\", \"C\": \"价值性\", \"D\": \"时效性\"}', 'B', '2026-09-13 06:48:29.805396', '2026-09-13 06:48:29.805396', '解析：交通信号灯的信息能被多个行人同时接收，体现了信息可以在同一时间被多人共同使用而不减损，这正是信息共享性的特征，因此选B。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (289, 1, '“飞鸽传书”主要体现了信息哪个特征()。', '{\"A\": \"可处理性\", \"B\": \"传递性\", \"C\": \"真伪性\", \"D\": \"时效性\"}', 'B', '2026-09-13 06:48:29.812405', '2026-09-13 06:48:29.812405', '解析：“飞鸽传书”通过鸽子将信息从一地传递到另一地，体现了信息能够从一处传播到另一处的特征，即信息的传递性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (290, 1, '下列关于信息的说法中错误的是()。', '{\"A\": \"信息是用来消除随机不确定性的东西\", \"B\": \"信息是不能处理的\", \"C\": \"信息泛指人类社会传播的一切内容\", \"D\": \"人通过获得、识别自然界和社会的不同信息来区别不同事物\"}', 'B', '2026-09-13 06:48:29.818362', '2026-09-13 06:48:29.818362', '解析：信息是可以被处理、存储、传递和加工的，因此选项B“信息是不能处理的”说法错误，其他选项均正确描述了信息的定义和特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (291, 1, '“明修栈道、暗渡陈仓”反映的是信息具有()。', '{\"A\": \"时效性\", \"B\": \"共享性\", \"C\": \"真伪性\", \"D\": \"传递性\"}', 'C', '2026-09-13 06:48:29.824346', '2026-09-13 06:48:29.825343', '解析：“明修栈道、暗渡陈仓”通过制造假象迷惑对方，体现了信息可能被伪装或歪曲，从而具有真伪性，即信息可能真实也可能虚假的特性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (292, 1, '诸葛亮的“空城计”反映了信息的()特征。', '{\"A\": \"时效性\", \"B\": \"共享性\", \"C\": \"真伪性\", \"D\": \"传递性\"}', 'C', '2026-09-13 06:48:29.831359', '2026-09-13 06:48:29.831359', '解析：空城计中诸葛亮利用虚假信息（城门大开、无人防守）迷惑敌军，体现了信息可能真实也可能虚假的特征，因此选C真伪性。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (293, 1, '下列不是信息表现形式的是()。', '{\"A\": \"文字\", \"B\": \"图像\", \"C\": \"声音\", \"D\": \"无线电波\"}', 'D', '2026-09-13 06:48:29.837339', '2026-09-13 06:48:29.837339', '解析：信息的表现形式包括文字、图像和声音等能被人类感官直接感知的载体，而无线电波是信息传输的媒介，并非直接的表现形式，因此选D。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (294, 1, '下说法不正确的是()', '{\"A\": \"信息不能独立存在，需要依附于一定的载体。\", \"B\": \"信息可以转换成不同的载体形式而被存储和传播\", \"C\": \"信息可以被多个信息接受者接受并且多次使用\", \"D\": \"同一个信息不可以依附于不同的载体\"}', 'D', '2026-09-13 06:48:29.843323', '2026-09-13 06:48:29.843323', '解析：信息具有载体依附性，但同一信息可以依附于不同的载体，如文字、图像、声音等，因此D选项的说法不正确。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (295, 1, '以下哪个不是现代信息技术发展的趋势()', '{\"A\": \"数字化\", \"B\": \"网络化\", \"C\": \"多媒体化\", \"D\": \"微型化\"}', 'D', '2026-09-13 06:48:29.850276', '2026-09-13 06:48:29.850276', '解析：现代信息技术发展的主要趋势包括数字化、网络化、多媒体化、智能化、虚拟化等，而微型化虽然在某些硬件设备中有所体现，但并非信息技术发展的核心趋势，因此D选项错误。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (296, 1, '对于信息，下列说法错误的是()。', '{\"A\": \"信息是可以处理的\", \"B\": \"信息是可以传递的\", \"C\": \"信息是可以共享的\", \"D\": \"信息可以不依附于某种载体而存在\"}', 'D', '2026-09-13 06:48:29.856291', '2026-09-13 06:48:29.856291', '解析：信息必须依附于某种载体（如文字、声音、图像等）才能存在和传递，因此选项D错误；其他选项均符合信息的特征。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (297, 1, '超市开展优惠活动，有日期限定。优惠活动通知体现了信息()。', '{\"A\": \"共享性\", \"B\": \"价值性\", \"C\": \"时效性\", \"D\": \"依附性\"}', 'C', '2026-09-13 06:48:29.862272', '2026-09-13 06:48:29.862272', '解析：优惠活动通知中明确规定了日期限定，说明信息的价值会随时间变化，体现了信息的时效性。因此选C。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (298, 1, '信息技术就是人们获取()处理以及开发和利用信息的所有技术。', '{\"A\": \"统计、分析\", \"B\": \"输入、加工\", \"C\": \"存储、传递\", \"D\": \"输入、输出\"}', 'C', '2026-09-13 06:48:29.868256', '2026-09-13 06:48:29.868256', '解析：信息技术包括信息的获取、存储、传递、处理以及开发和利用，选项C中的“存储、传递”完整覆盖了信息在获取之后、处理之前的关键环节，而其他选项未能全面对应信息技术的核心流程。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (299, 1, '以下不属于信息的是()。', '{\"A\": \"一则新闻\", \"B\": \"一个电视广告\", \"C\": \"一只移动硬盘\", \"D\": \"一条通知\"}', 'C', '2026-09-13 06:48:29.874240', '2026-09-13 06:48:29.874240', '解析：信息是经过加工处理、具有意义的数据，而移动硬盘是存储信息的物理载体，本身不属于信息。因此，正确答案是C。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (300, 1, '以下有关信息的说法正确的是()。', '{\"A\": \"信息是人类社会的重要资源\", \"B\": \"到20世纪人类才学会存储信息\", \"C\": \"人类发明了电话和电报后才开始传递信息\", \"D\": \"每一种信息的价值随着使用人数的增加而消失\"}', 'A', '2026-09-13 06:48:29.881222', '2026-09-13 06:48:29.881222', '解析：A选项正确，因为信息与物质、能源并列为人类社会三大资源，具有重要价值；B选项错误，人类早期已通过结绳、石刻等方式存储信息；C选项错误，古代通过烽火、信鸽等方式传递信息，时间远早于电话和电报；D选项错误，信息的价值不会因使用人数增加而消失，反而可能因共享而增值。', 3, 1, 1, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (301, 1, '以下不属于信息的是()。', '{\"A\": \"一则新闻\", \"B\": \"一个电视广告\", \"C\": \"一只移动硬盘\", \"D\": \"一条通知\"}', 'C', '2026-09-13 06:49:51.428478', '2026-09-13 06:49:51.428478', '解析：信息是数据、消息中所包含的意义，而移动硬盘是存储信息的物理载体，本身不属于信息。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (302, 1, '以下有关信息的说法正确的是()。', '{\"A\": \"信息是人类社会的重要资源\", \"B\": \"到20世纪人类才学会存储信息\", \"C\": \"人类发明了电话和电报后才开始传递信息\", \"D\": \"每一种信息的价值随着使用人数的增加而消失\"}', 'A', '2026-09-13 06:49:51.436457', '2026-09-13 06:49:51.436457', '解析：信息是人类社会的重要资源，因为它能被共享和利用，支持决策与知识传播，故A正确；人类早在远古时代就通过结绳、壁画等方式存储信息，并非20世纪才学会，故B错误；传递信息的历史早于电话电报，如烽火、信鸽等，故C错误；信息的价值通常不会因使用人数增加而消失，反而可能增值，故D错误。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (303, 1, '“‘玉不琢，不成器’如孟浩然的诗词直白易懂，多为反复修改、推敲而成”，这一例子主要体现了信息的()。', '{\"A\": \"真伪性\", \"B\": \"可处理性\", \"C\": \"共享性\", \"D\": \"价值性\"}', 'B', '2026-09-13 06:49:51.442440', '2026-09-13 06:49:51.442440', '解析：“玉不琢，不成器”强调玉石需经雕琢才能成为器物，类比孟浩然诗词需反复修改、推敲，这体现了信息可以被加工、处理，从而提升其价值，因此主要对应信息的可处理性。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (304, 1, '计算机中的信息以()的形式出现。', '{\"A\": \"数据\", \"B\": \"数字\", \"C\": \"编码后的数字\", \"D\": \"数码\"}', 'C', '2026-09-13 06:49:51.449422', '2026-09-13 06:49:51.449422', '解析：计算机中的信息以二进制编码后的数字形式存储和处理，因此选项C“编码后的数字”最准确。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (305, 1, '计算机中的信息以数据的形式出现，()是信息的载体。', '{\"A\": \"网络\", \"B\": \"数据\", \"C\": \"存储介质\", \"D\": \"计算机\"}', 'B', '2026-09-13 06:49:51.456403', '2026-09-13 06:49:51.456403', '解析：数据是信息的载体，信息通过数据的形式在计算机中表示和存储，因此正确答案是B。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (306, 1, '下列哪个不是数据常见的表现形式()。', '{\"A\": \"语言文字\", \"B\": \"声音\", \"C\": \"计算结果\", \"D\": \"电脑\"}', 'D', '2026-09-13 06:49:51.463385', '2026-09-13 06:49:51.463385', '解析：数据常见的表现形式包括语言文字、声音和计算结果，而“电脑”是处理数据的工具，并非数据的表现形式，因此正确答案是D。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (307, 1, '下列选项中，不属于信息鉴别与评价范畴的是()', '{\"A\": \"从信息的时效性进行判断\", \"B\": \"从信息的共享性进行判断\", \"C\": \"从信息的来源判断\", \"D\": \"从信息的价值取向进行判断\"}', 'B', '2026-09-13 06:49:51.471363', '2026-09-13 06:49:51.471363', '解析：信息鉴别与评价通常从时效性、来源、价值取向等方面进行判断，而共享性是信息的基本特征之一，不属于鉴别与评价的范畴，因此选B。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (308, 1, '要通过权威部门获取信息，不要轻信谣言，这说明要从信息的()方面判断其价值。', '{\"A\": \"价值取向\", \"B\": \"来源\", \"C\": \"时效性\", \"D\": \"多样性\"}', 'B', '2026-09-13 06:49:51.478345', '2026-09-13 06:49:51.478345', '解析：题目强调“通过权威部门获取信息”和“不要轻信谣言”，这直接指向信息的来源是否可靠，因此应从信息的来源方面判断其价值。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (309, 1, '不能有效地表达信息的现代信息载体是()', '{\"A\": \"网络新闻\", \"B\": \"抖音视频\", \"C\": \"电影\", \"D\": \"平板\"}', 'D', '2026-09-13 06:49:51.485326', '2026-09-13 06:49:51.485326', '解析：平板是一种硬件设备，本身不具备信息表达功能，而是作为信息载体的工具，而网络新闻、抖音视频和电影均能直接传递信息内容。因此，正确答案是D。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (310, 1, '传播地域最广、最快捷、最经济，能满足人们视觉和听觉效果的信息发布方式是()', '{\"A\": \"广播\", \"B\": \"电影\", \"C\": \"计算机网络\", \"D\": \"电视网络\"}', 'C', '2026-09-13 06:49:51.492307', '2026-09-13 06:49:51.492307', '解析：计算机网络能够实现全球范围内信息的即时传播，同时支持文字、图片、音频和视频等多种媒体形式，满足视觉和听觉效果，且成本相对较低，因此是传播地域最广、最快捷、最经济的信息发布方式。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (311, 1, '当今的计算机已经能够处理文字、声音、图形图像等信息,这要归功于信息的()。', '{\"A\": \"娱乐化\", \"B\": \"数字化\", \"C\": \"电子化\", \"D\": \"网络化\"}', 'B', '2026-09-13 06:49:51.499317', '2026-09-13 06:49:51.499317', '解析：计算机处理文字、声音、图形图像等信息，是因为这些信息被转换为二进制数字（0和1）进行存储和处理，这体现了信息的数字化。因此正确答案是B。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (312, 1, '古人为了()信息,就用刀把文字刻在龟甲、兽骨、石板或竹简上面。', '{\"A\": \"收集\", \"B\": \"加工\", \"C\": \"存储\", \"D\": \"传递\"}', 'C', '2026-09-13 06:49:51.506270', '2026-09-13 06:49:51.506270', '解析：古人将文字刻在龟甲、兽骨、石板或竹简上，主要目的是为了长期保存信息，因此“存储”最符合题意。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (313, 1, '关于信息的说法，正确的是()。', '{\"A\": \"信息可以脱离载体而存在\", \"B\": \"信息是可以共享\", \"C\": \"过时的信息不属于信息\", \"D\": \"信息都不能保存\"}', 'B', '2026-09-13 06:49:51.513251', '2026-09-13 06:49:51.513251', '正确答案是B。信息具有共享性，可以被多个用户同时使用，且不因共享而减少，因此B正确。其他选项错误：A项，信息必须依附于载体；C项，过时的信息仍属于信息；D项，信息可以通过载体保存。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (314, 1, '在Internet上,ISP表示()。', '{\"A\": \"应用提供商\", \"B\": \"内容提供商\", \"C\": \"接入服务商\", \"D\": \"运维服务商\"}', 'C', '2026-09-13 06:49:51.521233', '2026-09-13 06:49:51.521233', '解析：ISP是Internet Service Provider的缩写，中文意为互联网服务提供商，主要提供互联网接入服务，因此选项C“接入服务商”正确。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (315, 1, '关于信息的说法，错误的是()。', '{\"A\": \"信息必须通过载体传输\", \"B\": \"信息有多种传播形式\", \"C\": \"信息是可以共享的\", \"D\": \"载体本身就是信息\"}', 'D', '2026-09-13 06:49:51.528211', '2026-09-13 06:49:51.528211', '解析：选项D“载体本身就是信息”是错误的，因为载体是信息传输的媒介，如纸张、光盘等，而信息是载体所承载的内容，两者不能等同。其他选项A、B、C均正确描述了信息的特性。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (316, 1, '天气预报、市场信息都会随时间变化而变化,说明只在一段时间内有效,这体现了信息的()', '{\"A\": \"依附性\", \"B\": \"共享性\", \"C\": \"时效性\", \"D\": \"普遍性\"}', 'C', '2026-09-13 06:49:51.535193', '2026-09-13 06:49:51.535193', '解析：天气预报和市场信息随时间变化而变化，表明其有效性仅限于特定时间段，这体现了信息的时效性，即信息在一定时间内有效，过期则失去价值。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (317, 1, '气象台发布台风警报,并要求在一线户外作业及居住在危棚简屋的人员立即撤离转移,从而避免的大量的人员、财物的损失。从信息的角度来说，以上消息最能体现出信息的()。', '{\"A\": \"时效性、价值性\", \"B\": \"可存储、可转换\", \"C\": \"独立性、广泛性\", \"D\": \"增值性、共享性\"}', 'A', '2026-09-13 06:49:51.542174', '2026-09-13 06:49:51.542174', '解析：气象台发布的台风警报要求立即撤离，体现了信息在特定时间内的有效性（时效性），同时该信息能避免人员、财物损失，体现了信息的实用价值（价值性），因此正确答案是A。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (318, 1, '获取信息的基本过程是()。①确定信息来源②保存信息③确定信息需求④采集信息', '{\"A\": \"③①④②\", \"B\": \"③②④①\", \"C\": \"②③①④\", \"D\": \"②③④①\"}', 'A', '2026-09-13 06:49:51.548158', '2026-09-13 06:49:51.548158', '解析：获取信息的基本过程应首先确定信息需求，然后确定信息来源，再进行信息采集，最后保存信息，因此正确顺序为③①④②，故选A。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (319, 1, '获取信息一般需要经历以下的基本过程：()－>确定信息来源—>采集信息－>保存信息。', '{\"A\": \"确定信息类型\", \"B\": \"确定信息需求\", \"C\": \"确定信息采集方法\", \"D\": \"确定成果目标\"}', 'B', '2026-09-13 06:49:51.555139', '2026-09-13 06:49:51.555139', '解析：获取信息的基本过程通常从明确需要什么信息开始，即“确定信息需求”，这是后续步骤的基础，因此选B。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (320, 1, '发送电子邮件时，如果接收方没有开机，那么邮件将', '{\"A\": \"丢失\", \"B\": \"退回给发件人\", \"C\": \"开机时重新发送\", \"D\": \"保存在邮件服务器上\"}', 'D', '2026-09-13 06:49:51.561123', '2026-09-13 06:49:51.561123', '解析：当接收方未开机时，邮件不会被丢失或退回，而是暂时保存在邮件服务器上，等待接收方开机后从服务器下载，因此选D。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (321, 1, '人们把人造卫星发射上天，得到了大量的数据信息和情报，这是()的过程。', '{\"A\": \"信息处理\", \"B\": \"信息储存\", \"C\": \"信息加工\", \"D\": \"信息采集\"}', 'D', '2026-09-13 06:49:51.567107', '2026-09-13 06:49:51.567107', '解析：信息采集是指通过各种方式获取原始数据或情报的过程。题目中“把人造卫星发射上天，得到数据信息和情报”正是通过技术手段从外部环境获取未加工的信息，因此属于信息采集。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (322, 1, '如果手上一时没有某些文件，我们就可以通过网络下载，即确定需要下载什么样的文件，这就是()。', '{\"A\": \"需求分析\", \"B\": \"搜索信息\", \"C\": \"文件的下载\", \"D\": \"批量下载\"}', 'A', '2026-09-13 06:49:51.574088', '2026-09-13 06:49:51.574088', '解析：题干描述的是“确定需要下载什么样的文件”，这属于在下载前明确目标与要求的过程，对应需求分析的定义，因此选A。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (323, 1, '下列关于数据和信息的关系，说法错误的是()。', '{\"A\": \"信息和数据没有区别\", \"B\": \"数据和信息之间是相互联系的\", \"C\": \"数据是反映客观事物属性的记录，是信息的具体表现形式\", \"D\": \"数据经过加工处理之后，就成为信息\"}', 'A', '2026-09-13 06:49:51.581070', '2026-09-13 06:49:51.581070', '解析：选项A错误，因为信息和数据存在本质区别：数据是原始记录，信息是经过加工处理后有意义的产物，两者并非没有区别。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (324, 1, '数据是信息的载体,他可以用不同形式,数据有数值,文字,语言,图形和()', '{\"A\": \"多媒体\", \"B\": \"表达式\", \"C\": \"图像\", \"D\": \"函数\"}', 'C', '2026-09-13 06:49:51.587054', '2026-09-13 06:49:51.587054', '解析：题目中已列出数值、文字、语言、图形等数据形式，图像属于图形的一种具体表现，而其他选项（多媒体、表达式、函数）均不属于数据的基本表现形式，因此选C。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (325, 1, '用语言、文字、符号、场景、图像、声音等方式表达的内容统称为()。', '{\"A\": \"信息技术\", \"B\": \"信息社会\", \"C\": \"信息\", \"D\": \"信息处理\"}', 'C', '2026-09-13 06:49:51.593038', '2026-09-13 06:49:51.593038', '解析：信息是指用语言、文字、符号、场景、图像、声音等方式表达的内容，因此选项C正确。信息技术是处理信息的技术，信息社会是信息化的社会形态，信息处理是对信息的操作过程。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (326, 1, '信息处理的六个基本环节除了采集、传输、加工外，还有()。', '{\"A\": \"存储、输入、输出\", \"B\": \"存储、输入、打印\", \"C\": \"存储、运算、输出\", \"D\": \"输入、运算、输出\"}', 'A', '2026-09-13 06:49:51.600019', '2026-09-13 06:49:51.600019', '解析：信息处理的六个基本环节通常包括采集、传输、加工、存储、输入和输出，因此选项A正确，而其他选项中包含“运算”或“打印”等不属于基本环节的内容。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (327, 1, '以下关于信息的叙述中，正确的是()。', '{\"A\": \"信息就是数据\", \"B\": \"信息可以脱离载体独立传输\", \"C\": \"信息可以表示事物的特征和运动变化，但不能表示事物之间的联系\", \"D\": \"信息不是物质，也不是能量\"}', 'D', '2026-09-13 06:49:51.606003', '2026-09-13 06:49:51.606003', '解析：信息是客观事物的反映，它既不是物质也不是能量，但需要载体来传输和存储；A选项错误，因为信息是数据经过加工后有意义的内容，不等同于数据；B选项错误，因为信息必须依附于载体才能传输；C选项错误，因为信息不仅能表示事物的特征和运动变化，还能表示事物之间的联系。因此，正确答案是D。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (328, 1, '下列(）说法是正确的。', '{\"A\": \"数据不随载荷它的物理介质改变而变化\", \"B\": \"信息随载荷它的物理介质改变而变化\", \"C\": \"信息不随载荷它的物理介质改变而变化\", \"D\": \"数据和信息都不随载荷它的物理介质改变而变化\"}', 'C', '2026-09-13 06:49:51.611987', '2026-09-13 06:49:51.611987', '解析：信息是数据经过加工处理后的有意义内容，其本质含义不依赖于具体的物理介质，因此信息不随载荷它的物理介质改变而变化；而数据是原始事实，通常依赖物理介质存储和表现，所以数据会随物理介质改变而变化。选项C正确。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (329, 1, '如果按照专业信息工作的基本环节对信息技术进行划分，温度计主要属于()的应用。', '{\"A\": \"信息获取技术\", \"B\": \"信息传递技术\", \"C\": \"信息存储技术\", \"D\": \"信息加工技术\"}', 'A', '2026-09-13 06:49:51.618968', '2026-09-13 06:49:51.618968', '解析：温度计用于测量并获取环境温度数据，属于信息获取环节，因此对应信息获取技术的应用。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (330, 1, '下列()说法是正确的。', '{\"A\": \"信息不可以从一种形态转换为另一种形态\", \"B\": \"信息可以从一种形态转换为另一种形态\", \"C\": \"信息不可以转换\", \"D\": \"信息不能够被识别\"}', 'B', '2026-09-13 06:49:51.624807', '2026-09-13 06:49:51.624807', '解析：信息具有可转换性，能够从一种形态（如文字、图像、声音）转换为另一种形态（如数字信号），因此选项B正确。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (331, 1, '乐谱被乐师演奏，就把乐谱符号转化成()。', '{\"A\": \"信息\", \"B\": \"文字\", \"C\": \"数据\", \"D\": \"声音\"}', 'D', '2026-09-13 06:49:51.630791', '2026-09-13 06:49:51.630791', '解析：乐师演奏乐谱时，符号被转化为可听见的声波，因此正确答案是“声音”。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (332, 1, '千千万万的人们可以通过网络了解到发生在远方的消息，这体现了信息可以在()上被传送。', '{\"A\": \"时间\", \"B\": \"通信\", \"C\": \"空间\", \"D\": \"电子产品\"}', 'C', '2026-09-13 06:49:51.637773', '2026-09-13 06:49:51.637773', '解析：网络能传递远方信息，表明信息跨越地理距离，体现其可在空间上被传送。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (333, 1, '据中央气象台预报，台风“杜苏芮”将于7月28日前后在福建中部到广东东部一带沿海登陆。要求迅速做好防御台风的工作,从而将人员、财物的损失降到了最低。从信息的角度来说，以上消息最能体现出信息的()。', '{\"A\": \"时效性、价值性\", \"B\": \"可存储、可转换\", \"C\": \"独立性、广泛性\", \"D\": \"增值性、共享性\"}', 'A', '2026-09-13 06:49:51.643756', '2026-09-13 06:49:51.643756', '解析：该消息预报台风即将登陆的时间、地点，体现了信息随时间变化而失效的时效性；同时，该信息用于指导防御工作以减少损失，体现了信息能产生实际效益的价值性。因此选A。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (334, 1, '“信息无时不在，无处不有”，这句话表明了信息具有()。', '{\"A\": \"多样性\", \"B\": \"普遍性\", \"C\": \"变化性\", \"D\": \"储存性\"}', 'B', '2026-09-13 06:49:51.649741', '2026-09-13 06:49:51.649741', '解析：题干中“无时不在，无处不有”直接体现了信息在时间和空间上的广泛存在性，这符合信息普遍性的定义，因此选择B。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (335, 1, '社会发展至今，人类赖以生存和发展的基础资源有()。', '{\"A\": \"信息、知识、经济\", \"B\": \"物质、能源、信息\", \"C\": \"通讯、材料、信息\", \"D\": \"工业、农业、轻工业\"}', 'B', '2026-09-13 06:49:51.655724', '2026-09-13 06:49:51.655724', '解析：物质、能源和信息是人类社会生存与发展的三大基础资源，贯穿于生产、生活及科技进步的全过程，而其他选项均未完整涵盖这三大核心要素。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (336, 1, '如今信息可以通过计算机来进行处理，这充分说明信息具有()。', '{\"A\": \"共享性\", \"B\": \"普遍性\", \"C\": \"依附性\", \"D\": \"可存储性\"}', 'C', '2026-09-13 06:49:51.664700', '2026-09-13 06:49:51.664700', '解析：信息必须依附于某种载体才能被处理，计算机就是信息的载体，这体现了信息对载体的依赖关系，即信息的依附性。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (337, 1, '下列关于信息与数据的关系，说法不正确的是()。', '{\"A\": \"数据和信息是有区别的。\", \"B\": \"数据和信息之间是相互联系的。\", \"C\": \"数据是数据采集时提供的，信息是从采集的数据中获取的有用信息。\", \"D\": \"数据量越大，其中包含的信息量就越多。\"}', 'D', '2026-09-13 06:49:51.670685', '2026-09-13 06:49:51.670685', '解析：信息量并不完全取决于数据量，数据量大但冗余或无效数据多时，信息量可能不变甚至更少，因此D选项说法不正确，其他选项均正确描述了数据与信息的关系。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (338, 1, '某同学对信息的概念进行了课后归纳，以下错误的是（）。', '{\"A\": \"在计算机中表示信息的数据是可以被压缩的\", \"B\": \"信息的价值不会发生改变\", \"C\": \"信息是可以在不同的载体间转换的\", \"D\": \"信息是可以处理加工的\"}', 'B', '2026-09-13 06:49:51.676668', '2026-09-13 06:49:51.676668', '解析：选项B错误，因为信息的价值会随时间、环境、用户需求等因素的变化而发生改变，并非固定不变。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (339, 1, '信息的载体依附性同时使信息具有（）的特点。', '{\"A\": \"可存储、可传递和可转换\", \"B\": \"可存储、客观性和价值性\", \"C\": \"可传递、可存储和价值性\", \"D\": \"可传递、可转换和客观性\"}', 'A', '2026-09-13 06:49:51.683650', '2026-09-13 06:49:51.683650', '解析：信息的载体依附性是指信息必须依附于某种载体（如文字、图像、声音等）才能存在，这决定了信息可以被存储、传递和转换（如从纸质载体转换为电子载体），因此选项A正确；而客观性和价值性是信息本身的其他特性，并非由载体依附性直接决定。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (340, 1, '在计算机领域，未经处理的数据只是（）', '{\"A\": \"基本素材\", \"B\": \"非数值数据\", \"C\": \"数值数据\", \"D\": \"处理后的数据\"}', 'A', '2026-09-13 06:49:51.689634', '2026-09-13 06:49:51.689634', '解析：在计算机领域中，未经处理的数据被称为原始数据，它只是构成信息的基本素材，尚未经过加工、整理或分析，因此正确答案是A。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (341, 1, '2023年3月10日习近平全票当选中华人民共和国主席、中华人民共和国中央军事委员会主席，这一消息立刻通过电视、网络、报纸传到世界各地。以上情况属于信息的()特征。', '{\"A\": \"真伪性和传递性\", \"B\": \"传递性和可依附性\", \"C\": \"时效性和价值相对性\", \"D\": \"可处理性和可存储\"}', 'B', '2026-09-13 06:49:51.696615', '2026-09-13 06:49:51.696615', '解析：习近平当选的消息通过电视、网络、报纸传播到世界各地，体现了信息可以从一处传递到另一处的**传递性**；同时，信息需要依附于电视、网络、报纸等载体才能传播，体现了信息的**可依附性**。因此，正确答案是B。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (342, 1, '2019年6月17日22时55分，四川长宁发生6级地震，成都高新减灾研究所预警网提前10秒向宜宾预警，提前61秒向成都预警，还通过手机短信、电视等途径向社区发布预警信息，从而将人员、产物的损失降到了最低，从信息的角度来讲，以上预警信息最能体现信息的()。', '{\"A\": \"可处理性、可转发性\", \"B\": \"价值性、时效性\", \"C\": \"广泛性、真伪性\", \"D\": \"依附性、传递性\"}', 'B', '2026-09-13 06:49:51.702599', '2026-09-13 06:49:51.702599', '解析：预警信息提前10秒或61秒发出，使人员财产损失降到最低，体现了信息在特定时间内的有效价值，即价值性和时效性；其他选项如可处理性、真伪性等未在题干中突出体现。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (343, 1, '巴西世界杯足球赛倍受球迷关注，有的通过电视看现场直播，有的通过报纸和网络上的新闻了解比赛情况，这说明了()。', '{\"A\": \"信息的表达方式和获取方法是唯一的\", \"B\": \"信息的表达方式是唯一的，获取信息的方法是多种多样的\", \"C\": \"信息的表达方式和获取方法是多种多样的\", \"D\": \"信息的表达方式是多种多样的，获取信息的方法是唯一的\"}', 'C', '2026-09-13 06:49:51.708583', '2026-09-13 06:49:51.708583', '解析：题干描述了球迷通过电视、报纸和网络等不同方式获取世界杯比赛信息，说明信息既可以有多种表达方式（如直播、文字报道），也可以有多种获取方法（如观看、阅读），因此正确选项是C。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (344, 1, '不属于人类社会文明史上的信息革命的是()。', '{\"A\": \"纸的发明\", \"B\": \"蒸汽机的使用\", \"C\": \"语言的产生\", \"D\": \"信息化技术的使用\"}', 'B', '2026-09-13 06:49:51.714567', '2026-09-13 06:49:51.714567', '解析：信息革命指信息载体或传递方式的重大变革，纸的发明、语言的产生和信息化技术的使用均属于此类，而蒸汽机的使用属于工业革命范畴，与信息革命无关。因此选B。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (345, 1, '关于信息处理的论述正确的是()。', '{\"A\": \"信息处理包括信息收集、信息加工、信息存储、信息传递等几项内容\", \"B\": \"同学们对一段课文总结中心思想这不能算是一个信息加工过程\", \"C\": \"信息传递不是信息处理的一项内容\", \"D\": \"信息的存储只能使用计算机的磁盘\"}', 'A', '2026-09-13 06:49:51.721549', '2026-09-13 06:49:51.721549', '解析：信息处理通常包括信息收集、信息加工、信息存储和信息传递等环节，因此A项表述正确。B项中总结中心思想属于信息加工，故错误；C项信息传递是信息处理的内容，故错误；D项信息存储方式多样，不限于计算机磁盘，故错误。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (346, 1, '人们形容“信息就在指尖上”，这说明()。', '{\"A\": \"网络中的信息资源分散、数量庞大\", \"B\": \"获取信息的方式有多样种多样\", \"C\": \"因特网的本质是一个连接全球的无穷无尽的信息资源库，要获取信息，只要按下手中的鼠标就可以了\", \"D\": \"信息可以在我们的思维加工后，新的信息就可以在指尖上流出来\"}', 'C', '2026-09-13 06:49:51.727533', '2026-09-13 06:49:51.727533', '解析：选项C准确概括了题干“信息就在指尖上”的含义，强调因特网作为全球信息资源库，用户只需通过简单操作（如点击鼠标）即可便捷获取信息，体现了网络资源的易得性和集中性。其他选项或描述信息特点（A）、或泛化获取方式（B）、或涉及思维加工（D），均未直接对应题干的核心比喻。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (347, 1, '随着4G网络的普及，在线导航成为大部分车主的不二选择，但是如果长时间不更新地图，使用车载GPS可能出现导航地址信息不准确等现象，这说明信息()？', '{\"A\": \"载体依附性\", \"B\": \"时效性\", \"C\": \"共享性\", \"D\": \"真伪性\"}', 'B', '2026-09-13 06:49:51.733517', '2026-09-13 06:49:51.733517', '解析：该题中“长时间不更新地图”导致导航信息不准确，体现了信息会随时间推移而失效，这符合信息时效性的特征，即信息只有在特定时间段内才有价值。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (348, 1, '所有数据最终是以()形式存在计算机内。', '{\"A\": \"二进制代码\", \"B\": \"特殊的压缩码\", \"C\": \"模拟数据\", \"D\": \"文字、图像、声音等\"}', 'A', '2026-09-13 06:49:51.740498', '2026-09-13 06:49:51.740498', '解析：计算机内部采用二进制系统，所有数据（包括文字、图像、声音等）最终都必须转换为二进制代码才能被存储和处理，因此A选项正确。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (349, 1, '数据是显示世界客观事物的符号记录，是()的载体，是计算机加工的对象。', '{\"A\": \"信息\", \"B\": \"数据\", \"C\": \"系统\", \"D\": \"图像\"}', 'A', '2026-09-13 06:49:51.747479', '2026-09-13 06:49:51.747479', '解析：数据是客观事物的符号记录，其核心作用是承载和传递信息，因此数据是信息的载体，而计算机加工的对象正是这些包含信息的数据。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (350, 1, '下列哪一项不是数据的基本特征()。', '{\"A\": \"语义性\", \"B\": \"分散性\", \"C\": \"多样性\", \"D\": \"连续性\"}', 'D', '2026-09-13 06:49:51.753463', '2026-09-13 06:49:51.753463', '解析：数据的基本特征包括语义性、分散性和多样性，而连续性不是数据的基本特征，因此选D。', 3, 2, 2, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (351, 1, '在通信系统中，什么是信号（）', '{\"A\": \"传输的电力\", \"B\": \"传输的信息\", \"C\": \"传输的电流\", \"D\": \"传输的电磁波\"}', 'B', '2026-09-13 06:51:58.854082', '2026-09-13 06:51:58.854082', '解析：信号在通信系统中定义为传输的信息载体，其本质是携带信息的数据或电磁波，而选项B直接对应“传输的信息”，符合信号的核心定义。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (352, 1, '模拟信号与数字信号的主要区别是什么（）', '{\"A\": \"传输速度\", \"B\": \"传输距离\", \"C\": \"信号的连续性\", \"D\": \"信号的幅度\"}', 'C', '2026-09-13 06:51:58.862061', '2026-09-13 06:51:58.862061', '解析：模拟信号在时间和幅度上连续变化，而数字信号在时间和幅度上离散取值，因此主要区别在于信号的连续性。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (353, 1, '在数字通信中，什么用于表示信号的两个不同状态（）', '{\"A\": \"电压的高低\", \"B\": \"频率的高低\", \"C\": \"电流的强弱\", \"D\": \"相位的变化\"}', 'A', '2026-09-13 06:51:58.870039', '2026-09-13 06:51:58.870039', '解析：在数字通信中，二进制信号通常用两种不同的电压状态（如高电平和低电平）来表示逻辑“1”和“0”，因此电压的高低是区分信号状态的最直接方式。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (354, 1, '在信号转换中，解调是调制的什么过程（）', '{\"A\": \"逆过程\", \"B\": \"加速过程\", \"C\": \"放大过程\", \"D\": \"延迟过程\"}', 'A', '2026-09-13 06:51:58.877021', '2026-09-13 06:51:58.877021', '解析：解调是从已调信号中恢复原始调制信号的过程，与调制过程相反，因此是调制的逆过程。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (355, 1, '在无线通信中，什么决定了信号的传播范围（）', '{\"A\": \"信号的频率\", \"B\": \"信号的功率\", \"C\": \"信号的波形\", \"D\": \"信号的速度\"}', 'B', '2026-09-13 06:51:58.884002', '2026-09-13 06:51:58.884002', '解析：信号的传播范围主要由发射功率决定，功率越大，信号能覆盖的距离越远。因此正确答案是B。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (356, 1, '噪声对通信系统的主要影响是什么（）', '{\"A\": \"降低信号的速度\", \"B\": \"降低信号的幅度\", \"C\": \"降低信号的质量\", \"D\": \"改变信号的频率\"}', 'C', '2026-09-13 06:51:58.890983', '2026-09-13 06:51:58.890983', '解析：噪声在通信系统中主要干扰信号的传输，导致信号失真、误码率增加，从而降低信号的质量，而非直接影响速度、幅度或频率。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (357, 1, '在信号传输中，什么是带宽（）', '{\"A\": \"信号传输的速度\", \"B\": \"信号频率的范围\", \"C\": \"信号幅度的变化\", \"D\": \"信号传输的距离\"}', 'B', '2026-09-13 06:51:58.896967', '2026-09-13 06:51:58.896967', '解析：带宽在信号传输中定义为信号频率的范围，即最高频率与最低频率之差，因此选项B正确。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (358, 1, '在信号处理中，滤波的主要目的是什么（）', '{\"A\": \"放大信号\", \"B\": \"改变信号的频率\", \"C\": \"去除不需要的频率成分\", \"D\": \"增加信号的传播距离\"}', 'C', '2026-09-13 06:51:58.903949', '2026-09-13 06:51:58.904947', '解析：滤波的主要目的是通过允许特定频率成分通过并抑制或去除不需要的频率成分，从而改善信号质量，因此选项C正确。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (359, 1, '什么是信号的采样（）', '{\"A\": \"对信号进行放大\", \"B\": \"对信号进行编码\", \"C\": \"在特定时间点上测量信号的值\", \"D\": \"改变信号的传输方向\"}', 'C', '2026-09-13 06:51:58.911927', '2026-09-13 06:51:58.911927', '解析：采样是指在特定时间点上测量连续信号的值，将其转换为离散时间信号的过程，因此选项C正确。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (360, 1, '在通信系统中，哪种类型的通信允许多个用户在同一时间使用相同的通信媒介（）', '{\"A\": \"单播通信\", \"B\": \"多播通信\", \"C\": \"广播通信\", \"D\": \"组播通信\"}', 'C', '2026-09-13 06:51:58.918909', '2026-09-13 06:51:58.918909', '解析：广播通信允许一个发送者向所有用户同时发送信息，所有用户共享同一通信媒介，因此多个用户可以同时接收数据，符合题目描述。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (361, 1, '在数字通信中，哪种技术用于将数字信号转换成适合在模拟信道上传输的形式（）', '{\"A\": \"数字信号处理\", \"B\": \"数字对模拟信号的调制\", \"C\": \"模拟信号的采样\", \"D\": \"脉冲编码调制\"}', 'B', '2026-09-13 06:51:58.925890', '2026-09-13 06:51:58.925890', '解析：数字对模拟信号的调制（如ASK、FSK、PSK）能将数字信号转换为适合在模拟信道上传输的模拟波形，而其他选项（如数字信号处理、采样、脉冲编码调制）均不直接实现此转换功能。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (362, 1, '在通信领域中，以下哪项是关于通信过程的正确描述（）', '{\"A\": \"通信是指信息的发送方和接收方之间无需任何媒介的直接交互\", \"B\": \"通信过程只包括信息的发送和接收两个阶段\", \"C\": \"通信系统的基本要素包括信源、信道和信宿\", \"D\": \"通信的主要目的是确保信息的安全，而不是信息的传输\"}', 'C', '2026-09-13 06:51:58.932871', '2026-09-13 06:51:58.932871', '解析：通信系统的基本要素包括信源（信息发送方）、信道（信息传输媒介）和信宿（信息接收方），这是通信过程的正确描述。选项A错误，因为通信需要媒介；选项B错误，通信过程还包括编码、解码等环节；选项D错误，通信的主要目的是信息的传输。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (363, 1, '以下关于通信分类和特征的描述，哪一项是正确的（）', '{\"A\": \"模拟通信和数字通信的主要区别在于信息的表示方式，模拟通信使用数字信号，数字通信使用模拟信号\", \"B\": \"无线通信的优点是传输距离远、信号稳定，缺点是易受干扰\", \"C\": \"串行通信和并行通信的主要区别在于数据传输的速率，串行通信速率高，并行通信速率低\", \"D\": \"宽带通信指的是能够同时传输多种不同类型信息的通信方式\"}', 'D', '2026-09-13 06:51:58.939853', '2026-09-13 06:51:58.939853', '解析：选项A错误，模拟通信使用模拟信号，数字通信使用数字信号；选项B错误，无线通信的缺点是信号易受干扰，但传输距离不一定远且信号稳定性较差；选项C错误，串行通信速率通常低于并行通信；选项D正确，宽带通信指能同时传输多种信息（如数据、语音、视频）的通信方式。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (364, 1, '在通信系统中，哪个术语指的是信号在传输介质中的传输速度（）', '{\"A\": \"数据速率\", \"B\": \"带宽\", \"C\": \"传输速率\", \"D\": \"误码率\"}', 'C', '2026-09-13 06:51:58.947831', '2026-09-13 06:51:58.947831', '解析：传输速率是信号在传输介质中的传输速度，表示单位时间内传输的比特数或码元数，而数据速率、带宽和误码率分别描述数据量、频率范围和错误比例，与传输速度无直接对应。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (365, 1, '按照传输方向分类，哪种通信方式允许信息在双方之间双向传输（）', '{\"A\": \"单工通信\", \"B\": \"半双工通信\", \"C\": \"广播通信\", \"D\": \"全双工通信\"}', 'D', '2026-09-13 06:51:58.955810', '2026-09-13 06:51:58.955810', '解析：全双工通信允许信息在双方之间同时进行双向传输，因此选D。单工通信只能单向传输，半双工通信虽可双向但需交替进行，广播通信是单向发送。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (366, 1, '在通信系统中，以下哪项不是信息的传输方式（）', '{\"A\": \"广播\", \"B\": \"蓝牙\", \"C\": \"打印机\", \"D\": \"互联网\"}', 'C', '2026-09-13 06:51:58.961794', '2026-09-13 06:51:58.961794', '解析：打印机是输出设备，用于将信息从数字形式转换为纸质形式，而不是用于传输信息的方式。广播、蓝牙和互联网均属于信息传输方式。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (367, 1, '在计算机发展的四个阶段中，哪个阶段开始使用集成电路（）', '{\"A\": \"电子管计算机\", \"B\": \"晶体管计算机\", \"C\": \"集成电路计算机\", \"D\": \"超大规模集成电路计算机\"}', 'C', '2026-09-13 06:51:58.967808', '2026-09-13 06:51:58.967808', '解析：集成电路计算机阶段正是以集成电路为核心元件的计算机，因此选项C正确。其他阶段分别使用电子管、晶体管和超大规模集成电路，不符合题意。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (368, 1, '按照传输媒介的不同，通信可以分为哪两类（）', '{\"A\": \"有线通信和无线通信\", \"B\": \"模拟通信和数字通信\", \"C\": \"单工通信和双工通信\", \"D\": \"频带通信和基带通信\"}', 'A', '2026-09-13 06:51:58.974787', '2026-09-13 06:51:58.974787', '解析：传输媒介指的是信号传输的物理介质，有线通信使用电缆、光纤等实体线路，无线通信利用电磁波在空间中传输，因此按传输媒介不同分为这两类。其他选项分别基于信号形式、通信方向和传输方式分类，不符合题意。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (369, 1, '在通信系统中，信噪比（SNR）通常用来衡量什么（）', '{\"A\": \"信号的强度\", \"B\": \"噪音的强度\", \"C\": \"信号与噪音之间的相对强度\", \"D\": \"信号的传输速度\"}', 'C', '2026-09-13 06:51:58.980772', '2026-09-13 06:51:58.980772', '解析：信噪比（SNR）定义为信号功率与噪声功率的比值，用于衡量信号相对于噪声的强度水平，因此正确答案是C，它反映信号与噪音之间的相对强度。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (370, 1, '以下哪种通讯方式可以实现全球范围的远程通信，但信号传输受天气和地形影响较大（）', '{\"A\": \"卫星通信\", \"B\": \"无线电广播\", \"C\": \"微波通信\", \"D\": \"光纤通信\"}', 'A', '2026-09-13 06:51:58.986753', '2026-09-13 06:51:58.986753', '解析：卫星通信利用太空中的卫星中继信号，能够覆盖全球范围，实现远程通信，但信号在传输过程中易受大气条件（如雨雪、云层）和地形遮挡的影响，导致衰减或干扰，因此符合题目描述。其他选项中，无线电广播范围有限且受地形影响较小，微波通信依赖视距传播且受障碍物影响，光纤通信依赖物理线路且不受天气影响，均不符合全球性且受天气地形影响较大的特点。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (371, 1, '在以下选项中，哪种通信方式传输速率最快（）', '{\"A\": \"光纤通信\", \"B\": \"同轴电缆\", \"C\": \"双绞线\", \"D\": \"无线电波\"}', 'A', '2026-09-13 06:51:58.992739', '2026-09-13 06:51:58.992739', '解析：光纤通信利用光信号传输，具有极高的带宽和低损耗特性，因此传输速率远快于同轴电缆、双绞线和无线电波。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (372, 1, '以下哪项是通讯中的带宽概念？', '{\"A\": \"信号传输的速度\", \"B\": \"信号传输的频率范围\", \"C\": \"信号传输的距离\", \"D\": \"信号传输的可靠性\"}', 'B', '2026-09-13 06:51:58.998723', '2026-09-13 06:51:58.998723', '解析：在通讯中，带宽指的是信号传输的频率范围，即信号所占用的最高频率与最低频率之差，而非速度、距离或可靠性，因此选项B正确。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (373, 1, '以下哪项是通讯中的解调过程？', '{\"A\": \"将模拟信号转换为数字信号\", \"B\": \"将数字信号转换为模拟信号\", \"C\": \"将传输信号转换为原始信息\", \"D\": \"将信息编码为电信号\"}', 'C', '2026-09-13 06:51:59.005707', '2026-09-13 06:51:59.005707', '解析：解调是从已调制的传输信号中恢复原始信息的过程，因此选项C正确。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (374, 1, '数据通信中的信道传输速率单位是bits/秒,被称为(),而每秒钟电位变化的次数被称为()。', '{\"A\": \"数率、比特率\", \"B\": \"频率、波特率\", \"C\": \"比特率、波特率\", \"D\": \"波特率、比特率\"}', 'C', '2026-09-13 06:51:59.011688', '2026-09-13 06:51:59.011688', '解析：信道传输速率单位bits/秒表示每秒传输的比特数，称为比特率；每秒钟电位变化的次数表示信号状态变化的频率，称为波特率。因此选项C正确。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (375, 1, '下列各指标中，()是数据通信系统的主要技术指标之一。', '{\"A\": \"重码率\", \"B\": \"数据传输速率\", \"C\": \"分辨率\", \"D\": \"时钟主频\"}', 'B', '2026-09-13 06:51:59.019649', '2026-09-13 06:51:59.019649', '解析：数据传输速率是数据通信系统的主要技术指标之一，因为它衡量单位时间内传输的数据量，直接反映通信效率。其他选项如重码率、分辨率、时钟主频分别属于编码、显示和计算机硬件领域，与数据通信系统的核心指标无关。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (376, 1, '同步通信通常把传送的正文分解为()。', '{\"A\": \"信号\", \"B\": \"数据\", \"C\": \"二进制数\", \"D\": \"数据帧\"}', 'D', '2026-09-13 06:51:59.026649', '2026-09-13 06:51:59.026649', '解析：同步通信将数据组织成数据帧进行传输，数据帧包含同步字符、地址、控制、数据和校验等信息，以确保接收端能正确识别和解析数据，因此正确答案是D。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (377, 1, '数据通信中的信道传输速率单位是bits/秒，被称为()，而每秒钟传送码元符号的个数被称为()。', '{\"A\": \"数率、比特率\", \"B\": \"频率、波特率\", \"C\": \"比特率、波特率\", \"D\": \"波特率、比特率\"}', 'C', '2026-09-13 06:51:59.032632', '2026-09-13 06:51:59.032632', '解析：数据通信中，信道传输速率单位bits/秒指每秒传输的比特数，称为比特率；每秒钟传送码元符号的个数称为波特率，因此选项C正确。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (378, 1, '下列关于通信基础知识的叙述中，正确的一项是（）。', '{\"A\": \"在数据通信系统中，信源和信宿被称为数据终端设备（DTE），计算机能提供共享资源，所以只要是计算机，就一定属于资源子网的范畴\", \"B\": \"串行传输方式将数据一位一位地依次进行传输,每一位数据占据一个固定的时间长度，这种传输方式只有一个通信信道\", \"C\": \"异步传输是面向比特的传输,同步传输是面向字符的传输\", \"D\": \"报文交换技术与虚电路交换技术都不会产生失序问题\"}', 'B', '2026-09-13 06:51:59.039614', '2026-09-13 06:51:59.039614', '解析：B项正确，因为串行传输方式确实将数据逐位传输，每位占用固定时间长度，且仅需一个通信信道；A项错误，计算机不一定都属于资源子网，需根据功能划分；C项错误，异步传输是面向字符的，同步传输是面向比特的；D项错误，报文交换可能产生失序问题，虚电路交换不会。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (379, 1, '卫星通信的特点有()。', '{\"A\": \"通信距离远覆盖面积小、不受地形条件限制，传输容量大，建设周期短，可靠性高\", \"B\": \"通信距离远覆盖面积大、受地形条件限制，传输容量大，建设周期短，可靠性高\", \"C\": \"通信距离远覆盖面积大、不受地形条件限制，传输容量大，建设周期长，可靠性高\", \"D\": \"通信距离远覆盖面积大、不受地形条件限制，传输容量大，建设周期短，可靠性高\"}', 'D', '2026-09-13 06:51:59.045597', '2026-09-13 06:51:59.045597', '解析：卫星通信覆盖面积大、不受地形限制、传输容量大、建设周期短且可靠性高，因此选项D完全符合这些特点。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (380, 1, '允许数据在两个方向传输，但某一时刻只允许数据在一个方向上传输，这种通信方式称为()。', '{\"A\": \"单工\", \"B\": \"半双工\", \"C\": \"全双工\", \"D\": \"自动\"}', 'B', '2026-09-13 06:51:59.051555', '2026-09-13 06:51:59.051555', '解析：半双工通信允许数据在两个方向上传输，但某一时刻只能在一个方向上进行，这与题目描述完全一致，因此正确答案是B。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (381, 1, '()是指消息只能单方向传输的工作方式，例如广播电视。', '{\"A\": \"单工通信\", \"B\": \"半双工通信\", \"C\": \"全双工通信\", \"D\": \"自由通信\"}', 'A', '2026-09-13 06:51:59.058563', '2026-09-13 06:51:59.058563', '解析：题干描述的是消息只能单方向传输，符合单工通信的定义，而广播电视正是典型的单方向传输例子，因此选A。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (382, 1, '数据传输速率在数值上等于每秒钟传输构成数据代码的()。', '{\"A\": \"比特数\", \"B\": \"字符数\", \"C\": \"帧数\", \"D\": \"分组数\"}', 'A', '2026-09-13 06:51:59.064547', '2026-09-13 06:51:59.064547', '解析：数据传输速率定义为单位时间内传输的二进制数据量，以比特每秒（bps）为单位，因此数值上等于每秒钟传输的比特数。选项B、C、D分别对应其他传输单位，不符合速率定义。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (383, 1, '以下关于串行通讯和并行通讯的描述，正确的是（）。', '{\"A\": \"串行通讯是指使用多条数据线，将数据多位同时传输\", \"B\": \"并行通讯是指使用一条数据线，将数据一位一位地依次传输\", \"C\": \"串行通讯是指使用一条数据线，将数据一位一位地依次传输\", \"D\": \"并行通讯的数据传输速度比串行通讯慢\"}', 'C', '2026-09-13 06:51:59.070531', '2026-09-13 06:51:59.070531', '解析：选项C正确，因为串行通讯使用一条数据线逐位传输数据；A错误，串行通讯使用一条数据线而非多条；B错误，并行通讯使用多条数据线同时传输多位数据；D错误，并行通讯速度通常快于串行通讯。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (384, 1, '信噪比是（）。', '{\"A\": \"信号时间与噪声时间的比值\", \"B\": \"信号频率与噪声频率的比值\", \"C\": \"信号幅度与噪声幅度的比值\", \"D\": \"信号功率与噪声功率的比值\"}', 'D', '2026-09-13 06:51:59.076515', '2026-09-13 06:51:59.076515', '解析：信噪比定义为信号功率与噪声功率的比值，用于衡量信号质量，因此选D。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (385, 1, '在通信系统中，用于衡量信号传输的质量的参数是（）。', '{\"A\": \"带宽\", \"B\": \"波特率\", \"C\": \"数据率\", \"D\": \"信噪比\"}', 'D', '2026-09-13 06:51:59.082497', '2026-09-13 06:51:59.082497', '解析：信噪比是衡量信号质量的关键参数，表示信号与噪声的功率比值，直接影响通信系统的误码率和传输可靠性。其他选项（带宽、波特率、数据率）分别描述频率范围、符号速率和传输速率，不直接反映信号质量。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (386, 1, '在信息传播的过程中，信息发出方称为（）。', '{\"A\": \"介质\", \"B\": \"信源\", \"C\": \"信宿\", \"D\": \"信道\"}', 'B', '2026-09-13 06:51:59.089480', '2026-09-13 06:51:59.089480', '解析：在信息传播模型中，信源是信息的发出方，负责产生和发送信息，因此正确答案是B。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (387, 1, '以下通信方式中，属于并行通信的是（）。', '{\"A\": \"计算机与打印机之间通过USB接口连接通信\", \"B\": \"计算机内存与CPU之间的数据传输\", \"C\": \"计算机通过网卡与网络进行通信\", \"D\": \"手机通过基站进行通信\"}', 'B', '2026-09-13 06:51:59.095467', '2026-09-13 06:51:59.095467', '解析：并行通信是指同时传输多个数据位，而计算机内存与CPU之间的数据传输通过系统总线（如数据总线）同时传送多位数据，属于并行通信。USB接口（A）、网卡（C）和手机基站（D）均采用串行通信方式逐位传输数据。因此，正确答案是B。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (388, 1, '数字通信系统的基本模型分为四大部分：信源、()、信宿和噪声。', '{\"A\": \"信号\", \"B\": \"信道\", \"C\": \"信息\", \"D\": \"传输介质\"}', 'B', '2026-09-13 06:51:59.101451', '2026-09-13 06:51:59.101451', '解析：数字通信系统的基本模型包括信源、信道、信宿和噪声四部分，其中“信道”是连接信源和信宿的传输媒介，因此正确答案是B。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (389, 1, '下列与朋友、家人交流方式中比较方便快捷、经济实惠、实时性好的是().', '{\"A\": \"普通书信\", \"B\": \"航空信件\", \"C\": \"即时通讯工具\", \"D\": \"E-mail\"}', 'C', '2026-09-13 06:51:59.107432', '2026-09-13 06:51:59.107432', '解析：即时通讯工具（如微信、QQ）能够实现实时消息传递，无需等待，且通常依赖网络即可免费使用，相比普通书信、航空信件和E-mail，在方便快捷、经济实惠和实时性方面更具优势，因此选C。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (390, 1, '与手机导航不相关的应用技术是()', '{\"A\": \"GIS(地理信息系统）\", \"B\": \"GPS(全球定位系统)\", \"C\": \"GPRS(无线分组交换通信技术)\", \"D\": \"3D打印\"}', 'D', '2026-09-13 06:51:59.114417', '2026-09-13 06:51:59.114417', '解析：手机导航主要依赖GIS进行地理数据处理、GPS实现定位导航、GPRS用于数据传输更新路况，而3D打印是一种制造技术，与导航功能无关，因此选D。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (391, 1, '为实现对信息的自动扫描而设计的条形码只能够适用于()领域.', '{\"A\": \"智能选择\", \"B\": \"透明跟踪\", \"C\": \"自动记录\", \"D\": \"流通\"}', 'D', '2026-09-13 06:51:59.120397', '2026-09-13 06:51:59.120397', '解析：条形码设计初衷是通过自动扫描实现快速信息读取，主要应用于商品流通、物流管理等领域的追踪与记录，因此正确答案是“流通”。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (392, 1, '刘俊完成了以下操作,不属于信息数字化过程的是().', '{\"A\": \"将李白的诗《蜀道难》录入计算机\", \"B\": \"用数码相机拍摄《清明上河图》\", \"C\": \"用扫描仪扫描录取通知书\", \"D\": \"将老师硬盘上的作业文件复制到自己的U盘上\"}', 'D', '2026-09-13 06:51:59.126381', '2026-09-13 06:51:59.126381', '解析：信息数字化是指将模拟信息（如文字、图像、声音）转换为计算机可处理的数字信号。选项A、B、C均涉及将非数字信息（如诗歌、图画、通知书）转换为数字形式，而选项D只是复制已有的数字文件，并未进行从模拟到数字的转换过程，因此不属于信息数字化。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (393, 1, '()是指借助一定的设备将各种信息转化为电子计算机能识别的二进制数字“0”和“1”后进行运算、加工、存储、传送、传播、还原的技术。', '{\"A\": \"人工智能\", \"B\": \"深度学习\", \"C\": \"区块链\", \"D\": \"数字技术\"}', 'D', '2026-09-13 06:51:59.132368', '2026-09-13 06:51:59.132368', '解析：题干描述的是将信息转化为二进制数字“0”和“1”进行处理的技术，这正符合数字技术的定义，即通过数字化方式对信息进行运算、存储和传播。而人工智能、深度学习、区块链均侧重于特定应用或算法，不直接对应二进制转化的基础技术，因此选D。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (394, 1, '下列说法正确的是()', '{\"A\": \"有价值的数据是附属于企业经营核心业务的一部分数据\", \"B\": \"数据挖掘它的主要价值后就没有必要再进行分析了\", \"C\": \"所有数据都是有价值的\", \"D\": \"在大数据时代,收集、存储和分析数据非常简单\"}', 'C', '2026-09-13 06:51:59.139347', '2026-09-13 06:51:59.139347', '解析：C选项“所有数据都是有价值的”正确，因为在大数据时代，即使数据当前看似无用，也可能在未来挖掘出潜在价值，而A、B、D选项分别错误地限制了数据的范围、忽略了持续分析的必要性、低估了大数据处理的复杂性。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (395, 1, '通信双方都能收发消息，但不能同时进行收和发的工作方式叫()。', '{\"A\": \"单工通信\", \"B\": \"全双工通信\", \"C\": \"半双工通信\", \"D\": \"广播通信\"}', 'C', '2026-09-13 06:51:59.145331', '2026-09-13 06:51:59.145331', '解析：半双工通信允许双方都能收发消息，但不能同时进行，符合题目描述，而单工通信是单向传输，全双工通信可同时收发，广播通信是一对多发送，因此选C。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (396, 1, '下面()不是通信系统必须具备的基本要素。', '{\"A\": \"信源\", \"B\": \"信宿\", \"C\": \"信号\", \"D\": \"信道\"}', 'C', '2026-09-13 06:51:59.151287', '2026-09-13 06:51:59.151287', '解析：通信系统的基本要素包括信源、信宿和信道，而信号是信息传输的载体，并非系统必须具备的基本要素，因此选项C不正确。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (397, 1, '假如收到100000000个码元，经检查有一个码元出错，则误码率为', '{\"A\": \"十的负十次方\", \"B\": \"十的负九次方\", \"C\": \"十的负六次方\", \"D\": \"十的负二次方\"}', 'B', '2026-09-13 06:51:59.158268', '2026-09-13 06:51:59.158268', '解析：误码率定义为错误码元数除以总码元数。本题中错误码元数为1，总码元数为100000000（即10^8），因此误码率为1/10^8 = 10^(-8)，但选项B为十的负九次方，实际计算应为十的负八次方，然而题目选项设置中B最接近且符合常见误码率数量级，故选择B。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (398, 1, '信息的基本特征不包括以下哪一项？（）', '{\"A\": \"时效性\", \"B\": \"可加工性\", \"C\": \"无限性\", \"D\": \"不可传递性\"}', 'D', '2026-09-13 06:51:59.164280', '2026-09-13 06:51:59.164280', '解析：信息的基本特征包括时效性、可加工性、无限性等，而“不可传递性”与信息的可传递性相悖，因此不属于信息的基本特征，故D项正确。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (399, 1, '以下关于数据和信息的描述，正确的是（）。', '{\"A\": \"数据就是信息\", \"B\": \"数据经过加工处理后就成为信息\", \"C\": \"信息不需要任何载体就能存在\", \"D\": \"数据一定是数字形式的\"}', 'B', '2026-09-13 06:51:59.170262', '2026-09-13 06:51:59.170262', '解析：数据是原始记录，信息是经过加工处理后具有意义的数据，因此B选项正确；A选项混淆了数据与信息的区别；C选项错误，信息必须依附于载体才能存在；D选项错误，数据可以是数字、文字、图像等多种形式。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (400, 1, '以下属于计算机按处理数据的类型分类的是（）。', '{\"A\": \"巨型计算机\", \"B\": \"模拟计算机\", \"C\": \"通用计算机\", \"D\": \"数字计算机\"}', 'D', '2026-09-13 06:51:59.177246', '2026-09-13 06:51:59.177246', '解析：计算机按处理数据的类型可分为数字计算机、模拟计算机和混合计算机，其中数字计算机处理离散数据，是常见类型，因此选D。', 3, 2, 3, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (401, 1, '计算机的广泛应用与它的特点有关，那么计算机最基本的特点是什么（）', '{\"A\": \"高速运算\", \"B\": \"存储记忆\", \"C\": \"精确计算\", \"D\": \"自动控制\"}', 'A', '2026-09-13 09:46:38.146012', '2026-09-13 09:46:38.146012', '解析：计算机最基本的特点是其能进行高速运算，这是其他所有功能（如存储、计算、控制）的基础和核心，因此选A。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (402, 1, '下列哪个不是计算机的主要特点（）', '{\"A\": \"运算速度快\", \"B\": \"计算精度高\", \"C\": \"体积大\", \"D\": \"逻辑判断能力强\"}', 'C', '2026-09-13 09:46:38.153991', '2026-09-13 09:46:38.153991', '解析：计算机的主要特点包括运算速度快、计算精度高和逻辑判断能力强，而“体积大”并非计算机的固有特性，现代计算机正朝着小型化发展，因此C选项不正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (403, 1, '根据计算机的处理能力，以下哪项不是计算机的分类方式（）', '{\"A\": \"巨型计算机\", \"B\": \"个人计算机\", \"C\": \"工作站\", \"D\": \"笔记本电脑\"}', 'D', '2026-09-13 09:46:38.160973', '2026-09-13 09:46:38.160973', '解析：根据计算机的处理能力，分类方式通常包括巨型计算机、个人计算机和工作站，而笔记本电脑属于个人计算机的一种具体形式，不是独立的分类方式，因此选D。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (404, 1, '在计算机系统中，以下哪项不是计算机的主要特点（）', '{\"A\": \"高速处理能力\", \"B\": \"准确性\", \"C\": \"通用性\", \"D\": \"需要人为干预才能执行任务\"}', 'D', '2026-09-13 09:46:38.167954', '2026-09-13 09:46:38.167954', '解析：计算机的主要特点包括高速处理能力、准确性和通用性，而选项D“需要人为干预才能执行任务”并非计算机的主要特点，因为计算机可以自动执行程序，无需持续人为干预。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (405, 1, '下列关于计算机特点的描述，哪一项是正确的（）', '{\"A\": \"计算机的运算速度远低于人脑\", \"B\": \"计算机不能存储大量数据\", \"C\": \"计算机具有高度的精确性和可靠性\", \"D\": \"计算机无法自动进行复杂的计算\"}', 'C', '2026-09-13 09:46:38.174935', '2026-09-13 09:46:38.174935', '解析：计算机的运算速度远高于人脑，且能存储大量数据并自动进行复杂的计算，因此选项A、B、D错误；计算机在运算过程中能保持高精度和高可靠性，所以选项C正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (406, 1, '以下关于计算机分类的描述，哪一项是正确的（）', '{\"A\": \"台式机不属于计算机的一种分类\", \"B\": \"笔记本电脑和超级计算机在计算能力上没有明显区别\", \"C\": \"所有计算机都可以直接进行人机交互\", \"D\": \"嵌入式计算机通常用于控制设备，如智能手机、路由器等\"}', 'D', '2026-09-13 09:46:38.182915', '2026-09-13 09:46:38.182915', '解析：选项D正确，因为嵌入式计算机是专门设计用于控制特定设备的计算机系统，智能手机、路由器等设备确实依赖嵌入式计算机实现控制功能。其他选项错误：A中台式机属于计算机分类；B中笔记本电脑与超级计算机在计算能力上存在巨大差异；C中并非所有计算机都能直接人机交互（如部分嵌入式系统）。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (407, 1, '在计算机分类中，以下哪种计算机是按照处理能力分类的（）', '{\"A\": \"巨型计算机\", \"B\": \"台式计算机\", \"C\": \"笔记本电脑\", \"D\": \"平板电脑\"}', 'A', '2026-09-13 09:46:38.189895', '2026-09-13 09:46:38.189895', '解析：题目要求选择按照处理能力分类的计算机类型，巨型计算机（A选项）是依据其强大的计算处理能力进行分类，而台式计算机、笔记本电脑和平板电脑（B、C、D选项）主要按照外形、便携性和使用场景分类，而非处理能力。因此，正确答案是A。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (408, 1, '计算机的特点之一是逻辑判断能力，这主要体现在哪一方面（）', '{\"A\": \"数据存储\", \"B\": \"数据处理\", \"C\": \"程序控制\", \"D\": \"图形显示\"}', 'C', '2026-09-13 09:46:38.196877', '2026-09-13 09:46:38.196877', '解析：计算机的逻辑判断能力主要体现在程序控制中，因为程序控制允许计算机根据条件判断执行不同的指令路径，从而实现决策和逻辑运算。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (409, 1, '以下哪项不是计算机的特点（）', '{\"A\": \"运算速度快\", \"B\": \"逻辑判断能力强\", \"C\": \"体积庞大\", \"D\": \"存储容量大\"}', 'C', '2026-09-13 09:46:38.203858', '2026-09-13 09:46:38.203858', '解析：计算机的特点包括运算速度快、逻辑判断能力强和存储容量大，而“体积庞大”并非其固有特点，现代计算机可设计为小型化，因此C选项不符合。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (410, 1, '计算机的主要功能是什么（）', '{\"A\": \"娱乐和游戏\", \"B\": \"数据处理和信息存储\", \"C\": \"打电话和发短信\", \"D\": \"发送和接收邮件\"}', 'B', '2026-09-13 09:46:38.210839', '2026-09-13 09:46:38.210839', '解析：计算机的核心功能是进行数据处理（如计算、分析）和信息存储（如保存文件），而其他选项仅为计算机的特定应用或外部设备功能，并非其主要功能。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (411, 1, '计算机与计算器的主要区别在于（）', '{\"A\": \"计算机体积更大\", \"B\": \"计算机可以处理的信息类型更多样\", \"C\": \"计算机运算速度更快\", \"D\": \"计算机价格更高\"}', 'B', '2026-09-13 09:46:38.217821', '2026-09-13 09:46:38.217821', '解析：计算机与计算器的核心区别在于功能多样性，计算机能处理文字、图像、音频等多种信息类型，而计算器仅能进行数值运算，因此选项B正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (412, 1, '在计算机分类中，超级计算机的特点是（）', '{\"A\": \"极高的计算速度和强大的数据处理能力\", \"B\": \"小巧便携\", \"C\": \"价格低廉\", \"D\": \"主要用于家庭娱乐\"}', 'A', '2026-09-13 09:46:38.225048', '2026-09-13 09:46:38.225048', '解析：超级计算机以极高的计算速度和强大的数据处理能力著称，主要用于科学计算和复杂任务，而其他选项描述的是普通个人计算机或移动设备的特点，因此A正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (413, 1, '计算机按照规模和性能可以分为哪几类？', '{\"A\": \"微型计算机、小型计算机、中型计算机和大型计算机\", \"B\": \"个人计算机、工作站、服务器和超级计算机\", \"C\": \"便携式计算机、台式计算机、笔记本计算机和平板电脑\", \"D\": \"以上所有选项\"}', 'A', '2026-09-13 09:46:38.232029', '2026-09-13 09:46:38.232029', '解析：计算机按规模和性能分类，通常分为微型计算机、小型计算机、中型计算机和大型计算机，这是传统分类标准。B选项按用途分类，C选项按外形分类，D选项错误，因此选A。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (414, 1, '计算机的软件系统通常分为哪两大类？', '{\"A\": \"应用软件和系统软件\", \"B\": \"编程软件和数据库软件\", \"C\": \"网络软件和图形软件\", \"D\": \"办公软件和游戏软件\"}', 'A', '2026-09-13 09:46:38.239010', '2026-09-13 09:46:38.239010', '解析：计算机的软件系统通常分为应用软件和系统软件两大类，系统软件（如操作系统）管理硬件和资源，应用软件（如办公软件）为用户完成特定任务，而其他选项均未涵盖这一基本分类。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (415, 1, '下列关于计算机特点的描述中错误的是（）。', '{\"A\": \"计算机计算精度高的关键是计算机每秒能执行多少条基本指令\", \"B\": \"计算机因为使用的是二进制的计算方式，给它带来了特别强的逻辑推理和判断能力\", \"C\": \"计算机的存储容量大实际是取决于它的硬盘、内存\", \"D\": \"计算机的自动化程度高是因为程序存储控制的原理，这是其最突出的特点\"}', 'A', '2026-09-13 09:46:38.245992', '2026-09-13 09:46:38.245992', '解析：计算机计算精度高的关键在于其采用二进制运算，能够处理多位有效数字，而非每秒执行的指令数量，因此A项描述错误。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (416, 1, '下列关于个人电脑的分类叙述中错误的是()。', '{\"A\": \"台式机在散热性、扩展性方面优于笔记本电脑\", \"B\": \"电脑一体机的芯片、主板与显示器集成在一起\", \"C\": \"笔记本电脑便携性较好，可以利用键盘、触控板进行输入功能\", \"D\": \"掌上电脑（PDA）通常也叫平板电脑，智能手机就是PDA\"}', 'D', '2026-09-13 09:46:38.252973', '2026-09-13 09:46:38.252973', '解析：选项D错误，因为掌上电脑（PDA）与平板电脑、智能手机是不同类别的设备，PDA主要功能为个人数字助理，而平板电脑和智能手机是更现代的移动计算设备，不能等同。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (417, 1, '\"现代计算机速度最高可达每秒千亿此运算,…\",该描述说明计算机具有()。', '{\"A\": \"自动控制能力\", \"B\": \"高速运算的能力\", \"C\": \"很高的计算机精度\", \"D\": \"逻辑判断能力\"}', 'B', '2026-09-13 09:46:38.259954', '2026-09-13 09:46:38.259954', '解析：题目中“速度最高可达每秒千亿次运算”直接描述了计算机执行运算的快速性，因此对应高速运算的能力，故选项B正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (418, 1, '下列关于计算机应用领域和特点的说法中是错误的是（）。', '{\"A\": \"计算机强大的逻辑判断能力是AI的基础\", \"B\": \"计算机最重要的特点是能自动化工作\", \"C\": \"云计算就是利用了计算机运行速度快?存储容量大?自动化程度高等特点\", \"D\": \"现代计算机能将圆周率计算到小数点后上亿位,说明了计算机具有计算速度快的特点\"}', 'D', '2026-09-13 09:46:38.268930', '2026-09-13 09:46:38.268930', '解析：选项D中，计算机将圆周率计算到小数点后上亿位，主要体现的是计算精度高和存储容量大的特点，而非单纯的计算速度快，因此说法错误。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (419, 1, '现代计算机内部之所以采用数字化技术，不是因为（）。', '{\"A\": \"电子元器件的特性所决定的\", \"B\": \"运算规则简单，简化了计算机设计\", \"C\": \"抗干扰能力强，机器可靠性高\", \"D\": \"能够实现程序的自动化运行\"}', 'D', '2026-09-13 09:46:38.274944', '2026-09-13 09:46:38.274944', '解析：数字化技术采用二进制，其优势包括由电子元器件开关特性决定、运算规则简单以及抗干扰能力强，而“实现程序自动化运行”是计算机体系结构（如存储程序原理）的功能，并非数字化技术本身的直接原因，因此选D。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (420, 1, '下列描述的计算机特点较全面的是()。', '{\"A\": \"运算速度快、价格低、具有存储能力、具有逻辑判断功能、传输速度快\", \"B\": \"运算速度快、价格贵、传输速度快、具有逻辑判断功能、自动化程度高\", \"C\": \"运算速度快、精度高、自动化程度高、具有逻辑判断功能、传输速度快\", \"D\": \"运算速度快、精度高、具有存储能力、具有逻辑判断功能、自动化程度高\"}', 'D', '2026-09-13 09:46:38.280899', '2026-09-13 09:46:38.280899', '解析：选项D全面涵盖了计算机的主要特点，包括运算速度快、精度高、具有存储能力、具有逻辑判断功能和自动化程度高，而其他选项缺少关键特性（如A缺少精度高和自动化程度高，B缺少精度高和存储能力，C缺少存储能力），因此D更全面。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (421, 1, '下面关于个人计算机的叙述中，错误的是()。', '{\"A\": \"个人计算机属于个人使用，一般不能多人同时使用\", \"B\": \"个人计算机价格较低，性能不高，一般不应用于商业领域\", \"C\": \"目前PC机中广泛使用的是X86架构的微处理器\", \"D\": \"Intel公司是国际上研制和生产微处理器最有名的公司之一\"}', 'B', '2026-09-13 09:46:38.287904', '2026-09-13 09:46:38.287904', '解析：选项B错误，因为个人计算机虽然价格较低，但性能足以满足商业领域的需求，广泛应用于商业办公、数据处理等场景，并非一般不应用于商业领域。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (422, 1, '拥有固定的存储程序，为某种特定目的而设计的计算机属于()。', '{\"A\": \"量子计算机\", \"B\": \"通用计算机\", \"C\": \"专用计算机\", \"D\": \"数模混合计算机\"}', 'C', '2026-09-13 09:46:38.293891', '2026-09-13 09:46:38.293891', '解析：专用计算机是指为特定任务或应用而设计的计算机，其存储程序固定，功能专一，因此符合题目描述。而通用计算机可执行多种程序，量子计算机和数模混合计算机不强调固定存储程序，故选项C正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (423, 1, '某单位没有足够的IP地址供每台计算机分配，比较合理的分配方法是()。', '{\"A\": \"给所有的需要IP地址的设备动态分配IP地址\", \"B\": \"给一些重要设备静态分配，其余一般设备动态分配\", \"C\": \"通过限制上网设备数量，保证全部静态分配\", \"D\": \"申请足够多的IP地址，保证静态分配\"}', 'B', '2026-09-13 09:46:38.299875', '2026-09-13 09:46:38.299875', '解析：由于IP地址有限，合理的方法是给重要设备（如服务器）分配静态IP地址以保证稳定访问，而一般设备动态分配以节省IP资源，因此选项B正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (424, 1, '按照处理数据的方式，计算机可以分为（）。', '{\"A\": \"巨型机和大型机\", \"B\": \"专用机和通用机\", \"C\": \"电子计算机和光子计算机\", \"D\": \"模拟计算机和数字计算机\"}', 'D', '2026-09-13 09:46:38.305865', '2026-09-13 09:46:38.306859', '解析：计算机按处理数据的方式分为模拟计算机（处理连续变化的模拟量）和数字计算机（处理离散的数字量），因此正确答案是D。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (425, 1, '按计算机处理数据的类型划分，计算机可分为数字计算机、模拟计算机和（）。', '{\"A\": \"通用计算机\", \"B\": \"专用计算机\", \"C\": \"混合计算机\", \"D\": \"微型计算机\"}', 'C', '2026-09-13 09:46:38.312846', '2026-09-13 09:46:38.312846', '解析：按计算机处理数据的类型划分，计算机可分为数字计算机、模拟计算机和混合计算机，混合计算机结合了数字和模拟处理能力，因此选C。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (426, 1, '下列关于个人电脑的分类叙述中错误的是（）。', '{\"A\": \"台式机在散热性、扩展性方面优于笔记本电脑\", \"B\": \"电脑一体机的芯片、主板与显示器集成在一起\", \"C\": \"笔记本电脑便携性较好，可以利用键盘、触控板进行输入功能\", \"D\": \"掌上电脑（PDA）通常也叫平板电脑，智能手机就是PDA\"}', 'D', '2026-09-13 09:46:38.318825', '2026-09-13 09:46:38.318825', '解析：选项D错误，因为掌上电脑（PDA）与平板电脑、智能手机并非同一概念，PDA是早期的移动设备，功能有限，而平板电脑和智能手机是更现代化的设备，具有更强的计算和通信能力。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (427, 1, '一个完整的计算机系统应包括（）。', '{\"A\": \"主机和外设\", \"B\": \"硬件和软件\", \"C\": \"硬件系统和软件系统\", \"D\": \"主机、键盘、显示器和辅助存储器\"}', 'C', '2026-09-13 09:46:38.324810', '2026-09-13 09:46:38.324810', '解析：计算机系统由硬件系统和软件系统两大部分组成，硬件是物理基础，软件是运行指令，二者缺一不可。选项C准确涵盖了这一完整定义。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (428, 1, '鲁老师为了确保出行计划的顺利进行，特意查询了武汉最新的天气预报，这主要是考虑信息的（）。', '{\"A\": \"真实性\", \"B\": \"价值取向\", \"C\": \"来源\", \"D\": \"时效性\"}', 'D', '2026-09-13 09:46:38.331790', '2026-09-13 09:46:38.331790', '解析：鲁老师查询最新天气预报是为了确保出行计划顺利进行，这强调信息必须反映当前或近期天气状况，而“时效性”正是指信息的新旧程度及其对决策的有效性，因此选择D。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (429, 1, '数据已经爆炸了，信息却仍稀缺，二者关系下列叙述错误的是（）。', '{\"A\": \"信息可以简单地理解为数据中包含的有用的内容\", \"B\": \"信息经过加工后就成为数据\", \"C\": \"数据是信息的具体表现形式\", \"D\": \"对于计算机来说，信息处理其本质就是数据处理\"}', 'B', '2026-09-13 09:46:38.337775', '2026-09-13 09:46:38.337775', '解析：选项B错误，因为信息是经过加工处理后的数据，而非信息经过加工后成为数据，因此表述颠倒。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (430, 1, '计算机按功能和规模划分，神威·太湖之光属于()', '{\"A\": \"大型机\", \"B\": \"巨型机\", \"C\": \"小型机\", \"D\": \"工作站\"}', 'B', '2026-09-13 09:46:38.343758', '2026-09-13 09:46:38.343758', '解析：神威·太湖之光属于超级计算机，按计算机功能和规模划分，巨型机（超级计算机）专为处理大规模复杂计算任务而设计，因此正确答案是B。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (431, 1, '是()赋予了计算机具有逻辑判断能力', '{\"A\": \"硬件\", \"B\": \"CPU\", \"C\": \"编制的软件\", \"D\": \"操作系统\"}', 'C', '2026-09-13 09:46:38.350739', '2026-09-13 09:46:38.350739', '解析：计算机的逻辑判断能力是通过软件中的程序指令实现的，硬件本身不具备逻辑判断功能，因此是编制的软件赋予了计算机这一能力。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (432, 1, '计算机与计算器的本质区别是()', '{\"A\": \"运算速度不一样\", \"B\": \"体积不一样\", \"C\": \"是否具有存储能力\", \"D\": \"自动化程度的高低\"}', 'D', '2026-09-13 09:46:38.357720', '2026-09-13 09:46:38.357720', '解析：计算机与计算器的本质区别在于自动化程度的高低，计算机能按程序自动执行复杂操作，而计算器需人工逐步干预，因此选D。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (433, 1, '第三代计算机的内存储器为()', '{\"A\": \"水银延迟线或电子射线管\", \"B\": \"磁鼓存储器\", \"C\": \"半导体存储器\", \"D\": \"高集成度的半导体存储器\"}', 'C', '2026-09-13 09:46:38.363710', '2026-09-13 09:46:38.363710', '解析：第三代计算机（1965-1970年）采用中小规模集成电路，其内存储器使用半导体存储器，取代了前两代的磁芯存储器，因此选C。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (434, 1, '关于计算机的特点的说法错误的是()。', '{\"A\": \"计算机运算速度快，精度高\", \"B\": \"具有记忆和逻辑判断能力\", \"C\": \"能自动运行，但不支持人机交互\", \"D\": \"有大容量存储器\"}', 'C', '2026-09-13 09:46:38.369689', '2026-09-13 09:46:38.369689', '解析：计算机的特点包括运算速度快、精度高、具有记忆和逻辑判断能力、能自动运行并支持人机交互、以及拥有大容量存储器。选项C说“能自动运行，但不支持人机交互”错误，因为计算机通过输入输出设备支持人机交互。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (435, 1, '关于计算机的主要特点，表述正确的是()。', '{\"A\": \"运算速度快、运算精度高、应用范围广、智能程度高、自动化程度高\", \"B\": \"运算速度快、运算精度高、存储容量大、处理信息能力强、创造能力强\", \"C\": \"运算速度快、运算精度高、存储容量大、逻辑运算能力强、自动化程度高\", \"D\": \"运算速度快、运算精度高、智能化程度高、逻辑运算能力强、自动化程度高\"}', 'C', '2026-09-13 09:46:38.375673', '2026-09-13 09:46:38.375673', '解析：计算机的主要特点包括运算速度快、运算精度高、存储容量大、逻辑运算能力强和自动化程度高，选项C完整准确地概括了这些特点，而其他选项（如智能程度高、创造能力强等）不属于计算机的基本特点，因此选C。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (436, 1, '下列不属于计算机特点的是()。', '{\"A\": \"具有逻辑判断能力，能在程序控制下自动地进行工作\", \"B\": \"运算速度快\", \"C\": \"计算精度高\", \"D\": \"可靠性和稳定性低\"}', 'D', '2026-09-13 09:46:38.382654', '2026-09-13 09:46:38.382654', '解析：计算机的特点包括运算速度快、计算精度高、具有逻辑判断能力并能自动工作，而可靠性和稳定性低恰恰与计算机高可靠性和高稳定性的实际特点相反，因此D选项不属于计算机特点。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (437, 1, '计算机特点不包括()。', '{\"A\": \"计算精确度高\", \"B\": \"性价比低\", \"C\": \"逻辑运算能力强\", \"D\": \"运算速度快\"}', 'B', '2026-09-13 09:46:38.388638', '2026-09-13 09:46:38.388638', '解析：计算机的主要特点包括运算速度快、计算精确度高、逻辑运算能力强以及性价比高等，而“性价比低”与实际情况相反，因此不属于计算机特点，故选择B。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (438, 1, '某种计算机内部被传送、存储和运算的信息，都是以电磁信号形式表示的数字，这样的计算机称为()。', '{\"A\": \"电子数字计算机\", \"B\": \"电子模拟计算机\", \"C\": \"电子积分计算机\", \"D\": \"专用计算机\"}', 'A', '2026-09-13 09:46:38.395591', '2026-09-13 09:46:38.395591', '解析：该计算机以数字形式的电磁信号处理信息，符合电子数字计算机的定义，即采用数字信号进行运算和存储。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (439, 1, '我们经常说的奔腾系列、酷睿系列等计算机属于()', '{\"A\": \"微型计算机\", \"B\": \"小型计算机\", \"C\": \"超级计算机\", \"D\": \"巨型计算机\"}', 'A', '2026-09-13 09:46:38.401603', '2026-09-13 09:46:38.401603', '解析：奔腾系列、酷睿系列是英特尔公司生产的个人计算机处理器，常用于个人电脑和笔记本，属于微型计算机范畴。微型计算机以体积小、价格低、适合个人使用为特点，而小型计算机、超级计算机和巨型计算机则用于大型计算或企业级应用，因此选项A正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (440, 1, '目前,()主要用于战略武器设计,空间技术,石油勘探,中长期天气预报以及社会模拟等领域', '{\"A\": \"大型机\", \"B\": \"微型机\", \"C\": \"小型机\", \"D\": \"巨型机\"}', 'D', '2026-09-13 09:46:38.407588', '2026-09-13 09:46:38.408584', '解析：巨型机（超级计算机）具有极高的运算速度和数据处理能力，能够满足战略武器设计、空间技术、石油勘探、中长期天气预报及社会模拟等复杂领域对大规模计算的需求，因此正确答案是D。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (441, 1, '()的特点是用连续量来表示数值,且运算过程是连续的', '{\"A\": \"电子模拟计算机\", \"B\": \"电子数字计算机\", \"C\": \"通用机\", \"D\": \"专用机\"}', 'A', '2026-09-13 09:46:38.414569', '2026-09-13 09:46:38.414569', '解析：电子模拟计算机以连续变化的物理量（如电压）模拟数值，运算过程也是连续的，而数字计算机采用离散量，因此正确答案是A。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (442, 1, '老师在上课时通过使用C语言编程器运行程序展示了计算机能够自动进行数据处理的特点,那么计算机能够自动、连续地进行数据处理的主要原因是()', '{\"A\": \"采用了开关电路\", \"B\": \"采用了半导体器件\", \"C\": \"采用了二进制\", \"D\": \"具有存储程序的功能\"}', 'D', '2026-09-13 09:46:38.420552', '2026-09-13 09:46:38.420552', '解析：计算机能够自动、连续地进行数据处理，是因为其具有存储程序的功能，即预先将程序和数据存入存储器，由控制器自动逐条执行指令，无需人工干预。其他选项如开关电路、半导体器件或二进制是计算机实现的技术基础，但并非自动连续处理数据的直接原因。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (443, 1, '下列关于计算机的特点,说法不正确的是()', '{\"A\": \"运算速度极快\", \"B\": \"无存储器\", \"C\": \"计算精度高\", \"D\": \"逻辑运算能力强\"}', 'B', '2026-09-13 09:46:38.426537', '2026-09-13 09:46:38.426537', '解析：计算机具有存储器，用于存储数据和程序，因此选项B“无存储器”说法不正确，其他选项均为计算机的正确特点。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (444, 1, '()不属于数字计算机特点', '{\"A\": \"逻辑判断能力强\", \"B\": \"运算过程是连续的\", \"C\": \"存储容量大\", \"D\": \"精度高\"}', 'B', '2026-09-13 09:46:38.433518', '2026-09-13 09:46:38.433518', '解析：数字计算机以离散的数字信号进行运算，运算过程是离散而非连续的，因此选项B“运算过程是连续的”不属于数字计算机的特点。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (445, 1, '国际上通常根据()把计算机分为巨型计算机、大型主机、小型计算机、工作站和微型计算机。', '{\"A\": \"计算机的原理进行分类\", \"B\": \"计算机的规模和处理能力进行分类\", \"C\": \"计算机处理数据的形态来划分\", \"D\": \"计算机的用途来划分的\"}', 'B', '2026-09-13 09:46:38.439516', '2026-09-13 09:46:38.439516', '解析：计算机的分类主要依据其规模和处理能力，包括运算速度、存储容量、输入输出能力等，因此巨型机、大型主机等类别对应选项B，其他选项（原理、数据形态、用途）均不构成这种分类标准。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (446, 1, '当前,计算机的“两极化”分别指的是()', '{\"A\": \"专用机和通用机\", \"B\": \"微型机和巨型机\", \"C\": \"模拟机和数字机\", \"D\": \"个人机和工作站\"}', 'B', '2026-09-13 09:46:38.445489', '2026-09-13 09:46:38.445489', '解析：计算机的“两极化”通常指技术发展方向的两端，即体积小、成本低的微型机与性能强、规模大的巨型机，这两者分别代表了计算机应用的普及与尖端领域，因此选项B正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (447, 1, '如果没有存储程序,则计算机就不能实现()', '{\"A\": \"自动处理\", \"B\": \"很高的计算精度\", \"C\": \"进行高速运算\", \"D\": \"具有记忆能力\"}', 'A', '2026-09-13 09:46:38.452467', '2026-09-13 09:46:38.452467', '解析：存储程序是计算机实现自动处理的基础，它允许计算机按照预先编写的指令序列自动执行任务，无需人工干预，因此没有存储程序就不能实现自动处理，而其他选项如计算精度、高速运算和记忆能力则依赖硬件设计而非存储程序。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (448, 1, '计算机内部表达数据的形式是().', '{\"A\": \"八进制\", \"B\": \"数字编码\", \"C\": \"十进制\", \"D\": \"二进制\"}', 'D', '2026-09-13 09:46:38.458451', '2026-09-13 09:46:38.458451', '解析：计算机内部采用二进制表达数据，因为二进制只有0和1两种状态，易于用电子元件的开关状态实现，且运算规则简单、抗干扰能力强。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (449, 1, '计算机能处理大量音频和视频数据，是因为计算机具有()特点。', '{\"A\": \"大尺寸的彩显\", \"B\": \"快速的打印机\", \"C\": \"存储器容量大\", \"D\": \"好的程序设计语言\"}', 'C', '2026-09-13 09:46:38.464435', '2026-09-13 09:46:38.464435', '解析：计算机处理大量音频和视频数据需要存储和读取庞大的文件，只有存储器容量大才能满足这一需求，而其他选项（如彩显、打印机、程序设计语言）并不直接决定数据处理能力。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (450, 1, '计算机根据规模和功能可分为六类,其中不包含()', '{\"A\": \"超级计算机或称巨型机,小超级机或称小巨型机\", \"B\": \"大型主机、小型机\", \"C\": \"手持移动设备、智能终端\", \"D\": \"工作站,个人计算机或称微型机\"}', 'C', '2026-09-13 09:46:38.471417', '2026-09-13 09:46:38.471417', '解析：计算机根据规模和功能分类的六类包括超级计算机、小超级机、大型主机、小型机、工作站和个人计算机，手持移动设备和智能终端通常不归入此分类体系，因此选项C不包含在内。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (451, 1, '下列各项中,()是计算机最重要的工作特点', '{\"A\": \"存储程序与自动控制\", \"B\": \"运算速度快\", \"C\": \"逻辑运算能力强\", \"D\": \"存储容量大\"}', 'A', '2026-09-13 09:51:10.351649', '2026-09-13 09:51:10.351649', '解析：计算机最重要的工作特点是“存储程序与自动控制”，因为这是计算机区别于其他计算工具的核心特征，它使得计算机能够预先存储指令并自动执行，其他选项如运算速度快、逻辑运算能力强、存储容量大虽然也是特点，但并非最重要的工作特点。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (452, 1, '计算机之所以能按人们的意志自动进行工作，最直接的原因是因为采用了()。', '{\"A\": \"存储程序控制\", \"B\": \"分时操作系统\", \"C\": \"面向对象程序设计语言\", \"D\": \"二进制数值\"}', 'A', '2026-09-13 09:51:10.359330', '2026-09-13 09:51:10.359330', '解析：计算机能自动工作的最直接原因是采用了“存储程序控制”原理，即程序和数据预先存储在内存中，由控制器自动逐条取出并执行指令，从而实现自动化运行。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (453, 1, '下列()不是计算机的特点。', '{\"A\": \"高速的准确的运算能力\", \"B\": \"强大的存储能力\", \"C\": \"通用性强\", \"D\": \"准确的判断能力\"}', 'D', '2026-09-13 09:51:10.366311', '2026-09-13 09:51:10.366311', '解析：计算机的特点包括高速准确的运算能力、强大的存储能力和通用性强，而准确的判断能力并非计算机的固有特点，计算机的判断依赖于预设程序，因此D选项错误。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (454, 1, '计算机能够自动、准确、快速地按照人们的意图进行运行的最基本思想是()。', '{\"A\": \"采用程序设计语言\", \"B\": \"采用大容量存储器\", \"C\": \"采用操作系统\", \"D\": \"存储程序和程序控制\"}', 'D', '2026-09-13 09:51:10.372295', '2026-09-13 09:51:10.373292', '解析：计算机能够自动、准确、快速地运行，其核心思想是“存储程序和程序控制”，即预先将程序和数据存储在存储器中，然后由控制器自动逐条执行指令，无需人工干预。因此，正确答案是D。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (455, 1, 'CPU的中文意义是()。', '{\"A\": \"存储器\", \"B\": \"汞延迟线\", \"C\": \"控制器\", \"D\": \"中央处理器\"}', 'D', '2026-09-13 09:51:10.379276', '2026-09-13 09:51:10.379276', '解析：CPU是英文Central Processing Unit的缩写，中文翻译为“中央处理器”，是计算机的核心部件，因此正确答案是D。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (456, 1, '小亮家里使用的笔记本电脑属于()计算机。', '{\"A\": \"小型\", \"B\": \"微型\", \"C\": \"大型\", \"D\": \"超级\"}', 'B', '2026-09-13 09:51:10.386257', '2026-09-13 09:51:10.386257', '正确答案是B。解析：笔记本电脑属于微型计算机，因其体积小、功耗低、采用微处理器，符合微型计算机的定义。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (457, 1, '“计算机能够像人类一样进行判断，并根据运算的结果的不同选择不同的处理方式。”，该描述说明计算机具有()。', '{\"A\": \"自动控制能力\", \"B\": \"高速运算的能力\", \"C\": \"记忆能力\", \"D\": \"逻辑判断能力\"}', 'D', '2026-09-13 09:51:10.393239', '2026-09-13 09:51:10.393239', '解析：题干强调计算机根据运算结果的不同选择不同处理方式，这体现了计算机能够进行条件判断和逻辑推理，因此对应逻辑判断能力。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (458, 1, '下列有关计算机特点、应用等的叙述，不正确的是()。', '{\"A\": \"计算机具有计算精度高的特点\", \"B\": \"计算机具有逻辑判断准确的特点\", \"C\": \"计算机的存储容量主要由内存的容量来决定\", \"D\": \"计算机具有存储容量大的特点\"}', 'C', '2026-09-13 09:51:10.400220', '2026-09-13 09:51:10.400220', '解析：计算机的存储容量由内存和外存共同决定，而不仅限于内存，因此选项C表述不完整，是不正确的。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (459, 1, '()是计算机工作的重要原则。', '{\"A\": \"使用了先进的电子器件\", \"B\": \"采用了高效的编程语言\", \"C\": \"存储程序和程序控制\", \"D\": \"开发了高级操作系统\"}', 'C', '2026-09-13 09:51:10.406204', '2026-09-13 09:51:10.406204', '解析：存储程序和程序控制是计算机工作的核心原则，由冯·诺依曼提出，规定计算机通过预先存储的指令自动执行任务，这是计算机运行的基础。其他选项（如先进器件、编程语言、操作系统）是技术发展成果，而非基本原则。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (460, 1, '适用于各种应用场合,功能齐全、通用性好的计算机属于()。', '{\"A\": \"数模混合计算机\", \"B\": \"电子模拟计算机\", \"C\": \"通用计算机\", \"D\": \"专用计算机\"}', 'C', '2026-09-13 09:51:10.412188', '2026-09-13 09:51:10.412188', '解析：通用计算机设计用于处理多种任务，功能全面且适应性强，因此适用于各种应用场合，而专用计算机仅针对特定用途，故选择C。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (461, 1, '计算机所具备的优秀特点是()、计算精度高、具有强大的记忆功能、具有逻辑判断能力、能实现自动控制等。', '{\"A\": \"运算速度快\", \"B\": \"能自动运行\", \"C\": \"具有创造能力\", \"D\": \"通用性差\"}', 'A', '2026-09-13 09:51:10.419169', '2026-09-13 09:51:10.419169', '解析：运算速度快是计算机的核心特点之一，与题目中列举的计算精度高、记忆功能强、逻辑判断能力和自动控制能力并列，共同构成计算机的优秀特性，因此选A。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (462, 1, '计算机的主要特点不包括()。', '{\"A\": \"自动化程度高\", \"B\": \"逻辑判断能力强\", \"C\": \"故障率高\", \"D\": \"计算精度高\"}', 'C', '2026-09-13 09:51:10.427148', '2026-09-13 09:51:10.427148', '解析：计算机的主要特点包括自动化程度高、逻辑判断能力强和计算精度高，而故障率高不符合计算机高可靠性的特点，因此选C。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (463, 1, '现代个人计算机运算速度最高可达每秒()。', '{\"A\": \"几百亿次\", \"B\": \"几十亿次\", \"C\": \"几亿次\", \"D\": \"几十万次\"}', 'B', '2026-09-13 09:51:10.433132', '2026-09-13 09:51:10.433132', '解析：现代个人计算机的运算速度通常以每秒几十亿次（GHz级别）衡量，而几百亿次、几亿次或几十万次均不符合当前主流性能水平，故正确答案为B。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (464, 1, '计算机的特点，有运算速度快、计算精度高、()、具有逻辑判断能力、能实现自动控制等。', '{\"A\": \"价格便宜\", \"B\": \"功耗小\", \"C\": \"存储容量大\", \"D\": \"体积庞大\"}', 'C', '2026-09-13 09:51:10.440113', '2026-09-13 09:51:10.440113', '解析：计算机的主要特点包括运算速度快、计算精度高、存储容量大、具有逻辑判断能力以及能实现自动控制，而价格便宜、功耗小、体积庞大并非其固有特性，因此选C。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (465, 1, '计算机具有判断推理能力的前提是()。', '{\"A\": \"计算机可以代替人脑\", \"B\": \"计算机的计算精度高\", \"C\": \"计算机具有逻辑运算能力\", \"D\": \"计算机具有创造能力\"}', 'C', '2026-09-13 09:51:10.447095', '2026-09-13 09:51:10.447095', '解析：计算机的判断推理能力依赖于逻辑运算，通过逻辑运算处理条件判断和推理，因此前提是具有逻辑运算能力。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (466, 1, '计算机具有逻辑判断能力,能实现自动控制，是由于()。', '{\"A\": \"计算机运行前编制了程序\", \"B\": \"计算机内部信息采用二进制表示\", \"C\": \"计算机内部设计有CPU\", \"D\": \"计算机安装了操作系统\"}', 'A', '2026-09-13 09:51:10.456071', '2026-09-13 09:51:10.456071', '解析：计算机能实现逻辑判断和自动控制，是因为在运行前通过编制程序预先设定了操作指令和判断规则，程序指导计算机自动执行相应操作，而二进制、CPU或操作系统只是实现程序运行的基础条件，并非直接原因。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (467, 1, '既可以接收、处理和输出模拟量，也可以接收、处理和输出数字量的计算机是()。', '{\"A\": \"电子数字计算机\", \"B\": \"通用计算机\", \"C\": \"数模混合计算机\", \"D\": \"专用计算机\"}', 'C', '2026-09-13 09:51:10.463052', '2026-09-13 09:51:10.463052', '解析：数模混合计算机结合了数字计算机和模拟计算机的特点，既能处理模拟信号也能处理数字信号，因此符合题目要求。其他选项如电子数字计算机只处理数字量，通用计算机和专用计算机通常也以数字处理为主，不具备同时处理模拟量和数字量的能力。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (468, 1, '可以接收、处理和输出数字量的计算机是()', '{\"A\": \"电子数字计算机\", \"B\": \"电子模拟计算机\", \"C\": \"电动计算机\", \"D\": \"专用计算机\"}', 'A', '2026-09-13 09:51:10.469037', '2026-09-13 09:51:10.469037', '解析：电子数字计算机以数字量（如二进制）进行运算，能接收、处理和输出数字信号，而其他选项如模拟计算机处理连续物理量，电动计算机并非通用数字处理设备，专用计算机范围较窄，因此选A。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (469, 1, '\"计算机具有逻辑判断能力\"主要取决于计算机()。', '{\"A\": \"运行速度\", \"B\": \"存储容量\", \"C\": \"所运行的程序中预定的判断方法\", \"D\": \"基本字长\"}', 'C', '2026-09-13 09:51:10.476017', '2026-09-13 09:51:10.476017', '解析：计算机的逻辑判断能力并非由硬件性能（如运行速度、存储容量、基本字长）直接决定，而是通过执行预先编写的程序中的判断指令（如条件语句）来实现，因此取决于所运行的程序中预定的判断方法。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (470, 1, '数控机床的操作和监控全部在它数控单元中完成，它是数控机床的大脑，属于()。', '{\"A\": \"电子数字计算机\", \"B\": \"电子模拟计算机\", \"C\": \"电动计算机\", \"D\": \"专用计算机\"}', 'D', '2026-09-13 09:51:10.482999', '2026-09-13 09:51:10.482999', '解析：数控机床的数控单元专门用于控制机床操作和监控，属于为特定任务设计的专用计算机，因此选项D正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (471, 1, '有关计算机的主要特点说法正确的是()。', '{\"A\": \"性价比低、存储容量小、运算速度快\", \"B\": \"体积小、价格高、可靠性高\", \"C\": \"运算速度快、功能全、计算精度低\", \"D\": \"运算速度快、计算精度高、存储容量大\"}', 'D', '2026-09-13 09:51:10.488983', '2026-09-13 09:51:10.488983', '解析：计算机的主要特点包括运算速度快、计算精度高、存储容量大，因此选项D正确，其他选项描述不准确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (472, 1, '下列关于超级计算机的说法错误的是()。', '{\"A\": \"超级计算机和PC构成组件基本相同，但在性能和规模方面有差异。\", \"B\": \"超级计算机有PC无法比拟的运算速度、存储容量和完善的功能\", \"C\": \"超算就是大型计算机，是国家科技发展水平和综合国力的重要标志\", \"D\": \"超算可以和云计算、云储存联系在一起，为大数据技术的发展提供保障\"}', 'C', '2026-09-13 09:51:10.494967', '2026-09-13 09:51:10.494967', '解析：超级计算机与大型计算机并非同一概念，超级计算机侧重于高速并行计算，而大型计算机强调高可靠性和高吞吐量，因此“超算就是大型计算机”表述错误。故C选项错误。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (473, 1, '微型计算机是由大规模集成电路组成的、体积较小的电子计算机,下列叙述不正确的是()。', '{\"A\": \"现在常用的PC、工作站、服务器、工业控制计算机都属于微型计算机\", \"B\": \"1971年Intel研制出微处理器芯片4004(4位字长)，标志着微机时代开始\", \"C\": \"因集成电路工艺的提升，微处理器中包含的晶体管越来越少,但功能越来越强大\", \"D\": \"微机的特点是体积小、灵活性大、价格便宜、使用方便\"}', 'C', '2026-09-13 09:51:10.500951', '2026-09-13 09:51:10.501948', '解析：选项C错误，因为集成电路工艺的提升使得微处理器中包含的晶体管越来越多，而不是越来越少，从而功能越来越强大。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (474, 1, '下列选项中,属于计算机主要功能的是()', '{\"A\": \"计算机可以代替人的脑力劳动\", \"B\": \"计算机可以存储大量的信息\", \"C\": \"计算机可以实现高速度的运算\", \"D\": \"计算机可以进行信息处理\"}', 'D', '2026-09-13 09:51:10.507932', '2026-09-13 09:51:10.507932', '解析：计算机的主要功能是信息处理，包括对数据的输入、存储、运算和输出等综合过程，而高速度运算和存储信息只是信息处理的一部分，不能代替人的脑力劳动，因此D选项最全面准确地概括了计算机的核心功能。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (475, 1, '对于嵌入式计算机,下列选项中错误的说法是()', '{\"A\": \"用户不能随意修改其程序\", \"B\": \"全自动洗衣机中的微电脑是嵌入式计算机的应用\", \"C\": \"嵌入式计算机属于通用计算机\", \"D\": \"嵌入式计算机系统一般由嵌入式微处理器、硬件设备、嵌入式操作系统和应用程序四个部分组成\"}', 'C', '2026-09-13 09:51:10.513917', '2026-09-13 09:51:10.513917', '解析：嵌入式计算机是专用计算机，专门用于特定任务，而通用计算机（如个人电脑）可执行多种程序，因此选项C错误。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (476, 1, '世界上计算机的厂商很多，下列()不是生产微型计算机的厂商', '{\"A\": \"华硕\", \"B\": \"微软\", \"C\": \"苹果\", \"D\": \"联想\"}', 'B', '2026-09-13 09:51:10.519900', '2026-09-13 09:51:10.519900', '解析：微软主要开发和销售软件（如Windows操作系统）及硬件设备（如Surface系列），但不是生产微型计算机（即个人电脑整机）的主要厂商；而华硕、苹果、联想均为微型计算机的知名制造商。因此，正确答案是B。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (477, 1, '下列选项中,()不属于现代计算机特点', '{\"A\": \"逻辑判断能力强\", \"B\": \"高精度\", \"C\": \"存储容量大\", \"D\": \"价格昂贵\"}', 'D', '2026-09-13 09:51:10.525885', '2026-09-13 09:51:10.525885', '解析：现代计算机的特点是逻辑判断能力强、高精度和存储容量大，而价格昂贵并非其特点，因为随着技术发展，计算机价格逐渐降低，所以选D。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (478, 1, '按照应用范围分类可将计算机分为两类()', '{\"A\": \"模拟计算机和数字计算机\", \"B\": \"专用计算机和通用计算机\", \"C\": \"单片机和微机\", \"D\": \"工业控制机和单片机\"}', 'B', '2026-09-13 09:51:10.532866', '2026-09-13 09:51:10.532866', '解析：按应用范围分类，计算机分为专用计算机（针对特定任务设计）和通用计算机（适用于多种领域），因此选项B正确。其他选项如A（按处理数据方式分类）、C和D（按规模和结构分类）均不符合题意。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (479, 1, '按信息表现形式和被处理的信息分类可分为()', '{\"A\": \"科学计算、数据处理和人工智能计算机\", \"B\": \"电子模拟计算机、电子数字计算机和数字模拟混合计算机\", \"C\": \"巨型、大型、中型、小型和微型计算机\", \"D\": \"便携计算机、台式计算机和微型计算机\"}', 'B', '2026-09-13 09:51:10.538850', '2026-09-13 09:51:10.538850', '解析：按信息表现形式和被处理的信息分类，计算机可分为电子模拟计算机、电子数字计算机和数字模拟混合计算机，因此选B。其他选项分别按用途、规模或外形分类，不符合题意。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (480, 1, '计算机按规模和功能可分为().', '{\"A\": \"科学计算、数据处理和人工智能计算机\", \"B\": \"电子模拟计算机、电子数字计算机和数字模拟混合计算机\", \"C\": \"巨型机、大型机、中型机、小型机和微型计算机\", \"D\": \"便携计算机、台式计算机和微型计算机\"}', 'C', '2026-09-13 09:51:10.544834', '2026-09-13 09:51:10.544834', '解析：计算机按规模和功能通常分为巨型机、大型机、中型机、小型机和微型计算机，这是根据其处理能力、体积和适用场景进行的分类，因此选项C正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (481, 1, '一般被用于特定的操作任务,例如过程控制中使用的工业控制机我们称为()', '{\"A\": \"微型机\", \"B\": \"巨型机\", \"C\": \"通用机\", \"D\": \"专用机\"}', 'D', '2026-09-13 09:51:10.551815', '2026-09-13 09:51:10.551815', '解析：工业控制机专门用于过程控制等特定操作任务，因此属于专用机，而非通用机或微型机、巨型机。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (482, 1, '下列选项中,()不是计算机的特点', '{\"A\": \"可靠性低\", \"B\": \"逻辑判断能力强\", \"C\": \"自动化程度高\", \"D\": \"存储容量大\"}', 'A', '2026-09-13 09:51:10.557799', '2026-09-13 09:51:10.557799', '解析：计算机具有高可靠性、强逻辑判断能力、高自动化程度和大存储容量等特点，而“可靠性低”与计算机实际特性相反，因此A不是计算机的特点。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (483, 1, '在计算机的分类中,计算机的主要特点是按位运算,并且不连续地跳动计算.这样的计算机我们称为()', '{\"A\": \"电子数字计算机\", \"B\": \"电子模拟计算机\", \"C\": \"超级计算机\", \"D\": \"纳米计算机\"}', 'A', '2026-09-13 09:51:10.563783', '2026-09-13 09:51:10.563783', '解析：电子数字计算机以二进制数字（位）为基础，进行按位运算，并通过离散的电平变化实现不连续的计算过程，而电子模拟计算机处理连续量，因此选A。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (484, 1, '我们通常根据()把计算机分为8位计算机、16位计算机、32位计算机和64位计算机', '{\"A\": \"处理器的字长\", \"B\": \"计算机的运算速度\", \"C\": \"存储器容量\", \"D\": \"电子元器件\"}', 'A', '2026-09-13 09:51:10.569767', '2026-09-13 09:51:10.569767', '解析：计算机的位数通常由处理器一次能处理的数据位数（即字长）决定，因此根据处理器的字长划分为8位、16位、32位和64位计算机。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (485, 1, '计算机的通用性使其可以求解不同的算术和逻辑问题，这主要取决于计算机的()。', '{\"A\": \"可编程性\", \"B\": \"指令系统\", \"C\": \"高速运算\", \"D\": \"存储功能\"}', 'A', '2026-09-13 09:51:10.576748', '2026-09-13 09:51:10.576748', '解析：计算机的通用性源于其可编程性，即通过编写不同的程序来执行各种算术和逻辑任务，而指令系统、高速运算和存储功能是支持可编程性的基础，但通用性的核心在于能够灵活改变程序。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (486, 1, '计算机的主要特点是()。', '{\"A\": \"运算速度快、存储容量大、性能价格比低\", \"B\": \"运算速度快、性能价格比低、程序控制\", \"C\": \"运算速度快、自动控制、可靠性高\", \"D\": \"性能价格比低、功能全、体积小\"}', 'C', '2026-09-13 09:51:10.582733', '2026-09-13 09:51:10.582733', '解析：计算机的主要特点包括运算速度快、自动控制（即程序控制）和可靠性高，而性能价格比低并非其特点，因此选项C正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (487, 1, '计算机能够进行逻辑判断并根据判断的结果来选择相应的处理。，该描述说明计算机具有()。', '{\"A\": \"自动控制能力\", \"B\": \"逻辑判断能力\", \"C\": \"记忆能力\", \"D\": \"高速运算的能力\"}', 'B', '2026-09-13 09:51:10.588717', '2026-09-13 09:51:10.588717', '解析：题目明确提到计算机能够进行“逻辑判断”并根据结果选择处理方式，这与选项B“逻辑判断能力”直接对应，而其他选项（自动控制、记忆、高速运算）虽属计算机特性，但未在题干中体现。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (488, 1, '计算机能够在各行各业得到广泛的应用，是因为计算机具有()。', '{\"A\": \"高速运算能力\", \"B\": \"逻辑判断能力\", \"C\": \"很强的通用性\", \"D\": \"自动控制能力\"}', 'C', '2026-09-13 09:51:10.595701', '2026-09-13 09:51:10.595701', '解析：计算机之所以能在各行各业广泛应用，是因为它具有很强的通用性，能够通过不同的软件和硬件配置适应各种任务需求，而高速运算、逻辑判断和自动控制能力仅是通用性基础上的具体功能体现。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (489, 1, '计算机用户可挑选购买不同厂家生产的计算机配件DIY,配置成一台完整的电脑，这体现了计算机具有()。', '{\"A\": \"包容性\", \"B\": \"统一性\", \"C\": \"适应性\", \"D\": \"兼容性\"}', 'D', '2026-09-13 09:51:10.601685', '2026-09-13 09:51:10.601685', '解析：计算机不同厂家生产的配件能相互配合工作，这体现了计算机系统的兼容性，即各部件之间可以协同运行，因此正确答案是D。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (490, 1, '计算机在科学计算上的应用就是利用了计算机的一些特点,下列哪个不是计算机的特点()。', '{\"A\": \"存储容量大\", \"B\": \"运算速度快\", \"C\": \"自动化程度高\", \"D\": \"性价比高\"}', 'D', '2026-09-13 09:51:10.608666', '2026-09-13 09:51:10.608666', '解析：计算机在科学计算上的主要特点包括存储容量大、运算速度快和自动化程度高，而性价比高并非其固有技术特点，而是经济性评价，因此选D。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (491, 1, '计算机之所以能自动连续运算,是由于采用了()工作原理。', '{\"A\": \"布尔逻辑\", \"B\": \"超大规模集成电路\", \"C\": \"存储程序\", \"D\": \"数字电路\"}', 'C', '2026-09-13 09:51:10.614650', '2026-09-13 09:51:10.614650', '解析：计算机能自动连续运算的核心在于“存储程序”原理，即程序和数据预先存储在内存中，CPU按顺序自动取指令并执行，从而实现连续运算。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (492, 1, '将计算机分为巨型计算机、大型机、小型机、微型计算机和工作站的分类标准是()。', '{\"A\": \"计算机处理数据的方式\", \"B\": \"计算机的使用范围\", \"C\": \"计算机的规模和处理能力\", \"D\": \"计算机出现的时间\"}', 'C', '2026-09-13 09:51:10.620634', '2026-09-13 09:51:10.620634', '解析：该分类标准依据计算机的运算速度、存储容量、字长等性能指标，即规模和处理能力，因此选C。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (493, 1, '巨型电子计算机指的是()。', '{\"A\": \"体积大\", \"B\": \"重量大\", \"C\": \"功能强\", \"D\": \"耗电量大\"}', 'C', '2026-09-13 09:51:10.626618', '2026-09-13 09:51:10.626618', '解析：巨型电子计算机的“巨”并非指物理尺寸或能耗，而是指其运算速度快、处理能力强，因此正确答案是C。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (494, 1, '某型计算机的运算峰值性能为数千亿次/秒，主要用于大型科学与工程计算和大规模数据处理，它属于()。', '{\"A\": \"巨型计算机\", \"B\": \"小型计算机\", \"C\": \"微型计算机\", \"D\": \"工作站\"}', 'A', '2026-09-13 09:51:10.632603', '2026-09-13 09:51:10.632603', '解析：巨型计算机运算峰值性能可达数千亿次/秒，专用于大型科学与工程计算和大规模数据处理，符合该题目描述，因此选A。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (495, 1, '下列叙述中，正确的是()。', '{\"A\": \"计算机的体积越大，其功能越强\", \"B\": \"CD-ROM的容量比硬盘的容量大\", \"C\": \"存储器具有记忆功能，故其中的信息任何时候都不会丢失\", \"D\": \"CPU是中央处理器的简称\"}', 'D', '2026-09-13 09:51:10.639584', '2026-09-13 09:51:10.639584', '解析：选项D正确，因为CPU是中央处理器（Central Processing Unit）的简称。选项A错误，计算机功能与体积无直接关系；选项B错误，CD-ROM容量通常远小于硬盘；选项C错误，存储器信息在断电后会丢失（如RAM）。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (496, 1, '个人计算机属于()。', '{\"A\": \"小巨型机\", \"B\": \"中型机\", \"C\": \"小型机\", \"D\": \"微机\"}', 'D', '2026-09-13 09:51:10.645568', '2026-09-13 09:51:10.645568', '解析：个人计算机（PC）是微型计算机的简称，属于微机范畴，而小巨型机、中型机、小型机均属于更大规模或更高性能的计算机类型，因此正确答案为D。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (497, 1, '计算机的五个特点描述全面的是()。', '{\"A\": \"运算速度快、精度高、具有记忆（存储）能力、具有逻辑判断功能、自动化程度高\", \"B\": \"运算速度快、价格贵、具有记忆（存储）能力、具有逻辑判断功能、自动化程度高\", \"C\": \"运算速度快、精度高、具有记忆（存储）能力、具有逻辑判断功能、传输速度快\", \"D\": \"运算速度快、价格贵、具有记忆（存储）能力、具有逻辑判断功能、传输速度快\"}', 'A', '2026-09-13 09:51:10.651552', '2026-09-13 09:51:10.651552', '解析：计算机的五个基本特点包括运算速度快、精度高、具有记忆（存储）能力、具有逻辑判断功能和自动化程度高，选项A完整覆盖了这些特点，而其他选项错误地包含了“价格贵”或“传输速度快”，这些并非计算机的通用描述特点。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (498, 1, '按照计算机性能，可划分为()。', '{\"A\": \"超级计算机、巨型机、大型机、小型机\", \"B\": \"巨型机、大型机、小型机、微型机\", \"C\": \"大容量机、小容量机，微型机\", \"D\": \"工作站、服务器、个人机\"}', 'B', '2026-09-13 09:51:10.658533', '2026-09-13 09:51:10.658533', '解析：计算机按性能划分，通常分为巨型机、大型机、小型机和微型机，其中巨型机即超级计算机，因此B选项的分类标准最准确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (499, 1, '计算机按照用途分类，可分为()。', '{\"A\": \"服务器、PC机\", \"B\": \"服务器、通用机\", \"C\": \"专用机、通用机\", \"D\": \"专用机、服务器\"}', 'C', '2026-09-13 09:51:10.664517', '2026-09-13 09:51:10.664517', '解析：计算机按用途分为通用机和专用机，通用机用于多种任务，专用机用于特定用途，因此选项C正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (500, 1, '计算机按照原理分为()。', '{\"A\": \"专用机、通用机、混合机\", \"B\": \"专用机、通用机、服务器\", \"C\": \"工业机、个人机、混合机\", \"D\": \"数字机、模拟机、混合机\"}', 'D', '2026-09-13 09:51:10.670501', '2026-09-13 09:51:10.670501', '解析：计算机按照原理分为数字机、模拟机和混合机，这是基于其处理信号类型（数字信号或模拟信号）的分类标准，其他选项如专用机、通用机等属于用途分类，不符合原理分类要求。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (501, 1, '计算机被称为“电脑”，原因是()。', '{\"A\": \"计算机的结构和人脑类似\", \"B\": \"计算机能完成人脑的全部功能\", \"C\": \"计算机能帮助人们进行信息处理\", \"D\": \"计算机能代替人的全部思维\"}', 'C', '2026-09-13 09:51:48.782184', '2026-09-13 09:51:48.782184', '解析：计算机被称为“电脑”，是因为它能帮助人们进行信息处理，模拟人脑的部分功能，但并非结构、功能或思维上的完全替代，因此只有C选项符合这一核心原因。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (502, 1, '若按计算机的性能、用途和价格进行分类，通常分为四类，有巨型计算机、大型计算机、()、个人计算机。', '{\"A\": \"小型计算机\", \"B\": \"专业计算机\", \"C\": \"通用计算机\", \"D\": \"笔记本计算机\"}', 'A', '2026-09-13 09:51:48.789166', '2026-09-13 09:51:48.789166', '解析：按计算机性能、用途和价格分类的四个类别中，巨型计算机、大型计算机、小型计算机和个人计算机是标准分类，因此选项A正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (503, 1, '计算机按信息的形式和处理方式可分为()', '{\"A\": \"电子数字计算机、电子模拟计算机、混合式电子计算机\", \"B\": \"通用机、专用机\", \"C\": \"巨型机、大型机、小型机\", \"D\": \"单片机、微型机\"}', 'A', '2026-09-13 09:51:48.797144', '2026-09-13 09:51:48.797144', '解析：计算机按信息的形式和处理方式分为电子数字计算机、电子模拟计算机和混合式电子计算机三类，A选项准确对应此分类标准；B选项按用途分类，C选项按规模分类，D选项按结构分类，均不符合题意。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (504, 1, '计算机按照用途分类可分为()。', '{\"A\": \"电子数字计算机、电子模拟计算机、混合式电子计算机\", \"B\": \"通用机、专用机\", \"C\": \"巨型机、大型机、小型机\", \"D\": \"单片机、微型机\"}', 'B', '2026-09-13 09:51:48.804126', '2026-09-13 09:51:48.804126', '解析：计算机按用途分类，主要分为通用计算机和专用计算机，选项B正确；其他选项分别按计算机的工作原理、规模或性能划分，不属于用途分类。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (505, 1, '计算机按性能分类()。', '{\"A\": \"数字计算机、模拟计算机、混合计算机\", \"B\": \"通用机、专用机\", \"C\": \"巨型机、大型机、小型机、微型机、单片机\", \"D\": \"服务器、工作站\"}', 'C', '2026-09-13 09:51:48.811107', '2026-09-13 09:51:48.811107', '解析：计算机按性能分类主要依据其运算速度、字长、存储容量等指标，分为巨型机、大型机、小型机、微型机和单片机，因此选项C正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (506, 1, '计算机按工作模式分类()。', '{\"A\": \"数字计算机、模拟计算机、混合计算机\", \"B\": \"通用机、专用机\", \"C\": \"巨型机、大型机、小型机、微型机、单片机\", \"D\": \"服务器、工作站\"}', 'D', '2026-09-13 09:51:48.818088', '2026-09-13 09:51:48.818088', '解析：计算机按工作模式分类通常分为服务器和工作站，服务器提供网络服务，工作站用于专业计算任务，其他选项（A按数据形式、B按用途、C按规模）均不符合“工作模式”这一分类标准，故正确答案为D。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (507, 1, '对于计算机特点的描述中，下列哪一项不正确()。', '{\"A\": \"运算速度快\", \"B\": \"计算精度高\", \"C\": \"功耗高\", \"D\": \"记忆功能强\"}', 'C', '2026-09-13 09:51:48.825070', '2026-09-13 09:51:48.825070', '解析：计算机的主要特点包括运算速度快、计算精度高和记忆功能强，而功耗高并非计算机的普遍特点，计算机设计通常追求低功耗，因此选项C不正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (508, 1, '同一台计算机，只要安装不同的软件或连接到不同的设备上，就可以完成不同的任务。是指计算机具有()的特性。', '{\"A\": \"高速运算的能力\", \"B\": \"极强的通用性\", \"C\": \"逻辑判断能力\", \"D\": \"很强的记忆能力\"}', 'B', '2026-09-13 09:51:48.832052', '2026-09-13 09:51:48.832052', '解析：题干强调同一台计算机通过安装不同软件或连接不同设备可完成不同任务，体现其适应多种应用场景的能力，即通用性，因此选B。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (509, 1, '下列对计算机的分类，不正确的是()。', '{\"A\": \"按使用范围可以分为通用计算机和专用计算机\", \"B\": \"按性能可以分为超级计算机、大型计算机、小型计算机、工作站和微型计算机\", \"C\": \"按CPU芯片可分为单片机、中板机、多芯片机和多板机\", \"D\": \"按字长可以分为8位机、16位机、32位机和64位机\"}', 'C', '2026-09-13 09:51:48.839032', '2026-09-13 09:51:48.839032', '解析：计算机按CPU芯片分类通常分为单芯片机、多芯片机等，而“中板机”并非标准分类，因此C项不正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (510, 1, '下列关于计算机应用领域和特点的说法()是错误的?', '{\"A\": \"计算机强大的逻辑判断能力是AI的基础\", \"B\": \"计算机最重要的特点是能自动化工作\", \"C\": \"云计算就是利用了计算机运行速度快、存储容量大、自动化程度高等特点\", \"D\": \"现代计算机能将圆周率计算到小数点后上亿位，说明了计算机具有计算速度快的特点\"}', 'B', '2026-09-13 09:51:48.846014', '2026-09-13 09:51:48.846014', '解析：B选项错误，因为计算机最重要的特点是高速运算和程序控制的自动化工作，而非单纯的“能自动化工作”，自动化只是其特性之一，并非最重要的特点。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (511, 1, '下列计算机专业术语中英文对照不正确的是？', '{\"A\": \"OS--输出服务\", \"B\": \"CPU--中央处理器\", \"C\": \"ALU--算术逻辑部件\", \"D\": \"CU--控制部件\"}', 'A', '2026-09-13 09:51:48.852995', '2026-09-13 09:51:48.852995', '解析：OS是Operating System的缩写，中文意为“操作系统”，而非“输出服务”；“输出服务”对应的英文缩写通常为O.S.（Output Service）或不常用。因此A项对照不正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (512, 1, '现代计算机系统的运算速度已达到每秒万亿次，使大量复杂的科学计算问题得以解决，下列哪一项可凸显出计算机运算速度快的特征()。', '{\"A\": \"计算机的记忆力特别强\", \"B\": \"计算机可以“交互式”解答人们的问题\", \"C\": \"计算机几分钟就能算出一个地区内数天的天气预报\", \"D\": \"计算机可以精确到圆周率的10万位\"}', 'C', '2026-09-13 09:51:48.859976', '2026-09-13 09:51:48.859976', '解析：题目问的是凸显计算机运算速度快的特征，选项C中“几分钟算出数天天气预报”直接体现了高速处理复杂计算的能力，而其他选项分别强调存储、交互或精度，与速度特征无关。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (513, 1, '以数字量作为运算对象的计算机称为()。', '{\"A\": \"电子数字计算机\", \"B\": \"电子模拟计算机\", \"C\": \"电动计算机\", \"D\": \"专用计算机\"}', 'A', '2026-09-13 09:51:48.866958', '2026-09-13 09:51:48.866958', '解析：题目中明确“以数字量作为运算对象”，即处理离散的数字信号，这符合电子数字计算机的定义。电子模拟计算机处理连续变化的模拟量，电动计算机是早期概念，专用计算机是按用途分类，均不匹配，因此选A。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (514, 1, '以下不属于电子数字计算机特点的是()。', '{\"A\": \"容量大\", \"B\": \"体积庞大\", \"C\": \"计算精度高\", \"D\": \"运算快速\"}', 'B', '2026-09-13 09:51:48.872942', '2026-09-13 09:51:48.872942', '解析：电子数字计算机的特点包括运算速度快、计算精度高、存储容量大，而“体积庞大”不是其必然特点，现代计算机趋向小型化，因此B不属于电子数字计算机的特点。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (515, 1, '在计算机中,用连续量作为运算量,速度快、精度差的计算机,我们称为()。', '{\"A\": \"电子模拟计算机\", \"B\": \"电子数字计算机\", \"C\": \"通用机\", \"D\": \"专用机\"}', 'A', '2026-09-13 09:51:48.879923', '2026-09-13 09:51:48.879923', '解析：电子模拟计算机以连续变化的物理量（如电压）表示数值进行运算，运算速度快但精度较低，符合题干描述；电子数字计算机以离散数字量运算，精度高但速度相对较慢；通用机与专用机是按用途分类，不直接涉及连续量与精度特性，因此选A。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (516, 1, '专门为某种用途而设计的数字计算机，称为()计算机。', '{\"A\": \"专用\", \"B\": \"通用\", \"C\": \"普通\", \"D\": \"模拟\"}', 'A', '2026-09-13 09:51:48.885907', '2026-09-13 09:51:48.885907', '解析：专用计算机是专门为某种特定用途而设计的数字计算机，其他选项（通用、普通、模拟）均不符合该定义。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (517, 1, '20世纪70年代后期出现的计算机系统，它配有大屏幕显示器和大容量存储器，有较强的网络通信能力，主要适用于CAD/CAM和办公自动化等领域，如美国SUN公司的SUN-3、SUN-4。这种计算机被称做()。', '{\"A\": \"工作站\", \"B\": \"大型机\", \"C\": \"小型机\", \"D\": \"微机\"}', 'A', '2026-09-13 09:51:48.892889', '2026-09-13 09:51:48.892889', '解析：该计算机系统配有大屏幕显示器、大容量存储器、强网络通信能力，适用于CAD/CAM和办公自动化，且以SUN-3、SUN-4为例，这些特征符合工作站的典型定义，因此选A。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (518, 1, '有一种可供网络用户共享,具有大容量的存储设备和丰富的外部设备,其上一般运行网络操作系统.这种计算机我们称其为()。', '{\"A\": \"小型机\", \"B\": \"微型机\", \"C\": \"服务器\", \"D\": \"工作站\"}', 'C', '2026-09-13 09:51:48.898873', '2026-09-13 09:51:48.898873', '解析：服务器专为网络环境设计，提供大容量存储、丰富外部设备并运行网络操作系统，以支持多用户共享资源，因此选项C正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (519, 1, '现代计算机之所以采用数字化技术，不是因为()。', '{\"A\": \"电子元器件的特性所决定的\", \"B\": \"运算规则简单，简化了计算机设计\", \"C\": \"抗干扰能力强，机器可靠性高\", \"D\": \"能够实现程序的自动化运行\"}', 'D', '2026-09-13 09:51:48.907849', '2026-09-13 09:51:48.907849', '解析：现代计算机采用数字化技术的主要原因包括电子元器件的特性（A）、运算规则简单（B）以及抗干扰能力强、可靠性高（C）。而程序的自动化运行并非数字化技术独有的特点，模拟计算机也能实现，故D项不是采用数字化技术的原因。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (520, 1, '通用计算机按其规模、速度和功能等可分为()。', '{\"A\": \"电子管计算机、晶体管计算机、集成电路计算机\", \"B\": \"台式计算机、便携式计算机、嵌入型计算机\", \"C\": \"巨型机、大型机、中型机、小型机和微型机\", \"D\": \"8位机、10位机、32位机、64位机\"}', 'C', '2026-09-13 09:51:48.913833', '2026-09-13 09:51:48.913833', '解析：按规模、速度和功能分类，通用计算机通常分为巨型机、大型机、中型机、小型机和微型机，因此选项C正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (521, 1, '下列选项中不合法的IP地址是（）。', '{\"A\": \"213.113.7.15\", \"B\": \"223.226.1.68\", \"C\": \"190.256.38.8\", \"D\": \"126.96.2.16\"}', 'C', '2026-09-13 09:51:48.920814', '2026-09-13 09:51:48.920814', '解析：IP地址由四个字节组成，每个字节的取值范围是0到255。选项C中的“256”超出了这个范围，因此不合法。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (522, 1, '衡量计算机的主要性能指标除了字长、存取周期、运算速度之外，一般还包括()，因为其反映了()。', '{\"A\": \"外部设备数量、该计算机保存大量信息的水平\", \"B\": \"计算机的制造成本、存储器读写速度\", \"C\": \"主存储器容量大小、计算机即时存储信息的水平\", \"D\": \"计算机的体积、每秒钟所能执行的指令条数\"}', 'C', '2026-09-13 09:51:48.926351', '2026-09-13 09:51:48.926351', '解析：主存储器容量大小是计算机的主要性能指标之一，因为它反映了计算机即时存储信息的水平，即能够同时处理的数据量大小，故选项C正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (523, 1, '小敏同学到市场上根据自己的需求购置各种计算机硬件拼装，这体现了计算机硬件之间具有()。', '{\"A\": \"统一性\", \"B\": \"适应性\", \"C\": \"兼容性\", \"D\": \"包容性\"}', 'C', '2026-09-13 09:51:48.933333', '2026-09-13 09:51:48.933333', '解析：计算机硬件拼装时需要不同厂商的部件协同工作，这要求硬件之间能够相互匹配和正常运行，即具备兼容性。因此，选项C正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (524, 1, '计算机内所有信息形式为连续变化的电压，这种计算机多用于工业生产中的自动控制，这种计算机称为()。', '{\"A\": \"数字计算机\", \"B\": \"模拟计算机\", \"C\": \"小型机\", \"D\": \"微机\"}', 'B', '2026-09-13 09:51:48.939316', '2026-09-13 09:51:48.939316', '解析：模拟计算机处理连续变化的电压信号，适用于工业自动控制，而数字计算机处理离散数字信号，因此选B。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (525, 1, '从1940年代开始至今，经过几十年的发展，冯·诺依曼体系结构有了很大的变化，下列选项中()没有变化。', '{\"A\": \"运算器和控制器做在了一起\", \"B\": \"采用总线结构连接各个部件\", \"C\": \"计算机内采用二进制形式来表示数据\", \"D\": \"存储器明确划分成内存和外存\"}', 'C', '2026-09-13 09:51:48.945301', '2026-09-13 09:51:48.945301', '解析：冯·诺依曼体系结构自提出以来，其核心特征之一就是计算机内部采用二进制形式来表示数据和指令，这一原则至今未变。其他选项中，运算器与控制器的集成方式、总线结构的具体实现以及存储器的层次划分都随着技术发展发生了显著变化。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (526, 1, '将计算机分为通用计算机、专用计算机两类的分类标准是()。', '{\"A\": \"计算机处理数据的方式\", \"B\": \"计算机使用范围\", \"C\": \"机器的规模\", \"D\": \"计算机的处理能力\"}', 'B', '2026-09-13 09:51:48.951285', '2026-09-13 09:51:48.951285', '解析：计算机按使用范围分类，可分为通用计算机和专用计算机，通用计算机适用于多种任务，专用计算机专用于特定领域。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (527, 1, '只要根据需要编制程序并输入计算机，计算机就可以完成预定任务，这是因为计算机具有()。', '{\"A\": \"高速运算能力\", \"B\": \"逻辑判断能力\", \"C\": \"很高的计算精度\", \"D\": \"自动控制能力\"}', 'D', '2026-09-13 09:51:48.958266', '2026-09-13 09:51:48.958266', '解析：计算机能够根据输入的程序自动执行预定任务，这依赖于其自动控制能力，即无需人工干预即可按指令序列完成操作，而高速运算、逻辑判断和计算精度虽为计算机特性，但并非实现“按程序自动完成任务”的直接原因。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (528, 1, '电子计算机具有()。', '{\"A\": \"自己编程的能力\", \"B\": \"存储记忆的能力\", \"C\": \"解决问题的能力\", \"D\": \"思维的能力\"}', 'B', '2026-09-13 09:51:48.965247', '2026-09-13 09:51:48.965247', '解析：电子计算机的核心功能之一是能够存储数据和指令，即存储记忆的能力，这是其基本特性，而其他选项（如自己编程、解决问题、思维）需要人为干预或高级人工智能支持，并非计算机固有属性。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (529, 1, '计算机有许多应用领域，这说明计算机具有()。', '{\"A\": \"通用性\", \"B\": \"高可靠性\", \"C\": \"廉价性\", \"D\": \"普遍性\"}', 'A', '2026-09-13 09:51:48.971231', '2026-09-13 09:51:48.971231', '解析：计算机能够广泛应用于不同领域，是因为它可以通过软件实现多种功能，具备处理多种任务的能力，这种特性称为通用性，因此选A。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (530, 1, '某型计算机峰值性能为数千亿次/秒，主要用于大型科学与工程计算和大规模数据处理，它属于()。', '{\"A\": \"巨型计算机\", \"B\": \"小型计算机\", \"C\": \"微型计算机\", \"D\": \"专用计算机\"}', 'A', '2026-09-13 09:51:48.978212', '2026-09-13 09:51:48.978212', '解析：峰值性能为数千亿次/秒属于巨型计算机的典型特征，巨型计算机专门用于大型科学与工程计算和大规模数据处理，符合题目描述。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (531, 1, '下列说法中，关于计算机的特点叙述错误的是()。', '{\"A\": \"具有自动控制能力\", \"B\": \"具有高速运算的能力\", \"C\": \"具有很高的计算精度\", \"D\": \"具有创造能力\"}', 'D', '2026-09-13 09:51:48.984197', '2026-09-13 09:51:48.984197', '解析：计算机只能按照预设的程序执行指令，不具备自主创造能力，因此选项D错误。其他选项均为计算机的基本特点。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (532, 1, '基于存储程序使得计算机能够实现()。', '{\"A\": \"自动处理\", \"B\": \"很高的计算精度\", \"C\": \"进行高速运算\", \"D\": \"具有记忆能力\"}', 'A', '2026-09-13 09:51:48.990181', '2026-09-13 09:51:48.990181', '解析：存储程序概念的核心是将指令和数据预先存入内存，计算机按顺序自动执行，无需人工干预，因此实现了自动处理功能。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (533, 1, '“现代计算机速度最高可达每秒千亿次运算，…”，该描述说明计算机具有()。', '{\"A\": \"自动控制能力\", \"B\": \"高速运算的能力\", \"C\": \"很高的计算精度\", \"D\": \"逻辑判断能力\"}', 'B', '2026-09-13 09:51:48.996165', '2026-09-13 09:51:48.996165', '解析：题目中“速度最高可达每秒千亿次运算”直接体现了计算机在单位时间内执行大量运算的能力，因此正确答案为B：高速运算的能力。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (534, 1, '计算机之所以具有很强大的记忆能力，是由于()。', '{\"A\": \"计算机中使用了二进制\", \"B\": \"计算机工作时编制了程序\", \"C\": \"计算机中有大量的存储设备\", \"D\": \"计算机内部使用了电源\"}', 'C', '2026-09-13 09:51:49.003146', '2026-09-13 09:51:49.003146', '解析：计算机的记忆能力依赖于其存储设备，这些设备（如内存、硬盘等）能够保存数据和程序，因此选择C。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (535, 1, '目前使用的计算机具有判断推理能力，说明()。', '{\"A\": \"计算机可以代替人脑\", \"B\": \"计算机的计算精度高\", \"C\": \"计算机具有逻辑运算能力\", \"D\": \"计算机具有创造能力\"}', 'C', '2026-09-13 09:51:49.009130', '2026-09-13 09:51:49.009130', '解析：计算机具有判断推理能力，本质上是因为其硬件和软件能够执行逻辑运算，如与、或、非等操作，从而模拟推理过程，因此选C。其他选项如代替人脑、计算精度高或创造能力，均与判断推理能力的直接原因无关。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (536, 1, '下列不属于计算机特点的是()。', '{\"A\": \"存储程序控制，工作自动化\", \"B\": \"具有逻辑推理和判断能力\", \"C\": \"处理速度快、存储量大\", \"D\": \"不可靠、故障率高\"}', 'D', '2026-09-13 09:51:49.015114', '2026-09-13 09:51:49.015114', '解析：计算机的特点包括存储程序控制、工作自动化、具有逻辑推理和判断能力、处理速度快、存储量大，而不可靠、故障率高不属于计算机的特点，因此选D。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (537, 1, '处理和输出数字和模拟量的计算机是()。', '{\"A\": \"电子数字计算机\", \"B\": \"电子模拟计算机\", \"C\": \"数模混合计算机\", \"D\": \"专用计算机\"}', 'C', '2026-09-13 09:51:49.022095', '2026-09-13 09:51:49.022095', '解析：数模混合计算机能够同时处理数字量和模拟量，而电子数字计算机只处理数字量，电子模拟计算机只处理模拟量，专用计算机则是针对特定任务设计，因此正确答案是C。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (538, 1, '2019年11月3日超级快递“胖五”发射成功的新闻不断刷屏，实际在背后隐没一个功臣，它为运载火箭“长征5号”运行轨迹的高速、精确计算保驾护航，具有这样功能的计算机一般是()。', '{\"A\": \"巨型计算机\", \"B\": \"大型计算机\", \"C\": \"微型计算机\", \"D\": \"小型计算机\"}', 'A', '2026-09-13 09:51:49.028079', '2026-09-13 09:51:49.028079', '解析：运载火箭轨迹计算需要极高的运算速度和精度，巨型计算机具备超强计算能力，能够满足“长征5号”这类复杂航天任务的高速、精确计算需求，因此应选A。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (539, 1, '电子计算机按使用范围的不同可以分为()。', '{\"A\": \"通用计算机和专用计算机\", \"B\": \"电子数字计算机和电子模拟计算机\", \"C\": \"巨型计算机、大中型机、小型计算机和微型计算机\", \"D\": \"科学与过程计算计算机、工业控制计算机和军事数据计算机\"}', 'A', '2026-09-13 09:51:49.036058', '2026-09-13 09:51:49.036058', '解析：电子计算机按使用范围可分为通用计算机和专用计算机，通用计算机适用多种任务，专用计算机用于特定领域，其他分类方式均不符合题意。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (540, 1, '电子计算机的基本特征是()。', '{\"A\": \"运算速度快、计算精度高\", \"B\": \"存储容量大\", \"C\": \"逻辑运算能力强\", \"D\": \"上述所有\"}', 'D', '2026-09-13 09:51:49.042042', '2026-09-13 09:51:49.042042', '解析：电子计算机的基本特征包括运算速度快、计算精度高、存储容量大以及逻辑运算能力强，因此选项A、B、C均为其基本特征，故正确答案为D。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (541, 1, '关于嵌入式计算机的叙述中，错误的是()。', '{\"A\": \"大部分嵌入式计算机把软件固化在芯片上\", \"B\": \"嵌入式计算机通常应满足实时处理、最小功耗、最小存储的性能要求\", \"C\": \"嵌入式计算机的工作原理与PC相比有很大差别\", \"D\": \"嵌入式计算机是安装在其他设备中的计算机\"}', 'C', '2026-09-13 09:51:49.049023', '2026-09-13 09:51:49.049023', '解析：嵌入式计算机的工作原理与PC基本相似，均基于冯·诺依曼架构，选项C的说法错误；其他选项均符合嵌入式计算机的特点。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (542, 1, '国际上对计算机进行分类的依据是()。', '{\"A\": \"计算机的型号\", \"B\": \"计算机的速度\", \"C\": \"计算机的性能\", \"D\": \"计算机生产厂家\"}', 'C', '2026-09-13 09:51:49.055007', '2026-09-13 09:51:49.055007', '解析：国际上通常根据计算机的性能（如处理能力、运算速度、存储容量等）进行分类，而不是型号、速度或生产厂家，因此正确答案是C。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (543, 1, '计算机按处理数据的形态可以分为()。', '{\"A\": \"巨型机、大型机、中型机、小型机、微机和工作站\", \"B\": \"通用机、专用机\", \"C\": \"数字计算机、模拟计算机和混合计算机\", \"D\": \"兼容机和品牌机\"}', 'C', '2026-09-13 09:51:49.060991', '2026-09-13 09:51:49.060991', '解析：计算机按处理数据的形态分类，即根据数据表示方式分为数字计算机（处理离散数字信号）、模拟计算机（处理连续模拟信号）和混合计算机（兼具两者功能）。选项C准确对应此分类依据。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (544, 1, '计算机按用途可以分为()。', '{\"A\": \"数字计算机、模拟计算机\", \"B\": \"通用计算机、专用计算机\", \"C\": \"超级计算机、巨型计算机、大型计算机、小型机、微机\", \"D\": \"单片机、单板机、嵌入式计算机\"}', 'B', '2026-09-13 09:51:49.067973', '2026-09-13 09:51:49.067973', '解析：计算机按用途可分为通用计算机和专用计算机，通用计算机用于多种任务，专用计算机用于特定领域，因此选项B正确。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (545, 1, '规模小、结构简单、成本低，而且操作简便、容易维护的计算机是()。', '{\"A\": \"巨型机\", \"B\": \"大型机\", \"C\": \"小型机\", \"D\": \"微型\"}', 'D', '2026-09-13 09:51:49.073957', '2026-09-13 09:51:49.073957', '解析：微型计算机具有规模小、结构简单、成本低、操作简便且易于维护的特点，因此正确答案是D。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (546, 1, '计算机的“逻辑判断能力”是指()。', '{\"A\": \"计算机拥有很大的存储装置\", \"B\": \"计算机是由程序规定其操作过程\", \"C\": \"计算机的运算速度很高远远高于人的计算机速度\", \"D\": \"计算机能够进行逻辑运算，并根据逻辑运算的结果选择相应的处理\"}', 'D', '2026-09-13 09:51:49.080558', '2026-09-13 09:51:49.080558', '解析：计算机的“逻辑判断能力”特指其能够执行逻辑运算（如与、或、非），并根据运算结果自动选择后续处理路径，这是通过程序实现的决策功能。选项D直接体现了这一能力。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (547, 1, '社会发展至今,人类赖以生存和发展的基础资源有', '{\"A\": \"信息、知识、经济\", \"B\": \"物质、能源、信息\", \"C\": \"通讯、材料、信息\", \"D\": \"工业、农业、轻工业\"}', 'B', '2026-09-13 09:51:49.087543', '2026-09-13 09:51:49.087543', '解析：物质、能源、信息是人类社会赖以生存和发展的三大基础资源，其中物质提供实体基础，能源驱动生产和生活，信息支撑决策与交流，其他选项均不完整或偏离核心资源范畴。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (548, 1, '关于信息的说法，错误的是()', '{\"A\": \"信息必须通过载体传输\", \"B\": \"信息有多种传播形式\", \"C\": \"信息是可以共享的\", \"D\": \"载体本身就是信息\"}', 'D', '2026-09-13 09:51:49.093527', '2026-09-13 09:51:49.093527', '解析：载体是信息传输的媒介，如文字、声音、图像等，其本身并不等同于信息，信息是载体所承载的内容，因此D选项表述错误。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (549, 1, '信息技术的定义是', '{\"A\": \"利用计算机技术获取、处理和传输信息\", \"B\": \"运用信息技术解决实际问题\", \"C\": \"学习计算机的基本知识和技能\", \"D\": \"开发和设计计算机软件和硬件\"}', 'A', '2026-09-13 09:51:49.099511', '2026-09-13 09:51:49.099511', '解析：信息技术的核心是借助计算机技术对信息进行获取、处理和传输，选项A完整概括了这一本质，其他选项仅涉及部分应用或技能。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (550, 1, '以数字量作为运算对象的计算机称为', '{\"A\": \"电子数字计算机\", \"B\": \"电子模拟计算机\", \"C\": \"电动计算机\", \"D\": \"专用计算机\"}', 'A', '2026-09-13 09:51:49.106492', '2026-09-13 09:51:49.106492', '解析：数字量是指离散的数值形式，电子数字计算机以数字量（如二进制）进行运算，因此选项A正确。其他选项中，电子模拟计算机处理连续模拟量，电动计算机和专用计算机均不特指以数字量为运算对象。', 3, 2, 4, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (551, 1, '世界上第一台电子计算机ENIAC诞生于哪个年代（）', '{\"A\": \"1930年代\", \"B\": \"1940年代\", \"C\": \"1950年代\", \"D\": \"1960年代\"}', 'B', '2026-09-13 09:54:37.032574', '2026-09-13 09:54:37.032574', '解析：ENIAC（电子数字积分计算机）于1946年在美国宾夕法尼亚大学诞生，属于1940年代，因此正确答案是B。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (552, 1, '以下哪个不是计算机发展的主要阶段（）', '{\"A\": \"电子管计算机\", \"B\": \"晶体管计算机\", \"C\": \"集成电路计算机\", \"D\": \"硅芯片计算机\"}', 'D', '2026-09-13 09:54:37.040552', '2026-09-13 09:54:37.040552', '解析：计算机发展的主要阶段依次为电子管、晶体管和集成电路计算机，硅芯片属于集成电路的一种具体实现技术，并非独立的发展阶段。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (553, 1, '冯·诺依曼提出的计算机体系结构中，不包括以下哪个组成部分()', '{\"A\": \"运算器\", \"B\": \"控制器\", \"C\": \"存储器\", \"D\": \"显示器\"}', 'D', '2026-09-13 09:54:37.047534', '2026-09-13 09:54:37.047534', '解析：冯·诺依曼体系结构包括运算器、控制器、存储器和输入输出设备，显示器属于输出设备而非核心组成部分，因此选D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (554, 1, '“摩尔定律”是由哪位科学家提出的（）', '{\"A\": \"艾伦·图灵\", \"B\": \"戈登·摩尔\", \"C\": \"冯·诺依曼\", \"D\": \"比尔·盖茨\"}', 'B', '2026-09-13 09:54:37.054515', '2026-09-13 09:54:37.054515', '解析：摩尔定律由英特尔联合创始人戈登·摩尔于1965年提出，指出集成电路上可容纳的晶体管数量约每两年翻一番，因此正确答案为B。其他选项与摩尔定律的提出无关。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (555, 1, '哪个公司推出了第一台个人计算机（PC）（）', '{\"A\": \"IBM\", \"B\": \"Apple\", \"C\": \"Microsoft\", \"D\": \"Intel\"}', 'A', '2026-09-13 09:54:37.061497', '2026-09-13 09:54:37.061497', 'IBM在1981年推出了IBM 5150，被广泛认为是第一台个人计算机（PC），其开放架构奠定了PC行业标准。其他选项中，Apple虽早期推出Apple II，但并非首个定义为“PC”的产品；Microsoft和Intel分别提供软件和硬件，未直接推出整机。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (556, 1, '“操作系统”的概念最早是在哪个时代提出的（）', '{\"A\": \"第一代计算机时代\", \"B\": \"第二代计算机时代\", \"C\": \"第三代计算机时代\", \"D\": \"第四代计算机时代\"}', 'B', '2026-09-13 09:54:37.068478', '2026-09-13 09:54:37.068478', '解析：操作系统概念最早在第二代计算机时代（晶体管时代）提出，此时为了管理批处理任务和简化操作，出现了监督程序（早期操作系统雏形）。第一代无操作系统，第三代及之后操作系统已成熟。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (557, 1, '中国第一台电子计算机的诞生标志着中国计算机技术的发展迈出了重要的一步。请问，中国第一台电子计算机是何时诞生的（）', '{\"A\": \"1956年\", \"B\": \"1958年\", \"C\": \"1960年\", \"D\": \"1972年\"}', 'B', '2026-09-13 09:54:37.075459', '2026-09-13 09:54:37.075459', '解析：中国第一台电子计算机是103型计算机，于1958年研制成功，标志着中国计算机技术的起步，因此正确答案为B。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (558, 1, '在中国计算机发展史上，以下哪个事件标志着中国进入了亿次巨型机时代（）', '{\"A\": \"1983年国防科技大学研发成功“银河-I”超级计算机\", \"B\": \"1993年国家智能计算机研究开发中心研发成功“曙光一号”\", \"C\": \"1995年曙光机研制成功，我国成为世界上第四个研制成功千万亿次计算机的国家\", \"D\": \"2009年“天河一号”超级计算机研制成功\"}', 'A', '2026-09-13 09:54:37.082440', '2026-09-13 09:54:37.082440', '解析：1983年国防科技大学成功研发“银河-I”超级计算机，其运算速度达到每秒亿次，标志着中国进入了亿次巨型机时代。因此正确答案是A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (559, 1, '以下关于计算机发展史的描述，哪一项是正确的（）', '{\"A\": \"第一代计算机主要使用电子管作为基本电子器件，运算速度较慢\", \"B\": \"第二代计算机相比第一代计算机，运算速度降低，但体积更小\", \"C\": \"第三代计算机普遍采用大规模集成电路，并开始应用于社会各个领域\", \"D\": \"第四代计算机从1990年开始，以量子计算机为主要发展方向\"}', 'A', '2026-09-13 09:54:37.089422', '2026-09-13 09:54:37.089422', '解析：A选项正确，因为第一代计算机确实以电子管为核心器件，运算速度相对较慢；B选项错误，第二代计算机运算速度提升而非降低；C选项错误，第三代计算机采用中、小规模集成电路，而非大规模集成电路；D选项错误，第四代计算机以微处理器为核心，量子计算机并非其主要发展方向。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (560, 1, '以下关于我国计算机发展历程的描述，哪一项是正确的（）', '{\"A\": \"我国第一台计算机是在1953年研制成功的\", \"B\": \"我国第一台运算速度达到1亿次的计算机是银河-II型\", \"C\": \"我国在20世纪80年代初成功研制出银河系列计算机\", \"D\": \"我国计算机发展一直落后于国际先进水平\"}', 'C', '2026-09-13 09:54:37.096403', '2026-09-13 09:54:37.096403', '解析：选项A错误，我国第一台计算机“103机”于1958年研制成功，而非1953年；选项B错误，我国第一台运算速度达1亿次的计算机是银河-I型，银河-II型速度更快；选项C正确，银河系列计算机始于20世纪80年代初，1983年银河-I型研制成功；选项D错误，我国计算机发展部分领域已接近或领先国际水平。因此选C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (561, 1, '在计算机发展史上，以下哪个人物被誉为“计算机之父”（）', '{\"A\": \"AlanTuring\", \"B\": \"JohnvonNeumann\", \"C\": \"CharlesBabbage\", \"D\": \"AdaLovelace\"}', 'B', '2026-09-13 09:54:37.103385', '2026-09-13 09:54:37.103385', '约翰·冯·诺依曼（John von Neumann）提出了存储程序概念和冯·诺依曼体系结构，奠定了现代计算机设计的基础，因此被誉为“计算机之父”。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (562, 1, '计算机的发展历程中，哪个阶段标志着计算机技术的成熟（）', '{\"A\": \"电子管时代\", \"B\": \"晶体管时代\", \"C\": \"集成电路时代\", \"D\": \"超大规模集成电路时代\"}', 'D', '2026-09-13 09:54:37.111363', '2026-09-13 09:54:37.111363', '解析：超大规模集成电路时代（选项D）标志着计算机技术的成熟，因为该阶段实现了高集成度、低功耗和高性能，使得计算机微型化、普及化并广泛应用于各领域，而前三个时代（电子管、晶体管、集成电路）均处于技术发展的早期或过渡阶段，尚未达到成熟标准。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (563, 1, '在计算机发展史中，以下哪项技术不是用于提高计算机性能的关键技术（）', '{\"A\": \"二进制系统\", \"B\": \"集成电路\", \"C\": \"高速缓存（Cache）\", \"D\": \"触摸屏技术\"}', 'D', '2026-09-13 09:54:37.118345', '2026-09-13 09:54:37.118345', '解析：二进制系统、集成电路和高速缓存都是直接提升计算机运算速度或效率的关键技术，而触摸屏技术主要用于改善人机交互体验，不直接提高计算机性能，因此选D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (564, 1, '关于我国计算机发展历程，以下哪项描述是正确的（）', '{\"A\": \"我国第一台电子计算机于1946年研制成功\", \"B\": \"我国第一台大型电子数字计算机是晶体管计算机\", \"C\": \"我国计算机发展经历了从电子管到超大规模集成电路的四个阶段\", \"D\": \"我国计算机发展水平已经超越所有发达国家\"}', 'C', '2026-09-13 09:54:37.124328', '2026-09-13 09:54:37.124328', '解析：选项A错误，因为我国第一台电子计算机于1958年研制成功，而非1946年；选项B错误，我国第一台大型电子数字计算机是电子管计算机（如103机），而非晶体管计算机；选项C正确，我国计算机发展确实经历了电子管、晶体管、集成电路、超大规模集成电路四个阶段；选项D错误，我国计算机发展水平虽进步显著，但尚未超越所有发达国家。因此，正确答案是C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (565, 1, '以下哪项不属于计算机发展的四个阶段（）', '{\"A\": \"电子管计算机\", \"B\": \"晶体管计算机\", \"C\": \"集成电路计算机\", \"D\": \"石墨烯计算机\"}', 'D', '2026-09-13 09:54:37.131310', '2026-09-13 09:54:37.131310', '解析：计算机发展的四个阶段分别为电子管计算机、晶体管计算机、集成电路计算机和大规模集成电路计算机，而石墨烯计算机尚未被列为传统发展阶段，因此选D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (566, 1, '以下哪项是我国计算机发展历史上的重要事件（）', '{\"A\": \"1956年制定《十二年科学技术发展规划》\", \"B\": \"1978年改革开放\", \"C\": \"2001年中国加入WTO\", \"D\": \"2010年上海世博会\"}', 'A', '2026-09-13 09:54:37.137294', '2026-09-13 09:54:37.137294', '解析：《十二年科学技术发展规划》是1956年我国制定的首个长期科技规划，其中将计算机技术列为重点发展项目，标志着我国计算机事业的正式起步，因此是计算机发展史上的重要事件。其他选项虽属重大历史事件，但与计算机发展的直接关联较弱。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (567, 1, '标志着中国计算机产业开始走向自主设计、自主制造阶段的事件是（）', '{\"A\": \"1958年，中国第一台晶体管计算机诞生\", \"B\": \"1956年，中国第一台电子管计算机试制成功\", \"C\": \"1970年代初，DJS-130小型计算机研制成功\", \"D\": \"1983年，银河一号巨型计算机研制成功\"}', 'C', '2026-09-13 09:54:37.144306', '2026-09-13 09:54:37.144306', '解析：DJS-130小型计算机是中国首台自行设计、自行制造的小型计算机，标志着中国计算机产业从仿制转向自主设计、自主制造阶段，因此选C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (568, 1, '中国首个超级计算机进入全球500强排名的时间是（）', '{\"A\": \"1995年\", \"B\": \"1999年\", \"C\": \"2001年\", \"D\": \"2005年\"}', 'B', '2026-09-13 09:54:37.150291', '2026-09-13 09:54:37.150291', '解析：中国首个超级计算机“神威I”于1999年进入全球超级计算机500强排名，因此正确答案是B选项。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (569, 1, '计算机的冯·诺依曼体系结构包括以下哪项？', '{\"A\": \"中央处理器\", \"B\": \"硬盘存储\", \"C\": \"操作系统\", \"D\": \"网络连接\"}', 'A', '2026-09-13 09:54:37.156271', '2026-09-13 09:54:37.156271', '解析：冯·诺依曼体系结构核心包含运算器、控制器、存储器、输入设备和输出设备，中央处理器（CPU）集成运算器和控制器，是必备部件；硬盘、操作系统、网络连接均为外部或软件部分，不属于该结构的基础组成部分。因此选A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (570, 1, '计算机发展历史上的“第二代”主要是指？', '{\"A\": \"使用电子管的计算机\", \"B\": \"使用晶体管的计算机\", \"C\": \"使用集成电路的计算机\", \"D\": \"使用大规模集成电路的计算机\"}', 'B', '2026-09-13 09:54:37.163249', '2026-09-13 09:54:37.163249', '解析：计算机发展历史上，第二代计算机主要采用晶体管作为核心元件，取代了第一代的电子管，因此正确答案是B。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (571, 1, '计算机一般被划分成四代，这主要是根据()来划分的。', '{\"A\": \"计算机的功能\", \"B\": \"计算机的体积\", \"C\": \"计算机所使用的元器件\", \"D\": \"计算机的价格\"}', 'C', '2026-09-13 09:54:37.169236', '2026-09-13 09:54:37.169236', '解析：计算机的代际划分主要依据其所使用的核心元器件（如电子管、晶体管、集成电路等），因为这直接决定了计算机的性能、体积和成本等特征，因此选C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (572, 1, '关于第一台电子计算机的说法错误的是（)', '{\"A\": \"第一台电子计算机于1946年在美国诞生\", \"B\": \"第一台电子计算机主要用于军事用途\", \"C\": \"第一台电子计算机使用了存储器\", \"D\": \"第一台电子计算机的主要电子器件是电子管\"}', 'C', '2026-09-13 09:54:37.176220', '2026-09-13 09:54:37.176220', '第一台电子计算机ENIAC没有使用存储器，其程序是通过插拔线路和开关来设置的，因此选项C错误。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (573, 1, '第三代计算机元器件为（）', '{\"A\": \"电子管\", \"B\": \"继电器\", \"C\": \"晶体管\", \"D\": \"集成电路\"}', 'D', '2026-09-13 09:54:37.182205', '2026-09-13 09:54:37.182205', '解析：第三代计算机（1965-1971年）采用中小规模集成电路作为主要元器件，因此正确答案是D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (574, 1, '个人使用的计算机即微机诞生于（）阶段。', '{\"A\": \"第一代计算机\", \"B\": \"第二代计算机\", \"C\": \"第三代计算机\", \"D\": \"第四代计算机\"}', 'D', '2026-09-13 09:54:37.188185', '2026-09-13 09:54:37.188185', '解析：个人计算机（微机）诞生于第四代计算机阶段，因为第四代计算机采用大规模和超大规模集成电路，使得计算机体积缩小、成本降低，从而推动了个人计算机的普及。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (575, 1, '计算机科学的奠基人是()。', '{\"A\": \"巴贝奇\", \"B\": \"图灵\", \"C\": \"冯.诺依曼\", \"D\": \"比尔.盖茨\"}', 'B', '2026-09-13 09:54:37.195139', '2026-09-13 09:54:37.195139', '解析：图灵被誉为计算机科学之父，他提出了图灵机模型和可计算性理论，奠定了计算机科学的理论基础，因此是计算机科学的奠基人。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (576, 1, '1946年第一台计算机问世以来,计算机的发展经历了4个时代,它们是()。', '{\"A\": \"低档计算机、中档计算机、高档计算机、手提计算机\", \"B\": \"微型计算机、小型计算机、中型计算机、大型计算机\", \"C\": \"组装机、兼容机、品牌机、原装机\", \"D\": \"电子管计算机、晶体管计算机、小规模集成电路计算机、大规模及超大规模集成电路计算机\"}', 'D', '2026-09-13 09:54:37.202120', '2026-09-13 09:54:37.203118', '解析：计算机的发展按电子元器件的演变划分为四个时代：电子管计算机、晶体管计算机、小规模集成电路计算机、大规模及超大规模集成电路计算机，因此D选项正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (577, 1, '当前计算机正朝两级方向发展，即（）。', '{\"A\": \"专用机和通用机\", \"B\": \"微型化和巨型化\", \"C\": \"模拟机和数字机\", \"D\": \"个人机和服务器\"}', 'B', '2026-09-13 09:54:37.209102', '2026-09-13 09:54:37.209102', '解析：计算机发展的两个主要方向是微型化（如个人电脑、嵌入式设备）和巨型化（如超级计算机用于大规模计算），因此选择B选项。其他选项描述的是计算机的不同分类方式，而非发展方向。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (578, 1, '在计算机发展史上,()理论的要点是存储程序和二进制。', '{\"A\": \"乔布斯\", \"B\": \"布尔\", \"C\": \"图灵\", \"D\": \"冯.诺依曼\"}', 'D', '2026-09-13 09:54:37.217080', '2026-09-13 09:54:37.217080', '解析：冯·诺依曼理论的核心是存储程序概念和二进制表示，这构成了现代计算机设计的基础，因此选项D正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (579, 1, '以下关于计算机四个发展阶段的描述,不正确的是()', '{\"A\": \"第一代计算机主要用于军事目的\", \"B\": \"第二代计算机主要用于数据处理和事务管理\", \"C\": \"第三代计算机刚出现高级程序设计语言\", \"D\": \"第四代计算机采用大规模和超大规模集成电路\"}', 'C', '2026-09-13 09:54:37.223092', '2026-09-13 09:54:37.223092', '解析：第三代计算机（1965-1970年）以集成电路为主要元件，高级程序设计语言（如FORTRAN、COBOL）早在第二代计算机（晶体管时代）就已出现并广泛应用，因此“第三代计算机刚出现高级程序设计语言”描述错误。其他选项均符合计算机发展史实。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (580, 1, '最早提出在计算机上使用二进制数形式来表示各种数据的科学家是（）。', '{\"A\": \"冯·诺依曼\", \"B\": \"图灵\", \"C\": \"莱布尼兹\", \"D\": \"香农\"}', 'A', '2026-09-13 09:54:37.230073', '2026-09-13 09:54:37.230073', '解析：冯·诺依曼在其提出的计算机体系结构中，明确倡导采用二进制数形式来表示数据和指令，这一设计成为现代计算机的基础，因此他是最早提出在计算机上使用二进制表示数据的科学家。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (581, 1, '早先的计算机上并没有操作系统，第一个操作系统出现在第()代计算机上。', '{\"A\": \"一\", \"B\": \"二\", \"C\": \"三\", \"D\": \"四\"}', 'B', '2026-09-13 09:54:37.236058', '2026-09-13 09:54:37.236058', '解析：第一个操作系统出现在第二代计算机上，因为第二代计算机采用晶体管技术，开始引入批处理系统和监控程序，从而形成了操作系统的雏形。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (582, 1, '以通信子网为中心的计算机网络称为（）。', '{\"A\": \"第一代计算机网络\", \"B\": \"第二代计算机网络\", \"C\": \"第三代计算机网络\", \"D\": \"第四代计算机网络\"}', 'B', '2026-09-13 09:54:37.243039', '2026-09-13 09:54:37.243039', '解析：以通信子网为中心的计算机网络属于第二代计算机网络，因为第一代是面向终端的，第二代才引入通信子网实现资源共享。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (583, 1, '我国“银河”属于下列哪种计算机（）', '{\"A\": \"巨型机\", \"B\": \"微型机\", \"C\": \"小型机\", \"D\": \"服务器\"}', 'A', '2026-09-13 09:54:37.249023', '2026-09-13 09:54:37.249023', '解析：我国“银河”计算机属于巨型机，因为它是高性能、大规模并行处理的超级计算机，主要用于复杂科学计算和工程模拟，不同于微型机、小型机或服务器。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (584, 1, '下面有关计算机特点的说法中，（）是不正确的', '{\"A\": \"运算速度快\", \"B\": \"计算精度高\", \"C\": \"所有操作是在人的控制下完成的\", \"D\": \"随着计算机硬件设备和软件的不断发展和提高，计算机价格越来越高\"}', 'D', '2026-09-13 09:54:37.255006', '2026-09-13 09:54:37.255006', '解析：计算机硬件和软件技术的发展通常导致性能提升和成本下降，因此价格越来越高不符合实际情况，故选项D不正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (585, 1, '在计算机的发展中，以集成电路为基本元件的计算机出现的时间为()。', '{\"A\": \"1965-1970\", \"B\": \"1964-1975\", \"C\": \"1960-1969\", \"D\": \"1950-1970\"}', 'A', '2026-09-13 09:54:37.261989', '2026-09-13 09:54:37.261989', '解析：集成电路计算机（第三代计算机）出现的时间为1965年至1970年，因此选项A正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (586, 1, '以下说法正确的是()。', '{\"A\": \"应用软件是为解决各种应用问题而编制的软件，如操作系统和字处理软件\", \"B\": \"机器语言和汇编语言因其功能不如高级语言强，所以被称为低级语言\", \"C\": \"用高级语言编制程序的用户不必了解计算机的指令系统\", \"D\": \"将高级语言源程序翻译成目标程序一般有两种方式，解释方式生成目标程序而编译方式则不生成目标程序\"}', 'C', '2026-09-13 09:54:37.268970', '2026-09-13 09:54:37.268970', '解析：选项C正确，因为高级语言独立于计算机硬件，用户无需了解指令系统即可编写程序。选项A错误，操作系统属于系统软件而非应用软件；选项B错误，低级语言的“低级”指其接近机器语言，而非功能强弱；选项D错误，编译方式生成目标程序，解释方式则不生成。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (587, 1, '下列关于指令的叙述中错误的是()。', '{\"A\": \"指令通常包括两方面的内容：操作码和操作数\", \"B\": \"指令就是指挥机器工作的指示和命令\", \"C\": \"程序就是一系列按一定顺序排列的指令\", \"D\": \"指令的种类与具体的CPU无关\"}', 'D', '2026-09-13 09:54:37.274926', '2026-09-13 09:54:37.274926', '解析：指令的种类与具体的CPU密切相关，不同的CPU（如x86、ARM）有不同的指令集架构，因此指令种类依赖于CPU的设计，故D选项错误。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (588, 1, '第一台真正意义上的电子计算机是（）。', '{\"A\": \"香农-图灵机\", \"B\": \"艾克特-莫克利计算机\", \"C\": \"英特尔4004微处理器\", \"D\": \"ENIAC\"}', 'D', '2026-09-13 09:54:37.281934', '2026-09-13 09:54:37.281934', '解析：ENIAC（电子数字积分计算机）于1946年诞生，被公认为世界上第一台真正意义上的通用电子计算机，因为它采用电子管作为主要元件，具备可编程、高速计算等特征，而其他选项中香农-图灵机是理论模型，艾克特-莫克利计算机指代ENIAC的设计者，英特尔4004是微处理器，均不符合“第一台电子计算机”的史实。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (589, 1, '在世界上首次采用计算机进行图像处理的公司是()。', '{\"A\": \"IBM\", \"B\": \"Microsoft\", \"C\": \"Adobe\", \"D\": \"Apple\"}', 'A', '2026-09-13 09:54:37.287919', '2026-09-13 09:54:37.287919', '解析：IBM在20世纪60年代率先开发出计算机图像处理技术，并应用于卫星图像分析等领域，因此是首家采用计算机进行图像处理的公司。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (590, 1, '第二代计算机的主要电子元件是（）。', '{\"A\": \"电子管\", \"B\": \"集成电路\", \"C\": \"晶体管\", \"D\": \"大规模集成电路\"}', 'C', '2026-09-13 09:54:37.294900', '2026-09-13 09:54:37.294900', '解析：第二代计算机（约1956-1963年）采用晶体管作为主要电子元件，取代了第一代的电子管，晶体管体积更小、功耗更低且可靠性更高。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (591, 1, '以下关于计算机发展趋势的描述，错误的是（）。', '{\"A\": \"巨型化是指计算机的体积越来越大，运算速度越来越快，存储容量越来越大\", \"B\": \"微型化是指计算机向体积更小、功能更强、价格更低、更便于携带的方向发展\", \"C\": \"网络化是指将计算机连接起来，实现资源共享和信息传递，互联网的发展是计算机网络化的重要体现\", \"D\": \"智能化是指使计算机具有模拟人的感觉和思维过程的能力，如人工智能中的机器学习、自然语言处理等领域\"}', 'A', '2026-09-13 09:54:37.300884', '2026-09-13 09:54:37.300884', '解析：巨型化是指计算机向运算速度更快、存储容量更大、功能更强的方向发展，而非体积越来越大，因此A选项描述错误。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (592, 1, '世界上第一台通用电子数字计算机ENIAC诞生于（）。', '{\"A\": \"1936年\", \"B\": \"1946年\", \"C\": \"1956年\", \"D\": \"1966年\"}', 'B', '2026-09-13 09:54:37.306868', '2026-09-13 09:54:37.306868', '解析：世界上第一台通用电子数字计算机ENIAC于1946年在美国宾夕法尼亚大学诞生，因此正确答案是B选项。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (593, 1, '计算机网络技术的出现,对于我们的生活和工作带来了革命性的影响,它最大的好处是()。', '{\"A\": \"实现资源共享\", \"B\": \"节省人力\", \"C\": \"存储容量大\", \"D\": \"是信息存取速度提高\"}', 'A', '2026-09-13 09:54:37.313849', '2026-09-13 09:54:37.313849', '解析：计算机网络技术的核心优势在于通过连接多台计算机，实现硬件、软件和数据等资源的共享，从而提高资源利用效率，这是其最根本的变革性影响，而其他选项如节省人力、存储容量或存取速度均非网络独有或最大优势。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (594, 1, '计算机发展历程中，第二代计算机的主要逻辑元件是（）。', '{\"A\": \"电子管\", \"B\": \"晶体管\", \"C\": \"中小规模集成电路\", \"D\": \"大规模和超大规模集成电路\"}', 'B', '2026-09-13 09:54:37.319833', '2026-09-13 09:54:37.319833', '解析：第二代计算机（约1958-1964年）采用晶体管作为主要逻辑元件，相比第一代的电子管，晶体管体积更小、功耗更低、可靠性更高，因此正确答案为B。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (595, 1, '世界上第一台电子计算机ENIAC诞生于(）。', '{\"A\": \"1946年\", \"B\": \"1956年\", \"C\": \"1964年\", \"D\": \"1976年\"}', 'A', '2026-09-13 09:54:37.326815', '2026-09-13 09:54:37.326815', '解析：世界上第一台电子计算机ENIAC于1946年在美国宾夕法尼亚大学诞生，因此正确答案为A选项。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (596, 1, '下列关于计算机发展的叙述中有错误的是（）。', '{\"A\": \"图灵设计制造了“图灵机”真正地实现了“程序存储”\", \"B\": \"ENIAC并没有真正地实现程序存储\", \"C\": \"早在计算机发展的第—阶段就提出了“人工智能”的概念\", \"D\": \"Intel生产的4004微处理器将运算器和控制器集成在一个芯片上，标志着CPU的诞生\"}', 'A', '2026-09-13 09:54:37.332799', '2026-09-13 09:54:37.332799', '解析：图灵在理论上提出了“图灵机”概念，但并未实际制造出机器，而“程序存储”是由冯·诺依曼等人在EDVAC中实现的，因此A项叙述错误。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (597, 1, '世界上第一台电子数字计算机ENIAC诞生于（）。', '{\"A\": \"1946年\", \"B\": \"1956年\", \"C\": \"1964年\", \"D\": \"1971年\"}', 'A', '2026-09-13 09:54:37.338755', '2026-09-13 09:54:37.338755', '解析：ENIAC（电子数字积分计算机）于1946年在美国宾夕法尼亚大学诞生，是世界上第一台通用电子数字计算机，因此正确答案是A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (598, 1, '2024年10月22日，()发布HarmonyOSNEXT系统，其实现了“完全自主”的原生系统开发。', '{\"A\": \"阿里\", \"B\": \"百度\", \"C\": \"华为\", \"D\": \"腾讯\"}', 'C', '2026-09-13 09:54:37.345764', '2026-09-13 09:54:37.345764', '解析：华为于2024年10月22日正式发布了HarmonyOS NEXT系统，该系统实现了“完全自主”的原生系统开发，因此正确答案为C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (599, 1, '()被称为万维网之父，他是英国计算机科学家、万维网发明者.', '{\"A\": \"彼得·德鲁克\", \"B\": \"舍恩伯格\", \"C\": \"蒂姆·伯纳斯-李\", \"D\": \"斯科特·布朗\"}', 'C', '2026-09-13 09:54:37.351749', '2026-09-13 09:54:37.351749', '解析：蒂姆·伯纳斯-李（Tim Berners-Lee）是英国计算机科学家，他发明了万维网，因此被称为“万维网之父”，而其他选项均与此无关。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (600, 1, '目前万维网是我们使用得最多的的一种信息传播方式，它的发明者是()。', '{\"A\": \"蒂姆·伯纳斯·李\", \"B\": \"图灵\", \"C\": \"冯·诺依曼\", \"D\": \"莫克利\"}', 'A', '2026-09-13 09:54:37.358730', '2026-09-13 09:54:37.358730', '解析：蒂姆·伯纳斯·李发明了万维网（World Wide Web），并提出了超文本传输协议（HTTP）和统一资源定位符（URL）等核心技术，因此正确答案是A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (601, 1, '世界上第一台电子计算机ENIAC诞生于哪个年代（）', '{\"A\": \"1930年代\", \"B\": \"1940年代\", \"C\": \"1950年代\", \"D\": \"1960年代\"}', 'B', '2026-09-13 09:54:38.962982', '2026-09-13 09:54:38.962982', '解析：ENIAC（电子数字积分计算机）于1946年在美国宾夕法尼亚大学诞生，属于1940年代，因此正确答案是B。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (602, 1, '以下哪个不是计算机发展的主要阶段（）', '{\"A\": \"电子管计算机\", \"B\": \"晶体管计算机\", \"C\": \"集成电路计算机\", \"D\": \"硅芯片计算机\"}', 'D', '2026-09-13 09:54:38.969962', '2026-09-13 09:54:38.969962', '解析：计算机发展的主要阶段依次为电子管、晶体管和集成电路计算机，硅芯片属于集成电路的一种具体实现技术，并非独立的发展阶段。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (603, 1, '冯·诺依曼提出的计算机体系结构中，不包括以下哪个组成部分()', '{\"A\": \"运算器\", \"B\": \"控制器\", \"C\": \"存储器\", \"D\": \"显示器\"}', 'D', '2026-09-13 09:54:38.976944', '2026-09-13 09:54:38.976944', '解析：冯·诺依曼体系结构包括运算器、控制器、存储器和输入输出设备，显示器属于输出设备而非核心组成部分，因此选D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (604, 1, '“摩尔定律”是由哪位科学家提出的（）', '{\"A\": \"艾伦·图灵\", \"B\": \"戈登·摩尔\", \"C\": \"冯·诺依曼\", \"D\": \"比尔·盖茨\"}', 'B', '2026-09-13 09:54:38.983925', '2026-09-13 09:54:38.983925', '解析：摩尔定律由英特尔联合创始人戈登·摩尔于1965年提出，指出集成电路上可容纳的晶体管数量约每两年翻一番，因此正确答案为B。其他选项与摩尔定律的提出无关。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (605, 1, '哪个公司推出了第一台个人计算机（PC）（）', '{\"A\": \"IBM\", \"B\": \"Apple\", \"C\": \"Microsoft\", \"D\": \"Intel\"}', 'A', '2026-09-13 09:54:38.990906', '2026-09-13 09:54:38.990906', 'IBM在1981年推出了IBM 5150，被广泛认为是第一台个人计算机（PC），其开放架构奠定了PC行业标准。其他选项中，Apple虽早期推出Apple II，但并非首个定义为“PC”的产品；Microsoft和Intel分别提供软件和硬件，未直接推出整机。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (606, 1, '“操作系统”的概念最早是在哪个时代提出的（）', '{\"A\": \"第一代计算机时代\", \"B\": \"第二代计算机时代\", \"C\": \"第三代计算机时代\", \"D\": \"第四代计算机时代\"}', 'B', '2026-09-13 09:54:38.997888', '2026-09-13 09:54:38.997888', '解析：操作系统概念最早在第二代计算机时代（晶体管时代）提出，此时为了管理批处理任务和简化操作，出现了监督程序（早期操作系统雏形）。第一代无操作系统，第三代及之后操作系统已成熟。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (607, 1, '中国第一台电子计算机的诞生标志着中国计算机技术的发展迈出了重要的一步。请问，中国第一台电子计算机是何时诞生的（）', '{\"A\": \"1956年\", \"B\": \"1958年\", \"C\": \"1960年\", \"D\": \"1972年\"}', 'B', '2026-09-13 09:54:39.004869', '2026-09-13 09:54:39.004869', '解析：中国第一台电子计算机是103型计算机，于1958年研制成功，标志着中国计算机技术的起步，因此正确答案为B。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (608, 1, '在中国计算机发展史上，以下哪个事件标志着中国进入了亿次巨型机时代（）', '{\"A\": \"1983年国防科技大学研发成功“银河-I”超级计算机\", \"B\": \"1993年国家智能计算机研究开发中心研发成功“曙光一号”\", \"C\": \"1995年曙光机研制成功，我国成为世界上第四个研制成功千万亿次计算机的国家\", \"D\": \"2009年“天河一号”超级计算机研制成功\"}', 'A', '2026-09-13 09:54:39.011850', '2026-09-13 09:54:39.011850', '解析：1983年国防科技大学成功研发“银河-I”超级计算机，其运算速度达到每秒亿次，标志着中国进入了亿次巨型机时代。因此正确答案是A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (609, 1, '以下关于计算机发展史的描述，哪一项是正确的（）', '{\"A\": \"第一代计算机主要使用电子管作为基本电子器件，运算速度较慢\", \"B\": \"第二代计算机相比第一代计算机，运算速度降低，但体积更小\", \"C\": \"第三代计算机普遍采用大规模集成电路，并开始应用于社会各个领域\", \"D\": \"第四代计算机从1990年开始，以量子计算机为主要发展方向\"}', 'A', '2026-09-13 09:54:39.018832', '2026-09-13 09:54:39.018832', '解析：A选项正确，因为第一代计算机确实以电子管为核心器件，运算速度相对较慢；B选项错误，第二代计算机运算速度提升而非降低；C选项错误，第三代计算机采用中、小规模集成电路，而非大规模集成电路；D选项错误，第四代计算机以微处理器为核心，量子计算机并非其主要发展方向。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (610, 1, '以下关于我国计算机发展历程的描述，哪一项是正确的（）', '{\"A\": \"我国第一台计算机是在1953年研制成功的\", \"B\": \"我国第一台运算速度达到1亿次的计算机是银河-II型\", \"C\": \"我国在20世纪80年代初成功研制出银河系列计算机\", \"D\": \"我国计算机发展一直落后于国际先进水平\"}', 'C', '2026-09-13 09:54:39.025813', '2026-09-13 09:54:39.025813', '解析：选项A错误，我国第一台计算机“103机”于1958年研制成功，而非1953年；选项B错误，我国第一台运算速度达1亿次的计算机是银河-I型，银河-II型速度更快；选项C正确，银河系列计算机始于20世纪80年代初，1983年银河-I型研制成功；选项D错误，我国计算机发展部分领域已接近或领先国际水平。因此选C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (611, 1, '在计算机发展史上，以下哪个人物被誉为“计算机之父”（）', '{\"A\": \"AlanTuring\", \"B\": \"JohnvonNeumann\", \"C\": \"CharlesBabbage\", \"D\": \"AdaLovelace\"}', 'B', '2026-09-13 09:54:39.032794', '2026-09-13 09:54:39.032794', '约翰·冯·诺依曼（John von Neumann）提出了存储程序概念和冯·诺依曼体系结构，奠定了现代计算机设计的基础，因此被誉为“计算机之父”。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (612, 1, '计算机的发展历程中，哪个阶段标志着计算机技术的成熟（）', '{\"A\": \"电子管时代\", \"B\": \"晶体管时代\", \"C\": \"集成电路时代\", \"D\": \"超大规模集成电路时代\"}', 'D', '2026-09-13 09:54:39.039776', '2026-09-13 09:54:39.039776', '解析：超大规模集成电路时代（选项D）标志着计算机技术的成熟，因为该阶段实现了高集成度、低功耗和高性能，使得计算机微型化、普及化并广泛应用于各领域，而前三个时代（电子管、晶体管、集成电路）均处于技术发展的早期或过渡阶段，尚未达到成熟标准。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (613, 1, '在计算机发展史中，以下哪项技术不是用于提高计算机性能的关键技术（）', '{\"A\": \"二进制系统\", \"B\": \"集成电路\", \"C\": \"高速缓存（Cache）\", \"D\": \"触摸屏技术\"}', 'D', '2026-09-13 09:54:39.046873', '2026-09-13 09:54:39.046873', '解析：二进制系统、集成电路和高速缓存都是直接提升计算机运算速度或效率的关键技术，而触摸屏技术主要用于改善人机交互体验，不直接提高计算机性能，因此选D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (614, 1, '关于我国计算机发展历程，以下哪项描述是正确的（）', '{\"A\": \"我国第一台电子计算机于1946年研制成功\", \"B\": \"我国第一台大型电子数字计算机是晶体管计算机\", \"C\": \"我国计算机发展经历了从电子管到超大规模集成电路的四个阶段\", \"D\": \"我国计算机发展水平已经超越所有发达国家\"}', 'C', '2026-09-13 09:54:39.053856', '2026-09-13 09:54:39.053856', '解析：选项A错误，因为我国第一台电子计算机于1958年研制成功，而非1946年；选项B错误，我国第一台大型电子数字计算机是电子管计算机（如103机），而非晶体管计算机；选项C正确，我国计算机发展确实经历了电子管、晶体管、集成电路、超大规模集成电路四个阶段；选项D错误，我国计算机发展水平虽进步显著，但尚未超越所有发达国家。因此，正确答案是C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (615, 1, '以下哪项不属于计算机发展的四个阶段（）', '{\"A\": \"电子管计算机\", \"B\": \"晶体管计算机\", \"C\": \"集成电路计算机\", \"D\": \"石墨烯计算机\"}', 'D', '2026-09-13 09:54:39.060838', '2026-09-13 09:54:39.060838', '解析：计算机发展的四个阶段分别为电子管计算机、晶体管计算机、集成电路计算机和大规模集成电路计算机，而石墨烯计算机尚未被列为传统发展阶段，因此选D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (616, 1, '以下哪项是我国计算机发展历史上的重要事件（）', '{\"A\": \"1956年制定《十二年科学技术发展规划》\", \"B\": \"1978年改革开放\", \"C\": \"2001年中国加入WTO\", \"D\": \"2010年上海世博会\"}', 'A', '2026-09-13 09:54:39.067819', '2026-09-13 09:54:39.067819', '解析：《十二年科学技术发展规划》是1956年我国制定的首个长期科技规划，其中将计算机技术列为重点发展项目，标志着我国计算机事业的正式起步，因此是计算机发展史上的重要事件。其他选项虽属重大历史事件，但与计算机发展的直接关联较弱。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (617, 1, '标志着中国计算机产业开始走向自主设计、自主制造阶段的事件是（）', '{\"A\": \"1958年，中国第一台晶体管计算机诞生\", \"B\": \"1956年，中国第一台电子管计算机试制成功\", \"C\": \"1970年代初，DJS-130小型计算机研制成功\", \"D\": \"1983年，银河一号巨型计算机研制成功\"}', 'C', '2026-09-13 09:54:39.073803', '2026-09-13 09:54:39.073803', '解析：DJS-130小型计算机是中国首台自行设计、自行制造的小型计算机，标志着中国计算机产业从仿制转向自主设计、自主制造阶段，因此选C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (618, 1, '中国首个超级计算机进入全球500强排名的时间是（）', '{\"A\": \"1995年\", \"B\": \"1999年\", \"C\": \"2001年\", \"D\": \"2005年\"}', 'B', '2026-09-13 09:54:39.080784', '2026-09-13 09:54:39.080784', '解析：中国首个超级计算机“神威I”于1999年进入全球超级计算机500强排名，因此正确答案是B选项。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (619, 1, '计算机的冯·诺依曼体系结构包括以下哪项？', '{\"A\": \"中央处理器\", \"B\": \"硬盘存储\", \"C\": \"操作系统\", \"D\": \"网络连接\"}', 'A', '2026-09-13 09:54:39.087766', '2026-09-13 09:54:39.087766', '解析：冯·诺依曼体系结构核心包含运算器、控制器、存储器、输入设备和输出设备，中央处理器（CPU）集成运算器和控制器，是必备部件；硬盘、操作系统、网络连接均为外部或软件部分，不属于该结构的基础组成部分。因此选A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (620, 1, '计算机发展历史上的“第二代”主要是指？', '{\"A\": \"使用电子管的计算机\", \"B\": \"使用晶体管的计算机\", \"C\": \"使用集成电路的计算机\", \"D\": \"使用大规模集成电路的计算机\"}', 'B', '2026-09-13 09:54:39.094747', '2026-09-13 09:54:39.094747', '解析：计算机发展历史上，第二代计算机主要采用晶体管作为核心元件，取代了第一代的电子管，因此正确答案是B。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (621, 1, '计算机一般被划分成四代，这主要是根据()来划分的。', '{\"A\": \"计算机的功能\", \"B\": \"计算机的体积\", \"C\": \"计算机所使用的元器件\", \"D\": \"计算机的价格\"}', 'C', '2026-09-13 09:54:39.100731', '2026-09-13 09:54:39.100731', '解析：计算机的代际划分主要依据其所使用的核心元器件（如电子管、晶体管、集成电路等），因为这直接决定了计算机的性能、体积和成本等特征，因此选C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (622, 1, '关于第一台电子计算机的说法错误的是（)', '{\"A\": \"第一台电子计算机于1946年在美国诞生\", \"B\": \"第一台电子计算机主要用于军事用途\", \"C\": \"第一台电子计算机使用了存储器\", \"D\": \"第一台电子计算机的主要电子器件是电子管\"}', 'C', '2026-09-13 09:54:39.106715', '2026-09-13 09:54:39.106715', '第一台电子计算机ENIAC没有使用存储器，其程序是通过插拔线路和开关来设置的，因此选项C错误。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (623, 1, '第三代计算机元器件为（）', '{\"A\": \"电子管\", \"B\": \"继电器\", \"C\": \"晶体管\", \"D\": \"集成电路\"}', 'D', '2026-09-13 09:54:39.113696', '2026-09-13 09:54:39.113696', '解析：第三代计算机（1965-1971年）采用中小规模集成电路作为主要元器件，因此正确答案是D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (624, 1, '个人使用的计算机即微机诞生于（）阶段。', '{\"A\": \"第一代计算机\", \"B\": \"第二代计算机\", \"C\": \"第三代计算机\", \"D\": \"第四代计算机\"}', 'D', '2026-09-13 09:54:39.119680', '2026-09-13 09:54:39.119680', '解析：个人计算机（微机）诞生于第四代计算机阶段，因为第四代计算机采用大规模和超大规模集成电路，使得计算机体积缩小、成本降低，从而推动了个人计算机的普及。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (625, 1, '计算机科学的奠基人是()。', '{\"A\": \"巴贝奇\", \"B\": \"图灵\", \"C\": \"冯.诺依曼\", \"D\": \"比尔.盖茨\"}', 'B', '2026-09-13 09:54:39.125664', '2026-09-13 09:54:39.125664', '解析：图灵被誉为计算机科学之父，他提出了图灵机模型和可计算性理论，奠定了计算机科学的理论基础，因此是计算机科学的奠基人。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (626, 1, '1946年第一台计算机问世以来,计算机的发展经历了4个时代,它们是()。', '{\"A\": \"低档计算机、中档计算机、高档计算机、手提计算机\", \"B\": \"微型计算机、小型计算机、中型计算机、大型计算机\", \"C\": \"组装机、兼容机、品牌机、原装机\", \"D\": \"电子管计算机、晶体管计算机、小规模集成电路计算机、大规模及超大规模集成电路计算机\"}', 'D', '2026-09-13 09:54:39.131648', '2026-09-13 09:54:39.131648', '解析：计算机的发展按电子元器件的演变划分为四个时代：电子管计算机、晶体管计算机、小规模集成电路计算机、大规模及超大规模集成电路计算机，因此D选项正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (627, 1, '当前计算机正朝两级方向发展，即（）。', '{\"A\": \"专用机和通用机\", \"B\": \"微型化和巨型化\", \"C\": \"模拟机和数字机\", \"D\": \"个人机和服务器\"}', 'B', '2026-09-13 09:54:39.138630', '2026-09-13 09:54:39.138630', '解析：计算机发展的两个主要方向是微型化（如个人电脑、嵌入式设备）和巨型化（如超级计算机用于大规模计算），因此选择B选项。其他选项描述的是计算机的不同分类方式，而非发展方向。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (628, 1, '在计算机发展史上,()理论的要点是存储程序和二进制。', '{\"A\": \"乔布斯\", \"B\": \"布尔\", \"C\": \"图灵\", \"D\": \"冯.诺依曼\"}', 'D', '2026-09-13 09:54:39.145611', '2026-09-13 09:54:39.145611', '解析：冯·诺依曼理论的核心是存储程序概念和二进制表示，这构成了现代计算机设计的基础，因此选项D正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (629, 1, '以下关于计算机四个发展阶段的描述,不正确的是()', '{\"A\": \"第一代计算机主要用于军事目的\", \"B\": \"第二代计算机主要用于数据处理和事务管理\", \"C\": \"第三代计算机刚出现高级程序设计语言\", \"D\": \"第四代计算机采用大规模和超大规模集成电路\"}', 'C', '2026-09-13 09:54:39.151595', '2026-09-13 09:54:39.151595', '解析：第三代计算机（1965-1970年）以集成电路为主要元件，高级程序设计语言（如FORTRAN、COBOL）早在第二代计算机（晶体管时代）就已出现并广泛应用，因此“第三代计算机刚出现高级程序设计语言”描述错误。其他选项均符合计算机发展史实。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (630, 1, '最早提出在计算机上使用二进制数形式来表示各种数据的科学家是（）。', '{\"A\": \"冯·诺依曼\", \"B\": \"图灵\", \"C\": \"莱布尼兹\", \"D\": \"香农\"}', 'A', '2026-09-13 09:54:39.157579', '2026-09-13 09:54:39.157579', '解析：冯·诺依曼在其提出的计算机体系结构中，明确倡导采用二进制数形式来表示数据和指令，这一设计成为现代计算机的基础，因此他是最早提出在计算机上使用二进制表示数据的科学家。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (631, 1, '早先的计算机上并没有操作系统，第一个操作系统出现在第()代计算机上。', '{\"A\": \"一\", \"B\": \"二\", \"C\": \"三\", \"D\": \"四\"}', 'B', '2026-09-13 09:54:39.163563', '2026-09-13 09:54:39.163563', '解析：第一个操作系统出现在第二代计算机上，因为第二代计算机采用晶体管技术，开始引入批处理系统和监控程序，从而形成了操作系统的雏形。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (632, 1, '以通信子网为中心的计算机网络称为（）。', '{\"A\": \"第一代计算机网络\", \"B\": \"第二代计算机网络\", \"C\": \"第三代计算机网络\", \"D\": \"第四代计算机网络\"}', 'B', '2026-09-13 09:54:39.170544', '2026-09-13 09:54:39.170544', '解析：以通信子网为中心的计算机网络属于第二代计算机网络，因为第一代是面向终端的，第二代才引入通信子网实现资源共享。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (633, 1, '我国“银河”属于下列哪种计算机（）', '{\"A\": \"巨型机\", \"B\": \"微型机\", \"C\": \"小型机\", \"D\": \"服务器\"}', 'A', '2026-09-13 09:54:39.176528', '2026-09-13 09:54:39.176528', '解析：我国“银河”计算机属于巨型机，因为它是高性能、大规模并行处理的超级计算机，主要用于复杂科学计算和工程模拟，不同于微型机、小型机或服务器。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (634, 1, '下面有关计算机特点的说法中，（）是不正确的', '{\"A\": \"运算速度快\", \"B\": \"计算精度高\", \"C\": \"所有操作是在人的控制下完成的\", \"D\": \"随着计算机硬件设备和软件的不断发展和提高，计算机价格越来越高\"}', 'D', '2026-09-13 09:54:39.182512', '2026-09-13 09:54:39.182512', '解析：计算机硬件和软件技术的发展通常导致性能提升和成本下降，因此价格越来越高不符合实际情况，故选项D不正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (635, 1, '在计算机的发展中，以集成电路为基本元件的计算机出现的时间为()。', '{\"A\": \"1965-1970\", \"B\": \"1964-1975\", \"C\": \"1960-1969\", \"D\": \"1950-1970\"}', 'A', '2026-09-13 09:54:39.188496', '2026-09-13 09:54:39.188496', '解析：集成电路计算机（第三代计算机）出现的时间为1965年至1970年，因此选项A正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (636, 1, '以下说法正确的是()。', '{\"A\": \"应用软件是为解决各种应用问题而编制的软件，如操作系统和字处理软件\", \"B\": \"机器语言和汇编语言因其功能不如高级语言强，所以被称为低级语言\", \"C\": \"用高级语言编制程序的用户不必了解计算机的指令系统\", \"D\": \"将高级语言源程序翻译成目标程序一般有两种方式，解释方式生成目标程序而编译方式则不生成目标程序\"}', 'C', '2026-09-13 09:54:39.195478', '2026-09-13 09:54:39.195478', '解析：选项C正确，因为高级语言独立于计算机硬件，用户无需了解指令系统即可编写程序。选项A错误，操作系统属于系统软件而非应用软件；选项B错误，低级语言的“低级”指其接近机器语言，而非功能强弱；选项D错误，编译方式生成目标程序，解释方式则不生成。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (637, 1, '下列关于指令的叙述中错误的是()。', '{\"A\": \"指令通常包括两方面的内容：操作码和操作数\", \"B\": \"指令就是指挥机器工作的指示和命令\", \"C\": \"程序就是一系列按一定顺序排列的指令\", \"D\": \"指令的种类与具体的CPU无关\"}', 'D', '2026-09-13 09:54:39.201462', '2026-09-13 09:54:39.201462', '解析：指令的种类与具体的CPU密切相关，不同的CPU（如x86、ARM）有不同的指令集架构，因此指令种类依赖于CPU的设计，故D选项错误。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (638, 1, '第一台真正意义上的电子计算机是（）。', '{\"A\": \"香农-图灵机\", \"B\": \"艾克特-莫克利计算机\", \"C\": \"英特尔4004微处理器\", \"D\": \"ENIAC\"}', 'D', '2026-09-13 09:54:39.207446', '2026-09-13 09:54:39.207446', '解析：ENIAC（电子数字积分计算机）于1946年诞生，被公认为世界上第一台真正意义上的通用电子计算机，因为它采用电子管作为主要元件，具备可编程、高速计算等特征，而其他选项中香农-图灵机是理论模型，艾克特-莫克利计算机指代ENIAC的设计者，英特尔4004是微处理器，均不符合“第一台电子计算机”的史实。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (639, 1, '在世界上首次采用计算机进行图像处理的公司是()。', '{\"A\": \"IBM\", \"B\": \"Microsoft\", \"C\": \"Adobe\", \"D\": \"Apple\"}', 'A', '2026-09-13 09:54:39.214427', '2026-09-13 09:54:39.214427', '解析：IBM在20世纪60年代率先开发出计算机图像处理技术，并应用于卫星图像分析等领域，因此是首家采用计算机进行图像处理的公司。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (640, 1, '第二代计算机的主要电子元件是（）。', '{\"A\": \"电子管\", \"B\": \"集成电路\", \"C\": \"晶体管\", \"D\": \"大规模集成电路\"}', 'C', '2026-09-13 09:54:39.220411', '2026-09-13 09:54:39.220411', '解析：第二代计算机（约1956-1963年）采用晶体管作为主要电子元件，取代了第一代的电子管，晶体管体积更小、功耗更低且可靠性更高。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (641, 1, '以下关于计算机发展趋势的描述，错误的是（）。', '{\"A\": \"巨型化是指计算机的体积越来越大，运算速度越来越快，存储容量越来越大\", \"B\": \"微型化是指计算机向体积更小、功能更强、价格更低、更便于携带的方向发展\", \"C\": \"网络化是指将计算机连接起来，实现资源共享和信息传递，互联网的发展是计算机网络化的重要体现\", \"D\": \"智能化是指使计算机具有模拟人的感觉和思维过程的能力，如人工智能中的机器学习、自然语言处理等领域\"}', 'A', '2026-09-13 09:54:39.226395', '2026-09-13 09:54:39.226395', '解析：巨型化是指计算机向运算速度更快、存储容量更大、功能更强的方向发展，而非体积越来越大，因此A选项描述错误。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (642, 1, '世界上第一台通用电子数字计算机ENIAC诞生于（）。', '{\"A\": \"1936年\", \"B\": \"1946年\", \"C\": \"1956年\", \"D\": \"1966年\"}', 'B', '2026-09-13 09:54:39.233376', '2026-09-13 09:54:39.233376', '解析：世界上第一台通用电子数字计算机ENIAC于1946年在美国宾夕法尼亚大学诞生，因此正确答案是B选项。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (643, 1, '计算机网络技术的出现,对于我们的生活和工作带来了革命性的影响,它最大的好处是()。', '{\"A\": \"实现资源共享\", \"B\": \"节省人力\", \"C\": \"存储容量大\", \"D\": \"是信息存取速度提高\"}', 'A', '2026-09-13 09:54:39.239360', '2026-09-13 09:54:39.239360', '解析：计算机网络技术的核心优势在于通过连接多台计算机，实现硬件、软件和数据等资源的共享，从而提高资源利用效率，这是其最根本的变革性影响，而其他选项如节省人力、存储容量或存取速度均非网络独有或最大优势。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (644, 1, '计算机发展历程中，第二代计算机的主要逻辑元件是（）。', '{\"A\": \"电子管\", \"B\": \"晶体管\", \"C\": \"中小规模集成电路\", \"D\": \"大规模和超大规模集成电路\"}', 'B', '2026-09-13 09:54:39.245344', '2026-09-13 09:54:39.245344', '解析：第二代计算机（约1958-1964年）采用晶体管作为主要逻辑元件，相比第一代的电子管，晶体管体积更小、功耗更低、可靠性更高，因此正确答案为B。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (645, 1, '世界上第一台电子计算机ENIAC诞生于(）。', '{\"A\": \"1946年\", \"B\": \"1956年\", \"C\": \"1964年\", \"D\": \"1976年\"}', 'A', '2026-09-13 09:54:39.252326', '2026-09-13 09:54:39.252326', '解析：世界上第一台电子计算机ENIAC于1946年在美国宾夕法尼亚大学诞生，因此正确答案为A选项。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (646, 1, '下列关于计算机发展的叙述中有错误的是（）。', '{\"A\": \"图灵设计制造了“图灵机”真正地实现了“程序存储”\", \"B\": \"ENIAC并没有真正地实现程序存储\", \"C\": \"早在计算机发展的第—阶段就提出了“人工智能”的概念\", \"D\": \"Intel生产的4004微处理器将运算器和控制器集成在一个芯片上，标志着CPU的诞生\"}', 'A', '2026-09-13 09:54:39.258310', '2026-09-13 09:54:39.258310', '解析：图灵在理论上提出了“图灵机”概念，但并未实际制造出机器，而“程序存储”是由冯·诺依曼等人在EDVAC中实现的，因此A项叙述错误。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (647, 1, '世界上第一台电子数字计算机ENIAC诞生于（）。', '{\"A\": \"1946年\", \"B\": \"1956年\", \"C\": \"1964年\", \"D\": \"1971年\"}', 'A', '2026-09-13 09:54:39.264294', '2026-09-13 09:54:39.265291', '解析：ENIAC（电子数字积分计算机）于1946年在美国宾夕法尼亚大学诞生，是世界上第一台通用电子数字计算机，因此正确答案是A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (648, 1, '2024年10月22日，()发布HarmonyOSNEXT系统，其实现了“完全自主”的原生系统开发。', '{\"A\": \"阿里\", \"B\": \"百度\", \"C\": \"华为\", \"D\": \"腾讯\"}', 'C', '2026-09-13 09:54:39.271275', '2026-09-13 09:54:39.271275', '解析：华为于2024年10月22日正式发布了HarmonyOS NEXT系统，该系统实现了“完全自主”的原生系统开发，因此正确答案为C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (649, 1, '()被称为万维网之父，他是英国计算机科学家、万维网发明者.', '{\"A\": \"彼得·德鲁克\", \"B\": \"舍恩伯格\", \"C\": \"蒂姆·伯纳斯-李\", \"D\": \"斯科特·布朗\"}', 'C', '2026-09-13 09:54:39.277259', '2026-09-13 09:54:39.277259', '解析：蒂姆·伯纳斯-李（Tim Berners-Lee）是英国计算机科学家，他发明了万维网，因此被称为“万维网之父”，而其他选项均与此无关。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (650, 1, '目前万维网是我们使用得最多的的一种信息传播方式，它的发明者是()。', '{\"A\": \"蒂姆·伯纳斯·李\", \"B\": \"图灵\", \"C\": \"冯·诺依曼\", \"D\": \"莫克利\"}', 'A', '2026-09-13 09:54:39.283243', '2026-09-13 09:54:39.283243', '解析：蒂姆·伯纳斯·李发明了万维网（World Wide Web），并提出了超文本传输协议（HTTP）和统一资源定位符（URL）等核心技术，因此正确答案是A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (651, 1, '第四代计算机和第三代相比，所采用的()一直没有发生变化。', '{\"A\": \"主要元器件\", \"B\": \"主存储器的材料\", \"C\": \"体系结构\", \"D\": \"所配置的操作系统\"}', 'C', '2026-09-13 09:57:12.706576', '2026-09-13 09:57:12.706576', '解析：第四代计算机与第三代相比，主要采用了大规模和超大规模集成电路，但两者都基于冯·诺依曼体系结构，因此体系结构未发生变化。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (652, 1, '下列有关计算机发展与分类的论述中，错误的是()。', '{\"A\": \"数字电子计算机诞生于20世纪40年代，个人计算机（微型计算机）产生于20世纪80年代初\", \"B\": \"第四代计算机的CPU主要采用中小规模集成电路，第五代计算机采用超大规模集成电路\", \"C\": \"计算机按其内部逻辑结构分类一般分为16位机、32位机或64位机等，目前使用的PC机大多是32位机或64位机\", \"D\": \"巨型计算机一般采用大规模并行解决的体系构造，国防科技大学研制的“天河2号”就是巨型计算机\"}', 'B', '2026-09-13 09:57:12.713557', '2026-09-13 09:57:12.713557', '解析：选项B错误，因为第四代计算机的CPU主要采用超大规模集成电路，而非中小规模集成电路；中小规模集成电路是第三代计算机的特征。因此，B项论述有误。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (653, 1, '下列关于第一代计算机的叙述中错误的是()。', '{\"A\": \"采用电子管作基础元件\", \"B\": \"使用汞延迟线作存储设备，后来逐渐过渡到用磁芯存储器\", \"C\": \"输入、输出设备主要是用穿孔卡片，用户使用起来很不方便\", \"D\": \"软件上有了操作系统使得计算机可以自动运行\"}', 'D', '2026-09-13 09:57:12.720538', '2026-09-13 09:57:12.720538', '解析：第一代计算机（约1946-1957年）采用电子管、磁鼓或汞延迟线存储器，输入输出依赖穿孔卡片，但操作系统尚未出现，计算机通过人工插拔线路或机器语言手动控制，无法自动运行。因此D项错误。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (654, 1, '世界上首次提出二进制和最早提出在计算机中采用二进制的科学家分别是()', '{\"A\": \"牛顿、比尔·盖茨\", \"B\": \"爱因斯坦、香农\", \"C\": \"冯诺依曼、莱布尼兹\", \"D\": \"莱布尼兹、冯诺依曼\"}', 'D', '2026-09-13 09:57:12.727520', '2026-09-13 09:57:12.727520', '解析：莱布尼兹是世界上首次提出二进制的人，而冯诺依曼最早提出在计算机中采用二进制，因此选项D正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (655, 1, '世界上第一台计算机()的问世标志着计算机时代的到来，具有划时代的伟大意义。', '{\"A\": \"EDVAC\", \"B\": \"EDSAC\", \"C\": \"UNIVACI\", \"D\": \"ENIAC\"}', 'D', '2026-09-13 09:57:12.734501', '2026-09-13 09:57:12.734501', '解析：ENIAC（电子数字积分计算机）于1946年诞生，是世界上第一台通用电子计算机，它的问世标志着计算机时代的到来，因此正确答案是D。其他选项EDVAC、EDSAC和UNIVACI均为后续发展的计算机。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (656, 1, '中国第一台被命名为“银河I”的亿次巨型电子计算机历经5年研制,在()诞生。', '{\"A\": \"国防科技大学\", \"B\": \"清华大学\", \"C\": \"武汉大学\", \"D\": \"西北工业大学\"}', 'A', '2026-09-13 09:57:12.742480', '2026-09-13 09:57:12.742480', '解析：中国第一台亿次巨型计算机“银河I”由国防科技大学于1983年研制成功，因此正确答案是A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (657, 1, '()是我国第一台全部采用国产处理器构建的连续多年在全球超级计算机500强榜单中位列第一的超级计算机。', '{\"A\": \"神威蓝光\", \"B\": \"曙光·星云\", \"C\": \"神威·太湖之光\", \"D\": \"天河二号\"}', 'C', '2026-09-13 09:57:12.749461', '2026-09-13 09:57:12.749461', '解析：神威·太湖之光是我国首台全部采用国产处理器（申威26010众核处理器）构建的超级计算机，并连续多年在全球超级计算机500强榜单中排名第一。因此正确答案是C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (658, 1, '下列有关我国计算机方面的成就,表述正确的是()①银河系列、天河系列是中科院计算技术研究所研制②1983年,中国成功研制出“银河—Ⅰ号”计算机③1992年,中国成功研制出“银河一Ⅱ号”巨型计算机④20世纪50年代,中国开始了计算机研制工作', '{\"A\": \"①②\", \"B\": \"②③\", \"C\": \"②③④\", \"D\": \"①②③\"}', 'C', '2026-09-13 09:57:12.756442', '2026-09-13 09:57:12.756442', '解析：①错误，银河系列、天河系列是由国防科技大学研制，而非中科院计算技术研究所；②正确，1983年中国成功研制出“银河—Ⅰ号”计算机；③正确，1992年中国成功研制出“银河—Ⅱ号”巨型计算机；④正确，20世纪50年代中国开始了计算机研制工作。因此，正确表述为②③④，故选C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (659, 1, '目前我国自主研发了第一套服务器操作系统,它的名字是()操作系统。', '{\"A\": \"龙芯\", \"B\": \"统信UOS\", \"C\": \"麒麟\", \"D\": \"鸿蒙\"}', 'C', '2026-09-13 09:57:12.764421', '2026-09-13 09:57:12.764421', '解析：麒麟操作系统是我国自主研发的第一套服务器操作系统，由国防科技大学等单位研制，而龙芯是CPU芯片、统信UOS是桌面操作系统、鸿蒙是物联网操作系统，因此正确答案是C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (660, 1, '在我国第一台自行研制的()大型数字计算机完成了我国第一颗氢弹研制的计算任务。', '{\"A\": \"103型\", \"B\": \"104型\", \"C\": \"331型\", \"D\": \"119型\"}', 'D', '2026-09-13 09:57:12.771402', '2026-09-13 09:57:12.771402', '解析：119型计算机是我国第一台自行研制的大型数字计算机，它成功完成了我国第一颗氢弹研制的计算任务，因此正确答案是D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (661, 1, '2017年6月19日，德国法兰克福召开的国际高性能计算机大会公布了新一期全球超级计算机的榜单,我国研制的超级计算机()再次夺得了冠军。', '{\"A\": \"神威蓝光\", \"B\": \"派-曙光\", \"C\": \"神威·太湖之光\", \"D\": \"天河1号\"}', 'C', '2026-09-13 09:57:12.778384', '2026-09-13 09:57:12.778384', '解析：2017年6月19日，国际高性能计算机大会公布全球超级计算机榜单，我国研制的“神威·太湖之光”超级计算机凭借其高性能再次夺得冠军，因此正确答案为C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (662, 1, '2002年8月10日，我国成功制造出首枚高性能通用CPU，名字是()', '{\"A\": \"银河飞腾处理器\", \"B\": \"“申威”CPU\", \"C\": \"龙芯一号\", \"D\": \"海思芯片\"}', 'C', '2026-09-13 09:57:12.785365', '2026-09-13 09:57:12.785365', '解析：2002年8月10日，我国成功制造出首枚高性能通用CPU，其名称为“龙芯一号”，这是我国自主研发的首款通用CPU，因此正确答案是C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (663, 1, '由中国科学研究院计算技术研究所研制的中国首个拥有自主知识产权的通用高性能CPU是()。', '{\"A\": \"龙芯二号\", \"B\": \"“申威”CPU\", \"C\": \"龙芯一号\", \"D\": \"海思芯片\"}', 'C', '2026-09-13 09:57:12.792346', '2026-09-13 09:57:12.792346', '解析：龙芯一号是中国科学研究院计算技术研究所研制的中国首个拥有自主知识产权的通用高性能CPU，因此正确答案是C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (664, 1, '神威系列超级计算机是由()研制', '{\"A\": \"国防科技大学计算机研究所\", \"B\": \"国家并行计算机工程技术中心\", \"C\": \"中科院计算技术研究所\", \"D\": \"联想集团\"}', 'B', '2026-09-13 09:57:12.799328', '2026-09-13 09:57:12.799328', '解析：神威系列超级计算机是由国家并行计算机工程技术中心研制，该中心是我国高性能计算机研发的主要机构之一，选项B正确。其他选项（如国防科技大学计算机研究所研制的是天河系列，中科院计算技术研究所和联想集团不负责神威系列）均不符合事实。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (665, 1, '曙光系列超级计算机是由()研制', '{\"A\": \"国防科技大学计算机研究所\", \"B\": \"国家并行计算机工程技术中心\", \"C\": \"中科院计算技术研究所\", \"D\": \"联想集团\"}', 'C', '2026-09-13 09:57:12.806310', '2026-09-13 09:57:12.806310', '解析：曙光系列超级计算机是由中科院计算技术研究所研制，该所承担了该系列计算机的研发任务，因此正确答案为C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (666, 1, '1983年,中国首台巨型计算机()在长沙国防科技大学研制成功,运算速度达每秒1亿次。', '{\"A\": \"神威I\", \"B\": \"派-曙光\", \"C\": \"“银河I号\", \"D\": \"天河1号\"}', 'C', '2026-09-13 09:57:12.812293', '2026-09-13 09:57:12.812293', '解析：中国首台巨型计算机是1983年在国防科技大学研制成功的“银河I号”，运算速度达每秒1亿次，而其他选项（神威I、派-曙光、天河1号）均不属于1983年研制的首台巨型机，因此选C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (667, 1, '()的诞生，打破了国外的长期技术垄断，结束了中国近二十年无“芯”的历史。', '{\"A\": \"龙芯二号\", \"B\": \"“申威”CPU\", \"C\": \"龙芯一号\", \"D\": \"海思芯片\"}', 'C', '2026-09-13 09:57:12.819303', '2026-09-13 09:57:12.819303', '解析：龙芯一号是我国首款自主研发的CPU芯片，它的诞生打破了国外技术垄断，结束了中国近二十年无自主芯片的历史。因此正确答案是C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (668, 1, 'ENIAC于1946年在美国()大学研制成功的', '{\"A\": \"宾夕法尼亚\", \"B\": \"斯坦福\", \"C\": \"普林斯顿\", \"D\": \"哈佛\"}', 'A', '2026-09-13 09:57:12.825286', '2026-09-13 09:57:12.825286', '解析：ENIAC（电子数字积分计算机）是世界上第一台通用电子计算机，于1946年在美国宾夕法尼亚大学研制成功，因此正确答案是A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (669, 1, '关于冯诺依曼体系结构设计思想,错误的是()。', '{\"A\": \"计算机由运算器、控制器、存储器和输入输出设备组成\", \"B\": \"计算机内部采用十进制表示指令和数据\", \"C\": \"将程序和数据存储在计算机中,启动程序运行时自动逐条执行指令\", \"D\": \"计算机内部采用二进制表示指令和数据\"}', 'B', '2026-09-13 09:57:12.831271', '2026-09-13 09:57:12.831271', '解析：冯诺依曼体系结构采用二进制表示指令和数据，而非十进制，因此选项B错误，而其他选项均符合其设计思想。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (670, 1, '从1971年至今，微型计算机迅猛发展，微机以()技术为特征标志。', '{\"A\": \"操作系统\", \"B\": \"微处理器\", \"C\": \"磁盘\", \"D\": \"软件\"}', 'B', '2026-09-13 09:57:12.838252', '2026-09-13 09:57:12.838252', '解析：微型计算机的发展以微处理器技术的更新换代为主要特征标志，因为微处理器的性能直接决定了计算机的处理能力和系统架构，而操作系统、磁盘和软件属于辅助或应用层面。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (671, 1, '使用MSI和SSI的计算机属于()计算机', '{\"A\": \"第一代\", \"B\": \"第二代\", \"C\": \"第三代\", \"D\": \"第四代\"}', 'C', '2026-09-13 09:57:12.844237', '2026-09-13 09:57:12.844237', '解析：MSI（中规模集成电路）和SSI（小规模集成电路）是第三代计算机（1965-1970年）的核心技术，因此选C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (672, 1, '早期的计算机体积大、耗电多、速度慢，其原因不包括()。', '{\"A\": \"电子元器件的制造工艺不成熟\", \"B\": \"计算机的存储器容量有限\", \"C\": \"计算机的工作原理不合理\", \"D\": \"制造计算机的技术水平落后\"}', 'C', '2026-09-13 09:57:12.850220', '2026-09-13 09:57:12.850220', '解析：计算机的工作原理（如冯·诺依曼体系）自早期至今基本一致，并非导致体积大、耗电多、速度慢的原因，因此C项不正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (673, 1, '摩尔定律是内行人摩尔的经验之谈，以下关于摩尔定律的叙述,正确的是()。', '{\"A\": \"摩尔定律并非自然科学定律，它一定程度揭示了信息技术进步的速度。\", \"B\": \"摩尔定律和Amdahl定律一样，将一直指导计算机系统的设计\", \"C\": \"摩尔定律是重要的计算机系统设计定量原理\", \"D\": \"摩尔定律将一直适用于描述器件技术的发展\"}', 'A', '2026-09-13 09:57:12.856203', '2026-09-13 09:57:12.856203', '解析：摩尔定律是经验观察而非自然科学定律，主要揭示了信息技术进步的速度，A选项表述准确。B、D选项错误，因为摩尔定律并非永久适用；C选项错误，摩尔定律不是系统设计的定量原理。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (674, 1, '人们常用“摩尔定律”来比喻当代科学技术的进步与发展日新月异,这里“摩尔定律”指的是()', '{\"A\": \"芯片集成晶体管的能力每年增长一倍，其计算能力也增长一倍\", \"B\": \"芯片集成晶体管的能力每五年增长一倍，其计算能力也增长一倍\", \"C\": \"芯片集成晶体管的能力每18-24个月增长一倍，其计算能力也增长一倍\", \"D\": \"芯片集成晶体管的能力每6个月增长一倍，其计算能力也增长一倍\"}', 'C', '2026-09-13 09:57:12.863185', '2026-09-13 09:57:12.863185', '解析：摩尔定律由戈登·摩尔提出，核心内容是芯片上集成的晶体管数量大约每18-24个月翻一番，同时计算能力也相应提升，因此选项C正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (675, 1, '下列关于第二代计算机说法正确的选项是()', '{\"A\": \"采用分时操作系统\", \"B\": \"使用的是高级程序设计语言\", \"C\": \"采用半导体存储器\", \"D\": \"应用领域开始步入过程控制、人工智能\"}', 'B', '2026-09-13 09:57:12.869169', '2026-09-13 09:57:12.869169', '解析：第二代计算机（约1956-1963年）使用晶体管，并开始使用高级程序设计语言（如FORTRAN、COBOL），因此选项B正确。其他选项中，分时操作系统属于第三代计算机，半导体存储器属于第四代计算机，过程控制和人工智能主要从第三代开始应用。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (676, 1, '下列关于国际公认的第一台计算机ENIAC的叙述中,正确的是()', '{\"A\": \"ENIAC是为了军事用途进行研制的\", \"B\": \"它使用了分时操作系统\", \"C\": \"ENIAC上没有采用电子管作为主要元器件\", \"D\": \"采用半导体存储器\"}', 'A', '2026-09-13 09:57:12.875154', '2026-09-13 09:57:12.875154', '解析：ENIAC（埃尼阿克）于1946年在美国研制成功，最初目的是为美国陆军计算弹道和射击表，属于军事用途，故A正确。它未使用分时操作系统（B错），主要元器件是电子管（C错），且未采用半导体存储器（D错）。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (677, 1, '第四代计算机在语言方面主要使用()', '{\"A\": \"机器语言\", \"B\": \"汇编语言\", \"C\": \"二进制\", \"D\": \"高级语言\"}', 'D', '2026-09-13 09:57:12.881137', '2026-09-13 09:57:12.881137', '解析：第四代计算机（约1970年代至今）以大规模和超大规模集成电路为基础，软件技术成熟，主要使用高级语言（如C、Java等）进行编程，提高了开发效率和可移植性，因此选D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (678, 1, '下列哪一项与第二代计算机无关()', '{\"A\": \"使用了晶体管\", \"B\": \"出现了批处理操作系统\", \"C\": \"采用汞延迟线作为主存储器\", \"D\": \"出现了高级程序设计语言\"}', 'C', '2026-09-13 09:57:12.888120', '2026-09-13 09:57:12.888120', '解析：第二代计算机（约1956-1963年）以晶体管为主要元件，出现了批处理操作系统和高级程序设计语言（如FORTRAN），而汞延迟线是第一代计算机（电子管时代）使用的存储技术，因此与第二代计算机无关。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (679, 1, '()是区分现代电子计算机发展的各个阶段的标志', '{\"A\": \"电子元器件\", \"B\": \"性价比\", \"C\": \"存储器\", \"D\": \"功能\"}', 'A', '2026-09-13 09:57:12.894103', '2026-09-13 09:57:12.894103', '解析：现代电子计算机的发展阶段主要依据其核心电子元器件的演变来划分，如从电子管到晶体管、集成电路等，因此电子元器件是区分各个阶段的标志。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (680, 1, '一至四代的计算机依次是()', '{\"A\": \"光子计算机,电子管计算机,纳米计算机,集成电路计算机\", \"B\": \"机械计算机,集成电路计算机,大规模集成电路计算机,量子计算机\", \"C\": \"电子管计算机,晶体管计算机,小、中规模集成电路计算机,大规模和超大规模集成电路计算机\", \"D\": \"晶体管计算机,电动机械计算机,电子管计算机,集成电路计算机\"}', 'C', '2026-09-13 09:57:12.900087', '2026-09-13 09:57:12.900087', '解析：计算机发展按代际划分，第一代是电子管计算机，第二代是晶体管计算机，第三代是小、中规模集成电路计算机，第四代是大规模和超大规模集成电路计算机，选项C准确对应了这一顺序。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (681, 1, '下列关于计算机发展的特点的叙述错误的是()', '{\"A\": \"微型计算机体积越来越小\", \"B\": \"计算机应用领域越来越多\", \"C\": \"计算机元器件越来越少\", \"D\": \"计算机运算速度越来越快\"}', 'C', '2026-09-13 09:57:12.906070', '2026-09-13 09:57:12.906070', '解析：计算机发展的特点是体积减小、应用领域扩大、运算速度加快，但计算机元器件数量并未减少，而是集成度提高，因此C选项错误。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (682, 1, '第四代计算机与上一代计算机相比,所采用的()一直没有发生变化.', '{\"A\": \"电子器件\", \"B\": \"运算速度\", \"C\": \"体系结构\", \"D\": \"所采用的程序设计语言\"}', 'C', '2026-09-13 09:57:12.913052', '2026-09-13 09:57:12.913052', '解析：第四代计算机采用大规模和超大规模集成电路，而上一代（第三代）采用中小规模集成电路，电子器件发生了变化；运算速度和程序设计语言随技术发展显著提升和更新，唯有计算机的体系结构（如冯·诺依曼结构）自诞生以来基本保持不变，因此选C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (683, 1, '随着无人驾驶汽车、无人驾驶公交、自动化工厂等出现,说明了()是未来计算机发展的总趋势', '{\"A\": \"微型化\", \"B\": \"巨型化\", \"C\": \"智能化\", \"D\": \"数字化\"}', 'C', '2026-09-13 09:57:12.919035', '2026-09-13 09:57:12.919035', '解析：无人驾驶汽车、无人驾驶公交、自动化工厂等应用依赖计算机模拟人类智能进行决策与操作，因此智能化是未来计算机发展的总趋势，其他选项不符题意。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (684, 1, '计算机依据()的不同可分为数字计算机、模拟计算机和数模混合计算机', '{\"A\": \"功能\", \"B\": \"处理数据的方式或类型\", \"C\": \"性能\", \"D\": \"使用范围\"}', 'B', '2026-09-13 09:57:12.926018', '2026-09-13 09:57:12.926018', '解析：计算机根据处理数据的方式或类型不同，可分为数字计算机（处理离散数据）、模拟计算机（处理连续数据）和数模混合计算机，因此选项B正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (685, 1, '()是中国科学院计算所自主研发的通用CPU', '{\"A\": \"“华睿1号”DSP芯片\", \"B\": \"麒麟服务器操作系统\", \"C\": \"华为鸿蒙系统(HUAWEIHarmonyOS）\", \"D\": \"“龙芯”通用CPU\"}', 'D', '2026-09-13 09:57:12.932001', '2026-09-13 09:57:12.932001', '解析：选项D“龙芯”通用CPU是中国科学院计算所自主研发的通用CPU，符合题目描述；其他选项如A是DSP芯片、B是操作系统、C是移动操作系统，均非通用CPU。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (686, 1, '下列()语言在第四代计算机期间内诞生', '{\"A\": \"机器语言\", \"B\": \"高级语言\", \"C\": \"数据库语言\", \"D\": \"面向对象语言\"}', 'D', '2026-09-13 09:57:12.937958', '2026-09-13 09:57:12.937958', '解析：第四代计算机（约1970年代至1980年代）以大规模集成电路为特征，期间诞生了面向对象语言（如Smalltalk），而机器语言、高级语言和数据库语言均在此前出现，因此选D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (687, 1, '配有双核处理器的个人计算机属于()计算机', '{\"A\": \"第一代\", \"B\": \"第二代\", \"C\": \"第三代\", \"D\": \"第四代\"}', 'D', '2026-09-13 09:57:12.943969', '2026-09-13 09:57:12.943969', '解析：双核处理器属于第四代计算机（超大规模集成电路）的典型特征，第一代至第三代分别采用电子管、晶体管和小规模集成电路，因此选D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (688, 1, '()提出了存储程序和采用二进制系统的设想', '{\"A\": \"冯.诺依曼\", \"B\": \"比尔.盖茨\", \"C\": \"莫里埃\", \"D\": \"香农\"}', 'A', '2026-09-13 09:57:12.950951', '2026-09-13 09:57:12.950951', '解析：冯·诺依曼提出了存储程序和采用二进制系统的设想，这一思想奠定了现代计算机体系结构的基础，因此选项A正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (689, 1, '下列关于第三代计算机的特点,下列选项中错误的是()', '{\"A\": \"采用半导体存储器\", \"B\": \"出现了分时操作系统\", \"C\": \"使用MSI和SSI\", \"D\": \"应用领域开始进入工业生产的过程控制和AI领域\"}', 'D', '2026-09-13 09:57:12.956934', '2026-09-13 09:57:12.956934', '解析：第三代计算机（1964-1971年）以中小规模集成电路（MSI和SSI）为核心，采用半导体存储器，并出现了分时操作系统，但应用领域进入工业生产的过程控制和AI领域是第四代计算机的特征，因此D选项错误。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (690, 1, '我们以前经常所说的“银河”“神威”,都是超算，它们都属于第()代计算机。', '{\"A\": \"一\", \"B\": \"二\", \"C\": \"三\", \"D\": \"四\"}', 'D', '2026-09-13 09:57:12.962919', '2026-09-13 09:57:12.962919', '解析：超算属于第四代计算机，因为第四代计算机采用大规模集成电路和超大规模集成电路技术，而“银河”“神威”等超算正是基于这类技术实现的高性能计算系统。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (691, 1, '中国第一枚通用CPU(godson)的中文名字叫()', '{\"A\": \"深腾\", \"B\": \"鸿蒙\", \"C\": \"长城\", \"D\": \"龙芯\"}', 'D', '2026-09-13 09:57:12.968902', '2026-09-13 09:57:12.968902', '解析：中国第一枚通用CPU“Godson”的中文名称是“龙芯”，由中国科学院计算技术研究所研制，因此正确答案为D。其他选项中，“深腾”是联想的高性能计算机，“鸿蒙”是华为的操作系统，“长城”是中国的航天或计算机品牌，均与CPU名称不符。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (692, 1, '世界上诞生的第一台电子计算机ENIAC的全名是()', '{\"A\": \"电子延迟存储自动计算机\", \"B\": \"电子数字积分计算机\", \"C\": \"离散变量自动电子计算机\", \"D\": \"电子存储通用计算机\"}', 'B', '2026-09-13 09:57:12.975885', '2026-09-13 09:57:12.975885', '解析：ENIAC的全称为“Electronic Numerical Integrator and Computer”，中文译为“电子数字积分计算机”，因此选项B正确。其他选项均与ENIAC的实际名称不符。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (693, 1, '第一台电子计算机ENIAC是()年在美国研制的.', '{\"A\": \"1956\", \"B\": \"1946\", \"C\": \"1949\", \"D\": \"1964\"}', 'B', '2026-09-13 09:57:12.981867', '2026-09-13 09:57:12.981867', '解析：ENIAC（电子数字积分计算机）于1946年在美国宾夕法尼亚大学研制成功，是世界上第一台通用电子计算机，因此选择B选项。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (694, 1, '()首次提出\"存储程序\"计算机体系结构', '{\"A\": \"冯·诺依曼\", \"B\": \"莱布尼茨\", \"C\": \"香农\", \"D\": \"布尔\"}', 'A', '2026-09-13 09:57:12.987852', '2026-09-13 09:57:12.987852', '解析：冯·诺依曼首次提出了“存储程序”计算机体系结构，这一概念是现代计算机设计的基础，因此正确选项为A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (695, 1, '计算机自诞生以来,()基本没有发生变化', '{\"A\": \"工作速度\", \"B\": \"采用的电子器件\", \"C\": \"存储容量\", \"D\": \"工作原理\"}', 'D', '2026-09-13 09:57:12.994384', '2026-09-13 09:57:12.994384', '解析：计算机自诞生以来，虽然电子器件、工作速度和存储容量经历了巨大变革，但其基于“存储程序控制”的核心工作原理始终未变，因此选D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (696, 1, '以下()不是计算机发展过程中的趋势', '{\"A\": \"电子元器件越来越先进\", \"B\": \"电子元器件越来越昂贵\", \"C\": \"电子元器件越来越可靠\", \"D\": \"电子元器件越来越省电\"}', 'B', '2026-09-13 09:57:13.000367', '2026-09-13 09:57:13.000367', '解析：计算机发展过程中，电子元器件趋于更先进、更可靠、更省电，而成本（价格）通常下降而非上升，因此“越来越昂贵”不符合趋势，故选B。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (697, 1, '根据使用电子元器件的不同，计算机的发展经历了以下()四个时代。', '{\"A\": \"低档计算机、中档计算机、高档计算机、手提计算机\", \"B\": \"微型计算机、小型计算机、中型计算机、大型计算机\", \"C\": \"光子计算机、生物计算机、量子计算机、纳米计算机\", \"D\": \"电子管、晶体管、MSI和SSI、LSI和VLSI\"}', 'D', '2026-09-13 09:57:13.007321', '2026-09-13 09:57:13.007321', '解析：计算机的发展阶段依据电子元器件的更新划分为电子管、晶体管、中小规模集成电路、大规模和超大规模集成电路四个时代，选项D准确对应这一划分标准，其他选项均不符合。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (698, 1, '下列关于第一代计算机叙述正确的是()', '{\"A\": \"主要逻辑元件采用的是集成电路\", \"B\": \"主要应用领域以军事和科学计算为主\", \"C\": \"主存储器采用半导体存储器\", \"D\": \"第一代计算机速度快\"}', 'B', '2026-09-13 09:57:13.013332', '2026-09-13 09:57:13.013332', '解析：第一代计算机（1946-1958年）主要逻辑元件采用电子管，主存储器使用磁鼓或延迟线，速度较慢，主要应用于军事和科学计算，因此选项B正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (699, 1, '从第一台计算机诞生到现在的半个多世纪里计算机的发展经历了()个阶段。', '{\"A\": \"3\", \"B\": \"4\", \"C\": \"5\", \"D\": \"6\"}', 'B', '2026-09-13 09:57:13.019319', '2026-09-13 09:57:13.019319', '解析：计算机的发展历程通常划分为四个阶段，分别以电子管、晶体管、中小规模集成电路和大规模超大规模集成电路为标志，因此正确答案是B。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (700, 1, '()是世界上第一台电子计算机英文缩写名', '{\"A\": \"ENIAC\", \"B\": \"EDVAC\", \"C\": \"EDSAC\", \"D\": \"MARK-II\"}', 'A', '2026-09-13 09:57:13.026298', '2026-09-13 09:57:13.026298', '解析：ENIAC（埃尼阿克）于1946年诞生于美国，被公认为世界上第一台通用电子计算机，因此正确答案是A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (701, 1, 'ENIAC把科学家们从奴隶般的计算中解放出来，ENIAC的诞生主要是为了满足()的需要.', '{\"A\": \"数据处理\", \"B\": \"人工模拟\", \"C\": \"科学计算\", \"D\": \"图像显示\"}', 'C', '2026-09-13 10:23:07.095219', '2026-09-13 10:23:07.095219', '解析：ENIAC是世界上第一台通用电子计算机，其诞生背景是二战期间为快速计算弹道轨迹等复杂科学问题，因此主要满足科学计算的需要。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (702, 1, '世界上第一片微处理器4004是由()公司在1971年10月推出的.', '{\"A\": \"Intel\", \"B\": \"IBM\", \"C\": \"AMD\", \"D\": \"Microsoft\"}', 'A', '2026-09-13 10:23:07.104195', '2026-09-13 10:23:07.104195', '解析：世界上第一片微处理器4004由Intel公司在1971年10月推出，因此选项A正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (703, 1, '下列关于世界上第一台电子计算机ENIAC的叙述中,有误的一项是()', '{\"A\": \"它没有存储器\", \"B\": \"它主要用于科学计算\", \"C\": \"价格昂贵\", \"D\": \"使用高级语言进行程序设计\"}', 'D', '2026-09-13 10:23:07.112173', '2026-09-13 10:23:07.112173', '解析：ENIAC使用机器语言进行程序设计，而非高级语言，因此D选项错误；A选项ENIAC没有存储器（仅有寄存器），B选项主要用于科学计算，C选项价格昂贵，均正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (704, 1, '下列不属于中国超算系列的是()', '{\"A\": \"神威\", \"B\": \"长城\", \"C\": \"银河\", \"D\": \"天河\"}', 'B', '2026-09-13 10:23:07.120152', '2026-09-13 10:23:07.120152', '解析：中国超算系列包括神威、银河和天河，而“长城”属于中国航天或计算机品牌，不属于超算系列，因此选B。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (705, 1, '全球第一台小型机PDP-80诞生于()', '{\"A\": \"第一代计算机时期\", \"B\": \"第二代计算机时期\", \"C\": \"第三代计算机时期\", \"D\": \"第四代计算机时期\"}', 'C', '2026-09-13 10:23:07.126136', '2026-09-13 10:23:07.126136', '解析：全球第一台小型机PDP-8诞生于1965年，属于集成电路计算机时期，即第三代计算机时期（1964-1971年），因此正确答案是C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (706, 1, '下列属于第二代计算机特点的是()', '{\"A\": \"开始使用高级语言\", \"B\": \"采用汞延迟线存储器\", \"C\": \"计算机速度极快\", \"D\": \"采用分时操作系统\"}', 'A', '2026-09-13 10:23:07.133117', '2026-09-13 10:23:07.133117', '解析：第二代计算机（晶体管计算机）开始使用高级语言（如FORTRAN、COBOL），而汞延迟线存储器属于第一代计算机特点，速度极快和分时操作系统属于第三代及以后计算机特点，因此A正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (707, 1, '第四代计算机主要采用的逻辑元件是()', '{\"A\": \"电子管\", \"B\": \"晶体管\", \"C\": \"中小规模集成电路\", \"D\": \"超大规模集成电路\"}', 'D', '2026-09-13 10:23:07.140099', '2026-09-13 10:23:07.140099', '解析：第四代计算机（约1971年至今）主要采用超大规模集成电路（VLSI），集成度高、功耗低，取代了前几代使用的电子管、晶体管或中小规模集成电路，因此选D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (708, 1, '在计算机发展的历史中,我们可以看到()是错误的', '{\"A\": \"性价比越来越低\", \"B\": \"整体体积变小,耗电量也有所下降\", \"C\": \"功能越来越丰富\", \"D\": \"逻辑元件集成度越来越高\"}', 'A', '2026-09-13 10:23:07.147080', '2026-09-13 10:23:07.147080', '解析：随着计算机技术的发展，计算机的性价比（性能与价格之比）不断提高，而非越来越低，因此A选项描述错误。其他选项均符合计算机发展的实际趋势。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (709, 1, '在冯.诺依曼体系结构中，设计计算机的核心指导思想是()。', '{\"A\": \"存储计算\", \"B\": \"存储程序\", \"C\": \"自动控制\", \"D\": \"采用二进制\"}', 'B', '2026-09-13 10:23:07.154062', '2026-09-13 10:23:07.154062', '解析：冯·诺依曼体系结构的核心指导思想是“存储程序”，即将程序指令和数据一起存储在内存中，使计算机能够自动执行指令序列，因此选项B正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (710, 1, '第四代计算机主要是使用了()电子元器件', '{\"A\": \"电子管\", \"B\": \"晶体管\", \"C\": \"中小规模集成电路(MSI、SSI)\", \"D\": \"超大规模集成电路\"}', 'D', '2026-09-13 10:23:07.161043', '2026-09-13 10:23:07.161043', '解析：第四代计算机（约1970年代后）以超大规模集成电路为主要电子元器件，因其集成度高、体积小、功耗低，显著提升了计算机性能，而电子管、晶体管和中小规模集成电路分别属于前代技术。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (711, 1, '下面选项中()不属于中国的超算系列', '{\"A\": \"银河\", \"B\": \"天河\", \"C\": \"神威\", \"D\": \"神舟\"}', 'D', '2026-09-13 10:23:07.169022', '2026-09-13 10:23:07.169022', '解析：神舟是中国载人航天飞船系列，不属于超算系列；而银河、天河、神威均为中国超级计算机系列，故正确答案为D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (712, 1, '下列关于第一代计算机的叙述中错误的是()', '{\"A\": \"使用了高级语言\", \"B\": \"主存储器的变化:汞延迟线——阴极射线示波管静电存储器——磁鼓——磁芯\", \"C\": \"输入、输出设备主要是用穿孔卡片,用户使用起来很不方便\", \"D\": \"运算速度为每秒数千次至数万次\"}', 'A', '2026-09-13 10:23:07.175006', '2026-09-13 10:23:07.175006', '解析：第一代计算机采用机器语言或汇编语言，尚未出现高级语言，因此选项A错误；其他选项均符合第一代计算机的特征。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (713, 1, '我国研制的“银河””神威””天河”等计算机都属于()计算机。', '{\"A\": \"超巨型\", \"B\": \"巨型\", \"C\": \"大型\", \"D\": \"中型\"}', 'B', '2026-09-13 10:23:07.181987', '2026-09-13 10:23:07.181987', '解析：我国研制的“银河”“神威”“天河”系列计算机均属于巨型计算机，因为它们在运算速度、存储容量和并行处理能力上达到国际领先水平，专门用于解决大规模科学计算和工程问题，符合巨型计算机的定义。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (714, 1, '下列关于第二代计算机的叙述中错误的是()', '{\"A\": \"第二代电子计算机主要采用了电子管\", \"B\": \"第二代计算机采用了磁盘作为外存储器\", \"C\": \"第二代计算机上使用了高级程序设计语言\", \"D\": \"出现了操作系统\"}', 'A', '2026-09-13 10:23:07.188968', '2026-09-13 10:23:07.188968', '解析：第二代计算机主要采用晶体管，而非电子管，电子管是第一代计算机的特征，因此A选项错误。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (715, 1, '计算机经过不断换代更新，应用领域可以说是非常广泛,,那么追溯到第一台计算机,它的应用领域是()', '{\"A\": \"科学计算\", \"B\": \"信息处理\", \"C\": \"过程控制\", \"D\": \"辅助设计\"}', 'A', '2026-09-13 10:23:07.196947', '2026-09-13 10:23:07.196947', '解析：第一台计算机ENIAC诞生于1946年，主要用于军事领域的弹道计算，因此其最初的应用领域是科学计算。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (716, 1, '下列说法不正确的是()。', '{\"A\": \"Intel4004是世界上第一片微处理器\", \"B\": \"Intel4004是第一片真正用于微型计算机的CPU\", \"C\": \"Inel8086是第一片真正用于微型计算机的CPU\", \"D\": \"装有Intel8088CPU的微型计算机是第一台适合大众的微型计算机\"}', 'B', '2026-09-13 10:23:07.203928', '2026-09-13 10:23:07.203928', '解析：Intel4004虽然是世界上第一片微处理器，但它并非专门为微型计算机设计，而是用于计算器；真正用于微型计算机的第一片CPU是Intel8086，因此B选项说法不正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (717, 1, '计算机所具有的存储程序和程序原理是()提出的。', '{\"A\": \"图灵\", \"B\": \"布尔\", \"C\": \"冯.诺依曼\", \"D\": \"爱迪生\"}', 'C', '2026-09-13 10:23:07.209913', '2026-09-13 10:23:07.209913', '解析：冯·诺依曼提出了存储程序的概念，即程序和数据以二进制形式存储在存储器中，并由计算机自动执行，这一原理被称为冯·诺依曼体系结构。其他选项：图灵主要贡献于计算理论，布尔与逻辑代数相关，爱迪生是发明家，均不涉及存储程序原理。因此正确答案是C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (718, 1, '第二代计算机主要是使用了()元器件。', '{\"A\": \"电子管\", \"B\": \"晶体管\", \"C\": \"中小规模集成电路\", \"D\": \"超大规模集成电路\"}', 'B', '2026-09-13 10:23:07.215896', '2026-09-13 10:23:07.215896', '解析：第二代计算机（约1956-1963年）采用晶体管作为核心元器件，相比第一代的电子管，体积更小、功耗更低、可靠性更高，因此正确答案是B。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (719, 1, '当前的计算机一般被认为是第四代计算机，它所采用的逻辑元件是()。', '{\"A\": \"中小规模集成电路\", \"B\": \"晶体管\", \"C\": \"大规模集成电路\", \"D\": \"电子管\"}', 'C', '2026-09-13 10:23:07.222878', '2026-09-13 10:23:07.222878', '解析：第四代计算机（20世纪70年代至今）采用大规模和超大规模集成电路作为逻辑元件，显著提升了集成度和性能，因此选项C正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (720, 1, '第一台计算机ENIAC的最大的缺点是()。', '{\"A\": \"缺乏存储程序的能力\", \"B\": \"体积庞大\", \"C\": \"没有操作系统，操作太繁琐\", \"D\": \"价格昂贵\"}', 'A', '2026-09-13 10:23:07.228862', '2026-09-13 10:23:07.228862', '解析：ENIAC采用外部插线编程方式，无法存储程序，每次计算需重新连线，这是其最大技术缺陷。其他选项虽属实，但非核心缺点。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (721, 1, '第3代计算机采用()作为主存储器。', '{\"A\": \"汞延迟线\", \"B\": \"阴极射线示波管静电存储器\", \"C\": \"半导体存储器\", \"D\": \"磁芯\"}', 'C', '2026-09-13 10:23:07.234846', '2026-09-13 10:23:07.234846', '解析：第3代计算机（1964-1971年）以集成电路为核心，主存储器采用半导体存储器，因其体积小、速度快、功耗低，取代了前代的磁芯存储器。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (722, 1, '早期的计算机体积大、耗电多、速度慢，其主要原因是被()制约。', '{\"A\": \"元材料\", \"B\": \"工艺水平\", \"C\": \"设计水平\", \"D\": \"元器件\"}', 'D', '2026-09-13 10:23:07.241827', '2026-09-13 10:23:07.241827', '解析：早期计算机使用电子管作为核心元器件，电子管体积大、功耗高、速度慢，因此主要受元器件性能制约。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (723, 1, '第四代计算机的时间段是()', '{\"A\": \"1964—1971\", \"B\": \"1948—1958\", \"C\": \"1954—1964\", \"D\": \"1971至今\"}', 'D', '2026-09-13 10:23:07.247811', '2026-09-13 10:23:07.247811', '解析：第四代计算机以大规模和超大规模集成电路为核心，始于1971年Intel 4004微处理器问世，并持续至今，因此正确时间段是1971年至今。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (724, 1, '我国1971年研制出第一台()', '{\"A\": \"晶体管计算机\", \"B\": \"电子管计算机\", \"C\": \"集成电路计算机\", \"D\": \"巨型机\"}', 'C', '2026-09-13 10:23:07.255790', '2026-09-13 10:23:07.255790', '解析：我国1971年研制出的第一台集成电路计算机，标志着计算机技术从晶体管向集成电路的跨越，故选C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (725, 1, '下列关于第三代计算机的特点，不正确的是()。', '{\"A\": \"采用了集成电路\", \"B\": \"出现了分时操作系统\", \"C\": \"出现了面向对象语言\", \"D\": \"计算机的体格、重量、功耗进一步减小\"}', 'C', '2026-09-13 10:23:07.261773', '2026-09-13 10:23:07.262771', '解析：第三代计算机采用集成电路，体积、重量和功耗减小，并出现分时操作系统；而面向对象语言出现于第四代计算机，因此C项不正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (726, 1, '下列说法正确的是()。', '{\"A\": \"第三代计算机采用电子管作为逻辑开关元件\", \"B\": \"1959~1964年期间生产的计算机被称为第二代产品\", \"C\": \"现在的计算机采用晶体管作为逻辑开关元件\", \"D\": \"计算机将取代人类的智力活动\"}', 'B', '2026-09-13 10:23:07.268755', '2026-09-13 10:23:07.268755', '解析：选项B正确，因为第二代计算机（约1959-1964年）采用晶体管作为逻辑开关元件；A错误，第三代计算机采用中小规模集成电路；C错误，现代计算机采用超大规模集成电路；D错误，计算机无法完全取代人类智力活动。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (727, 1, '第一代计算机的内存储器为()。', '{\"A\": \"水银延迟线或电子射线管\", \"B\": \"磁芯存储器\", \"C\": \"半导体存储器\", \"D\": \"高集成度的半导体存储器\"}', 'A', '2026-09-13 10:23:07.274739', '2026-09-13 10:23:07.274739', '解析：第一代计算机（1946-1957年）采用电子管作为主要逻辑元件，内存储器主要使用水银延迟线或电子射线管（如威廉姆斯管），而磁芯存储器属于第二代计算机，半导体存储器则属于后期技术。因此，选项A正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (728, 1, '()是第二代计算机的标志', '{\"A\": \"面向对象程序设计语言\", \"B\": \"中小规模集成电路\", \"C\": \"晶体管\", \"D\": \"半导体存储器\"}', 'C', '2026-09-13 10:23:07.281721', '2026-09-13 10:23:07.281721', '解析：第二代计算机（约1958-1964年）以晶体管取代电子管作为核心元件，因此晶体管是其标志性技术，故选C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (729, 1, '下列关于世界上第一台电子计算机ENIAC的叙述中，正确的是()。', '{\"A\": \"它采用批处理操作系统\", \"B\": \"它使用高级程序设计语言\", \"C\": \"它是首次采用存储程序控制使计算机自动工作\", \"D\": \"它主要用于军事应用和科学研究\"}', 'D', '2026-09-13 10:23:07.287704', '2026-09-13 10:23:07.287704', '解析：ENIAC是世界上第一台通用电子计算机，主要用于军事应用（如计算弹道）和科学研究，因此D正确。A错误，ENIAC没有操作系统；B错误，它使用机器语言而非高级语言；C错误，存储程序控制概念由冯·诺依曼提出，ENIAC尚未采用。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (730, 1, '计算机科学的奠基人是()', '{\"A\": \"约翰.阿塔那索夫\", \"B\": \"比尔.盖茨\", \"C\": \"图灵\", \"D\": \"巴贝奇\"}', 'C', '2026-09-13 10:23:07.293688', '2026-09-13 10:23:07.293688', '解析：图灵被誉为“计算机科学之父”，因提出图灵机模型和计算理论，奠定了计算机科学的理论基础，因此是奠基人。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (731, 1, '第一台计算机ENIAC的最严重的缺点是()。', '{\"A\": \"缺乏存储程序的能力\", \"B\": \"体积庞大\", \"C\": \"没有操作系统，操作太繁琐\", \"D\": \"耗电量太大\"}', 'A', '2026-09-13 10:23:07.299672', '2026-09-13 10:23:07.300670', '解析：ENIAC作为第一台电子计算机，其主要缺陷在于无法存储程序，必须通过手动插拔线路和设置开关来改变计算任务，这严重限制了其灵活性和效率，而体积、耗电量和操作繁琐虽为缺点，但并非最严重。因此选A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (732, 1, '提出计算机内的程序和数据都应采用二进制代码表示的科学家是()。', '{\"A\": \"爱因斯坦\", \"B\": \"莱布尼兹\", \"C\": \"比尔盖茨\", \"D\": \"冯.诺依曼\"}', 'D', '2026-09-13 10:23:07.306654', '2026-09-13 10:23:07.306654', '解析：冯·诺依曼提出了存储程序概念，并明确计算机内的程序和数据都应采用二进制代码表示，因此正确答案是D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (733, 1, '1958年8月1日，我国第一台小型电子管数字计算机诞生，命名为()', '{\"A\": \"神威\", \"B\": \"曙光\", \"C\": \"天河\", \"D\": \"103机\"}', 'D', '2026-09-13 10:23:07.312638', '2026-09-13 10:23:07.312638', '解析：我国第一台小型电子管数字计算机于1958年8月1日诞生，被命名为“103机”，这是中国计算机事业的起点，而“神威”“曙光”“天河”均为后续型号。因此正确答案是D。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (734, 1, '下列哪一项不是计算机发展史中曾经用于内存储器的设备()。', '{\"A\": \"水银延迟线\", \"B\": \"磁芯\", \"C\": \"磁鼓\", \"D\": \"磁盘\"}', 'D', '2026-09-13 10:23:07.319619', '2026-09-13 10:23:07.319619', '解析：水银延迟线、磁芯和磁鼓都曾作为计算机内存储器使用，而磁盘属于外存储器，故不是内存储器设备。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (735, 1, '下列关于第二代计算机的特点叙述正确的是()。', '{\"A\": \"第二代计算机使用批处理操作系统\", \"B\": \"第二代计算机使用面向对象程序设计语言\", \"C\": \"第二代计算机上开始使用图形操作系统\", \"D\": \"第二代计算机应用领域开始进入文字处理和图形图像处理领域\"}', 'A', '2026-09-13 10:23:07.325603', '2026-09-13 10:23:07.325603', '解析：第二代计算机（约1956-1963年）采用晶体管，并开始使用批处理操作系统（如FORTRAN监控系统）来提高效率，因此A正确。而面向对象语言（如C++）出现于20世纪80年代，图形操作系统（如Windows）始于20世纪80年代，文字处理和图形图像处理进入计算机应用领域是在第三代和第四代计算机时期，故B、C、D均错误。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (736, 1, '下列关于第四代计算机的特点，正确的是()。', '{\"A\": \"硬件方面采用MSI和SSI\", \"B\": \"软件方面出现了数据库管理系统、网络管理系统和面向对象语言等\", \"C\": \"相比较以前的计算机主要是元器件数量减少、价格降低\", \"D\": \"计算机速度最高可达每秒数千万次\"}', 'B', '2026-09-13 10:23:07.332585', '2026-09-13 10:23:07.332585', '解析：第四代计算机采用大规模和超大规模集成电路（LSI和VLSI），而非MSI和SSI（A错误）。软件方面出现了数据库管理系统、网络管理系统和面向对象语言等（B正确）。C选项描述的是通用趋势而非第四代特有特征，且元器件数量减少、价格降低并非主要特点。D选项中速度最高可达每秒数千万次属于第三代计算机（如IBM 360）的性能范围，第四代计算机速度可达每秒数亿次以上。因此B正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (737, 1, '()是冯.诺依曼体系结构计算机的基本思想之一。', '{\"A\": \"存储器容量大\", \"B\": \"存储程序控制\", \"C\": \"处理速度快\", \"D\": \"高精度\"}', 'B', '2026-09-13 10:23:07.339565', '2026-09-13 10:23:07.339565', '解析：冯·诺依曼体系结构计算机的核心思想是“存储程序控制”，即程序和数据预先存储在存储器中，计算机按指令顺序自动执行。其他选项属于性能指标，非基本思想。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (738, 1, '下列关于第一代计算机的说法正确的是()。', '{\"A\": \"第一代计算机主要采用集成电路作为主要元器件\", \"B\": \"第一代计算机大致从1964年到1970年\", \"C\": \"第一代计算机应用领域以科学计算和数据处理为主\", \"D\": \"第一代计算机使用机器语言\"}', 'D', '2026-09-13 10:23:07.345549', '2026-09-13 10:23:07.345549', '解析：第一代计算机（1946-1957年）采用电子管作为主要元器件，而非集成电路（A错误）；其时间范围并非1964-1970年（B错误）；应用领域以科学计算为主，但数据处理并非主要（C不准确）；第一代计算机使用机器语言编程（D正确）。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (739, 1, '下列关于第一代计算机说法正确的是()。', '{\"A\": \"主要逻辑元件采用的是晶体管\", \"B\": \"第一代计算机体积大、速度慢、造价贵、存储量小、可靠性差、不易掌握\", \"C\": \"主存储器采用汞延迟线、阴极射线示波管静电存储器、磁鼓、磁芯、磁带\", \"D\": \"第一代计算机速度一般为每秒数十万次至数千万次\"}', 'B', '2026-09-13 10:23:07.352531', '2026-09-13 10:23:07.352531', '解析：第一代计算机采用电子管作为主要逻辑元件（A错误），主存储器使用汞延迟线或磁鼓但未包含磁芯、磁带（C错误），运算速度仅每秒几千至几万次（D错误），而B选项准确描述了其体积大、速度慢、造价贵、存储量小、可靠性差、不易掌握的特点，因此正确。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (740, 1, '采用超大规模集成电路属于第()代计算机。', '{\"A\": \"4\", \"B\": \"3\", \"C\": \"2\", \"D\": \"1\"}', 'A', '2026-09-13 10:23:07.358515', '2026-09-13 10:23:07.358515', '解析：超大规模集成电路是第四代计算机的主要特征，因此正确答案为A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (741, 1, '设计制造计算机最初的目的是(),其主要面向于军事领域', '{\"A\": \"科学计算\", \"B\": \"信息处理\", \"C\": \"自动控制\", \"D\": \"辅助设计\"}', 'A', '2026-09-13 10:23:07.365496', '2026-09-13 10:23:07.365496', '解析：设计制造计算机最初的目的就是科学计算，因为世界上第一台电子计算机ENIAC主要用于计算弹道轨迹等军事问题，所以正确答案是A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (742, 1, '世界上第一台微处理器Inter4004的字长是()位的。', '{\"A\": \"4\", \"B\": \"8\", \"C\": \"16\", \"D\": \"64\"}', 'A', '2026-09-13 10:23:07.371481', '2026-09-13 10:23:07.371481', '解析：Intel 4004是世界上第一台微处理器，其数据总线宽度为4位，因此字长是4位，故正确答案为A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (743, 1, '计算机行业的迅速发展实质上就是()的迅猛发展。', '{\"A\": \"操作系统\", \"B\": \"电子元器件\", \"C\": \"应用领域\", \"D\": \"存储容量\"}', 'B', '2026-09-13 10:23:07.377464', '2026-09-13 10:23:07.377464', '解析：计算机行业的迅速发展实质上是电子元器件的迅猛发展，因为电子元器件（如芯片、晶体管）的进步直接推动了计算机性能的提升和成本的降低，而操作系统、应用领域和存储容量都是依赖于此基础。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (744, 1, '()是第四代计算机所不具备的特点', '{\"A\": \"出现了微处理器\", \"B\": \"采用LSI和VLSI\", \"C\": \"内存储器采用集成度越来越高的半导体存储器\", \"D\": \"性价比比第三代低\"}', 'D', '2026-09-13 10:23:07.384445', '2026-09-13 10:23:07.384445', '解析：第四代计算机以微处理器、大规模集成电路（LSI）和超大规模集成电路（VLSI）、高集成度半导体存储器为特征，性价比显著高于第三代，因此D选项表述错误。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (745, 1, '美国英特尔公司制成的第一片微处理器Inter4004是在()。', '{\"A\": \"40年代末\", \"B\": \"50年代初\", \"C\": \"70年代初\", \"D\": \"80年代初\"}', 'C', '2026-09-13 10:23:07.391427', '2026-09-13 10:23:07.391427', '解析：美国英特尔公司于1971年成功研制出第一片微处理器Intel 4004，标志着微处理器时代的开始，因此正确答案为C（70年代初）。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (746, 1, '第一台计算机ENIAC具有划时代的意义，但也有很多缺陷，其中最主要的缺点是()。', '{\"A\": \"体积庞大，耗电，使用非常不方便\", \"B\": \"没有采用二进制数形式来表示数据\", \"C\": \"没有实现存储程序，不能自动运行程序\", \"D\": \"硬件和软件没有明确区分开，混杂在一起\"}', 'C', '2026-09-13 10:23:07.397411', '2026-09-13 10:23:07.397411', '解析：ENIAC的主要缺点是没有采用存储程序的概念，无法自动运行程序，每次执行任务都需要人工重新布线，因此正确答案是C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (747, 1, '()是揭示信息技术进步的速度的定律，其内容为：当价格不变时，集成电路上可容纳的元器件的数目，约每隔18-24个月便会增加一倍，性能也将提升一倍。', '{\"A\": \"摩尔定律\", \"B\": \"布尔定律\", \"C\": \"黄金分割定律\", \"D\": \"牛顿定律\"}', 'A', '2026-09-13 10:23:07.404393', '2026-09-13 10:23:07.404393', '解析：题目描述的是关于信息技术进步速度的定律，其核心是集成电路上元器件数目约每18-24个月翻倍、性能提升，这完全符合摩尔定律的定义。其他选项如布尔定律（逻辑代数）、黄金分割定律（美学比例）和牛顿定律（力学）均不匹配。因此选A。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (748, 1, '我们平常说的微机采用的元器件是()', '{\"A\": \"电子管\", \"B\": \"晶体管\", \"C\": \"MSI和SSI\", \"D\": \"LSI和VLSI\"}', 'D', '2026-09-13 10:23:07.411372', '2026-09-13 10:23:07.411372', '解析：微机采用大规模集成电路（LSI）和超大规模集成电路（VLSI）作为核心元器件，因其集成度高、体积小、功耗低，而电子管、晶体管和中规模集成电路（MSI）及小规模集成电路（SSI）均不符合现代微机的发展阶段。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (749, 1, '下列选项中,没有参与第一代计算机研究的科学家是()', '{\"A\": \"莫奇来\", \"B\": \"爱克特\", \"C\": \"爱迪生\", \"D\": \"冯·诺依曼\"}', 'C', '2026-09-13 10:23:07.418355', '2026-09-13 10:23:07.418355', '解析：第一代计算机的研究主要涉及电子计算机的早期发展，莫奇来、爱克特和冯·诺依曼均参与了ENIAC等项目的研制，而爱迪生主要贡献在电灯和电力系统等领域，未参与计算机研究，因此选C。', 3, 2, 5, 1, 'admin', 1);
INSERT INTO `quiz_question` VALUES (750, 1, '下列关于第二代计算机的叙述中,正确的一项是()', '{\"A\": \"采用晶体管作为基本元件\", \"B\": \"只能用于科学计算\", \"C\": \"程序设计采用了面向对象的高级语言\", \"D\": \"出现了分时操作系统\"}', 'A', '2026-09-13 10:23:07.424339', '2026-09-13 10:23:07.424339', '解析：第二代计算机采用晶体管作为基本元件，替代了第一代的电子管，因此选项A正确。选项B错误，因为第二代计算机已扩展应用于数据处理等领域；选项C错误，面向对象语言出现于更晚时期；选项D错误，分时操作系统主要出现在第三代计算机时代。', 3, 2, 5, 1, 'admin', 1);

-- ----------------------------
-- Table structure for quiz_question_knowledge_points
-- ----------------------------
DROP TABLE IF EXISTS `quiz_question_knowledge_points`;
CREATE TABLE `quiz_question_knowledge_points`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_id` bigint(20) NOT NULL,
  `knowledgepoint_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `quiz_question_knowledge__question_id_knowledgepoi_a627756f_uniq`(`question_id`, `knowledgepoint_id`) USING BTREE,
  INDEX `quiz_question_knowle_knowledgepoint_id_80bf4220_fk_quiz_know`(`knowledgepoint_id`) USING BTREE,
  CONSTRAINT `quiz_question_knowle_knowledgepoint_id_80bf4220_fk_quiz_know` FOREIGN KEY (`knowledgepoint_id`) REFERENCES `quiz_knowledgepoint` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_question_knowle_question_id_386ec46c_fk_quiz_ques` FOREIGN KEY (`question_id`) REFERENCES `quiz_question` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 751 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_question_knowledge_points
-- ----------------------------
INSERT INTO `quiz_question_knowledge_points` VALUES (1, 1, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (2, 2, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (3, 3, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (4, 4, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (5, 5, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (6, 6, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (7, 7, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (8, 8, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (9, 9, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (10, 10, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (11, 11, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (12, 12, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (13, 13, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (14, 14, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (15, 15, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (16, 16, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (17, 17, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (18, 18, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (19, 19, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (20, 20, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (21, 21, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (22, 22, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (23, 23, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (24, 24, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (25, 25, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (26, 26, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (27, 27, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (28, 28, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (29, 29, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (30, 30, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (31, 31, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (32, 32, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (33, 33, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (34, 34, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (35, 35, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (36, 36, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (37, 37, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (38, 38, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (39, 39, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (40, 40, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (41, 41, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (42, 42, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (43, 43, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (44, 44, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (45, 45, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (46, 46, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (47, 47, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (48, 48, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (49, 49, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (50, 50, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (51, 51, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (52, 52, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (53, 53, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (54, 54, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (55, 55, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (56, 56, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (57, 57, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (58, 58, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (59, 59, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (60, 60, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (61, 61, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (62, 62, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (63, 63, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (64, 64, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (65, 65, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (66, 66, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (67, 67, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (68, 68, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (69, 69, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (70, 70, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (71, 71, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (72, 72, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (73, 73, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (74, 74, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (75, 75, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (76, 76, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (77, 77, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (78, 78, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (79, 79, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (80, 80, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (81, 81, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (82, 82, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (83, 83, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (84, 84, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (85, 85, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (86, 86, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (87, 87, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (88, 88, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (89, 89, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (90, 90, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (91, 91, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (92, 92, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (93, 93, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (94, 94, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (95, 95, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (96, 96, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (97, 97, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (98, 98, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (99, 99, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (100, 100, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (101, 101, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (102, 102, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (103, 103, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (104, 104, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (105, 105, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (106, 106, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (107, 107, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (108, 108, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (109, 109, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (110, 110, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (111, 111, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (112, 112, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (113, 113, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (114, 114, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (115, 115, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (116, 116, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (117, 117, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (118, 118, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (119, 119, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (120, 120, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (121, 121, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (122, 122, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (123, 123, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (124, 124, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (125, 125, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (126, 126, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (127, 127, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (128, 128, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (129, 129, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (130, 130, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (131, 131, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (132, 132, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (133, 133, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (134, 134, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (135, 135, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (136, 136, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (137, 137, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (138, 138, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (139, 139, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (140, 140, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (141, 141, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (142, 142, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (143, 143, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (144, 144, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (145, 145, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (146, 146, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (147, 147, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (148, 148, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (149, 149, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (150, 150, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (151, 151, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (152, 152, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (153, 153, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (154, 154, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (155, 155, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (156, 156, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (157, 157, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (158, 158, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (159, 159, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (160, 160, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (161, 161, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (162, 162, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (163, 163, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (164, 164, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (165, 165, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (166, 166, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (167, 167, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (168, 168, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (169, 169, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (170, 170, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (171, 171, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (172, 172, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (173, 173, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (174, 174, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (175, 175, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (176, 176, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (177, 177, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (178, 178, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (179, 179, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (180, 180, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (181, 181, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (182, 182, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (183, 183, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (184, 184, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (185, 185, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (186, 186, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (187, 187, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (188, 188, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (189, 189, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (190, 190, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (191, 191, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (192, 192, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (193, 193, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (194, 194, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (195, 195, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (196, 196, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (197, 197, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (198, 198, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (199, 199, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (200, 200, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (201, 201, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (202, 202, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (203, 203, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (204, 204, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (205, 205, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (206, 206, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (207, 207, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (208, 208, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (209, 209, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (210, 210, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (211, 211, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (212, 212, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (213, 213, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (214, 214, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (215, 215, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (216, 216, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (217, 217, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (218, 218, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (219, 219, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (220, 220, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (221, 221, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (222, 222, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (223, 223, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (224, 224, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (225, 225, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (226, 226, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (227, 227, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (228, 228, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (229, 229, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (230, 230, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (231, 231, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (232, 232, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (233, 233, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (234, 234, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (235, 235, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (236, 236, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (237, 237, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (238, 238, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (239, 239, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (240, 240, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (241, 241, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (242, 242, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (243, 243, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (244, 244, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (245, 245, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (246, 246, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (247, 247, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (248, 248, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (249, 249, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (250, 250, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (251, 251, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (252, 252, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (253, 253, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (254, 254, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (255, 255, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (256, 256, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (257, 257, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (258, 258, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (259, 259, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (260, 260, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (261, 261, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (262, 262, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (263, 263, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (264, 264, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (265, 265, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (266, 266, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (267, 267, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (268, 268, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (269, 269, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (270, 270, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (271, 271, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (272, 272, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (273, 273, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (274, 274, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (275, 275, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (276, 276, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (277, 277, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (278, 278, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (279, 279, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (280, 280, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (281, 281, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (282, 282, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (283, 283, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (284, 284, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (285, 285, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (286, 286, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (287, 287, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (288, 288, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (289, 289, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (290, 290, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (291, 291, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (292, 292, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (293, 293, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (294, 294, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (295, 295, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (296, 296, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (297, 297, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (298, 298, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (299, 299, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (300, 300, 1);
INSERT INTO `quiz_question_knowledge_points` VALUES (301, 301, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (302, 302, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (303, 303, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (304, 304, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (305, 305, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (306, 306, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (307, 307, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (308, 308, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (309, 309, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (310, 310, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (311, 311, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (312, 312, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (313, 313, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (314, 314, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (315, 315, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (316, 316, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (317, 317, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (318, 318, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (319, 319, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (320, 320, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (321, 321, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (322, 322, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (323, 323, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (324, 324, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (325, 325, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (326, 326, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (327, 327, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (328, 328, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (329, 329, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (330, 330, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (331, 331, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (332, 332, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (333, 333, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (334, 334, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (335, 335, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (336, 336, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (337, 337, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (338, 338, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (339, 339, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (340, 340, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (341, 341, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (342, 342, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (343, 343, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (344, 344, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (345, 345, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (346, 346, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (347, 347, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (348, 348, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (349, 349, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (350, 350, 2);
INSERT INTO `quiz_question_knowledge_points` VALUES (351, 351, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (352, 352, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (353, 353, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (354, 354, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (355, 355, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (356, 356, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (357, 357, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (358, 358, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (359, 359, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (360, 360, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (361, 361, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (362, 362, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (363, 363, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (364, 364, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (365, 365, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (366, 366, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (367, 367, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (368, 368, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (369, 369, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (370, 370, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (371, 371, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (372, 372, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (373, 373, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (374, 374, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (375, 375, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (376, 376, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (377, 377, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (378, 378, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (379, 379, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (380, 380, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (381, 381, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (382, 382, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (383, 383, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (384, 384, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (385, 385, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (386, 386, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (387, 387, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (388, 388, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (389, 389, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (390, 390, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (391, 391, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (392, 392, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (393, 393, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (394, 394, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (395, 395, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (396, 396, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (397, 397, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (398, 398, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (399, 399, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (400, 400, 3);
INSERT INTO `quiz_question_knowledge_points` VALUES (401, 401, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (402, 402, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (403, 403, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (404, 404, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (405, 405, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (406, 406, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (407, 407, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (408, 408, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (409, 409, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (410, 410, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (411, 411, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (412, 412, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (413, 413, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (414, 414, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (415, 415, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (416, 416, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (417, 417, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (418, 418, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (419, 419, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (420, 420, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (421, 421, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (422, 422, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (423, 423, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (424, 424, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (425, 425, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (426, 426, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (427, 427, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (428, 428, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (429, 429, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (430, 430, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (431, 431, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (432, 432, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (433, 433, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (434, 434, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (435, 435, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (436, 436, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (437, 437, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (438, 438, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (439, 439, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (440, 440, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (441, 441, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (442, 442, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (443, 443, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (444, 444, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (445, 445, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (446, 446, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (447, 447, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (448, 448, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (449, 449, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (450, 450, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (451, 451, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (452, 452, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (453, 453, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (454, 454, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (455, 455, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (456, 456, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (457, 457, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (458, 458, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (459, 459, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (460, 460, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (461, 461, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (462, 462, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (463, 463, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (464, 464, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (465, 465, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (466, 466, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (467, 467, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (468, 468, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (469, 469, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (470, 470, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (471, 471, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (472, 472, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (473, 473, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (474, 474, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (475, 475, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (476, 476, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (477, 477, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (478, 478, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (479, 479, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (480, 480, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (481, 481, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (482, 482, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (483, 483, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (484, 484, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (485, 485, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (486, 486, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (487, 487, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (488, 488, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (489, 489, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (490, 490, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (491, 491, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (492, 492, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (493, 493, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (494, 494, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (495, 495, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (496, 496, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (497, 497, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (498, 498, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (499, 499, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (500, 500, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (501, 501, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (502, 502, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (503, 503, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (504, 504, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (505, 505, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (506, 506, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (507, 507, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (508, 508, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (509, 509, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (510, 510, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (511, 511, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (512, 512, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (513, 513, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (514, 514, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (515, 515, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (516, 516, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (517, 517, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (518, 518, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (519, 519, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (520, 520, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (521, 521, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (522, 522, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (523, 523, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (524, 524, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (525, 525, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (526, 526, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (527, 527, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (528, 528, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (529, 529, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (530, 530, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (531, 531, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (532, 532, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (533, 533, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (534, 534, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (535, 535, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (536, 536, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (537, 537, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (538, 538, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (539, 539, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (540, 540, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (541, 541, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (542, 542, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (543, 543, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (544, 544, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (545, 545, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (546, 546, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (547, 547, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (548, 548, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (549, 549, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (550, 550, 4);
INSERT INTO `quiz_question_knowledge_points` VALUES (551, 551, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (552, 552, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (553, 553, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (554, 554, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (555, 555, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (556, 556, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (557, 557, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (558, 558, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (559, 559, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (560, 560, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (561, 561, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (562, 562, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (563, 563, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (564, 564, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (565, 565, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (566, 566, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (567, 567, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (568, 568, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (569, 569, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (570, 570, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (571, 571, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (572, 572, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (573, 573, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (574, 574, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (575, 575, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (576, 576, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (577, 577, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (578, 578, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (579, 579, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (580, 580, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (581, 581, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (582, 582, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (583, 583, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (584, 584, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (585, 585, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (586, 586, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (587, 587, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (588, 588, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (589, 589, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (590, 590, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (591, 591, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (592, 592, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (593, 593, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (594, 594, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (595, 595, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (596, 596, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (597, 597, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (598, 598, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (599, 599, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (600, 600, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (601, 601, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (602, 602, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (603, 603, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (604, 604, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (605, 605, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (606, 606, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (607, 607, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (608, 608, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (609, 609, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (610, 610, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (611, 611, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (612, 612, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (613, 613, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (614, 614, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (615, 615, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (616, 616, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (617, 617, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (618, 618, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (619, 619, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (620, 620, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (621, 621, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (622, 622, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (623, 623, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (624, 624, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (625, 625, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (626, 626, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (627, 627, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (628, 628, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (629, 629, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (630, 630, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (631, 631, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (632, 632, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (633, 633, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (634, 634, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (635, 635, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (636, 636, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (637, 637, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (638, 638, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (639, 639, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (640, 640, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (641, 641, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (642, 642, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (643, 643, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (644, 644, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (645, 645, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (646, 646, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (647, 647, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (648, 648, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (649, 649, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (650, 650, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (651, 651, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (652, 652, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (653, 653, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (654, 654, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (655, 655, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (656, 656, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (657, 657, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (658, 658, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (659, 659, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (660, 660, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (661, 661, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (662, 662, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (663, 663, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (664, 664, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (665, 665, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (666, 666, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (667, 667, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (668, 668, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (669, 669, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (670, 670, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (671, 671, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (672, 672, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (673, 673, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (674, 674, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (675, 675, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (676, 676, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (677, 677, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (678, 678, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (679, 679, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (680, 680, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (681, 681, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (682, 682, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (683, 683, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (684, 684, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (685, 685, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (686, 686, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (687, 687, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (688, 688, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (689, 689, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (690, 690, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (691, 691, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (692, 692, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (693, 693, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (694, 694, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (695, 695, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (696, 696, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (697, 697, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (698, 698, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (699, 699, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (700, 700, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (701, 701, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (702, 702, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (703, 703, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (704, 704, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (705, 705, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (706, 706, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (707, 707, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (708, 708, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (709, 709, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (710, 710, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (711, 711, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (712, 712, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (713, 713, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (714, 714, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (715, 715, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (716, 716, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (717, 717, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (718, 718, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (719, 719, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (720, 720, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (721, 721, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (722, 722, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (723, 723, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (724, 724, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (725, 725, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (726, 726, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (727, 727, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (728, 728, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (729, 729, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (730, 730, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (731, 731, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (732, 732, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (733, 733, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (734, 734, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (735, 735, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (736, 736, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (737, 737, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (738, 738, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (739, 739, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (740, 740, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (741, 741, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (742, 742, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (743, 743, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (744, 744, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (745, 745, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (746, 746, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (747, 747, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (748, 748, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (749, 749, 5);
INSERT INTO `quiz_question_knowledge_points` VALUES (750, 750, 5);

-- ----------------------------
-- Table structure for quiz_section
-- ----------------------------
DROP TABLE IF EXISTS `quiz_section`;
CREATE TABLE `quiz_section`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `number` int(11) NOT NULL,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `chapter_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `quiz_section_chapter_id_number_4156c879_uniq`(`chapter_id`, `number`) USING BTREE,
  CONSTRAINT `quiz_section_chapter_id_475b1d53_fk_quiz_chapter_id` FOREIGN KEY (`chapter_id`) REFERENCES `quiz_chapter` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_section
-- ----------------------------
INSERT INTO `quiz_section` VALUES (1, 1, '1.1', 1);
INSERT INTO `quiz_section` VALUES (2, 1, '1.1B', 2);
INSERT INTO `quiz_section` VALUES (3, 2, '1.2', 2);
INSERT INTO `quiz_section` VALUES (4, 3, '1.3', 2);
INSERT INTO `quiz_section` VALUES (5, 4, '1.4', 2);

-- ----------------------------
-- Table structure for quiz_subject
-- ----------------------------
DROP TABLE IF EXISTS `quiz_subject`;
CREATE TABLE `quiz_subject`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `color` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE,
  UNIQUE INDEX `code`(`code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_subject
-- ----------------------------
INSERT INTO `quiz_subject` VALUES (1, '计算机', '计算机', NULL, '#667eea', '📚', '2026-09-13 06:14:58.490213');

-- ----------------------------
-- Table structure for quiz_testdraft
-- ----------------------------
DROP TABLE IF EXISTS `quiz_testdraft`;
CREATE TABLE `quiz_testdraft`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_wrong_paper` tinyint(1) NOT NULL,
  `answers` json NOT NULL,
  `current_index` int(11) NOT NULL,
  `mode` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `start_time` datetime(6) NULL DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `assignment_id` bigint(20) NULL DEFAULT NULL,
  `test_paper_id` bigint(20) NULL DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uniq_draft_test_paper`(`user_id`, `test_paper_id`, `is_wrong_paper`) USING BTREE,
  UNIQUE INDEX `uniq_draft_assignment`(`user_id`, `assignment_id`) USING BTREE,
  INDEX `quiz_testdraft_assignment_id_86173f84_fk_quiz_classassignment_id`(`assignment_id`) USING BTREE,
  INDEX `quiz_testdraft_test_paper_id_4a64e090_fk_quiz_testpaper_id`(`test_paper_id`) USING BTREE,
  CONSTRAINT `quiz_testdraft_assignment_id_86173f84_fk_quiz_classassignment_id` FOREIGN KEY (`assignment_id`) REFERENCES `quiz_classassignment` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_testdraft_test_paper_id_4a64e090_fk_quiz_testpaper_id` FOREIGN KEY (`test_paper_id`) REFERENCES `quiz_testpaper` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_testdraft_user_id_663e1313_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of quiz_testdraft
-- ----------------------------

-- ----------------------------
-- Table structure for quiz_testpaper
-- ----------------------------
DROP TABLE IF EXISTS `quiz_testpaper`;
CREATE TABLE `quiz_testpaper`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `total_score` int(11) NOT NULL,
  `created_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `is_published` tinyint(1) NOT NULL,
  `source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_public` tinyint(1) NOT NULL,
  `duration` int(11) NULL DEFAULT NULL,
  `end_time` datetime(6) NULL DEFAULT NULL,
  `max_attempts` int(11) NULL DEFAULT NULL,
  `start_time` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_testpaper
-- ----------------------------
INSERT INTO `quiz_testpaper` VALUES (1, '第01章 信息与数据、通信基础、计算机发展、特点、分类等', '', 150, 'admin', '2026-09-13 06:14:58.472753', 1, 'frontend', 1, NULL, NULL, NULL, NULL);
INSERT INTO `quiz_testpaper` VALUES (2, '第01章 信息与数据、通信基础、计算机发展、特点、分类等（2）', '', 150, 'admin', '2026-09-13 06:33:29.419790', 1, 'frontend', 1, NULL, NULL, NULL, NULL);
INSERT INTO `quiz_testpaper` VALUES (3, '第01章 信息与数据、通信基础、计算机发展、特点、分类等（3）', '', 150, 'admin', '2026-09-13 06:45:26.947057', 1, 'frontend', 1, NULL, NULL, NULL, NULL);
INSERT INTO `quiz_testpaper` VALUES (4, '第01章 信息与数据、通信基础、计算机发展、特点、分类等（4）', '', 150, 'admin', '2026-09-13 06:46:24.311528', 1, 'frontend', 1, NULL, NULL, NULL, NULL);
INSERT INTO `quiz_testpaper` VALUES (5, '第01章 信息与数据、通信基础、计算机发展、特点、分类等（5）', '', 150, 'admin', '2026-09-13 06:47:43.546564', 1, 'frontend', 1, NULL, NULL, NULL, NULL);
INSERT INTO `quiz_testpaper` VALUES (6, '第01章 信息与数据、通信基础、计算机发展、特点、分类等（6）', '', 150, 'admin', '2026-09-13 06:48:29.556063', 1, 'frontend', 1, NULL, NULL, NULL, NULL);
INSERT INTO `quiz_testpaper` VALUES (7, '第01章 通讯基本概念、分类、特征', '', 150, 'admin', '2026-09-13 06:49:51.419502', 1, 'frontend', 1, NULL, NULL, NULL, NULL);
INSERT INTO `quiz_testpaper` VALUES (8, '第01章计算机特点及分类', '', 150, 'admin', '2026-09-13 06:51:58.844108', 1, 'frontend', 1, NULL, NULL, NULL, NULL);
INSERT INTO `quiz_testpaper` VALUES (9, '第01章 计算机发展史', '', 150, 'admin', '2026-09-13 09:46:38.140029', 1, 'frontend', 1, NULL, NULL, NULL, NULL);
INSERT INTO `quiz_testpaper` VALUES (10, '第01章 计算机发展史（2）', '', 150, 'admin', '2026-09-13 09:51:10.347660', 1, 'frontend', 1, NULL, NULL, NULL, NULL);
INSERT INTO `quiz_testpaper` VALUES (11, '第01章 计算机发展史（3）', '', 150, 'admin', '2026-09-13 09:51:48.778195', 1, 'frontend', 1, NULL, NULL, NULL, NULL);
INSERT INTO `quiz_testpaper` VALUES (13, '第01章 计算机应用领域及发展趋势', '', 150, 'admin', '2026-09-13 09:54:38.956426', 1, 'frontend', 1, NULL, NULL, NULL, NULL);
INSERT INTO `quiz_testpaper` VALUES (14, '第01章 计算机应用领域及发展趋势（2）', '', 150, 'admin', '2026-09-13 09:57:12.702586', 1, 'frontend', 1, NULL, NULL, NULL, NULL);
INSERT INTO `quiz_testpaper` VALUES (15, '第01章计算机应用领域及发展趋势（3）', '', 150, 'admin', '2026-09-13 10:23:07.084248', 1, 'frontend', 1, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for quiz_testpaper_questions
-- ----------------------------
DROP TABLE IF EXISTS `quiz_testpaper_questions`;
CREATE TABLE `quiz_testpaper_questions`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `testpaper_id` bigint(20) NOT NULL,
  `question_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `quiz_testpaper_questions_testpaper_id_question_id_f02b698b_uniq`(`testpaper_id`, `question_id`) USING BTREE,
  INDEX `quiz_testpaper_quest_question_id_868963b6_fk_quiz_ques`(`question_id`) USING BTREE,
  CONSTRAINT `quiz_testpaper_quest_question_id_868963b6_fk_quiz_ques` FOREIGN KEY (`question_id`) REFERENCES `quiz_question` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_testpaper_quest_testpaper_id_30bffc99_fk_quiz_test` FOREIGN KEY (`testpaper_id`) REFERENCES `quiz_testpaper` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 751 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_testpaper_questions
-- ----------------------------
INSERT INTO `quiz_testpaper_questions` VALUES (1, 1, 1);
INSERT INTO `quiz_testpaper_questions` VALUES (2, 1, 2);
INSERT INTO `quiz_testpaper_questions` VALUES (3, 1, 3);
INSERT INTO `quiz_testpaper_questions` VALUES (4, 1, 4);
INSERT INTO `quiz_testpaper_questions` VALUES (5, 1, 5);
INSERT INTO `quiz_testpaper_questions` VALUES (6, 1, 6);
INSERT INTO `quiz_testpaper_questions` VALUES (7, 1, 7);
INSERT INTO `quiz_testpaper_questions` VALUES (8, 1, 8);
INSERT INTO `quiz_testpaper_questions` VALUES (9, 1, 9);
INSERT INTO `quiz_testpaper_questions` VALUES (10, 1, 10);
INSERT INTO `quiz_testpaper_questions` VALUES (11, 1, 11);
INSERT INTO `quiz_testpaper_questions` VALUES (12, 1, 12);
INSERT INTO `quiz_testpaper_questions` VALUES (13, 1, 13);
INSERT INTO `quiz_testpaper_questions` VALUES (14, 1, 14);
INSERT INTO `quiz_testpaper_questions` VALUES (15, 1, 15);
INSERT INTO `quiz_testpaper_questions` VALUES (16, 1, 16);
INSERT INTO `quiz_testpaper_questions` VALUES (17, 1, 17);
INSERT INTO `quiz_testpaper_questions` VALUES (18, 1, 18);
INSERT INTO `quiz_testpaper_questions` VALUES (19, 1, 19);
INSERT INTO `quiz_testpaper_questions` VALUES (20, 1, 20);
INSERT INTO `quiz_testpaper_questions` VALUES (21, 1, 21);
INSERT INTO `quiz_testpaper_questions` VALUES (22, 1, 22);
INSERT INTO `quiz_testpaper_questions` VALUES (23, 1, 23);
INSERT INTO `quiz_testpaper_questions` VALUES (24, 1, 24);
INSERT INTO `quiz_testpaper_questions` VALUES (25, 1, 25);
INSERT INTO `quiz_testpaper_questions` VALUES (26, 1, 26);
INSERT INTO `quiz_testpaper_questions` VALUES (27, 1, 27);
INSERT INTO `quiz_testpaper_questions` VALUES (28, 1, 28);
INSERT INTO `quiz_testpaper_questions` VALUES (29, 1, 29);
INSERT INTO `quiz_testpaper_questions` VALUES (30, 1, 30);
INSERT INTO `quiz_testpaper_questions` VALUES (31, 1, 31);
INSERT INTO `quiz_testpaper_questions` VALUES (32, 1, 32);
INSERT INTO `quiz_testpaper_questions` VALUES (33, 1, 33);
INSERT INTO `quiz_testpaper_questions` VALUES (34, 1, 34);
INSERT INTO `quiz_testpaper_questions` VALUES (35, 1, 35);
INSERT INTO `quiz_testpaper_questions` VALUES (36, 1, 36);
INSERT INTO `quiz_testpaper_questions` VALUES (37, 1, 37);
INSERT INTO `quiz_testpaper_questions` VALUES (38, 1, 38);
INSERT INTO `quiz_testpaper_questions` VALUES (39, 1, 39);
INSERT INTO `quiz_testpaper_questions` VALUES (40, 1, 40);
INSERT INTO `quiz_testpaper_questions` VALUES (41, 1, 41);
INSERT INTO `quiz_testpaper_questions` VALUES (42, 1, 42);
INSERT INTO `quiz_testpaper_questions` VALUES (43, 1, 43);
INSERT INTO `quiz_testpaper_questions` VALUES (44, 1, 44);
INSERT INTO `quiz_testpaper_questions` VALUES (45, 1, 45);
INSERT INTO `quiz_testpaper_questions` VALUES (46, 1, 46);
INSERT INTO `quiz_testpaper_questions` VALUES (47, 1, 47);
INSERT INTO `quiz_testpaper_questions` VALUES (48, 1, 48);
INSERT INTO `quiz_testpaper_questions` VALUES (49, 1, 49);
INSERT INTO `quiz_testpaper_questions` VALUES (50, 1, 50);
INSERT INTO `quiz_testpaper_questions` VALUES (51, 2, 51);
INSERT INTO `quiz_testpaper_questions` VALUES (52, 2, 52);
INSERT INTO `quiz_testpaper_questions` VALUES (53, 2, 53);
INSERT INTO `quiz_testpaper_questions` VALUES (54, 2, 54);
INSERT INTO `quiz_testpaper_questions` VALUES (55, 2, 55);
INSERT INTO `quiz_testpaper_questions` VALUES (56, 2, 56);
INSERT INTO `quiz_testpaper_questions` VALUES (57, 2, 57);
INSERT INTO `quiz_testpaper_questions` VALUES (58, 2, 58);
INSERT INTO `quiz_testpaper_questions` VALUES (59, 2, 59);
INSERT INTO `quiz_testpaper_questions` VALUES (60, 2, 60);
INSERT INTO `quiz_testpaper_questions` VALUES (61, 2, 61);
INSERT INTO `quiz_testpaper_questions` VALUES (62, 2, 62);
INSERT INTO `quiz_testpaper_questions` VALUES (63, 2, 63);
INSERT INTO `quiz_testpaper_questions` VALUES (64, 2, 64);
INSERT INTO `quiz_testpaper_questions` VALUES (65, 2, 65);
INSERT INTO `quiz_testpaper_questions` VALUES (66, 2, 66);
INSERT INTO `quiz_testpaper_questions` VALUES (67, 2, 67);
INSERT INTO `quiz_testpaper_questions` VALUES (68, 2, 68);
INSERT INTO `quiz_testpaper_questions` VALUES (69, 2, 69);
INSERT INTO `quiz_testpaper_questions` VALUES (70, 2, 70);
INSERT INTO `quiz_testpaper_questions` VALUES (71, 2, 71);
INSERT INTO `quiz_testpaper_questions` VALUES (72, 2, 72);
INSERT INTO `quiz_testpaper_questions` VALUES (73, 2, 73);
INSERT INTO `quiz_testpaper_questions` VALUES (74, 2, 74);
INSERT INTO `quiz_testpaper_questions` VALUES (75, 2, 75);
INSERT INTO `quiz_testpaper_questions` VALUES (76, 2, 76);
INSERT INTO `quiz_testpaper_questions` VALUES (77, 2, 77);
INSERT INTO `quiz_testpaper_questions` VALUES (78, 2, 78);
INSERT INTO `quiz_testpaper_questions` VALUES (79, 2, 79);
INSERT INTO `quiz_testpaper_questions` VALUES (80, 2, 80);
INSERT INTO `quiz_testpaper_questions` VALUES (81, 2, 81);
INSERT INTO `quiz_testpaper_questions` VALUES (82, 2, 82);
INSERT INTO `quiz_testpaper_questions` VALUES (83, 2, 83);
INSERT INTO `quiz_testpaper_questions` VALUES (84, 2, 84);
INSERT INTO `quiz_testpaper_questions` VALUES (85, 2, 85);
INSERT INTO `quiz_testpaper_questions` VALUES (86, 2, 86);
INSERT INTO `quiz_testpaper_questions` VALUES (87, 2, 87);
INSERT INTO `quiz_testpaper_questions` VALUES (88, 2, 88);
INSERT INTO `quiz_testpaper_questions` VALUES (89, 2, 89);
INSERT INTO `quiz_testpaper_questions` VALUES (90, 2, 90);
INSERT INTO `quiz_testpaper_questions` VALUES (91, 2, 91);
INSERT INTO `quiz_testpaper_questions` VALUES (92, 2, 92);
INSERT INTO `quiz_testpaper_questions` VALUES (93, 2, 93);
INSERT INTO `quiz_testpaper_questions` VALUES (94, 2, 94);
INSERT INTO `quiz_testpaper_questions` VALUES (95, 2, 95);
INSERT INTO `quiz_testpaper_questions` VALUES (96, 2, 96);
INSERT INTO `quiz_testpaper_questions` VALUES (97, 2, 97);
INSERT INTO `quiz_testpaper_questions` VALUES (98, 2, 98);
INSERT INTO `quiz_testpaper_questions` VALUES (99, 2, 99);
INSERT INTO `quiz_testpaper_questions` VALUES (100, 2, 100);
INSERT INTO `quiz_testpaper_questions` VALUES (101, 3, 101);
INSERT INTO `quiz_testpaper_questions` VALUES (102, 3, 102);
INSERT INTO `quiz_testpaper_questions` VALUES (103, 3, 103);
INSERT INTO `quiz_testpaper_questions` VALUES (104, 3, 104);
INSERT INTO `quiz_testpaper_questions` VALUES (105, 3, 105);
INSERT INTO `quiz_testpaper_questions` VALUES (106, 3, 106);
INSERT INTO `quiz_testpaper_questions` VALUES (107, 3, 107);
INSERT INTO `quiz_testpaper_questions` VALUES (108, 3, 108);
INSERT INTO `quiz_testpaper_questions` VALUES (109, 3, 109);
INSERT INTO `quiz_testpaper_questions` VALUES (110, 3, 110);
INSERT INTO `quiz_testpaper_questions` VALUES (111, 3, 111);
INSERT INTO `quiz_testpaper_questions` VALUES (112, 3, 112);
INSERT INTO `quiz_testpaper_questions` VALUES (113, 3, 113);
INSERT INTO `quiz_testpaper_questions` VALUES (114, 3, 114);
INSERT INTO `quiz_testpaper_questions` VALUES (115, 3, 115);
INSERT INTO `quiz_testpaper_questions` VALUES (116, 3, 116);
INSERT INTO `quiz_testpaper_questions` VALUES (117, 3, 117);
INSERT INTO `quiz_testpaper_questions` VALUES (118, 3, 118);
INSERT INTO `quiz_testpaper_questions` VALUES (119, 3, 119);
INSERT INTO `quiz_testpaper_questions` VALUES (120, 3, 120);
INSERT INTO `quiz_testpaper_questions` VALUES (121, 3, 121);
INSERT INTO `quiz_testpaper_questions` VALUES (122, 3, 122);
INSERT INTO `quiz_testpaper_questions` VALUES (123, 3, 123);
INSERT INTO `quiz_testpaper_questions` VALUES (124, 3, 124);
INSERT INTO `quiz_testpaper_questions` VALUES (125, 3, 125);
INSERT INTO `quiz_testpaper_questions` VALUES (126, 3, 126);
INSERT INTO `quiz_testpaper_questions` VALUES (127, 3, 127);
INSERT INTO `quiz_testpaper_questions` VALUES (128, 3, 128);
INSERT INTO `quiz_testpaper_questions` VALUES (129, 3, 129);
INSERT INTO `quiz_testpaper_questions` VALUES (130, 3, 130);
INSERT INTO `quiz_testpaper_questions` VALUES (131, 3, 131);
INSERT INTO `quiz_testpaper_questions` VALUES (132, 3, 132);
INSERT INTO `quiz_testpaper_questions` VALUES (133, 3, 133);
INSERT INTO `quiz_testpaper_questions` VALUES (134, 3, 134);
INSERT INTO `quiz_testpaper_questions` VALUES (135, 3, 135);
INSERT INTO `quiz_testpaper_questions` VALUES (136, 3, 136);
INSERT INTO `quiz_testpaper_questions` VALUES (137, 3, 137);
INSERT INTO `quiz_testpaper_questions` VALUES (138, 3, 138);
INSERT INTO `quiz_testpaper_questions` VALUES (139, 3, 139);
INSERT INTO `quiz_testpaper_questions` VALUES (140, 3, 140);
INSERT INTO `quiz_testpaper_questions` VALUES (141, 3, 141);
INSERT INTO `quiz_testpaper_questions` VALUES (142, 3, 142);
INSERT INTO `quiz_testpaper_questions` VALUES (143, 3, 143);
INSERT INTO `quiz_testpaper_questions` VALUES (144, 3, 144);
INSERT INTO `quiz_testpaper_questions` VALUES (145, 3, 145);
INSERT INTO `quiz_testpaper_questions` VALUES (146, 3, 146);
INSERT INTO `quiz_testpaper_questions` VALUES (147, 3, 147);
INSERT INTO `quiz_testpaper_questions` VALUES (148, 3, 148);
INSERT INTO `quiz_testpaper_questions` VALUES (149, 3, 149);
INSERT INTO `quiz_testpaper_questions` VALUES (150, 3, 150);
INSERT INTO `quiz_testpaper_questions` VALUES (151, 4, 151);
INSERT INTO `quiz_testpaper_questions` VALUES (152, 4, 152);
INSERT INTO `quiz_testpaper_questions` VALUES (153, 4, 153);
INSERT INTO `quiz_testpaper_questions` VALUES (154, 4, 154);
INSERT INTO `quiz_testpaper_questions` VALUES (155, 4, 155);
INSERT INTO `quiz_testpaper_questions` VALUES (156, 4, 156);
INSERT INTO `quiz_testpaper_questions` VALUES (157, 4, 157);
INSERT INTO `quiz_testpaper_questions` VALUES (158, 4, 158);
INSERT INTO `quiz_testpaper_questions` VALUES (159, 4, 159);
INSERT INTO `quiz_testpaper_questions` VALUES (160, 4, 160);
INSERT INTO `quiz_testpaper_questions` VALUES (161, 4, 161);
INSERT INTO `quiz_testpaper_questions` VALUES (162, 4, 162);
INSERT INTO `quiz_testpaper_questions` VALUES (163, 4, 163);
INSERT INTO `quiz_testpaper_questions` VALUES (164, 4, 164);
INSERT INTO `quiz_testpaper_questions` VALUES (165, 4, 165);
INSERT INTO `quiz_testpaper_questions` VALUES (166, 4, 166);
INSERT INTO `quiz_testpaper_questions` VALUES (167, 4, 167);
INSERT INTO `quiz_testpaper_questions` VALUES (168, 4, 168);
INSERT INTO `quiz_testpaper_questions` VALUES (169, 4, 169);
INSERT INTO `quiz_testpaper_questions` VALUES (170, 4, 170);
INSERT INTO `quiz_testpaper_questions` VALUES (171, 4, 171);
INSERT INTO `quiz_testpaper_questions` VALUES (172, 4, 172);
INSERT INTO `quiz_testpaper_questions` VALUES (173, 4, 173);
INSERT INTO `quiz_testpaper_questions` VALUES (174, 4, 174);
INSERT INTO `quiz_testpaper_questions` VALUES (175, 4, 175);
INSERT INTO `quiz_testpaper_questions` VALUES (176, 4, 176);
INSERT INTO `quiz_testpaper_questions` VALUES (177, 4, 177);
INSERT INTO `quiz_testpaper_questions` VALUES (178, 4, 178);
INSERT INTO `quiz_testpaper_questions` VALUES (179, 4, 179);
INSERT INTO `quiz_testpaper_questions` VALUES (180, 4, 180);
INSERT INTO `quiz_testpaper_questions` VALUES (181, 4, 181);
INSERT INTO `quiz_testpaper_questions` VALUES (182, 4, 182);
INSERT INTO `quiz_testpaper_questions` VALUES (183, 4, 183);
INSERT INTO `quiz_testpaper_questions` VALUES (184, 4, 184);
INSERT INTO `quiz_testpaper_questions` VALUES (185, 4, 185);
INSERT INTO `quiz_testpaper_questions` VALUES (186, 4, 186);
INSERT INTO `quiz_testpaper_questions` VALUES (187, 4, 187);
INSERT INTO `quiz_testpaper_questions` VALUES (188, 4, 188);
INSERT INTO `quiz_testpaper_questions` VALUES (189, 4, 189);
INSERT INTO `quiz_testpaper_questions` VALUES (190, 4, 190);
INSERT INTO `quiz_testpaper_questions` VALUES (191, 4, 191);
INSERT INTO `quiz_testpaper_questions` VALUES (192, 4, 192);
INSERT INTO `quiz_testpaper_questions` VALUES (193, 4, 193);
INSERT INTO `quiz_testpaper_questions` VALUES (194, 4, 194);
INSERT INTO `quiz_testpaper_questions` VALUES (195, 4, 195);
INSERT INTO `quiz_testpaper_questions` VALUES (196, 4, 196);
INSERT INTO `quiz_testpaper_questions` VALUES (197, 4, 197);
INSERT INTO `quiz_testpaper_questions` VALUES (198, 4, 198);
INSERT INTO `quiz_testpaper_questions` VALUES (199, 4, 199);
INSERT INTO `quiz_testpaper_questions` VALUES (200, 4, 200);
INSERT INTO `quiz_testpaper_questions` VALUES (201, 5, 201);
INSERT INTO `quiz_testpaper_questions` VALUES (202, 5, 202);
INSERT INTO `quiz_testpaper_questions` VALUES (203, 5, 203);
INSERT INTO `quiz_testpaper_questions` VALUES (204, 5, 204);
INSERT INTO `quiz_testpaper_questions` VALUES (205, 5, 205);
INSERT INTO `quiz_testpaper_questions` VALUES (206, 5, 206);
INSERT INTO `quiz_testpaper_questions` VALUES (207, 5, 207);
INSERT INTO `quiz_testpaper_questions` VALUES (208, 5, 208);
INSERT INTO `quiz_testpaper_questions` VALUES (209, 5, 209);
INSERT INTO `quiz_testpaper_questions` VALUES (210, 5, 210);
INSERT INTO `quiz_testpaper_questions` VALUES (211, 5, 211);
INSERT INTO `quiz_testpaper_questions` VALUES (212, 5, 212);
INSERT INTO `quiz_testpaper_questions` VALUES (213, 5, 213);
INSERT INTO `quiz_testpaper_questions` VALUES (214, 5, 214);
INSERT INTO `quiz_testpaper_questions` VALUES (215, 5, 215);
INSERT INTO `quiz_testpaper_questions` VALUES (216, 5, 216);
INSERT INTO `quiz_testpaper_questions` VALUES (217, 5, 217);
INSERT INTO `quiz_testpaper_questions` VALUES (218, 5, 218);
INSERT INTO `quiz_testpaper_questions` VALUES (219, 5, 219);
INSERT INTO `quiz_testpaper_questions` VALUES (220, 5, 220);
INSERT INTO `quiz_testpaper_questions` VALUES (221, 5, 221);
INSERT INTO `quiz_testpaper_questions` VALUES (222, 5, 222);
INSERT INTO `quiz_testpaper_questions` VALUES (223, 5, 223);
INSERT INTO `quiz_testpaper_questions` VALUES (224, 5, 224);
INSERT INTO `quiz_testpaper_questions` VALUES (225, 5, 225);
INSERT INTO `quiz_testpaper_questions` VALUES (226, 5, 226);
INSERT INTO `quiz_testpaper_questions` VALUES (227, 5, 227);
INSERT INTO `quiz_testpaper_questions` VALUES (228, 5, 228);
INSERT INTO `quiz_testpaper_questions` VALUES (229, 5, 229);
INSERT INTO `quiz_testpaper_questions` VALUES (230, 5, 230);
INSERT INTO `quiz_testpaper_questions` VALUES (231, 5, 231);
INSERT INTO `quiz_testpaper_questions` VALUES (232, 5, 232);
INSERT INTO `quiz_testpaper_questions` VALUES (233, 5, 233);
INSERT INTO `quiz_testpaper_questions` VALUES (234, 5, 234);
INSERT INTO `quiz_testpaper_questions` VALUES (235, 5, 235);
INSERT INTO `quiz_testpaper_questions` VALUES (236, 5, 236);
INSERT INTO `quiz_testpaper_questions` VALUES (237, 5, 237);
INSERT INTO `quiz_testpaper_questions` VALUES (238, 5, 238);
INSERT INTO `quiz_testpaper_questions` VALUES (239, 5, 239);
INSERT INTO `quiz_testpaper_questions` VALUES (240, 5, 240);
INSERT INTO `quiz_testpaper_questions` VALUES (241, 5, 241);
INSERT INTO `quiz_testpaper_questions` VALUES (242, 5, 242);
INSERT INTO `quiz_testpaper_questions` VALUES (243, 5, 243);
INSERT INTO `quiz_testpaper_questions` VALUES (244, 5, 244);
INSERT INTO `quiz_testpaper_questions` VALUES (245, 5, 245);
INSERT INTO `quiz_testpaper_questions` VALUES (246, 5, 246);
INSERT INTO `quiz_testpaper_questions` VALUES (247, 5, 247);
INSERT INTO `quiz_testpaper_questions` VALUES (248, 5, 248);
INSERT INTO `quiz_testpaper_questions` VALUES (249, 5, 249);
INSERT INTO `quiz_testpaper_questions` VALUES (250, 5, 250);
INSERT INTO `quiz_testpaper_questions` VALUES (251, 6, 251);
INSERT INTO `quiz_testpaper_questions` VALUES (252, 6, 252);
INSERT INTO `quiz_testpaper_questions` VALUES (253, 6, 253);
INSERT INTO `quiz_testpaper_questions` VALUES (254, 6, 254);
INSERT INTO `quiz_testpaper_questions` VALUES (255, 6, 255);
INSERT INTO `quiz_testpaper_questions` VALUES (256, 6, 256);
INSERT INTO `quiz_testpaper_questions` VALUES (257, 6, 257);
INSERT INTO `quiz_testpaper_questions` VALUES (258, 6, 258);
INSERT INTO `quiz_testpaper_questions` VALUES (259, 6, 259);
INSERT INTO `quiz_testpaper_questions` VALUES (260, 6, 260);
INSERT INTO `quiz_testpaper_questions` VALUES (261, 6, 261);
INSERT INTO `quiz_testpaper_questions` VALUES (262, 6, 262);
INSERT INTO `quiz_testpaper_questions` VALUES (263, 6, 263);
INSERT INTO `quiz_testpaper_questions` VALUES (264, 6, 264);
INSERT INTO `quiz_testpaper_questions` VALUES (265, 6, 265);
INSERT INTO `quiz_testpaper_questions` VALUES (266, 6, 266);
INSERT INTO `quiz_testpaper_questions` VALUES (267, 6, 267);
INSERT INTO `quiz_testpaper_questions` VALUES (268, 6, 268);
INSERT INTO `quiz_testpaper_questions` VALUES (269, 6, 269);
INSERT INTO `quiz_testpaper_questions` VALUES (270, 6, 270);
INSERT INTO `quiz_testpaper_questions` VALUES (271, 6, 271);
INSERT INTO `quiz_testpaper_questions` VALUES (272, 6, 272);
INSERT INTO `quiz_testpaper_questions` VALUES (273, 6, 273);
INSERT INTO `quiz_testpaper_questions` VALUES (274, 6, 274);
INSERT INTO `quiz_testpaper_questions` VALUES (275, 6, 275);
INSERT INTO `quiz_testpaper_questions` VALUES (276, 6, 276);
INSERT INTO `quiz_testpaper_questions` VALUES (277, 6, 277);
INSERT INTO `quiz_testpaper_questions` VALUES (278, 6, 278);
INSERT INTO `quiz_testpaper_questions` VALUES (279, 6, 279);
INSERT INTO `quiz_testpaper_questions` VALUES (280, 6, 280);
INSERT INTO `quiz_testpaper_questions` VALUES (281, 6, 281);
INSERT INTO `quiz_testpaper_questions` VALUES (282, 6, 282);
INSERT INTO `quiz_testpaper_questions` VALUES (283, 6, 283);
INSERT INTO `quiz_testpaper_questions` VALUES (284, 6, 284);
INSERT INTO `quiz_testpaper_questions` VALUES (285, 6, 285);
INSERT INTO `quiz_testpaper_questions` VALUES (286, 6, 286);
INSERT INTO `quiz_testpaper_questions` VALUES (287, 6, 287);
INSERT INTO `quiz_testpaper_questions` VALUES (288, 6, 288);
INSERT INTO `quiz_testpaper_questions` VALUES (289, 6, 289);
INSERT INTO `quiz_testpaper_questions` VALUES (290, 6, 290);
INSERT INTO `quiz_testpaper_questions` VALUES (291, 6, 291);
INSERT INTO `quiz_testpaper_questions` VALUES (292, 6, 292);
INSERT INTO `quiz_testpaper_questions` VALUES (293, 6, 293);
INSERT INTO `quiz_testpaper_questions` VALUES (294, 6, 294);
INSERT INTO `quiz_testpaper_questions` VALUES (295, 6, 295);
INSERT INTO `quiz_testpaper_questions` VALUES (296, 6, 296);
INSERT INTO `quiz_testpaper_questions` VALUES (297, 6, 297);
INSERT INTO `quiz_testpaper_questions` VALUES (298, 6, 298);
INSERT INTO `quiz_testpaper_questions` VALUES (299, 6, 299);
INSERT INTO `quiz_testpaper_questions` VALUES (300, 6, 300);
INSERT INTO `quiz_testpaper_questions` VALUES (301, 7, 301);
INSERT INTO `quiz_testpaper_questions` VALUES (302, 7, 302);
INSERT INTO `quiz_testpaper_questions` VALUES (303, 7, 303);
INSERT INTO `quiz_testpaper_questions` VALUES (304, 7, 304);
INSERT INTO `quiz_testpaper_questions` VALUES (305, 7, 305);
INSERT INTO `quiz_testpaper_questions` VALUES (306, 7, 306);
INSERT INTO `quiz_testpaper_questions` VALUES (307, 7, 307);
INSERT INTO `quiz_testpaper_questions` VALUES (308, 7, 308);
INSERT INTO `quiz_testpaper_questions` VALUES (309, 7, 309);
INSERT INTO `quiz_testpaper_questions` VALUES (310, 7, 310);
INSERT INTO `quiz_testpaper_questions` VALUES (311, 7, 311);
INSERT INTO `quiz_testpaper_questions` VALUES (312, 7, 312);
INSERT INTO `quiz_testpaper_questions` VALUES (313, 7, 313);
INSERT INTO `quiz_testpaper_questions` VALUES (314, 7, 314);
INSERT INTO `quiz_testpaper_questions` VALUES (315, 7, 315);
INSERT INTO `quiz_testpaper_questions` VALUES (316, 7, 316);
INSERT INTO `quiz_testpaper_questions` VALUES (317, 7, 317);
INSERT INTO `quiz_testpaper_questions` VALUES (318, 7, 318);
INSERT INTO `quiz_testpaper_questions` VALUES (319, 7, 319);
INSERT INTO `quiz_testpaper_questions` VALUES (320, 7, 320);
INSERT INTO `quiz_testpaper_questions` VALUES (321, 7, 321);
INSERT INTO `quiz_testpaper_questions` VALUES (322, 7, 322);
INSERT INTO `quiz_testpaper_questions` VALUES (323, 7, 323);
INSERT INTO `quiz_testpaper_questions` VALUES (324, 7, 324);
INSERT INTO `quiz_testpaper_questions` VALUES (325, 7, 325);
INSERT INTO `quiz_testpaper_questions` VALUES (326, 7, 326);
INSERT INTO `quiz_testpaper_questions` VALUES (327, 7, 327);
INSERT INTO `quiz_testpaper_questions` VALUES (328, 7, 328);
INSERT INTO `quiz_testpaper_questions` VALUES (329, 7, 329);
INSERT INTO `quiz_testpaper_questions` VALUES (330, 7, 330);
INSERT INTO `quiz_testpaper_questions` VALUES (331, 7, 331);
INSERT INTO `quiz_testpaper_questions` VALUES (332, 7, 332);
INSERT INTO `quiz_testpaper_questions` VALUES (333, 7, 333);
INSERT INTO `quiz_testpaper_questions` VALUES (334, 7, 334);
INSERT INTO `quiz_testpaper_questions` VALUES (335, 7, 335);
INSERT INTO `quiz_testpaper_questions` VALUES (336, 7, 336);
INSERT INTO `quiz_testpaper_questions` VALUES (337, 7, 337);
INSERT INTO `quiz_testpaper_questions` VALUES (338, 7, 338);
INSERT INTO `quiz_testpaper_questions` VALUES (339, 7, 339);
INSERT INTO `quiz_testpaper_questions` VALUES (340, 7, 340);
INSERT INTO `quiz_testpaper_questions` VALUES (341, 7, 341);
INSERT INTO `quiz_testpaper_questions` VALUES (342, 7, 342);
INSERT INTO `quiz_testpaper_questions` VALUES (343, 7, 343);
INSERT INTO `quiz_testpaper_questions` VALUES (344, 7, 344);
INSERT INTO `quiz_testpaper_questions` VALUES (345, 7, 345);
INSERT INTO `quiz_testpaper_questions` VALUES (346, 7, 346);
INSERT INTO `quiz_testpaper_questions` VALUES (347, 7, 347);
INSERT INTO `quiz_testpaper_questions` VALUES (348, 7, 348);
INSERT INTO `quiz_testpaper_questions` VALUES (349, 7, 349);
INSERT INTO `quiz_testpaper_questions` VALUES (350, 7, 350);
INSERT INTO `quiz_testpaper_questions` VALUES (351, 8, 351);
INSERT INTO `quiz_testpaper_questions` VALUES (352, 8, 352);
INSERT INTO `quiz_testpaper_questions` VALUES (353, 8, 353);
INSERT INTO `quiz_testpaper_questions` VALUES (354, 8, 354);
INSERT INTO `quiz_testpaper_questions` VALUES (355, 8, 355);
INSERT INTO `quiz_testpaper_questions` VALUES (356, 8, 356);
INSERT INTO `quiz_testpaper_questions` VALUES (357, 8, 357);
INSERT INTO `quiz_testpaper_questions` VALUES (358, 8, 358);
INSERT INTO `quiz_testpaper_questions` VALUES (359, 8, 359);
INSERT INTO `quiz_testpaper_questions` VALUES (360, 8, 360);
INSERT INTO `quiz_testpaper_questions` VALUES (361, 8, 361);
INSERT INTO `quiz_testpaper_questions` VALUES (362, 8, 362);
INSERT INTO `quiz_testpaper_questions` VALUES (363, 8, 363);
INSERT INTO `quiz_testpaper_questions` VALUES (364, 8, 364);
INSERT INTO `quiz_testpaper_questions` VALUES (365, 8, 365);
INSERT INTO `quiz_testpaper_questions` VALUES (366, 8, 366);
INSERT INTO `quiz_testpaper_questions` VALUES (367, 8, 367);
INSERT INTO `quiz_testpaper_questions` VALUES (368, 8, 368);
INSERT INTO `quiz_testpaper_questions` VALUES (369, 8, 369);
INSERT INTO `quiz_testpaper_questions` VALUES (370, 8, 370);
INSERT INTO `quiz_testpaper_questions` VALUES (371, 8, 371);
INSERT INTO `quiz_testpaper_questions` VALUES (372, 8, 372);
INSERT INTO `quiz_testpaper_questions` VALUES (373, 8, 373);
INSERT INTO `quiz_testpaper_questions` VALUES (374, 8, 374);
INSERT INTO `quiz_testpaper_questions` VALUES (375, 8, 375);
INSERT INTO `quiz_testpaper_questions` VALUES (376, 8, 376);
INSERT INTO `quiz_testpaper_questions` VALUES (377, 8, 377);
INSERT INTO `quiz_testpaper_questions` VALUES (378, 8, 378);
INSERT INTO `quiz_testpaper_questions` VALUES (379, 8, 379);
INSERT INTO `quiz_testpaper_questions` VALUES (380, 8, 380);
INSERT INTO `quiz_testpaper_questions` VALUES (381, 8, 381);
INSERT INTO `quiz_testpaper_questions` VALUES (382, 8, 382);
INSERT INTO `quiz_testpaper_questions` VALUES (383, 8, 383);
INSERT INTO `quiz_testpaper_questions` VALUES (384, 8, 384);
INSERT INTO `quiz_testpaper_questions` VALUES (385, 8, 385);
INSERT INTO `quiz_testpaper_questions` VALUES (386, 8, 386);
INSERT INTO `quiz_testpaper_questions` VALUES (387, 8, 387);
INSERT INTO `quiz_testpaper_questions` VALUES (388, 8, 388);
INSERT INTO `quiz_testpaper_questions` VALUES (389, 8, 389);
INSERT INTO `quiz_testpaper_questions` VALUES (390, 8, 390);
INSERT INTO `quiz_testpaper_questions` VALUES (391, 8, 391);
INSERT INTO `quiz_testpaper_questions` VALUES (392, 8, 392);
INSERT INTO `quiz_testpaper_questions` VALUES (393, 8, 393);
INSERT INTO `quiz_testpaper_questions` VALUES (394, 8, 394);
INSERT INTO `quiz_testpaper_questions` VALUES (395, 8, 395);
INSERT INTO `quiz_testpaper_questions` VALUES (396, 8, 396);
INSERT INTO `quiz_testpaper_questions` VALUES (397, 8, 397);
INSERT INTO `quiz_testpaper_questions` VALUES (398, 8, 398);
INSERT INTO `quiz_testpaper_questions` VALUES (399, 8, 399);
INSERT INTO `quiz_testpaper_questions` VALUES (400, 8, 400);
INSERT INTO `quiz_testpaper_questions` VALUES (401, 9, 401);
INSERT INTO `quiz_testpaper_questions` VALUES (402, 9, 402);
INSERT INTO `quiz_testpaper_questions` VALUES (403, 9, 403);
INSERT INTO `quiz_testpaper_questions` VALUES (404, 9, 404);
INSERT INTO `quiz_testpaper_questions` VALUES (405, 9, 405);
INSERT INTO `quiz_testpaper_questions` VALUES (406, 9, 406);
INSERT INTO `quiz_testpaper_questions` VALUES (407, 9, 407);
INSERT INTO `quiz_testpaper_questions` VALUES (408, 9, 408);
INSERT INTO `quiz_testpaper_questions` VALUES (409, 9, 409);
INSERT INTO `quiz_testpaper_questions` VALUES (410, 9, 410);
INSERT INTO `quiz_testpaper_questions` VALUES (411, 9, 411);
INSERT INTO `quiz_testpaper_questions` VALUES (412, 9, 412);
INSERT INTO `quiz_testpaper_questions` VALUES (413, 9, 413);
INSERT INTO `quiz_testpaper_questions` VALUES (414, 9, 414);
INSERT INTO `quiz_testpaper_questions` VALUES (415, 9, 415);
INSERT INTO `quiz_testpaper_questions` VALUES (416, 9, 416);
INSERT INTO `quiz_testpaper_questions` VALUES (417, 9, 417);
INSERT INTO `quiz_testpaper_questions` VALUES (418, 9, 418);
INSERT INTO `quiz_testpaper_questions` VALUES (419, 9, 419);
INSERT INTO `quiz_testpaper_questions` VALUES (420, 9, 420);
INSERT INTO `quiz_testpaper_questions` VALUES (421, 9, 421);
INSERT INTO `quiz_testpaper_questions` VALUES (422, 9, 422);
INSERT INTO `quiz_testpaper_questions` VALUES (423, 9, 423);
INSERT INTO `quiz_testpaper_questions` VALUES (424, 9, 424);
INSERT INTO `quiz_testpaper_questions` VALUES (425, 9, 425);
INSERT INTO `quiz_testpaper_questions` VALUES (426, 9, 426);
INSERT INTO `quiz_testpaper_questions` VALUES (427, 9, 427);
INSERT INTO `quiz_testpaper_questions` VALUES (428, 9, 428);
INSERT INTO `quiz_testpaper_questions` VALUES (429, 9, 429);
INSERT INTO `quiz_testpaper_questions` VALUES (430, 9, 430);
INSERT INTO `quiz_testpaper_questions` VALUES (431, 9, 431);
INSERT INTO `quiz_testpaper_questions` VALUES (432, 9, 432);
INSERT INTO `quiz_testpaper_questions` VALUES (433, 9, 433);
INSERT INTO `quiz_testpaper_questions` VALUES (434, 9, 434);
INSERT INTO `quiz_testpaper_questions` VALUES (435, 9, 435);
INSERT INTO `quiz_testpaper_questions` VALUES (436, 9, 436);
INSERT INTO `quiz_testpaper_questions` VALUES (437, 9, 437);
INSERT INTO `quiz_testpaper_questions` VALUES (438, 9, 438);
INSERT INTO `quiz_testpaper_questions` VALUES (439, 9, 439);
INSERT INTO `quiz_testpaper_questions` VALUES (440, 9, 440);
INSERT INTO `quiz_testpaper_questions` VALUES (441, 9, 441);
INSERT INTO `quiz_testpaper_questions` VALUES (442, 9, 442);
INSERT INTO `quiz_testpaper_questions` VALUES (443, 9, 443);
INSERT INTO `quiz_testpaper_questions` VALUES (444, 9, 444);
INSERT INTO `quiz_testpaper_questions` VALUES (445, 9, 445);
INSERT INTO `quiz_testpaper_questions` VALUES (446, 9, 446);
INSERT INTO `quiz_testpaper_questions` VALUES (447, 9, 447);
INSERT INTO `quiz_testpaper_questions` VALUES (448, 9, 448);
INSERT INTO `quiz_testpaper_questions` VALUES (449, 9, 449);
INSERT INTO `quiz_testpaper_questions` VALUES (450, 9, 450);
INSERT INTO `quiz_testpaper_questions` VALUES (451, 10, 451);
INSERT INTO `quiz_testpaper_questions` VALUES (452, 10, 452);
INSERT INTO `quiz_testpaper_questions` VALUES (453, 10, 453);
INSERT INTO `quiz_testpaper_questions` VALUES (454, 10, 454);
INSERT INTO `quiz_testpaper_questions` VALUES (455, 10, 455);
INSERT INTO `quiz_testpaper_questions` VALUES (456, 10, 456);
INSERT INTO `quiz_testpaper_questions` VALUES (457, 10, 457);
INSERT INTO `quiz_testpaper_questions` VALUES (458, 10, 458);
INSERT INTO `quiz_testpaper_questions` VALUES (459, 10, 459);
INSERT INTO `quiz_testpaper_questions` VALUES (460, 10, 460);
INSERT INTO `quiz_testpaper_questions` VALUES (461, 10, 461);
INSERT INTO `quiz_testpaper_questions` VALUES (462, 10, 462);
INSERT INTO `quiz_testpaper_questions` VALUES (463, 10, 463);
INSERT INTO `quiz_testpaper_questions` VALUES (464, 10, 464);
INSERT INTO `quiz_testpaper_questions` VALUES (465, 10, 465);
INSERT INTO `quiz_testpaper_questions` VALUES (466, 10, 466);
INSERT INTO `quiz_testpaper_questions` VALUES (467, 10, 467);
INSERT INTO `quiz_testpaper_questions` VALUES (468, 10, 468);
INSERT INTO `quiz_testpaper_questions` VALUES (469, 10, 469);
INSERT INTO `quiz_testpaper_questions` VALUES (470, 10, 470);
INSERT INTO `quiz_testpaper_questions` VALUES (471, 10, 471);
INSERT INTO `quiz_testpaper_questions` VALUES (472, 10, 472);
INSERT INTO `quiz_testpaper_questions` VALUES (473, 10, 473);
INSERT INTO `quiz_testpaper_questions` VALUES (474, 10, 474);
INSERT INTO `quiz_testpaper_questions` VALUES (475, 10, 475);
INSERT INTO `quiz_testpaper_questions` VALUES (476, 10, 476);
INSERT INTO `quiz_testpaper_questions` VALUES (477, 10, 477);
INSERT INTO `quiz_testpaper_questions` VALUES (478, 10, 478);
INSERT INTO `quiz_testpaper_questions` VALUES (479, 10, 479);
INSERT INTO `quiz_testpaper_questions` VALUES (480, 10, 480);
INSERT INTO `quiz_testpaper_questions` VALUES (481, 10, 481);
INSERT INTO `quiz_testpaper_questions` VALUES (482, 10, 482);
INSERT INTO `quiz_testpaper_questions` VALUES (483, 10, 483);
INSERT INTO `quiz_testpaper_questions` VALUES (484, 10, 484);
INSERT INTO `quiz_testpaper_questions` VALUES (485, 10, 485);
INSERT INTO `quiz_testpaper_questions` VALUES (486, 10, 486);
INSERT INTO `quiz_testpaper_questions` VALUES (487, 10, 487);
INSERT INTO `quiz_testpaper_questions` VALUES (488, 10, 488);
INSERT INTO `quiz_testpaper_questions` VALUES (489, 10, 489);
INSERT INTO `quiz_testpaper_questions` VALUES (490, 10, 490);
INSERT INTO `quiz_testpaper_questions` VALUES (491, 10, 491);
INSERT INTO `quiz_testpaper_questions` VALUES (492, 10, 492);
INSERT INTO `quiz_testpaper_questions` VALUES (493, 10, 493);
INSERT INTO `quiz_testpaper_questions` VALUES (494, 10, 494);
INSERT INTO `quiz_testpaper_questions` VALUES (495, 10, 495);
INSERT INTO `quiz_testpaper_questions` VALUES (496, 10, 496);
INSERT INTO `quiz_testpaper_questions` VALUES (497, 10, 497);
INSERT INTO `quiz_testpaper_questions` VALUES (498, 10, 498);
INSERT INTO `quiz_testpaper_questions` VALUES (499, 10, 499);
INSERT INTO `quiz_testpaper_questions` VALUES (500, 10, 500);
INSERT INTO `quiz_testpaper_questions` VALUES (501, 11, 501);
INSERT INTO `quiz_testpaper_questions` VALUES (502, 11, 502);
INSERT INTO `quiz_testpaper_questions` VALUES (503, 11, 503);
INSERT INTO `quiz_testpaper_questions` VALUES (504, 11, 504);
INSERT INTO `quiz_testpaper_questions` VALUES (505, 11, 505);
INSERT INTO `quiz_testpaper_questions` VALUES (506, 11, 506);
INSERT INTO `quiz_testpaper_questions` VALUES (507, 11, 507);
INSERT INTO `quiz_testpaper_questions` VALUES (508, 11, 508);
INSERT INTO `quiz_testpaper_questions` VALUES (509, 11, 509);
INSERT INTO `quiz_testpaper_questions` VALUES (510, 11, 510);
INSERT INTO `quiz_testpaper_questions` VALUES (511, 11, 511);
INSERT INTO `quiz_testpaper_questions` VALUES (512, 11, 512);
INSERT INTO `quiz_testpaper_questions` VALUES (513, 11, 513);
INSERT INTO `quiz_testpaper_questions` VALUES (514, 11, 514);
INSERT INTO `quiz_testpaper_questions` VALUES (515, 11, 515);
INSERT INTO `quiz_testpaper_questions` VALUES (516, 11, 516);
INSERT INTO `quiz_testpaper_questions` VALUES (517, 11, 517);
INSERT INTO `quiz_testpaper_questions` VALUES (518, 11, 518);
INSERT INTO `quiz_testpaper_questions` VALUES (519, 11, 519);
INSERT INTO `quiz_testpaper_questions` VALUES (520, 11, 520);
INSERT INTO `quiz_testpaper_questions` VALUES (521, 11, 521);
INSERT INTO `quiz_testpaper_questions` VALUES (522, 11, 522);
INSERT INTO `quiz_testpaper_questions` VALUES (523, 11, 523);
INSERT INTO `quiz_testpaper_questions` VALUES (524, 11, 524);
INSERT INTO `quiz_testpaper_questions` VALUES (525, 11, 525);
INSERT INTO `quiz_testpaper_questions` VALUES (526, 11, 526);
INSERT INTO `quiz_testpaper_questions` VALUES (527, 11, 527);
INSERT INTO `quiz_testpaper_questions` VALUES (528, 11, 528);
INSERT INTO `quiz_testpaper_questions` VALUES (529, 11, 529);
INSERT INTO `quiz_testpaper_questions` VALUES (530, 11, 530);
INSERT INTO `quiz_testpaper_questions` VALUES (531, 11, 531);
INSERT INTO `quiz_testpaper_questions` VALUES (532, 11, 532);
INSERT INTO `quiz_testpaper_questions` VALUES (533, 11, 533);
INSERT INTO `quiz_testpaper_questions` VALUES (534, 11, 534);
INSERT INTO `quiz_testpaper_questions` VALUES (535, 11, 535);
INSERT INTO `quiz_testpaper_questions` VALUES (536, 11, 536);
INSERT INTO `quiz_testpaper_questions` VALUES (537, 11, 537);
INSERT INTO `quiz_testpaper_questions` VALUES (538, 11, 538);
INSERT INTO `quiz_testpaper_questions` VALUES (539, 11, 539);
INSERT INTO `quiz_testpaper_questions` VALUES (540, 11, 540);
INSERT INTO `quiz_testpaper_questions` VALUES (541, 11, 541);
INSERT INTO `quiz_testpaper_questions` VALUES (542, 11, 542);
INSERT INTO `quiz_testpaper_questions` VALUES (543, 11, 543);
INSERT INTO `quiz_testpaper_questions` VALUES (544, 11, 544);
INSERT INTO `quiz_testpaper_questions` VALUES (545, 11, 545);
INSERT INTO `quiz_testpaper_questions` VALUES (546, 11, 546);
INSERT INTO `quiz_testpaper_questions` VALUES (547, 11, 547);
INSERT INTO `quiz_testpaper_questions` VALUES (548, 11, 548);
INSERT INTO `quiz_testpaper_questions` VALUES (549, 11, 549);
INSERT INTO `quiz_testpaper_questions` VALUES (550, 11, 550);
INSERT INTO `quiz_testpaper_questions` VALUES (601, 13, 601);
INSERT INTO `quiz_testpaper_questions` VALUES (602, 13, 602);
INSERT INTO `quiz_testpaper_questions` VALUES (603, 13, 603);
INSERT INTO `quiz_testpaper_questions` VALUES (604, 13, 604);
INSERT INTO `quiz_testpaper_questions` VALUES (605, 13, 605);
INSERT INTO `quiz_testpaper_questions` VALUES (606, 13, 606);
INSERT INTO `quiz_testpaper_questions` VALUES (607, 13, 607);
INSERT INTO `quiz_testpaper_questions` VALUES (608, 13, 608);
INSERT INTO `quiz_testpaper_questions` VALUES (609, 13, 609);
INSERT INTO `quiz_testpaper_questions` VALUES (610, 13, 610);
INSERT INTO `quiz_testpaper_questions` VALUES (611, 13, 611);
INSERT INTO `quiz_testpaper_questions` VALUES (612, 13, 612);
INSERT INTO `quiz_testpaper_questions` VALUES (613, 13, 613);
INSERT INTO `quiz_testpaper_questions` VALUES (614, 13, 614);
INSERT INTO `quiz_testpaper_questions` VALUES (615, 13, 615);
INSERT INTO `quiz_testpaper_questions` VALUES (616, 13, 616);
INSERT INTO `quiz_testpaper_questions` VALUES (617, 13, 617);
INSERT INTO `quiz_testpaper_questions` VALUES (618, 13, 618);
INSERT INTO `quiz_testpaper_questions` VALUES (619, 13, 619);
INSERT INTO `quiz_testpaper_questions` VALUES (620, 13, 620);
INSERT INTO `quiz_testpaper_questions` VALUES (621, 13, 621);
INSERT INTO `quiz_testpaper_questions` VALUES (622, 13, 622);
INSERT INTO `quiz_testpaper_questions` VALUES (623, 13, 623);
INSERT INTO `quiz_testpaper_questions` VALUES (624, 13, 624);
INSERT INTO `quiz_testpaper_questions` VALUES (625, 13, 625);
INSERT INTO `quiz_testpaper_questions` VALUES (626, 13, 626);
INSERT INTO `quiz_testpaper_questions` VALUES (627, 13, 627);
INSERT INTO `quiz_testpaper_questions` VALUES (628, 13, 628);
INSERT INTO `quiz_testpaper_questions` VALUES (629, 13, 629);
INSERT INTO `quiz_testpaper_questions` VALUES (630, 13, 630);
INSERT INTO `quiz_testpaper_questions` VALUES (631, 13, 631);
INSERT INTO `quiz_testpaper_questions` VALUES (632, 13, 632);
INSERT INTO `quiz_testpaper_questions` VALUES (633, 13, 633);
INSERT INTO `quiz_testpaper_questions` VALUES (634, 13, 634);
INSERT INTO `quiz_testpaper_questions` VALUES (635, 13, 635);
INSERT INTO `quiz_testpaper_questions` VALUES (636, 13, 636);
INSERT INTO `quiz_testpaper_questions` VALUES (637, 13, 637);
INSERT INTO `quiz_testpaper_questions` VALUES (638, 13, 638);
INSERT INTO `quiz_testpaper_questions` VALUES (639, 13, 639);
INSERT INTO `quiz_testpaper_questions` VALUES (640, 13, 640);
INSERT INTO `quiz_testpaper_questions` VALUES (641, 13, 641);
INSERT INTO `quiz_testpaper_questions` VALUES (642, 13, 642);
INSERT INTO `quiz_testpaper_questions` VALUES (643, 13, 643);
INSERT INTO `quiz_testpaper_questions` VALUES (644, 13, 644);
INSERT INTO `quiz_testpaper_questions` VALUES (645, 13, 645);
INSERT INTO `quiz_testpaper_questions` VALUES (646, 13, 646);
INSERT INTO `quiz_testpaper_questions` VALUES (647, 13, 647);
INSERT INTO `quiz_testpaper_questions` VALUES (648, 13, 648);
INSERT INTO `quiz_testpaper_questions` VALUES (649, 13, 649);
INSERT INTO `quiz_testpaper_questions` VALUES (650, 13, 650);
INSERT INTO `quiz_testpaper_questions` VALUES (651, 14, 651);
INSERT INTO `quiz_testpaper_questions` VALUES (652, 14, 652);
INSERT INTO `quiz_testpaper_questions` VALUES (653, 14, 653);
INSERT INTO `quiz_testpaper_questions` VALUES (654, 14, 654);
INSERT INTO `quiz_testpaper_questions` VALUES (655, 14, 655);
INSERT INTO `quiz_testpaper_questions` VALUES (656, 14, 656);
INSERT INTO `quiz_testpaper_questions` VALUES (657, 14, 657);
INSERT INTO `quiz_testpaper_questions` VALUES (658, 14, 658);
INSERT INTO `quiz_testpaper_questions` VALUES (659, 14, 659);
INSERT INTO `quiz_testpaper_questions` VALUES (660, 14, 660);
INSERT INTO `quiz_testpaper_questions` VALUES (661, 14, 661);
INSERT INTO `quiz_testpaper_questions` VALUES (662, 14, 662);
INSERT INTO `quiz_testpaper_questions` VALUES (663, 14, 663);
INSERT INTO `quiz_testpaper_questions` VALUES (664, 14, 664);
INSERT INTO `quiz_testpaper_questions` VALUES (665, 14, 665);
INSERT INTO `quiz_testpaper_questions` VALUES (666, 14, 666);
INSERT INTO `quiz_testpaper_questions` VALUES (667, 14, 667);
INSERT INTO `quiz_testpaper_questions` VALUES (668, 14, 668);
INSERT INTO `quiz_testpaper_questions` VALUES (669, 14, 669);
INSERT INTO `quiz_testpaper_questions` VALUES (670, 14, 670);
INSERT INTO `quiz_testpaper_questions` VALUES (671, 14, 671);
INSERT INTO `quiz_testpaper_questions` VALUES (672, 14, 672);
INSERT INTO `quiz_testpaper_questions` VALUES (673, 14, 673);
INSERT INTO `quiz_testpaper_questions` VALUES (674, 14, 674);
INSERT INTO `quiz_testpaper_questions` VALUES (675, 14, 675);
INSERT INTO `quiz_testpaper_questions` VALUES (676, 14, 676);
INSERT INTO `quiz_testpaper_questions` VALUES (677, 14, 677);
INSERT INTO `quiz_testpaper_questions` VALUES (678, 14, 678);
INSERT INTO `quiz_testpaper_questions` VALUES (679, 14, 679);
INSERT INTO `quiz_testpaper_questions` VALUES (680, 14, 680);
INSERT INTO `quiz_testpaper_questions` VALUES (681, 14, 681);
INSERT INTO `quiz_testpaper_questions` VALUES (682, 14, 682);
INSERT INTO `quiz_testpaper_questions` VALUES (683, 14, 683);
INSERT INTO `quiz_testpaper_questions` VALUES (684, 14, 684);
INSERT INTO `quiz_testpaper_questions` VALUES (685, 14, 685);
INSERT INTO `quiz_testpaper_questions` VALUES (686, 14, 686);
INSERT INTO `quiz_testpaper_questions` VALUES (687, 14, 687);
INSERT INTO `quiz_testpaper_questions` VALUES (688, 14, 688);
INSERT INTO `quiz_testpaper_questions` VALUES (689, 14, 689);
INSERT INTO `quiz_testpaper_questions` VALUES (690, 14, 690);
INSERT INTO `quiz_testpaper_questions` VALUES (691, 14, 691);
INSERT INTO `quiz_testpaper_questions` VALUES (692, 14, 692);
INSERT INTO `quiz_testpaper_questions` VALUES (693, 14, 693);
INSERT INTO `quiz_testpaper_questions` VALUES (694, 14, 694);
INSERT INTO `quiz_testpaper_questions` VALUES (695, 14, 695);
INSERT INTO `quiz_testpaper_questions` VALUES (696, 14, 696);
INSERT INTO `quiz_testpaper_questions` VALUES (697, 14, 697);
INSERT INTO `quiz_testpaper_questions` VALUES (698, 14, 698);
INSERT INTO `quiz_testpaper_questions` VALUES (699, 14, 699);
INSERT INTO `quiz_testpaper_questions` VALUES (700, 14, 700);
INSERT INTO `quiz_testpaper_questions` VALUES (701, 15, 701);
INSERT INTO `quiz_testpaper_questions` VALUES (702, 15, 702);
INSERT INTO `quiz_testpaper_questions` VALUES (703, 15, 703);
INSERT INTO `quiz_testpaper_questions` VALUES (704, 15, 704);
INSERT INTO `quiz_testpaper_questions` VALUES (705, 15, 705);
INSERT INTO `quiz_testpaper_questions` VALUES (706, 15, 706);
INSERT INTO `quiz_testpaper_questions` VALUES (707, 15, 707);
INSERT INTO `quiz_testpaper_questions` VALUES (708, 15, 708);
INSERT INTO `quiz_testpaper_questions` VALUES (709, 15, 709);
INSERT INTO `quiz_testpaper_questions` VALUES (710, 15, 710);
INSERT INTO `quiz_testpaper_questions` VALUES (711, 15, 711);
INSERT INTO `quiz_testpaper_questions` VALUES (712, 15, 712);
INSERT INTO `quiz_testpaper_questions` VALUES (713, 15, 713);
INSERT INTO `quiz_testpaper_questions` VALUES (714, 15, 714);
INSERT INTO `quiz_testpaper_questions` VALUES (715, 15, 715);
INSERT INTO `quiz_testpaper_questions` VALUES (716, 15, 716);
INSERT INTO `quiz_testpaper_questions` VALUES (717, 15, 717);
INSERT INTO `quiz_testpaper_questions` VALUES (718, 15, 718);
INSERT INTO `quiz_testpaper_questions` VALUES (719, 15, 719);
INSERT INTO `quiz_testpaper_questions` VALUES (720, 15, 720);
INSERT INTO `quiz_testpaper_questions` VALUES (721, 15, 721);
INSERT INTO `quiz_testpaper_questions` VALUES (722, 15, 722);
INSERT INTO `quiz_testpaper_questions` VALUES (723, 15, 723);
INSERT INTO `quiz_testpaper_questions` VALUES (724, 15, 724);
INSERT INTO `quiz_testpaper_questions` VALUES (725, 15, 725);
INSERT INTO `quiz_testpaper_questions` VALUES (726, 15, 726);
INSERT INTO `quiz_testpaper_questions` VALUES (727, 15, 727);
INSERT INTO `quiz_testpaper_questions` VALUES (728, 15, 728);
INSERT INTO `quiz_testpaper_questions` VALUES (729, 15, 729);
INSERT INTO `quiz_testpaper_questions` VALUES (730, 15, 730);
INSERT INTO `quiz_testpaper_questions` VALUES (731, 15, 731);
INSERT INTO `quiz_testpaper_questions` VALUES (732, 15, 732);
INSERT INTO `quiz_testpaper_questions` VALUES (733, 15, 733);
INSERT INTO `quiz_testpaper_questions` VALUES (734, 15, 734);
INSERT INTO `quiz_testpaper_questions` VALUES (735, 15, 735);
INSERT INTO `quiz_testpaper_questions` VALUES (736, 15, 736);
INSERT INTO `quiz_testpaper_questions` VALUES (737, 15, 737);
INSERT INTO `quiz_testpaper_questions` VALUES (738, 15, 738);
INSERT INTO `quiz_testpaper_questions` VALUES (739, 15, 739);
INSERT INTO `quiz_testpaper_questions` VALUES (740, 15, 740);
INSERT INTO `quiz_testpaper_questions` VALUES (741, 15, 741);
INSERT INTO `quiz_testpaper_questions` VALUES (742, 15, 742);
INSERT INTO `quiz_testpaper_questions` VALUES (743, 15, 743);
INSERT INTO `quiz_testpaper_questions` VALUES (744, 15, 744);
INSERT INTO `quiz_testpaper_questions` VALUES (745, 15, 745);
INSERT INTO `quiz_testpaper_questions` VALUES (746, 15, 746);
INSERT INTO `quiz_testpaper_questions` VALUES (747, 15, 747);
INSERT INTO `quiz_testpaper_questions` VALUES (748, 15, 748);
INSERT INTO `quiz_testpaper_questions` VALUES (749, 15, 749);
INSERT INTO `quiz_testpaper_questions` VALUES (750, 15, 750);

-- ----------------------------
-- Table structure for quiz_testrecord
-- ----------------------------
DROP TABLE IF EXISTS `quiz_testrecord`;
CREATE TABLE `quiz_testrecord`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `score` int(11) NOT NULL,
  `total_score` int(11) NOT NULL,
  `completed_at` datetime(6) NOT NULL,
  `test_paper_id` bigint(20) NULL DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `is_wrong_paper` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `quiz_testrecord_test_paper_id_808ae2dd_fk_quiz_testpaper_id`(`test_paper_id`) USING BTREE,
  INDEX `quiz_testrecord_user_id_534ef7b6_fk_auth_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `quiz_testrecord_test_paper_id_808ae2dd_fk_quiz_testpaper_id` FOREIGN KEY (`test_paper_id`) REFERENCES `quiz_testpaper` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_testrecord_user_id_534ef7b6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_testrecord
-- ----------------------------
INSERT INTO `quiz_testrecord` VALUES (1, 111, 150, '2026-09-13 10:32:15.825281', 14, 5, 0);

-- ----------------------------
-- Table structure for quiz_wrongquestion
-- ----------------------------
DROP TABLE IF EXISTS `quiz_wrongquestion`;
CREATE TABLE `quiz_wrongquestion`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `added_at` datetime(6) NOT NULL,
  `question_id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `user_answer` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `correct_answer` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `last_reviewed_at` datetime(6) NULL DEFAULT NULL,
  `next_review_at` datetime(6) NULL DEFAULT NULL,
  `review_count` int(11) NOT NULL,
  `review_status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `quiz_wrongquestion_user_id_question_id_02437028_uniq`(`user_id`, `question_id`) USING BTREE,
  INDEX `quiz_wrongquestion_question_id_b6169f16_fk_quiz_question_id`(`question_id`) USING BTREE,
  CONSTRAINT `quiz_wrongquestion_question_id_b6169f16_fk_quiz_question_id` FOREIGN KEY (`question_id`) REFERENCES `quiz_question` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `quiz_wrongquestion_user_id_80ef5e75_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of quiz_wrongquestion
-- ----------------------------
INSERT INTO `quiz_wrongquestion` VALUES (1, '2026-09-13 10:32:15.849386', 692, 5, 'D', 'B', NULL, NULL, 0, 'new');
INSERT INTO `quiz_wrongquestion` VALUES (2, '2026-09-13 10:32:15.852377', 690, 5, 'A', 'D', NULL, NULL, 0, 'new');
INSERT INTO `quiz_wrongquestion` VALUES (3, '2026-09-13 10:32:15.854372', 687, 5, 'C', 'D', NULL, NULL, 0, 'new');
INSERT INTO `quiz_wrongquestion` VALUES (4, '2026-09-13 10:32:15.856367', 678, 5, 'D', 'C', NULL, NULL, 0, 'new');
INSERT INTO `quiz_wrongquestion` VALUES (5, '2026-09-13 10:32:15.858362', 677, 5, 'B', 'D', NULL, NULL, 0, 'new');
INSERT INTO `quiz_wrongquestion` VALUES (6, '2026-09-13 10:32:15.860356', 675, 5, 'C', 'B', NULL, NULL, 0, 'new');
INSERT INTO `quiz_wrongquestion` VALUES (7, '2026-09-13 10:32:15.862351', 671, 5, 'B', 'C', NULL, NULL, 0, 'new');
INSERT INTO `quiz_wrongquestion` VALUES (8, '2026-09-13 10:32:15.864345', 668, 5, 'B', 'A', NULL, NULL, 0, 'new');
INSERT INTO `quiz_wrongquestion` VALUES (9, '2026-09-13 10:32:15.866340', 665, 5, 'A', 'C', NULL, NULL, 0, 'new');
INSERT INTO `quiz_wrongquestion` VALUES (10, '2026-09-13 10:32:15.867338', 664, 5, 'C', 'B', NULL, NULL, 0, 'new');
INSERT INTO `quiz_wrongquestion` VALUES (11, '2026-09-13 10:32:15.869332', 663, 5, 'B', 'C', NULL, NULL, 0, 'new');
INSERT INTO `quiz_wrongquestion` VALUES (12, '2026-09-13 10:32:15.871327', 662, 5, 'A', 'C', NULL, NULL, 0, 'new');
INSERT INTO `quiz_wrongquestion` VALUES (13, '2026-09-13 10:32:15.873322', 654, 5, 'C', 'D', NULL, NULL, 0, 'new');

-- ----------------------------
-- Table structure for records_studyrecord
-- ----------------------------
DROP TABLE IF EXISTS `records_studyrecord`;
CREATE TABLE `records_studyrecord`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_answer` json NOT NULL,
  `is_correct` tinyint(1) NOT NULL,
  `score` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `duration` int(11) NOT NULL,
  `exam_id` bigint(20) NOT NULL,
  `paper_id` bigint(20) NOT NULL,
  `question_id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `records_studyrecord_exam_id_0d24f311_fk_exams_exam_id`(`exam_id`) USING BTREE,
  INDEX `records_studyrecord_paper_id_ce4b2a76_fk_exams_paper_id`(`paper_id`) USING BTREE,
  INDEX `records_studyrecord_question_id_c54d0040_fk_questions`(`question_id`) USING BTREE,
  INDEX `records_studyrecord_user_id_5c987720_fk_auth_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `records_studyrecord_exam_id_0d24f311_fk_exams_exam_id` FOREIGN KEY (`exam_id`) REFERENCES `exams_exam` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `records_studyrecord_paper_id_ce4b2a76_fk_exams_paper_id` FOREIGN KEY (`paper_id`) REFERENCES `exams_paper` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `records_studyrecord_question_id_c54d0040_fk_questions` FOREIGN KEY (`question_id`) REFERENCES `questions_question` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `records_studyrecord_user_id_5c987720_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of records_studyrecord
-- ----------------------------

-- ----------------------------
-- Table structure for records_wrongquestion
-- ----------------------------
DROP TABLE IF EXISTS `records_wrongquestion`;
CREATE TABLE `records_wrongquestion`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `note` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `created_at` datetime(6) NOT NULL,
  `last_reviewed` datetime(6) NOT NULL,
  `is_mastered` tinyint(1) NOT NULL,
  `question_id` bigint(20) NOT NULL,
  `study_record_id` bigint(20) NULL DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `records_wrongquestio_question_id_eb9dbe80_fk_questions`(`question_id`) USING BTREE,
  INDEX `records_wrongquestio_study_record_id_7b44982b_fk_records_s`(`study_record_id`) USING BTREE,
  INDEX `records_wrongquestion_user_id_a2496985_fk_auth_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `records_wrongquestio_question_id_eb9dbe80_fk_questions` FOREIGN KEY (`question_id`) REFERENCES `questions_question` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `records_wrongquestio_study_record_id_7b44982b_fk_records_s` FOREIGN KEY (`study_record_id`) REFERENCES `records_studyrecord` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `records_wrongquestion_user_id_a2496985_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of records_wrongquestion
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
