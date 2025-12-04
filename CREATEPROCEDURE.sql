USE OnlineStore;

DELIMITER $$

-- ==========================
-- CUSTOMER TYPE
-- ==========================

CREATE PROCEDURE Proc_CustomerType_Insert (
    IN pTypeName VARCHAR(50)
)
BEGIN
    INSERT INTO CustomerType (TypeName)
    VALUES (pTypeName);

    SELECT LAST_INSERT_ID() AS NewId;
END $$

CREATE PROCEDURE Proc_CustomerType_Update (
    IN pCustomerTypeId INT UNSIGNED,
    IN pTypeName       VARCHAR(50)
)
BEGIN
    UPDATE CustomerType
    SET TypeName = pTypeName,
        UpdatedAt = NOW()
    WHERE CustomerTypeId = pCustomerTypeId;
END $$

CREATE PROCEDURE Proc_CustomerType_ById (
    IN pCustomerTypeId INT UNSIGNED
)
BEGIN
    SELECT *
    FROM CustomerType
    WHERE CustomerTypeId = pCustomerTypeId;
END $$

CREATE PROCEDURE Proc_CustomerType_List ()
BEGIN
    SELECT *
    FROM CustomerType;
END $$

CREATE PROCEDURE Proc_CustomerType_Delete (
    IN pCustomerTypeId INT UNSIGNED
)
BEGIN
    DELETE FROM CustomerType
    WHERE CustomerTypeId = pCustomerTypeId;
END $$



-- ==========================
-- CUSTOMER
-- ==========================

CREATE PROCEDURE Proc_Customer_Insert (
    IN pCustomerTypeId INT UNSIGNED,
    IN pFullName       VARCHAR(150),
    IN pEmailAddress   VARCHAR(150),
    IN pPasswordHash   VARCHAR(255),
    IN pCpfNumber      VARCHAR(14),
    IN pIsActive       TINYINT
)
BEGIN
    INSERT INTO Customer (
        CustomerTypeId,
        FullName,
        EmailAddress,
        PasswordHash,
        CpfNumber,
        IsActive
    )
    VALUES (
        pCustomerTypeId,
        pFullName,
        pEmailAddress,
        pPasswordHash,
        pCpfNumber,
        pIsActive
    );

    SELECT LAST_INSERT_ID() AS NewId;
END $$

CREATE PROCEDURE Proc_Customer_Update (
    IN pCustomerId     INT UNSIGNED,
    IN pCustomerTypeId INT UNSIGNED,
    IN pFullName       VARCHAR(150),
    IN pEmailAddress   VARCHAR(150),
    IN pPasswordHash   VARCHAR(255),
    IN pCpfNumber      VARCHAR(14),
    IN pIsActive       TINYINT
)
BEGIN
    UPDATE Customer
    SET CustomerTypeId = pCustomerTypeId,
        FullName       = pFullName,
        EmailAddress   = pEmailAddress,
        PasswordHash   = pPasswordHash,
        CpfNumber      = pCpfNumber,
        IsActive       = pIsActive,
        UpdatedAt      = NOW()
    WHERE CustomerId = pCustomerId;
END $$

CREATE PROCEDURE Proc_Customer_ById (
    IN pCustomerId INT UNSIGNED
)
BEGIN
    SELECT *
    FROM Customer
    WHERE CustomerId = pCustomerId;
END $$

CREATE PROCEDURE Proc_Customer_List ()
BEGIN
    SELECT *
    FROM Customer;
END $$

CREATE PROCEDURE Proc_Customer_Delete (
    IN pCustomerId INT UNSIGNED
)
BEGIN
    DELETE FROM Customer
    WHERE CustomerId = pCustomerId;
END $$



-- ==========================
-- COMPANY CUSTOMER (PJ)
-- ==========================

CREATE PROCEDURE Proc_CompanyCustomer_Insert (
    IN pCustomerId        INT UNSIGNED,
    IN pCorporateName     VARCHAR(200),
    IN pTradeName         VARCHAR(200),
    IN pCnpjNumber        VARCHAR(18),
    IN pStateRegistration VARCHAR(50)
)
BEGIN
    INSERT INTO CompanyCustomer (
        CustomerId,
        CorporateName,
        TradeName,
        CnpjNumber,
        StateRegistration
    )
    VALUES (
        pCustomerId,
        pCorporateName,
        pTradeName,
        pCnpjNumber,
        pStateRegistration
    );

    SELECT LAST_INSERT_ID() AS NewId;
END $$

