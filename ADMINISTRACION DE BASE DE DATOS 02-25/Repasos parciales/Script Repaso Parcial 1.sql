	

CREATE TABLE Measure_unit (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(16) NOT NULL
);

CREATE TABLE Reorder_level (
    id INT IDENTITY(1,1) PRIMARY KEY,
    level VARCHAR(16) NOT NULL
);

CREATE TABLE Ingredient (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    current_stock FLOAT NOT NULL,
    measure_unit_id INT NOT NULL,
    cost DECIMAL(12, 2) NOT NULL,
    reorder_level_id INT NOT NULL,
    FOREIGN KEY (measure_unit_id) REFERENCES Measure_unit(id),
    FOREIGN KEY (reorder_level_id) REFERENCES Reorder_level(id)
);

CREATE TABLE Product (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    description VARCHAR(256) NOT NULL,
    sale_price DECIMAL(12, 2) NOT NULL,
    cost_to_make DECIMAL(12, 2) NOT NULL
);

CREATE TABLE Recipe (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT,
    ingredient_id INT,
    quantity_used FLOAT,
    FOREIGN KEY (product_id) REFERENCES Product(id),
    FOREIGN KEY (ingredient_id) REFERENCES Ingredient(id)
);

CREATE TABLE Customer (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(128),
    email VARCHAR(128)
);

CREATE TABLE Invoice (
    id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    total DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    timestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES Customer(id)
);

CREATE TABLE [Order] (
    id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    invoice_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Product(id),
    FOREIGN KEY (invoice_id) REFERENCES Invoice(id)
);

-- Insert Measure Units
INSERT INTO Measure_unit (name) VALUES
('kg'),
('g'),
('l'),
('ml'),
('units'),
('cups'),
('tsp'),
('tbsp');

-- Insert Reorder Levels
INSERT INTO Reorder_level (level) VALUES
('Low'),
('Medium'),
('High'),
('Critical');

-- Insert Ingredients
INSERT INTO Ingredient (name, current_stock, measure_unit_id, cost, reorder_level_id) VALUES
('Wheat Flour', 500, 1, 0.80, 2),
('Sugar', 200, 1, 1.20, 2),
('Butter', 150, 1, 3.50, 2),
('Eggs', 300, 5, 0.25, 3),
('Milk', 100, 3, 0.90, 2),
('Chocolate Chips', 75, 1, 4.00, 1),
('Vanilla Extract', 5, 4, 12.00, 3),
('Baking Powder', 10, 2, 0.15, 3),
('Salt', 20, 2, 0.10, 4),
('Cinnamon', 8, 2, 8.00, 3),
('Yeast', 15, 2, 5.00, 2),
('Cream Cheese', 40, 1, 2.80, 2);

-- Insert Products
INSERT INTO Product (name, description, sale_price, cost_to_make) VALUES
('Chocolate Chip Cookies', 'Classic cookies with rich chocolate chips', 2.50, 0.85),
('Vanilla Cupcakes', 'Moist vanilla cupcakes with buttercream frosting', 3.75, 1.20),
('Cinnamon Rolls', 'Soft cinnamon rolls with cream cheese icing', 4.25, 1.50),
('Whole Wheat Bread', 'Healthy whole wheat bread loaf', 5.99, 2.10),
('Brownies', 'Fudgy chocolate brownies with walnuts', 3.25, 1.05),
('Cheesecake Slice', 'Creamy New York style cheesecake', 4.75, 1.80);

-- Insert Recipes
INSERT INTO Recipe (product_id, ingredient_id, quantity_used) VALUES
-- Chocolate Chip Cookies
(1, 1, 0.5),   -- 0.5kg Flour
(1, 2, 0.3),   -- 0.3kg Sugar
(1, 3, 0.25),  -- 0.25kg Butter
(1, 4, 2),     -- 2 Eggs
(1, 6, 0.4),   -- 0.4kg Chocolate Chips
(1, 7, 0.01),  -- 10ml Vanilla
(1, 8, 0.015), -- 15g Baking Powder
(1, 9, 0.005), -- 5g Salt

-- Vanilla Cupcakes
(2, 1, 0.4),   -- 0.4kg Flour
(2, 2, 0.35),  -- 0.35kg Sugar
(2, 3, 0.2),   -- 0.2kg Butter
(2, 4, 3),     -- 3 Eggs
(2, 5, 0.2),   -- 0.2l Milk
(2, 7, 0.02),  -- 20ml Vanilla
(2, 8, 0.01),  -- 10g Baking Powder

-- Cinnamon Rolls
(3, 1, 0.6),   -- 0.6kg Flour
(3, 2, 0.4),   -- 0.4kg Sugar
(3, 3, 0.3),   -- 0.3kg Butter
(3, 4, 2),     -- 2 Eggs
(3, 5, 0.25),  -- 0.25l Milk
(3, 10, 0.03), -- 30g Cinnamon
(3, 11, 0.02), -- 20g Yeast
(3, 12, 0.15); -- 0.15kg Cream Cheese

-- Insert Recipes for Whole Wheat Bread (Product ID: 4)
INSERT INTO Recipe (product_id, ingredient_id, quantity_used) VALUES
(4, 1, 0.8),    -- 0.8kg Wheat Flour
(4, 2, 0.1),    -- 0.1kg Sugar
(4, 3, 0.15),   -- 0.15kg Butter
(4, 4, 2),      -- 2 Eggs
(4, 5, 0.3),    -- 0.3l Milk
(4, 9, 0.008),  -- 8g Salt
(4, 11, 0.025); -- 25g Yeast

-- Insert Recipes for Brownies (Product ID: 5)
INSERT INTO Recipe (product_id, ingredient_id, quantity_used) VALUES
(5, 1, 0.3),    -- 0.3kg Flour
(5, 2, 0.4),    -- 0.4kg Sugar
(5, 3, 0.35),   -- 0.35kg Butter
(5, 4, 3),      -- 3 Eggs
(5, 6, 0.5),    -- 0.5kg Chocolate Chips
(5, 7, 0.015),  -- 15ml Vanilla Extract
(5, 8, 0.01),   -- 10g Baking Powder
(5, 9, 0.003);  -- 3g Salt

-- Insert Recipes for Cheesecake Slice (Product ID: 6)
INSERT INTO Recipe (product_id, ingredient_id, quantity_used) VALUES
(6, 1, 0.15),   -- 0.15kg Flour (for crust)
(6, 2, 0.2),    -- 0.2kg Sugar
(6, 3, 0.1),    -- 0.1kg Butter (for crust)
(6, 4, 4),      -- 4 Eggs
(6, 5, 0.1),    -- 0.1l Milk
(6, 7, 0.02),   -- 20ml Vanilla Extract
(6, 12, 0.4);   -- 0.4kg Cream Cheese

-- Insert Customers
INSERT INTO Customer (name, email) VALUES
('Maria Garcia', 'maria.garcia@email.com'),
('John Smith', 'john.smith@email.com'),
('Sarah Johnson', 'sarah.j@email.com'),
('David Wilson', 'david.wilson@email.com'),
('Emily Chen', 'emily.chen@email.com'),
('Michael Brown', 'michael.b@email.com'),
('Jessica Lee', 'jessica.lee@email.com'),
('Robert Davis', 'robert.davis@email.com');