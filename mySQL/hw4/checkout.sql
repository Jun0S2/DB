-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema checkout
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema checkout
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `checkout` DEFAULT CHARACTER SET utf8 ;
USE `checkout` ;

-- -----------------------------------------------------
-- Table `checkout`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `checkout`.`customer` ;

CREATE TABLE IF NOT EXISTS `checkout`.`customer` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `customer_name` VARCHAR(45) NOT NULL,
  `customer_address` VARCHAR(45) NOT NULL,
  `customer_phone1` INT(11) NOT NULL,
  `customer_phone2` INT(11) NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `checkout`.`order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `checkout`.`order` ;

CREATE TABLE IF NOT EXISTS `checkout`.`order` (
  `order_id` INT NOT NULL,
  `order_amount($)` INT NULL AUTO_INCREMENT,
  `order_quantity` INT NULL,
  `payment_status` TINYINT NOT NULL,
  `customer_id` INT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `order_user_id_fk_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `order_customer_id_fk`
    FOREIGN KEY (`customer_id`)
    REFERENCES `checkout`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `checkout`.`payment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `checkout`.`payment` ;

CREATE TABLE IF NOT EXISTS `checkout`.`payment` (
  `payment_status` TINYINT NOT NULL,
  `shipment_status` TINYINT NOT NULL,
  `order_id` INT NOT NULL,
  PRIMARY KEY (`payment_status`, `order_id`),
  INDEX `payment_order_id_fk_idx` (`order_id` ASC) VISIBLE,
  CONSTRAINT `payment_order_id_fk`
    FOREIGN KEY (`order_id`)
    REFERENCES `checkout`.`order` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `checkout`.`product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `checkout`.`product` ;

CREATE TABLE IF NOT EXISTS `checkout`.`product` (
  `product_id` INT NOT NULL,
  `product_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`product_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `checkout`.`order_detail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `checkout`.`order_detail` ;

CREATE TABLE IF NOT EXISTS `checkout`.`order_detail` (
  `item_price` INT NOT NULL,
  `item_quantity` VARCHAR(45) NULL,
  `product_id` INT NOT NULL,
  `order_id` INT NOT NULL,
  PRIMARY KEY (`product_id`, `order_id`),
  INDEX `order_detail_order_id fk_idx` (`order_id` ASC) VISIBLE,
  CONSTRAINT `order_detail_product_id_fk`
    FOREIGN KEY (`product_id`)
    REFERENCES `checkout`.`product` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `order_detail_order_id fk`
    FOREIGN KEY (`order_id`)
    REFERENCES `checkout`.`order` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
