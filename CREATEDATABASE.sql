-- Opcional: cria o banco e seleciona
CREATE DATABASE IF NOT EXISTS OnlineStore;
USE OnlineStore;

-- Tabela de tipos de cliente (Individual, Company)
CREATE TABLE CustomerType (
    CustomerTypeId   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    TypeName         VARCHAR(50) NOT NULL,  -- 'Individual', 'Company'

    CreatedAt        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt        DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (CustomerTypeId),
    UNIQUE KEY UQ_CustomerType_TypeName (TypeName)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- Tabela de clientes (somente PF e PJ; Visitante não entra aqui)
CREATE TABLE Customer (
    CustomerId       INT UNSIGNED NOT NULL AUTO_INCREMENT,
    CustomerTypeId   INT UNSIGNED NOT NULL,

    FullName         VARCHAR(150) NOT NULL,
    EmailAddress     VARCHAR(150) NOT NULL,
    PasswordHash     VARCHAR(255) NOT NULL,

    CpfNumber        VARCHAR(14) NULL,      -- apenas PF
    IsActive         TINYINT(1) NOT NULL DEFAULT 1,

    CreatedAt        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt        DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (CustomerId),
    UNIQUE KEY UQ_Customer_Email (EmailAddress),

    CONSTRAINT FK_Customer_CustomerType
        FOREIGN KEY (CustomerTypeId)
        REFERENCES CustomerType (CustomerTypeId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- Dados de empresa para clientes PJ
CREATE TABLE CompanyCustomer (
    CompanyCustomerId  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    CustomerId         INT UNSIGNED NOT NULL,

    CorporateName      VARCHAR(200) NOT NULL,
    TradeName          VARCHAR(200) NULL,
    CnpjNumber         VARCHAR(18) NOT NULL,
    StateRegistration  VARCHAR(50) NULL,

    CreatedAt          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt          DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (CompanyCustomerId),

    UNIQUE KEY UQ_CompanyCustomer_Customer (CustomerId),
    UNIQUE KEY UQ_CompanyCustomer_Cnpj (CnpjNumber),

    CONSTRAINT FK_CompanyCustomer_Customer
        FOREIGN KEY (CustomerId)
        REFERENCES Customer (CustomerId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- Produtos básicos
CREATE TABLE Product (
    ProductId      INT UNSIGNED NOT NULL AUTO_INCREMENT,

    ProductName    VARCHAR(200) NOT NULL,
    SkuCode        VARCHAR(50) NOT NULL,
    BasePrice      DECIMAL(18, 2) NOT NULL,  -- preço padrão (varejo)
    IsActive       TINYINT(1) NOT NULL DEFAULT 1,

    CreatedAt      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt      DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (ProductId),
    UNIQUE KEY UQ_Product_SkuCode (SkuCode)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- Regras de preço (varejo / atacado por faixa de quantidade)
CREATE TABLE ProductPrice (
    ProductPriceId  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ProductId       INT UNSIGNED NOT NULL,

    PriceType       VARCHAR(20) NOT NULL,   -- 'Retail' ou 'Wholesale'
    MinQuantity     INT UNSIGNED NOT NULL,
    MaxQuantity     INT UNSIGNED NULL,      -- null = sem limite superior
    UnitPrice       DECIMAL(18, 2) NOT NULL,

    CreatedAt       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt       DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (ProductPriceId),

    KEY IX_ProductPrice_Product (ProductId),

    CONSTRAINT FK_ProductPrice_Product
        FOREIGN KEY (ProductId)
        REFERENCES Product (ProductId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- Carrinho (para Visitante e para Cliente logado)
CREATE TABLE ShoppingCart (
    CartId         INT UNSIGNED NOT NULL AUTO_INCREMENT,

    CustomerId     INT UNSIGNED NULL,        -- null = visitante
    VisitorToken   VARCHAR(100) NULL,        -- token salvo em cookie/localStorage

    CartStatus     VARCHAR(20) NOT NULL DEFAULT 'Active', -- 'Active', 'Expired'
    CreatedAt      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ExpiresAt      DATETIME NULL,

    PRIMARY KEY (CartId),

    UNIQUE KEY UQ_ShoppingCart_VisitorToken (VisitorToken),
    KEY IX_ShoppingCart_Customer (CustomerId),

    CONSTRAINT FK_ShoppingCart_Customer
        FOREIGN KEY (CustomerId)
        REFERENCES Customer (CustomerId)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- Itens do carrinho
CREATE TABLE CartItem (
    CartItemId     INT UNSIGNED NOT NULL AUTO_INCREMENT,
    CartId         INT UNSIGNED NOT NULL,
    ProductId      INT UNSIGNED NOT NULL,

    Quantity       INT UNSIGNED NOT NULL,
    UnitPrice      DECIMAL(18, 2) NOT NULL, -- preço aplicado (varejo ou atacado) no momento
    CreatedAt      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (CartItemId),

    KEY IX_CartItem_Cart (CartId),
    KEY IX_CartItem_Product (ProductId),

    CONSTRAINT FK_CartItem_ShoppingCart
        FOREIGN KEY (CartId)
        REFERENCES ShoppingCart (CartId)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_CartItem_Product
        FOREIGN KEY (ProductId)
        REFERENCES Product (ProductId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