CREATE PROCEDURE Proc_CompanyCustomer_Update (
    IN pCompanyCustomerId INT UNSIGNED,
    IN pCustomerId        INT UNSIGNED,
    IN pCorporateName     VARCHAR(200),
    IN pTradeName         VARCHAR(200),
    IN pCnpjNumber        VARCHAR(18),
    IN pStateRegistration VARCHAR(50)
)
BEGIN
    UPDATE CompanyCustomer
    SET CustomerId        = pCustomerId,
        CorporateName     = pCorporateName,
        TradeName         = pTradeName,
        CnpjNumber        = pCnpjNumber,
        StateRegistration = pStateRegistration,
        UpdatedAt         = NOW()
    WHERE CompanyCustomerId = pCompanyCustomerId;
END $$

CREATE PROCEDURE Proc_CompanyCustomer_ById (
    IN pCompanyCustomerId INT UNSIGNED
)
BEGIN
    SELECT *
    FROM CompanyCustomer
    WHERE CompanyCustomerId = pCompanyCustomerId;
END $$

CREATE PROCEDURE Proc_CompanyCustomer_List ()
BEGIN
    SELECT *
    FROM CompanyCustomer;
END $$

CREATE PROCEDURE Proc_CompanyCustomer_Delete (
    IN pCompanyCustomerId INT UNSIGNED
)
BEGIN
    DELETE FROM CompanyCustomer
    WHERE CompanyCustomerId = pCompanyCustomerId;
END $$



-- ==========================
-- PRODUCT
-- ==========================

CREATE PROCEDURE Proc_Product_Insert (
    IN pProductName VARCHAR(200),
    IN pSkuCode     VARCHAR(50),
    IN pBasePrice   DECIMAL(18, 2),
    IN pIsActive    TINYINT
)
BEGIN
    INSERT INTO Product (
        ProductName,
        SkuCode,
        BasePrice,
        IsActive
    )
    VALUES (
        pProductName,
        pSkuCode,
        pBasePrice,
        pIsActive
    );

    SELECT LAST_INSERT_ID() AS NewId;
END $$

CREATE PROCEDURE Proc_Product_Update (
    IN pProductId   INT UNSIGNED,
    IN pProductName VARCHAR(200),
    IN pSkuCode     VARCHAR(50),
    IN pBasePrice   DECIMAL(18, 2),
    IN pIsActive    TINYINT
)
BEGIN
    UPDATE Product
    SET ProductName = pProductName,
        SkuCode     = pSkuCode,
        BasePrice   = pBasePrice,
        IsActive    = pIsActive,
        UpdatedAt   = NOW()
    WHERE ProductId = pProductId;
END $$

CREATE PROCEDURE Proc_Product_ById (
    IN pProductId INT UNSIGNED
)
BEGIN
    SELECT *
    FROM Product
    WHERE ProductId = pProductId;
END $$

CREATE PROCEDURE Proc_Product_List ()
BEGIN
    SELECT *
    FROM Product;
END $$

CREATE PROCEDURE Proc_Product_Delete (
    IN pProductId INT UNSIGNED
)
BEGIN
    DELETE FROM Product
    WHERE ProductId = pProductId;
END $$



-- ==========================
-- PRODUCT PRICE (RETAIL / WHOLESALE)
-- ==========================

CREATE PROCEDURE Proc_ProductPrice_Insert (
    IN pProductId   INT UNSIGNED,
    IN pPriceType   VARCHAR(20),
    IN pMinQuantity INT UNSIGNED,
    IN pMaxQuantity INT UNSIGNED,
    IN pUnitPrice   DECIMAL(18, 2)
)
BEGIN
    INSERT INTO ProductPrice (
        ProductId,
        PriceType,
        MinQuantity,
        MaxQuantity,
        UnitPrice
    )
    VALUES (
        pProductId,
        pPriceType,
        pMinQuantity,
        pMaxQuantity,
        pUnitPrice
    );

    SELECT LAST_INSERT_ID() AS NewId;
END $$

CREATE PROCEDURE Proc_ProductPrice_Update (
    IN pProductPriceId INT UNSIGNED,
    IN pProductId      INT UNSIGNED,
    IN pPriceType      VARCHAR(20),
    IN pMinQuantity    INT UNSIGNED,
    IN pMaxQuantity    INT UNSIGNED,
    IN pUnitPrice      DECIMAL(18, 2)
)
BEGIN
    UPDATE ProductPrice
    SET ProductId   = pProductId,
        PriceType   = pPriceType,
        MinQuantity = pMinQuantity,
        MaxQuantity = pMaxQuantity,
        UnitPrice   = pUnitPrice,
        UpdatedAt   = NOW()
    WHERE ProductPriceId = pProductPriceId;
