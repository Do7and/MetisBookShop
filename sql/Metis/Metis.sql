/*
 Source Server         : 本地
 Source Server Type    : MySQL
 Source Server Version : 8.0.23
 Source Host           : localhost:3306
 Source Schema         : Metis

 Target Server Type    : MySQL
 Target Server Version :8.0.23

*/


/*create database Metis*/
DROP DATABASE IF EXISTS `Metis`;
CREATE DATABASE IF NOT EXISTS `Metis` DEFAULT CHARACTER SET utf8;
USE `Metis`;

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

/*create table structure for Metis*/

-- ----------------------------
-- Table structure for creator
-- ----------------------------
DROP TABLE IF EXISTS `creator`;

CREATE TABLE `creator`(
`ID`  INT PRIMARY KEY NOT NULL UNIQUE COMMENT'作/译者编号',
`Name` VARCHAR(50) NOT NULL COMMENT'作/译者姓名',
`Nationality` VARCHAR(20) DEFAULT'未知' COMMENT'作/译者国籍',
`Birthday` DATE DEFAULT NULL COMMENT'作/译者出生日期',
`Deathday` DATE DEFAULT NULL COMMENT'作/译者死亡日期',
`Introduction` TEXT COMMENT'作/译者简介',
`Foreign_name` VARCHAR(50) DEFAULT NULL COMMENT'作/译者外文姓名',
KEY `creator_name` (`Name`)
);

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;

CREATE TABLE `category`(
`Subclass` VARCHAR(20) PRIMARY KEY NOT NULL UNIQUE COMMENT'子类',
`Class`  VARCHAR(20) NOT NULL COMMENT'大类');

-- ----------------------------
-- Table structure for press
-- ----------------------------
DROP TABLE IF EXISTS `press`;

CREATE TABLE `press`(
`PressID` MEDIUMINT NOT NULL UNIQUE PRIMARY KEY COMMENT'出版社编号',
`PressName` VARCHAR(20) NOT NULL COMMENT'出版社名',
`Contact` VARCHAR(50) NOT NULL COMMENT'联系人',
`Tel` VARCHAR(20) NOT NULL COMMENT'联系电话',
`Address` VARCHAR(50) COMMENT'出版社地址');

-- ----------------------------
-- Table structure for book
-- ----------------------------
DROP TABLE IF EXISTS `book`;

