USE OnlineStore;

-- LIMPAR TABELAS (opcional em ambiente de teste)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE CartItem;
TRUNCATE TABLE ShoppingCart;
TRUNCATE TABLE ProductPrice;
TRUNCATE TABLE Product;
TRUNCATE TABLE CompanyCustomer;
TRUNCATE TABLE Customer;
TRUNCATE TABLE CustomerType;
SET FOREIGN_KEY_CHECKS = 1;

--------------------------------------------------
-- 1) CUSTOMER TYPE – tipos de cliente
--------------------------------------------------
INSERT INTO CustomerType (CustomerTypeId, TypeName, CreatedAt)
VALUES
    (1, 'Individual', NOW()),
    (2, 'Company',   NOW()),
    (3, 'Guest',     NOW()),
    (4, 'Vip',       NOW()),
    (5, 'Blocked',   NOW());

--------------------------------------------------
-- 2) CUSTOMER – clientes PF e PJ
--------------------------------------------------
-- 3 clientes pessoa física (Individual)
INSERT INTO Customer (CustomerId, CustomerTypeId, FullName, EmailAddress, PasswordHash, CpfNumber, IsActive, CreatedAt)
VALUES
    (1, 1, 'John Doe',        'john.doe@test.com',        'HASH_JOHN_DOE',  '111.111.111-11', 1, NOW()),
    (2, 1, 'Mary Smith',      'mary.smith@test.com',      'HASH_MARY_SMITH','222.222.222-22', 1, NOW()),
    (3, 1, 'Pedro Santos',    'pedro.santos@test.com',    'HASH_PEDRO',     '333.333.333-33', 1, NOW());

-- 5 clientes pessoa jurídica (Company)
INSERT INTO Customer (CustomerId, CustomerTypeId, FullName, EmailAddress, PasswordHash, CpfNumber, IsActive, CreatedAt)
VALUES
    (4, 2, 'ACME LTDA Owner',        'owner@acme.com',         'HASH_ACME',       NULL, 1, NOW()),
    (5, 2, 'Global Trade Manager',   'manager@globaltrade.com','HASH_GLOBAL',     NULL, 1, NOW()),
    (6, 2, 'Tech Store Admin',       'admin@techstore.com',    'HASH_TECH',       NULL, 1, NOW()),
    (7, 2, 'Office Plus Director',   'director@officeplus.com','HASH_OFFICEPLUS', NULL, 1, NOW()),
    (8, 2, 'Supply Max Owner',       'owner@supplymax.com',    'HASH_SUPPLYMAX',  NULL, 1, NOW());

--------------------------------------------------
-- 3) COMPANY CUSTOMER – dados PJ (5 registros)
--------------------------------------------------
INSERT INTO CompanyCustomer (
    CompanyCustomerId,
    CustomerId,
    CorporateName,
    TradeName,
    CnpjNumber,
    StateRegistration,
    CreatedAt
)
VALUES
    (1, 4, 'ACME Comercio de Eletronicos LTDA',   'ACME Eletronicos',      '11.111.111/0001-11', 'ISENTO', NOW()),
    (2, 5, 'Global Trade Importacao e Exportacao','Global Trade',          '22.222.222/0001-22', '123456-0', NOW()),
    (3, 6, 'Tech Store Tecnologia LTDA',          'Tech Store',            '33.333.333/0001-33', '456789-1', NOW()),
    (4, 7, 'Office Plus Escritorio LTDA',         'Office Plus',           '44.444.444/0001-44', '789123-4', NOW()),
    (5, 8, 'Supply Max Distribuidora LTDA',       'Supply Max',            '55.555.555/0001-55', '987654-3', NOW());

--------------------------------------------------
-- 4) PRODUCT – 5 produtos
--------------------------------------------------
INSERT INTO Product (ProductId, ProductName, SkuCode, BasePrice, IsActive, CreatedAt)
VALUES
    (1, 'Notebook Basic 14"',  'NB-001', 3500.00, 1, NOW()),
    (2, 'Smartphone Entry',     'SM-001', 1500.00, 1, NOW()),
    (3, 'Office Chair Black',   'CH-001',  800.00, 1, NOW()),
    (4, 'Wireless Mouse',       'MS-001',   80.00, 1, NOW()),
    (5, 'USB Keyboard',         'KB-001',  100.00, 1, NOW());

--------------------------------------------------
-- 5) PRODUCT PRICE – varejo / atacado por faixa (10 registros)
--------------------------------------------------
-- Notebook Basic 14"
INSERT INTO ProductPrice (
    ProductPriceId,
    ProductId,
    PriceType,
    MinQuantity,
    MaxQuantity,
    UnitPrice,
    CreatedAt
)
VALUES
    (1, 1, 'Retail',    1,  4, 3500.00, NOW()),
    (2, 1, 'Wholesale', 5, NULL, 3300.00, NOW());

-- Smartphone Entry
INSERT INTO ProductPrice (
    ProductPriceId,
    ProductId,
    PriceType,
    MinQuantity,
    MaxQuantity,
    UnitPrice,
    CreatedAt
)
VALUES
    (3, 2, 'Retail',    1,  9, 1500.00, NOW()),
    (4, 2, 'Wholesale',10, NULL, 1350.00, NOW());