END $$

CREATE PROCEDURE Proc_ProductPrice_ById (
    IN pProductPriceId INT UNSIGNED
)
BEGIN
    SELECT *
    FROM ProductPrice
    WHERE ProductPriceId = pProductPriceId;
END $$

CREATE PROCEDURE Proc_ProductPrice_List ()
BEGIN
    SELECT *
    FROM ProductPrice;
END $$

CREATE PROCEDURE Proc_ProductPrice_Delete (
    IN pProductPriceId INT UNSIGNED
)
BEGIN
    DELETE FROM ProductPrice
    WHERE ProductPriceId = pProductPriceId;
END $$



-- ==========================
-- SHOPPING CART
-- ==========================

CREATE PROCEDURE Proc_ShoppingCart_Insert (
    IN pCustomerId   INT UNSIGNED,
    IN pVisitorToken VARCHAR(100),
    IN pCartStatus   VARCHAR(20),
    IN pExpiresAt    DATETIME
)
BEGIN
    INSERT INTO ShoppingCart (
        CustomerId,
        VisitorToken,
        CartStatus,
        ExpiresAt
    )
    VALUES (
        pCustomerId,
        pVisitorToken,
        pCartStatus,
        pExpiresAt
    );

    SELECT LAST_INSERT_ID() AS NewId;
END $$

CREATE PROCEDURE Proc_ShoppingCart_Update (
    IN pCartId       INT UNSIGNED,
    IN pCustomerId   INT UNSIGNED,
    IN pVisitorToken VARCHAR(100),
    IN pCartStatus   VARCHAR(20),
    IN pExpiresAt    DATETIME
)
BEGIN
    UPDATE ShoppingCart
    SET CustomerId   = pCustomerId,
        VisitorToken = pVisitorToken,
        CartStatus   = pCartStatus,
        ExpiresAt    = pExpiresAt
    WHERE CartId = pCartId;
END $$

CREATE PROCEDURE Proc_ShoppingCart_ById (
    IN pCartId INT UNSIGNED
)
BEGIN
    SELECT *
    FROM ShoppingCart
    WHERE CartId = pCartId;
END $$

CREATE PROCEDURE Proc_ShoppingCart_List ()
BEGIN
    SELECT *
    FROM ShoppingCart;
END $$

CREATE PROCEDURE Proc_ShoppingCart_Delete (
    IN pCartId INT UNSIGNED
)
BEGIN
    DELETE FROM ShoppingCart
    WHERE CartId = pCartId;
END $$



-- ==========================
-- CART ITEM
-- ==========================

CREATE PROCEDURE Proc_CartItem_Insert (
    IN pCartId    INT UNSIGNED,
    IN pProductId INT UNSIGNED,
    IN pQuantity  INT UNSIGNED,
    IN pUnitPrice DECIMAL(18, 2)
)
BEGIN
    INSERT INTO CartItem (
        CartId,
        ProductId,
        Quantity,
        UnitPrice
    )
    VALUES (
        pCartId,
        pProductId,
        pQuantity,
        pUnitPrice
    );

    SELECT LAST_INSERT_ID() AS NewId;
END $$

CREATE PROCEDURE Proc_CartItem_Update (
    IN pCartItemId INT UNSIGNED,
    IN pCartId     INT UNSIGNED,
    IN pProductId  INT UNSIGNED,
    IN pQuantity   INT UNSIGNED,
    IN pUnitPrice  DECIMAL(18, 2)
)
BEGIN
    UPDATE CartItem
    SET CartId    = pCartId,
        ProductId = pProductId,
        Quantity  = pQuantity,
        UnitPrice = pUnitPrice
    WHERE CartItemId = pCartItemId;
END $$

CREATE PROCEDURE Proc_CartItem_ById (
    IN pCartItemId INT UNSIGNED
)
BEGIN
    SELECT *
    FROM CartItem
    WHERE CartItemId = pCartItemId;
END $$

CREATE PROCEDURE Proc_CartItem_List ()
BEGIN
    SELECT *
    FROM CartItem;
END $$

CREATE PROCEDURE Proc_CartItem_Delete (
    IN pCartItemId INT UNSIGNED
)
BEGIN
    DELETE FROM CartItem
    WHERE CartItemId = pCartItemId;
END $$

DELIMITER ;