CREATE TABLE `book`(
`ISBN` VARCHAR(20) PRIMARY KEY NOT NULL UNIQUE COMMENT'书号',
`Name` VARCHAR(50) NOT NULL COMMENT'书名',
`Author` INT NOT NULL COMMENT'作者ID',
`Translater` VARCHAR(50) DEFAULT NULL COMMENT'译者姓名',
`Press` MEDIUMINT NOT NULL COMMENT'出版社编号',
`PressTime` DATE COMMENT'出版时间',
`Picture` BLOB COMMENT'封面图片',
`Subclass` VARCHAR(20) NOT NULL COMMENT'子类',
`Stock` INT NOT NULL DEFAULT 0 COMMENT'库存余量',  
`TotalSales` INT NOT NULL DEFAULT 0 COMMENT'累计已售',
`Score` FLOAT(2,1) DEFAULT NULL COMMENT'评分',
`Introduction` TEXT COMMENT'书籍简介',
`Cost` DECIMAL(7,2) NOT NULL COMMENT'进货价',
CONSTRAINT `FK_book_author_to_creator` FOREIGN KEY (`Author`) REFERENCES `creator` (`ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT `FK_book_press_to_press` FOREIGN KEY (`Press`) REFERENCES `press` (`PressID`) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT `FK_book_class_to_category` FOREIGN KEY (`Subclass`) REFERENCES `category` (`Subclass`) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;

CREATE TABLE `user`(
`ID` INT PRIMARY KEY AUTO_INCREMENT COMMENT'用户编号',
`state` ENUM('初级','中级','高级') NOT NULL COMMENT'会员状态',
`Name` VARCHAR(50) NOT NULL COMMENT'用户姓名',
`Address` VARCHAR(50) COMMENT'收货地址',
`Telephone` VARCHAR(20) NOT NULL UNIQUE COMMENT'联系电话',
`email` VARCHAR(30) NOT NULL COMMENT'用户邮箱',
`Credit` SMALLINT NOT NULL DEFAULT 0 COMMENT'用户积分',
`Password` VARCHAR(20) NOT NULL COMMENT'密码'
) AUTO_INCREMENT=100000;

-- ---------------------------------
-- Table structure for shopping_cart
-- ---------------------------------
DROP TABLE IF EXISTS `shopping_cart`;

CREATE TABLE `shopping_cart`(
`ID` INT NOT NULL COMMENT'用户编号',
`ISBN` VARCHAR(20) NOT NULL COMMENT'书号',
`Number` TINYINT NOT NULL COMMENT'数量',
PRIMARY KEY(`ID`,`ISBN`),
CONSTRAINT `FK_shopping_cart_ID_to_user` FOREIGN KEY (`ID`) REFERENCES `user` (`ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT `FK_shopping_cart_ISBN_to_book` FOREIGN KEY (`ISBN`) REFERENCES `book` (`ISBN`) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ----------------------------
-- Table structure for review
-- ----------------------------
DROP TABLE IF EXISTS `review`;

CREATE TABLE `review`(
`ID` INT NOT NULL COMMENT'用户编号',
`ISBN` VARCHAR(20) NOT NULL COMMENT'书号',
`Comment` VARCHAR(50) DEFAULT'该用户未评价。' COMMENT'用户评价',
`Score` ENUM('1','2','3','4','5') COMMENT'评分',
PRIMARY KEY(`ID`,`ISBN`),
CONSTRAINT `FK_review_ID_to_user` FOREIGN KEY (`ID`) REFERENCES `user` (`ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT `FK_review_ISBN_to_book` FOREIGN KEY (`ISBN`) REFERENCES `book` (`ISBN`) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ----------------------------
-- Table structure for staff
-- ----------------------------
DROP TABLE IF EXISTS `staff`;

CREATE TABLE `Staff`(
`ID` TINYINT PRIMARY KEY NOT NULL AUTO_INCREMENT COMMENT'管理人员编号',
`Password` VARCHAR(20) NOT NULL COMMENT'管理员密码',
`Name` VARCHAR(20) NOT NULL COMMENT'管理员姓名'
)AUTO_INCREMENT=1;

-- ----------------------------
-- Table structure for sales
-- ----------------------------
DROP TABLE IF EXISTS `Sales`;

CREATE TABLE `Sales`(
`ISBN` VARCHAR(20) NOT NULL COMMENT'书号',
`Type` ENUM('初级','中级','高级') NOT NULL COMMENT'客户类型',
`Price` DECIMAL(7,2) NOT NULL COMMENT'价格',
PRIMARY KEY(`ISBN`,`Type`),
CONSTRAINT `FK_Sales_ISBN_to_book` FOREIGN KEY (`ISBN`) REFERENCES `book` (`ISBN`) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ----------------------------
-- Table structure for order
-- ----------------------------
 DROP TABLE IF EXISTS `order`;
 
 CREATE TABLE `order`(
 `OrderID` INT PRIMARY KEY NOT NULL COMMENT'订单号',
 `Time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT'下单时间',
 `ISBN` VARCHAR(20) NOT NULL COMMENT'书号',
 `Total` SMALLINT NOT NULL DEFAULT 1 COMMENT'数量',
 `ID` INT NOT NULL COMMENT'下单用户',
 `Status` ENUM('已付款','已收货','退货申请中','已退货') NOT NULL COMMENT'订单状态',
 CONSTRAINT `FK_order_ID_to_user` FOREIGN KEY (`ID`) REFERENCES `user` (`ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
 CONSTRAINT `FK_order_ISBN_to_book` FOREIGN KEY (`ISBN`) REFERENCES `book` (`ISBN`) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ----------------------------
-- Table structure for return
-- ----------------------------
DROP TABLE IF EXISTS `return`;

CREATE TABLE `return`(
`OrderID` INT NOT NULL UNIQUE COMMENT'订单号',
`Return_reason` VARCHAR(50),
`Result` ENUM('是','否','待审核') DEFAULT '待审核' COMMENT'审核通过',
`ISBN` VARCHAR(20) NOT NULL COMMENT'书号',
 PRIMARY KEY(`OrderID`,`ISBN`),
 CONSTRAINT `FK_return_OrderID_to_order` FOREIGN KEY (`OrderID`) REFERENCES `order` (`OrderID`) ON DELETE RESTRICT ON UPDATE CASCADE
);
 
-- -----------------------------------
-- Trigger structure for StockDecrease
-- -----------------------------------
DELIMITER $
CREATE TRIGGER StockDecrease AFTER INSERT ON `order` FOR EACH ROW
BEGIN
DECLARE a INT;
DECLARE amount INT;
DECLARE b INT;
SET a=(SELECT `Total` FROM `order` WHERE `OrderID`= new.orderid);
SET amount=(SELECT `Stock` FROM `book` WHERE `ISBN`=new.ISBN);
SET b=(SELECT `TotalSales` FROM `book` WHERE `ISBN`=new.ISBN);
UPDATE book SET `Stock`=(amount-a),`TotalSales`=(b+a) WHERE `ISBN`=new.ISBN;
END$
DELIMITER ;
/*
当产生新订单时，对图书表的相应图书的库存以及累计销售量进行更新
*/

-- -----------------------------------
-- Trigger structure for StockIncrease
-- -----------------------------------
DELIMITER $
CREATE TRIGGER StockIncrease AFTER UPDATE ON `return` FOR EACH ROW
BEGIN
DECLARE a INT;
DECLARE amount INT;
DECLARE b INT;
SET a=(SELECT `Total` FROM `order` WHERE `OrderID`= new.orderid);
SET amount=(SELECT `Stock` FROM `book` WHERE `ISBN`=new.ISBN);
SET b=(SELECT `TotalSales` FROM `book` WHERE `ISBN`=new.ISBN);
IF (SELECT `Result` FROM `return` WHERE `OrderID`= new.orderid)='是' THEN
UPDATE book SET `Stock`=(amount+a),`TotalSales`=(b-a) WHERE `ISBN`=new.ISBN;
UPDATE `order` SET `status`='已退货' WHERE `OrderID`=new.orderid;
END IF;
END$
DELIMITER ;
/*
当退货审核通过时，对图书的库存以及销售总量进行更新,同时将订单状态更新为“已退货”
*/

-- -----------------------------------
-- Trigger structure for ReturnRequest
-- -----------------------------------
DELIMITER $
CREATE TRIGGER ReturnRequest AFTER INSERT ON `return` FOR EACH ROW
BEGIN
IF (SELECT `Result` FROM `return` WHERE `OrderID`= new.orderid)='待审核' THEN
UPDATE `order` SET `status`='退货申请中' WHERE `OrderID`=new.OrderID;
END IF;
END$
DELIMITER ;
/*
当产生新的退货申请时，将订单状态相应更新为“退货申请中”
*/

-- ---------------------------------
-- Trigger structure for ScoreUpdate
-- ---------------------------------
DELIMITER $
CREATE TRIGGER ScoreUpdate AFTER INSERT ON `review` FOR EACH ROW
BEGIN
DECLARE a FLOAT(2,1);
DECLARE b CHAR(1);
DECLARE c INT;
DECLARE total INT;
SET a=(SELECT `Score` FROM `book` WHERE `ISBN`=new.ISBN);
SET b=new.`Score`;
SET c=(SELECT `TotalSales` FROM `book` WHERE `ISBN`=new.ISBN);
UPDATE `book` SET `Score`=(a*(c-1)+CONVERT(b,SIGNED))/c WHERE `ISBN`=new.ISBN;
END$
DELIMITER ;
/*
当产生新评价时，对相应图书的评分进行更新
*/

-- ---------------------------------
-- Trigger structure for Levelup
-- ---------------------------------
DELIMITER $
CREATE TRIGGER Levelup AFTER UPDATE ON `order` FOR EACH ROW
BEGIN
DECLARE a SMALLINT;
DECLARE b SMALLINT;
IF(SELECT `Status` FROM `order` WHERE orderid=new.orderid)='已收货' THEN
SET a=(SELECT `credit` FROM `user` WHERE `id`=new.id);
SET b=(SELECT `total` FROM `order` WHERE `orderid`=new.orderid);
UPDATE `user` SET `credit`=(a+b) WHERE `id`=new.id;
END IF;
IF(SELECT `state` FROM `user` WHERE `id`=new.id)='初级' AND (a+b)>=50 THEN
UPDATE `user` SET `state`='中级' WHERE `id`=new.id;
END IF;
IF(SELECT `state` FROM `user` WHERE `id`=new.id)='中级' AND (a+b)>=150 THEN
UPDATE `user` SET `state`='高级' WHERE `id`=new.id;
END IF;
END$
DELIMITER ;
/*
当完成新订单时，更新用户积分；如果积分达到一定标准，更新会员等级
*/