-- Office Chair Black
INSERT INTO ProductPrice (
    ProductPriceId,
    ProductId,
    PriceType,
    MinQuantity,
    MaxQuantity,
    UnitPrice,
    CreatedAt
)
VALUES
    (5, 3, 'Retail',    1,  4,  800.00, NOW()),
    (6, 3, 'Wholesale', 5, NULL,  750.00, NOW());

-- Wireless Mouse
INSERT INTO ProductPrice (
    ProductPriceId,
    ProductId,
    PriceType,
    MinQuantity,
    MaxQuantity,
    UnitPrice,
    CreatedAt
)
VALUES
    (7, 4, 'Retail',    1,  9,   80.00, NOW()),
    (8, 4, 'Wholesale',10, NULL,  70.00, NOW());

-- USB Keyboard
INSERT INTO ProductPrice (
    ProductPriceId,
    ProductId,
    PriceType,
    MinQuantity,
    MaxQuantity,
    UnitPrice,
    CreatedAt
)
VALUES
    (9,  5, 'Retail',    1,  9, 100.00, NOW()),
    (10, 5, 'Wholesale',10, NULL,  90.00, NOW());

--------------------------------------------------
-- 6) SHOPPING CART – 5 carrinhos (2 visitantes, 3 clientes logados)
--------------------------------------------------
-- Visitante 1
INSERT INTO ShoppingCart (
    CartId,
    CustomerId,
    VisitorToken,
    CartStatus,
    CreatedAt,
    ExpiresAt
)
VALUES
    (1, NULL, 'VISITOR-ABC123', 'Active',
        '2025-12-04 10:00:00',
        '2025-12-05 10:00:00');

-- Visitante 2
INSERT INTO ShoppingCart (
    CartId,
    CustomerId,
    VisitorToken,
    CartStatus,
    CreatedAt,
    ExpiresAt
)
VALUES
    (2, NULL, 'VISITOR-XYZ789', 'Active',
        '2025-12-04 11:30:00',
        '2025-12-05 11:30:00');

-- Carrinho do John Doe (CustomerId 1)
INSERT INTO ShoppingCart (
    CartId,
    CustomerId,
    VisitorToken,
    CartStatus,
    CreatedAt,
    ExpiresAt
)
VALUES
    (3, 1, NULL, 'Active',
        '2025-12-04 09:00:00',
        NULL);

-- Carrinho da Mary Smith (CustomerId 2)
INSERT INTO ShoppingCart (
    CartId,
    CustomerId,
    VisitorToken,
    CartStatus,
    CreatedAt,
    ExpiresAt
)
VALUES
    (4, 2, NULL, 'Active',
        '2025-12-04 14:15:00',
        NULL);

-- Carrinho da ACME (CustomerId 4 - empresa)
INSERT INTO ShoppingCart (
    CartId,
    CustomerId,
    VisitorToken,
    CartStatus,
    CreatedAt,
    ExpiresAt
)
VALUES
    (5, 4, NULL, 'Active',
        '2025-12-04 15:45:00',
        NULL);

--------------------------------------------------
-- 7) CART ITEM – 5+ itens distribuídos pelos carrinhos
--------------------------------------------------
-- Carrinho 1 (visitante) – Mouse + Keyboard atacado
INSERT INTO CartItem (
    CartItemId,
    CartId,
    ProductId,
    Quantity,
    UnitPrice,
    CreatedAt
)
VALUES
    -- Wireless Mouse: 2 unidades (varejo)
    (1, 1, 4,  2,  80.00, '2025-12-04 10:05:00'),
    -- USB Keyboard: 10 unidades (atacado)
    (2, 1, 5, 10,  90.00, '2025-12-04 10:07:00');

-- Carrinho 2 (visitante) – 12 Smartphones (atacado)
INSERT INTO CartItem (
    CartItemId,
    CartId,
    ProductId,
    Quantity,
    UnitPrice,
    CreatedAt
)
VALUES
    (3, 2, 2, 12, 1350.00, '2025-12-04 11:35:00');

-- Carrinho 3 (John Doe) – 1 Notebook (varejo)
INSERT INTO CartItem (
    CartItemId,
    CartId,
    ProductId,
    Quantity,
    UnitPrice,
    CreatedAt
)
VALUES
    (4, 3, 1, 1, 3500.00, '2025-12-04 09:10:00');

-- Carrinho 5 (ACME) – 6 Cadeiras (atacado)
INSERT INTO CartItem (
    CartItemId,
    CartId,
    ProductId,
    Quantity,
    UnitPrice,
    CreatedAt
)
VALUES
    (5, 5, 3, 6, 750.00, '2025-12-04 15:50:00');

-- (Opcional) Carrinho 4 (Mary) – 3 teclados varejo
INSERT INTO CartItem (
    CartItemId,
    CartId,
    ProductId,
    Quantity,
    UnitPrice,
    CreatedAt
)
VALUES
    (6, 4, 5, 3, 100.00, '2025-12-04 14:20:00');
