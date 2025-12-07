-- =========================================================
-- CRIAÇÃO DO BANCO
-- =========================================================

CREATE DATABASE IF NOT EXISTS onlinestoredb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE onlinestoredb;

-- =========================================================
-- CONFIGURAÇÃO INICIAL
-- =========================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

-- =========================================================
-- PROCEDURES
-- =========================================================

DELIMITER $$

CREATE PROCEDURE CompanyCustomerByCustomerId (IN pCustomerId INT)
BEGIN
    SELECT *
    FROM CompanyCustomer
    WHERE CustomerId = pCustomerId;
END$$

CREATE PROCEDURE CompanyCustomerInsert (
    IN pCustomerId INT,
    IN pCorporateName VARCHAR(200),
    IN pTradeName VARCHAR(200),
    IN pCnpjNumber VARCHAR(20),
    IN pStateRegistration VARCHAR(50),
    OUT pCompanyCustomerId INT
)
BEGIN
    INSERT INTO CompanyCustomer (
        CustomerId, CorporateName, TradeName, CnpjNumber,
        StateRegistration, CreatedAt
    )
    VALUES (
        pCustomerId, pCorporateName, pTradeName, pCnpjNumber,
        pStateRegistration, NOW()
    );

    SET pCompanyCustomerId = LAST_INSERT_ID();
END$$

CREATE PROCEDURE CustomerByEmail (IN pEmailAddress VARCHAR(200))
BEGIN
    SELECT *
    FROM Customer
    WHERE EmailAddress = pEmailAddress;
END$$

CREATE PROCEDURE CustomerInsert (
    IN pCustomerTypeId INT,
    IN pFullName VARCHAR(200),
    IN pEmailAddress VARCHAR(200),
    IN pPasswordHash VARCHAR(256),
    IN pCpfNumber VARCHAR(20),
    IN pIsActive TINYINT,
    OUT pCustomerId INT
)
BEGIN
    INSERT INTO Customer (
        CustomerTypeId, FullName, EmailAddress,
        PasswordHash, CpfNumber, IsActive, CreatedAt
    )
    VALUES (
        pCustomerTypeId, pFullName, pEmailAddress,
        pPasswordHash, pCpfNumber, pIsActive, NOW()
    );

    SET pCustomerId = LAST_INSERT_ID();
END$$

CREATE PROCEDURE CustomerList ()
BEGIN
    SELECT * FROM Customer;
END$$

CREATE PROCEDURE CustomerTypeList ()
BEGIN
    SELECT * FROM CustomerType;
END$$

CREATE PROCEDURE OrderInsert (
    IN pCustomerId INT,
    IN pSourceCartId INT,
    IN pStatus INT,
    IN pTotalAmount DECIMAL(10,2),
    OUT pOrderId INT
)
BEGIN
    INSERT INTO Orders (
        CustomerId, SourceCartId, CreatedAt, Status, TotalAmount
    )
    VALUES (
        pCustomerId, pSourceCartId, NOW(), pStatus, pTotalAmount
    );

    SET pOrderId = LAST_INSERT_ID();
END$$

CREATE PROCEDURE PaymentInsert (
    IN pOrderId INT,
    IN pAmount DECIMAL(10,2),
    IN pMethod VARCHAR(50),
    IN pStatus INT,
    OUT pPaymentId INT
)
BEGIN
    INSERT INTO Payments (
        OrderId, Amount, Method, Status, CreatedAt
    )
    VALUES (
        pOrderId, pAmount, pMethod, pStatus, NOW()
    );

    SET pPaymentId = LAST_INSERT_ID();
END$$

DELIMITER ;

-- =========================================================
-- TABELAS
-- =========================================================

CREATE TABLE CustomerType (
  CustomerTypeId INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  TypeName VARCHAR(50) NOT NULL UNIQUE,
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Customer (
  CustomerId INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  CustomerTypeId INT UNSIGNED NOT NULL,
  FullName VARCHAR(150) NOT NULL,
  EmailAddress VARCHAR(150) NOT NULL UNIQUE,
  PasswordHash VARCHAR(255) NOT NULL,
  CpfNumber VARCHAR(14),
  IsActive TINYINT NOT NULL DEFAULT 1,
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT FK_Customer_CustomerType
    FOREIGN KEY (CustomerTypeId)
    REFERENCES CustomerType (CustomerTypeId)
) ENGINE=InnoDB;

CREATE TABLE CompanyCustomer (
  CompanyCustomerId INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  CustomerId INT UNSIGNED NOT NULL UNIQUE,
  CorporateName VARCHAR(200) NOT NULL,
  TradeName VARCHAR(200),
  CnpjNumber VARCHAR(18) NOT NULL UNIQUE,
  StateRegistration VARCHAR(50),
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT FK_CompanyCustomer_Customer
    FOREIGN KEY (CustomerId)
    REFERENCES Customer (CustomerId)
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Product (
  ProductId INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  ProductName VARCHAR(200) NOT NULL,
  SkuCode VARCHAR(50) NOT NULL UNIQUE,
  BasePrice DECIMAL(18,2) NOT NULL,
  IsActive TINYINT NOT NULL DEFAULT 1,
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE ShoppingCart (
  CartId INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  CustomerId INT UNSIGNED,
  VisitorToken VARCHAR(100) UNIQUE,
  CartStatus VARCHAR(20) DEFAULT 'Active',
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  ExpiresAt DATETIME DEFAULT NULL,
  CONSTRAINT FK_ShoppingCart_Customer
    FOREIGN KEY (CustomerId)
    REFERENCES Customer (CustomerId)
    ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE Orders (
  OrderId INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  CustomerId INT UNSIGNED NOT NULL,
  SourceCartId INT UNSIGNED,
  CreatedAt DATETIME NOT NULL,
  Status INT NOT NULL,
  TotalAmount DECIMAL(10,2) NOT NULL,
  CONSTRAINT FK_Orders_Customers
    FOREIGN KEY (CustomerId)
    REFERENCES Customer (CustomerId)
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Payments (
  PaymentId INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  OrderId INT UNSIGNED NOT NULL,
  Amount DECIMAL(10,2) NOT NULL,
  Method VARCHAR(50) NOT NULL,
  Status INT NOT NULL,
  TransactionCode VARCHAR(200),
  CreatedAt DATETIME NOT NULL,
  PaidAt DATETIME,
  CONSTRAINT FK_Payments_Orders
    FOREIGN KEY (OrderId)
    REFERENCES Orders (OrderId)
    ON DELETE CASCADE
) ENGINE=InnoDB;

COMMIT;
