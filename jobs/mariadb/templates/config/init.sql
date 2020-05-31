SET password=PASSWORD('<%= p("admin.password") %>');
GRANT ALL PRIVILEGES ON *.* TO '<%= p("admin.username") %>'@'%' IDENTIFIED BY '<%= p("admin.password") %>' WITH GRANT OPTION;
FLUSH PRIVILEGES;


CREATE DATABASE  IF NOT EXISTS `broker` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `broker`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for deployments
-- ----------------------------
DROP TABLE IF EXISTS `deployments`;
CREATE TABLE `deployments`  (
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `deployments_yml` longtext CHARACTER SET utf8 COLLATE utf8_general_ci,
  PRIMARY KEY (`name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of deployments
-- ----------------------------
INSERT INTO `deployments`(`name`, `deployments_yml`) VALUES ('mariadb', 'instance_groups:\r\n- azs:\r\n  - z5\r\n  instances: 1\r\n  jobs:\r\n  - name: mariadb\r\n    release: mariadb-on-demand-release\r\n  name: mariadb\r\n  networks:\r\n  - default:\r\n    - dns\r\n    - gateway\r\n    name: default\r\n  persistent_disk_type: 1GB\r\n  stemcell: xenial\r\n  vm_type: small\r\nname: mariadb\r\nproperties:\r\n  password: insoft@hrjin\r\n  port: \"13306\"\r\nreleases:\r\n- name: mariadb-on-demand-release\r\n  version: \"1.0\"\r\nstemcells:\r\n- alias: xenial\r\n  os: ubuntu-xenial\r\n  version: \"315.64\"\r\nupdate:\r\n  canaries: 1\r\n  canary_watch_time: 30000-120000\r\n  max_in_flight: 1\r\n  update_watch_time: 30000-120000');
INSERT INTO `deployments`(`name`, `deployments_yml`) VALUES ('redis', 'addons:\r\n- jobs:\r\n  - name: bpm\r\n    release: bpm\r\n  name: bpm\r\ninstance_groups:\r\n- azs:\r\n  - z5\r\n  instances: 1\r\n  jobs:\r\n  - name: redis\r\n    release: redis-service-release\r\n  name: redis\r\n  networks:\r\n  - name: default\r\n  persistent_disk_type: 2GB\r\n  stemcell: default\r\n  vm_type: medium\r\nname: redis\r\nproperties:\r\n  password: hoho1234\r\n  port: \'3658\'\r\n  vm_type: small\r\n  persistent_disk_type: 1GB\r\nreleases:\r\n- name: bpm\r\n  version: latest\r\n- name: redis-service-release\r\n  version: \'1.0\'\r\nstemcells:\r\n- alias: default\r\n  os: ubuntu-xenial\r\n  version: latest\r\nupdate:\r\n  canaries: 1\r\n  canary_watch_time: 5000-120000\r\n  max_in_flight: 1\r\n  serial: false\r\n  update_watch_time: 5000-120000');
INSERT INTO `deployments`(`name`, `deployments_yml`) VALUES ('rmq', 'instance_groups:\r\n- azs:\r\n  - z6\r\n  instances: 1\r\n  jobs:\r\n  - name: rabbitmq-server\r\n    release: rabbitmq-on-demand-release\r\n  name: rmq\r\n  networks:\r\n  - name: default\r\n  persistent_disk_type: 1GB\r\n  stemcell: xenial\r\n  vm_type: small\r\n- azs:\r\n  - z6\r\n  instances: 1\r\n  jobs:\r\n  - name: rabbitmq-haproxy\r\n    release: rabbitmq-on-demand-release\r\n  - consumes:\r\n      nats:\r\n        deployment: paasta\r\n        from: nats\r\n    name: route_registrar\r\n    properties:\r\n      route_registrar:\r\n        routes:\r\n        - name: rabbitmq-on-demand\r\n          port: 15672\r\n          registration_interval: 20s\r\n          uris:\r\n          - rabbitmq-on-demand.172.30.50.5.xip.io\r\n    release: routing\r\n  - name: bpm\r\n    release: bpm\r\n  name: haproxy\r\n  networks:\r\n  - name: default\r\n  stemcell: xenial\r\n  vm_type: small\r\nname: rabbitmq\r\nproperties:\r\n  password: jin1234\r\nreleases:\r\n- name: rabbitmq-on-demand-release\r\n  version: \"1.0\"\r\n- name: routing\r\n  version: latest\r\n- name: bpm\r\n  version: latest\r\nstemcells:\r\n- alias: xenial\r\n  os: ubuntu-xenial\r\n  version: 315.64\r\nupdate:\r\n  canaries: 1\r\n  canary_watch_time: 30000-180000\r\n  max_in_flight: 1\r\n  serial: false\r\n  update_watch_time: 30000-180000');

-- ----------------------------
-- Table structure for service
-- ----------------------------
DROP TABLE IF EXISTS `service`;
CREATE TABLE `service`  (
  `id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '서비스 ID',
  `bind_at` int(11) DEFAULT NULL COMMENT '결합 여부',
  `clssf` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '분류',
  `creat_de` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '생성 일자',
  `creat_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '생성자 ID',
  `dc` longtext CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '설명',
  `reqst_paramtr` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '요청 파라미터',
  `rspns_paramtr` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '응답 파라미터',
  `svc_broker_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스브로커 ID',
  `svc_nm` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 명',
  `svc_pltform_ty` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 플랫폼 구분',
  `svc_ty` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 구분',
  `tag` longtext CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '태그',
  `updt_de` timestamp(0) NULL DEFAULT NULL COMMENT '수정 일자',
  `updt_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '수정자 ID',
  `use_at` int(11) NOT NULL COMMENT '사용 여부',
  `service_broker_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK9g6fjrt65rmuxli5ynodl8ctp`(`service_broker_id`) USING BTREE,
  CONSTRAINT `FK9g6fjrt65rmuxli5ynodl8ctp` FOREIGN KEY (`service_broker_id`) REFERENCES `service_broker` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of service
-- ----------------------------
INSERT INTO `service` VALUES ('073859ba-f7cb-4922-b35b-3a0d1dc964e1', 0, NULL, now(), NULL, 'Paas-TA On-Demand MariaDB Service', 'password=admin, port=3306', NULL, NULL, 'mariadb', 'cloudfoundry', 'mariadb', '[\"cf\",\"mariadb\"]', NULL, '', 1, NULL);
INSERT INTO `service` VALUES ('5e17bbb3-1be6-4e25-bc34-91f70b15e0f7', 0, NULL, now(), NULL, 'Paas-TA On-Demand RabbitMQ Service', 'password=admin, port=5672', NULL, NULL, 'rmq', 'cloudfoundry', 'rmq', '[\"cf\",\"rabbitmq\"]', NULL, '', 1, NULL);
INSERT INTO `service` VALUES ('c47cf3fa-42ca-4b67-b4b4-63825c99158f', 0, NULL, now(), NULL, 'Paas-TA On-Demand Redis Service', 'password=admin, port=3657', NULL, NULL, 'redis', 'cloudfoundry', 'redis', '[\"cf\",\"redis\"]', NULL, '', 1, NULL);

-- ----------------------------
-- Table structure for service_broker
-- ----------------------------
DROP TABLE IF EXISTS `service_broker`;
CREATE TABLE `service_broker`  (
  `id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '서비스 브로커 ID',
  `broker_nm` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 브로커 명',
  `broker_url` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 브로커 URL',
  `creat_de` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '생성 일자',
  `creat_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '생성자 ID',
  `dc` longtext CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '설명',
  `svc_platform_ty` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 플랫폼 구분',
  `svc_ty` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 구분',
  `updt_de` timestamp(0) NULL DEFAULT NULL COMMENT '수정 일자',
  `updt_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '수정자 ID',
  `use_at` int(11) NOT NULL COMMENT '사용 여부',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for service_instn
-- ----------------------------
DROP TABLE IF EXISTS `service_instn`;
CREATE TABLE `service_instn`  (
  `id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '서비스 인스턴스 ID',
  `conect_info` longtext CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '접속 정보',
  `conect_url` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '접속 URL',
  `creat_de` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '생성 일자',
  `creat_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '생성자 ID',
  `wdtb_nm` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '배포명',
  `instn_nm` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '인스턴스 명',
  `orgnzt_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '조직 ID',
  `result_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '결과 코드',
  `result_mssage` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '결과 메시지',
  `spce_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '공간 ID',
  `sttus_value` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '상태 코드',
  `svc_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 ID',
  `svc_plan_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 플랜 ID',
  `svc_platform_ty` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 플랫폼 구분',
  `svc_ty` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 구분',
  `task_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '과제 ID',
  `updt_de` timestamp(0) NULL DEFAULT NULL COMMENT '수정 일자',
  `updt_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '수정자 ID',
  `use_at` int(11) NOT NULL COMMENT '사용 여부',
  `user_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '사용자 ID',
  `virtl_mchn_instn_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '가상머신 인스턴스 ID',
  `service_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 인스턴스 ID',
  `service_plan_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 플랜 ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FKt8bxgv2dnyhna9e0ly5m56bij`(`service_id`) USING BTREE,
  INDEX `FKkwim26kuxq71p9g8obyb8eohs`(`service_plan_id`) USING BTREE,
  CONSTRAINT `FKkwim26kuxq71p9g8obyb8eohs` FOREIGN KEY (`service_plan_id`) REFERENCES `service_plan` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FKt8bxgv2dnyhna9e0ly5m56bij` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for service_plan
-- ----------------------------
DROP TABLE IF EXISTS `service_plan`;
CREATE TABLE `service_plan`  (
  `id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '서비스 플랜 ID',
  `cntnc_disk` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '지속디스크',
  `creat_de` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '생성 일자',
  `creat_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '생성자 ID',
  `ct_unit` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '통화 단위',
  `dc` longtext CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '설명',
  `detail_info` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '상세 정보',
  `free_at` int(11) DEFAULT NULL COMMENT '무료 여부',
  `mntnc_ver` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '유지보수 버전',
  `plan_nm` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '플랜 명',
  `rntfee` int(11) DEFAULT NULL COMMENT '사용 요금',
  `svc_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 ID',
  `updt_de` timestamp(0) NULL DEFAULT NULL COMMENT '수정 일자',
  `updt_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '수정자 ID',
  `use_at` int(11) NOT NULL COMMENT '사용 여부',
  `virtl_mchn_ty` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '가상머신 타입',
  `service_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK20vmbecpvumi0kc93d6l2tq67`(`service_id`) USING BTREE,
  CONSTRAINT `FK20vmbecpvumi0kc93d6l2tq67` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of service_plan
-- ----------------------------
INSERT INTO `service_plan` VALUES ('235d6917-42dc-4c7f-bd8c-59c884b769c6', '1GB', now(), NULL, 'MONTHLY', 'redis service plan1', 'plan 1 info', 0, '2.1.1+abcdef', 'dedicated-redis1', 10, 'c47cf3fa-42ca-4b67-b4b4-63825c99158f', NULL, NULL, 1, 'small', 'c47cf3fa-42ca-4b67-b4b4-63825c99158f');
INSERT INTO `service_plan` VALUES ('326c92df-916a-4a27-a6fe-7deaca01f40f', '2GB', now(), NULL, 'MONTHLY', 'rabbitmq service plan1', 'plan 1 info', 0, '2.1.1+abcdef', 'dedicated-rmq2', 20, '5e17bbb3-1be6-4e25-bc34-91f70b15e0f7', NULL, NULL, 1, 'small', '5e17bbb3-1be6-4e25-bc34-91f70b15e0f7');
INSERT INTO `service_plan` VALUES ('8b548f5a-6ecf-4ec1-ad45-a9e4cae4b13f', '4GB', now(), NULL, 'MONTHLY', 'rabbitmq service plan2', 'plan 2 info', 0, '2.1.1+abcdef', 'dedicated-rmq1', 30, '5e17bbb3-1be6-4e25-bc34-91f70b15e0f7', NULL, NULL, 1, 'medium', '5e17bbb3-1be6-4e25-bc34-91f70b15e0f7');
INSERT INTO `service_plan` VALUES ('d0277f16-8c09-41e2-8e2c-632329eb0a7d', '2GB', now(), NULL, 'MONTHLY', 'mariadb service plan2', 'plan 2 info', 0, '2.1.1+abcdef', 'dedicated-maria2', 60, '073859ba-f7cb-4922-b35b-3a0d1dc964e1', NULL, NULL, 1, 'medium', '073859ba-f7cb-4922-b35b-3a0d1dc964e1');
INSERT INTO `service_plan` VALUES ('d0897483-de5b-47c0-9553-1253d7fed156', '2GB', now(), NULL, 'MONTHLY', 'redis service plan2', 'plan 2 info', 0, '2.1.1+abcdef', 'dedicated-redis2', 40, 'c47cf3fa-42ca-4b67-b4b4-63825c99158f', NULL, NULL, 1, 'medium', 'c47cf3fa-42ca-4b67-b4b4-63825c99158f');
INSERT INTO `service_plan` VALUES ('e7b15536-78e9-4e5e-bac9-303ee2427ec2', '1GB', now(), NULL, 'MONTHLY', 'mariadb service plan1', 'plan 1 info', 0, '2.1.1+abcdef', 'dedicated-maria1', 50, '073859ba-f7cb-4922-b35b-3a0d1dc964e1', NULL, NULL, 1, 'small', '073859ba-f7cb-4922-b35b-3a0d1dc964e1');

-- ----------------------------
-- Table structure for service_use_info
-- ----------------------------
DROP TABLE IF EXISTS `service_use_info`;
CREATE TABLE `service_use_info`  (
  `id` bigint(20) NOT NULL COMMENT '서비스 사용 ID',
  `begin_de` datetime(6) DEFAULT NULL COMMENT '시작 일자',
  `end_de` datetime(6) DEFAULT NULL COMMENT '종료 일자',
  `rntfee` int(11) DEFAULT NULL COMMENT '사용 요금',
  `svc_instn_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 인스턴스 ID',
  `svc_plan_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '서비스 플랜 ID',
  `service_instn_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `service_plan_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK6eaaa4cqb0ticpdgdu8jbsxbe`(`service_instn_id`) USING BTREE,
  INDEX `FKdwvipb6u4nfyhxmf0d0kpsks0`(`service_plan_id`) USING BTREE,
  CONSTRAINT `FK6eaaa4cqb0ticpdgdu8jbsxbe` FOREIGN KEY (`service_instn_id`) REFERENCES `service_instn` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FKdwvipb6u4nfyhxmf0d0kpsks0` FOREIGN KEY (`service_plan_id`) REFERENCES `service_plan` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

SET FOREIGN_KEY_CHECKS = 1;
