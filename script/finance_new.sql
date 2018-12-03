-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: 2018-12-02 19:54:38
-- 服务器版本： 5.7.21-0ubuntu0.16.04.1
-- PHP Version: 7.0.28-0ubuntu0.16.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `finance_new`
--

-- --------------------------------------------------------

--
-- 表的结构 `finance_order_down_payment`
--

CREATE TABLE `finance_order_down_payment` (
  `id` int(11) NOT NULL COMMENT '本记录id',
  `apply_id` varchar(32) NOT NULL DEFAULT '' COMMENT 'APPLY_ID',
  `receivable_fee` int(10) NOT NULL DEFAULT '0' COMMENT '应收首期款',
  `paid_fee` int(10) NOT NULL DEFAULT '0' COMMENT '实际收首期款',
  `pay_fee_at` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '订单首期款收齐时间',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单首期款收取';

-- --------------------------------------------------------

--
-- 表的结构 `finance_user`
--

CREATE TABLE `finance_user` (
  `id` int(11) NOT NULL COMMENT 'ID',
  `user_name` varchar(64) NOT NULL DEFAULT '' COMMENT '用户姓名',
  `id_card_encrypt` varchar(128) NOT NULL DEFAULT '' COMMENT '加密身份证号',
  `user_phone_id` int(11) NOT NULL DEFAULT '0' COMMENT '手机号ID',
  `wechat_open_id` varchar(50) NOT NULL DEFAULT '' COMMENT '微信open_id',
  `wechat_bound_at` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '微信绑定时间',
  `source_code` varchar(32) NOT NULL DEFAULT 'guazi_c2c' COMMENT '业务线来源，只做第一次的保存，guazi_c2c: 二手车, guazi_new_car: 新车',
  `id_checked` tinyint(1) NOT NULL DEFAULT '0' COMMENT '验证数据：0未验证，1:实名验证通过,2:实名验证不通过',
  `user_center_id` bigint(20) UNSIGNED NOT NULL DEFAULT '0' COMMENT '集团用户中心用户id',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表';

-- --------------------------------------------------------

--
-- 表的结构 `user_apply_credit`
--

CREATE TABLE `user_apply_credit` (
  `id` int(11) NOT NULL COMMENT 'ID',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '申请单号，这个单号关联着整个金融业务系统',
  `credit_org` tinyint(4) NOT NULL DEFAULT '0' COMMENT '授信机构，0:瓜子，1:微众',
  `credit_result` tinyint(4) NOT NULL DEFAULT '0' COMMENT '授信状态，0:未知，1:通过 ，2:拒绝，3:失败,需要重试',
  `result_code` int(11) NOT NULL DEFAULT '0' COMMENT '申请返回的数据信息编码',
  `credit_limit` bigint(20) NOT NULL DEFAULT '0' COMMENT '授信额度',
  `credit_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '授信时间',
  `util_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '授信截止时间',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户预审授信表';

-- --------------------------------------------------------

--
-- 表的结构 `user_audit_info`
--

CREATE TABLE `user_audit_info` (
  `id` int(11) NOT NULL COMMENT 'ID',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT 'order apply id',
  `custom_level` varchar(32) NOT NULL DEFAULT '' COMMENT '用户等级分类',
  `min_downpayment_ratio` int(8) NOT NULL DEFAULT '0' COMMENT '最低首付比',
  `final_downpayment_ratio` int(11) NOT NULL DEFAULT '0' COMMENT '用户最终做的首付比，可以是信审输出、可以是客户选择',
  `can_change_price` int(1) NOT NULL DEFAULT '0' COMMENT '是否可以',
  `credit_limit` bigint(20) NOT NULL DEFAULT '0' COMMENT '授信额度',
  `used_limit` bigint(20) NOT NULL DEFAULT '0' COMMENT '已使用的额度',
  `credit_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '授信时间',
  `util_time` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '授信截止时间',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户信审授信信息表';

-- --------------------------------------------------------

--
-- 表的结构 `user_bank_card`
--

CREATE TABLE `user_bank_card` (
  `id` int(11) NOT NULL COMMENT 'ID',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `bank_name` varchar(32) NOT NULL DEFAULT '' COMMENT '银行名称',
  `bank_code` varchar(16) NOT NULL DEFAULT '' COMMENT '银行代码',
  `card_number_encrypt` varchar(128) NOT NULL DEFAULT '' COMMENT '加密的卡号',
  `card_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡片类型：0: 借记卡，1：信用卡 2: 准借记卡',
  `reserve_phone_id` int(11) NOT NULL DEFAULT '0' COMMENT '预留手机号ID',
  `branch` varchar(256) NOT NULL DEFAULT '' COMMENT '支行',
  `province_id` int(11) NOT NULL DEFAULT '0' COMMENT '省份',
  `city_id` int(11) NOT NULL DEFAULT '0' COMMENT '城市',
  `checked` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0:未验证，1:验4通过，2:验3通过，3验证未过',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户银行卡';

-- --------------------------------------------------------

--
-- 表的结构 `user_contact`
--

CREATE TABLE `user_contact` (
  `id` int(11) NOT NULL COMMENT 'ID',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `contact_name` varchar(32) NOT NULL DEFAULT '' COMMENT '联系人名称',
  `phone_encrypt` varchar(128) NOT NULL DEFAULT '' COMMENT '联系人手机',
  `relationship` tinyint(4) NOT NULL DEFAULT '0' COMMENT '关系1:配偶，2:父母，3:兄弟，4:其他，5:朋友，6:同事，7:子女，8:姐妹，9:同学，10:亲属',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户联系人：一个用户会有多个联系人';

-- --------------------------------------------------------

--
-- 表的结构 `user_extend`
--

CREATE TABLE `user_extend` (
  `id` int(11) NOT NULL COMMENT 'ID',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `married` tinyint(4) NOT NULL DEFAULT '99' COMMENT '婚姻状态1:未婚，2:已婚，3:离异，4:丧偶，99:未知',
  `house` tinyint(4) NOT NULL DEFAULT '99' COMMENT '住房情况1:租房，2:集体宿舍，3:与亲戚合住，4:有房有贷，5:有房无贷，99:未知',
  `house_type` tinyint(4) NOT NULL DEFAULT '99' COMMENT '住房类型1:商品房，2:自建房，3:保障房，4:小产权房，5:其他，99:未知',
  `education` tinyint(4) NOT NULL DEFAULT '99' COMMENT '学历1:博士及以上，2:硕士，3:本科，4:大专，5:高中或者中专，6:初中及一下，99:未知',
  `job_type` tinyint(4) NOT NULL DEFAULT '99' COMMENT '职业身份1:事业单位或者公务员，2:企业职工，3:企业主，4:个体户，5:无固定职业，99:未知',
  `insurance` tinyint(4) NOT NULL DEFAULT '99' COMMENT '社保：1:有本地社保，2:无本地社保，99：未知',
  `society_fund` tinyint(4) NOT NULL DEFAULT '99' COMMENT '公积金，1:有公积金，2:无公积金，99:未知',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='一个用户有一个额外数据';

-- --------------------------------------------------------

--
-- 表的结构 `user_from`
--

CREATE TABLE `user_from` (
  `id` int(11) NOT NULL COMMENT 'ID',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `come_from` varchar(128) NOT NULL DEFAULT '' COMMENT '用户第一次来源',
  `cainfo` varchar(512) NOT NULL DEFAULT '' COMMENT '来源',
  `guid` varchar(32) NOT NULL DEFAULT '' COMMENT 'guid',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户来源表';

-- --------------------------------------------------------

--
-- 表的结构 `user_image`
--

CREATE TABLE `user_image` (
  `id` int(11) NOT NULL COMMENT 'ID',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `download_domain` varchar(128) NOT NULL DEFAULT '' COMMENT '下载domain',
  `image_url` varchar(512) NOT NULL DEFAULT '' COMMENT '原图',
  `image_type_id` int(11) NOT NULL DEFAULT '0' COMMENT '影像类型',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否隐藏图片，主要用于图片虚拟删除 0:正常，1:删除',
  `deleted_at` datetime NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '虚拟删除图片时间',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='影像材料';

-- --------------------------------------------------------

--
-- 表的结构 `user_living`
--

CREATE TABLE `user_living` (
  `id` int(11) NOT NULL COMMENT 'ID',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `address` varchar(256) NOT NULL DEFAULT '' COMMENT '地址',
  `province_id` int(11) NOT NULL DEFAULT '0' COMMENT '省份',
  `city_id` int(11) NOT NULL DEFAULT '0' COMMENT '城市',
  `district_id` int(11) NOT NULL DEFAULT '0' COMMENT '区县',
  `id5_address` varchar(256) NOT NULL DEFAULT '' COMMENT '身份证地址',
  `id5_province_id` int(11) NOT NULL DEFAULT '0' COMMENT '身份证省份',
  `id5_city_id` int(11) NOT NULL DEFAULT '0' COMMENT '身份证城市',
  `id5_district_id` int(11) NOT NULL DEFAULT '0' COMMENT '身份证区县',
  `id5_begin_date` date NOT NULL DEFAULT '1970-01-01' COMMENT '身份证生效时间',
  `id5_end_date` date NOT NULL DEFAULT '1970-01-01' COMMENT '身份证失效时间',
  `input_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '收集渠道0:客户，1:金专，2:销售',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户居住信息：一个用户只能有一个或者没有居住信息';

-- --------------------------------------------------------

--
-- 表的结构 `user_phone`
--

CREATE TABLE `user_phone` (
  `id` int(11) NOT NULL COMMENT 'ID',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `phone_encrypt` varchar(128) NOT NULL DEFAULT '' COMMENT '加密手机号',
  `phone_checked` tinyint(4) NOT NULL DEFAULT '0' COMMENT '验证数据：0未验证，1:实名验证通过,2:实名验证不通过',
  `input_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '收集渠道0:客户，1:金专，2:销售',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户手机号表';

-- --------------------------------------------------------

--
-- 表的结构 `user_work`
--

CREATE TABLE `user_work` (
  `id` int(11) NOT NULL COMMENT 'ID',
  `company_name` varchar(128) NOT NULL DEFAULT '' COMMENT '工作单位',
  `company_address` varchar(256) NOT NULL DEFAULT '' COMMENT '单位地址',
  `company_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '单位类型：1:企业公司,2:事业单位,3:公务员,4:自由职业,5:其他',
  `province_id` int(11) NOT NULL DEFAULT '0' COMMENT '省份',
  `city_id` int(11) NOT NULL DEFAULT '0' COMMENT '城市',
  `district_id` int(11) NOT NULL DEFAULT '0' COMMENT '区县',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `input_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '收集渠道0:客户，1:金专，2:销售',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户工作信息：一个用户可能有多条工作单位';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `finance_order_down_payment`
--
ALTER TABLE `finance_order_down_payment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_idx_order_id` (`apply_id`);

--
-- Indexes for table `finance_user`
--
ALTER TABLE `finance_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_idx_id_card_encrypt` (`id_card_encrypt`,`user_name`,`user_phone_id`),
  ADD KEY `idx_user_center_id` (`user_center_id`);

--
-- Indexes for table `user_apply_credit`
--
ALTER TABLE `user_apply_credit`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_idx_apply_id_credit_org` (`user_id`,`credit_org`);

--
-- Indexes for table `user_audit_info`
--
ALTER TABLE `user_audit_info`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_bank_card`
--
ALTER TABLE `user_bank_card`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_idx_card_number_encrypt` (`card_number_encrypt`),
  ADD KEY `idx_bank_card_user_id` (`user_id`);

--
-- Indexes for table `user_contact`
--
ALTER TABLE `user_contact`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_idx_user_id_name` (`user_id`,`contact_name`);

--
-- Indexes for table `user_extend`
--
ALTER TABLE `user_extend`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_idx_user_id` (`user_id`);

--
-- Indexes for table `user_from`
--
ALTER TABLE `user_from`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_idx_user_id` (`user_id`);

--
-- Indexes for table `user_image`
--
ALTER TABLE `user_image`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_img_user_id` (`user_id`);

--
-- Indexes for table `user_living`
--
ALTER TABLE `user_living`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_idx_living_user_id` (`user_id`);

--
-- Indexes for table `user_phone`
--
ALTER TABLE `user_phone`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_idx_phone_encrypt` (`phone_encrypt`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- Indexes for table `user_work`
--
ALTER TABLE `user_work`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_idx_company_name` (`user_id`,`company_name`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `finance_order_down_payment`
--
ALTER TABLE `finance_order_down_payment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '本记录id';

--
-- 使用表AUTO_INCREMENT `finance_user`
--
ALTER TABLE `finance_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID';

--
-- 使用表AUTO_INCREMENT `user_apply_credit`
--
ALTER TABLE `user_apply_credit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID';

--
-- 使用表AUTO_INCREMENT `user_audit_info`
--
ALTER TABLE `user_audit_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID';

--
-- 使用表AUTO_INCREMENT `user_bank_card`
--
ALTER TABLE `user_bank_card`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID';

--
-- 使用表AUTO_INCREMENT `user_contact`
--
ALTER TABLE `user_contact`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID';

--
-- 使用表AUTO_INCREMENT `user_extend`
--
ALTER TABLE `user_extend`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID';

--
-- 使用表AUTO_INCREMENT `user_from`
--
ALTER TABLE `user_from`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID';

--
-- 使用表AUTO_INCREMENT `user_image`
--
ALTER TABLE `user_image`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID';

--
-- 使用表AUTO_INCREMENT `user_living`
--
ALTER TABLE `user_living`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID';

--
-- 使用表AUTO_INCREMENT `user_phone`
--
ALTER TABLE `user_phone`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID';

--
-- 使用表AUTO_INCREMENT `user_work`
--
ALTER TABLE `user_work`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID';
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
