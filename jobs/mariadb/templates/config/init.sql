/*UPDATE mysql.user SET password=PASSWORD('<%= p("admin.password") %>') WHERE user='<%= p("admin.username") %>';*/
SET password=PASSWORD('<%= p("admin.password") %>');
GRANT ALL PRIVILEGES ON *.* TO '<%= p("admin.username") %>'@'%' IDENTIFIED BY '<%= p("admin.password") %>' WITH GRANT OPTION;
FLUSH PRIVILEGES;


CREATE DATABASE  IF NOT EXISTS `broker` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `broker`;

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service` (
  `id` varchar(255) NOT NULL,
  `bind_at` int DEFAULT NULL,
  `clssf` varchar(255) DEFAULT NULL,
  `dc` varchar(255) DEFAULT NULL,
  `request_parameter` varchar(255) DEFAULT NULL,
  `svc_broker_id` varchar(255) DEFAULT NULL,
  `svc_nm` varchar(255) DEFAULT NULL,
  `svc_pltform_ty` varchar(255) DEFAULT NULL,
  `svc_ty` varchar(255) DEFAULT NULL,
  `tag` varchar(255) DEFAULT NULL,
  `use_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


INSERT INTO `service` VALUES ('54e2de61-de84-4b9c-afc3-88d08aadfcb6',0,NULL,'Paas-TA On-Demand Redis Service','password=admin, port=3657',NULL,'redis','cloudfoundry','redis','[\"cf\",\"redis\"]',1);


DROP TABLE IF EXISTS `service_instn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_instn` (
  `id` varchar(255) NOT NULL,
  `conect_info` varchar(255) DEFAULT NULL,
  `creat_de` timestamp NULL DEFAULT NULL,
  `creat_id` varchar(255) DEFAULT NULL,
  `dashboard_url` varchar(255) DEFAULT NULL,
  `dtb_nm` varchar(255) DEFAULT NULL,
  `instn_nm` varchar(255) DEFAULT NULL,
  `orgnzt_guid` varchar(255) DEFAULT NULL,
  `spce_guid` varchar(255) DEFAULT NULL,
  `svc_id` varchar(255) DEFAULT NULL,
  `svc_plan_id` varchar(255) DEFAULT NULL,
  `task_id` varchar(255) DEFAULT NULL,
  `updt_de` timestamp NULL DEFAULT NULL,
  `updt_id` varchar(255) DEFAULT NULL,
  `use_at` int DEFAULT NULL,
  `user_id` varchar(255) DEFAULT NULL,
  `vm_instn_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;



DROP TABLE IF EXISTS `service_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_plan` (
  `id` varchar(255) NOT NULL,
  `bullet` varchar(255) DEFAULT NULL,
  `cntnc_disk` varchar(255) DEFAULT NULL,
  `cost` varchar(255) DEFAULT NULL,
  `creat_de` timestamp NULL DEFAULT NULL,
  `creat_id` varchar(255) DEFAULT NULL,
  `dc` varchar(255) DEFAULT NULL,
  `free_at` int DEFAULT NULL,
  `mntnc_var` varchar(255) DEFAULT NULL,
  `plan_nm` varchar(255) DEFAULT NULL,
  `rntfee` int DEFAULT NULL,
  `svc_id` varchar(255) DEFAULT NULL,
  `updt_de` timestamp NULL DEFAULT NULL,
  `updt_id` varchar(255) DEFAULT NULL,
  `use_at` int DEFAULT NULL,
  `vm_ty` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


INSERT INTO `service_plan` VALUES ('2a26b717-b8b5-489c-8ef1-02bcdc445720','[\"20 GB of messages\", \"20 connections\"]','1GB','[ { \"amount\":{ \"usd\":99.0 }, \"unit\":\"MONTHLY\" }]',NULL,NULL,'Redis service to provide a key-value store',0,'2.1.1+abcdef','dedicated-vm1',0,'54e2de61-de84-4b9c-afc3-88d08aadfcb6',NULL,NULL,1,'small'),('aaaaaaaa-bbbb-cccc-ddddddddddddddddd','[\"20 GB of messages\", \"20 connections\"]','2GB','[ { \"amount\":{ \"usd\":99.0 }, \"unit\":\"MONTHLY\" } ]',NULL,NULL,'Redis service to provide a key-value store',0,'2.1.1+abcdef','dedicated-vm2',0,'54e2de61-de84-4b9c-afc3-88d08aadfcb6',NULL,NULL,1,'medium'),('eeeeeeee-ffff-gggg-dhhhhhhhhhhhhhhhh','[\"20 GB of messages\", \"20 connections\"]','3GB','[ { \"amount\":{ \"usd\":99.0 }, \"unit\":\"MONTHLY\" } ]',NULL,NULL,'Redis service to provide a key-value store',0,'2.1.1+abcdef','dedicated-vm3',0,'54e2de61-de84-4b9c-afc3-88d08aadfcb6',NULL,NULL,1,'small'),('11111111-2222-3333-44444444444444444','[\"20 GB of messages\", \"20 connections\"]','4GB','[ { \"amount\":{ \"usd\":99.0 }, \"unit\":\"MONTHLY\" } ]',NULL,NULL,'Redis service to provide a key-value store',0,'2.1.1+abcdef','dedicated-vm4',0,'54e2de61-de84-4b9c-afc3-88d08aadfcb6',NULL,NULL,1,'medium');
/*!40000 ALTER TABLE `service_plan` ENABLE KEYS */;
UNLOCK TABLES;


DROP TABLE IF EXISTS `service_use_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_use_info` (
  `id` bigint NOT NULL,
  `begin_de` datetime DEFAULT NULL,
  `end_de` datetime DEFAULT NULL,
  `rntfee` int DEFAULT NULL,
  `svc_instn_id` varchar(255) DEFAULT NULL,
  `svc_plan_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

