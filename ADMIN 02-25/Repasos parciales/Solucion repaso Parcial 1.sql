--Ej. 1
BEGIN
	SELECT I.name, I.current_stock,MU.name AS 'Measure unit', I.cost, RL.level
	FROM Ingredient AS I
	INNER JOIN Reorder_level AS RL ON RL.id = I.reorder_level_id
	INNER JOIN Measure_unit AS MU ON MU.id = I.measure_unit_id
END;

-- Ej. 2
CREATE OR ALTER FUNCTION IngredientsByOrderLevel (@order_level VARCHAR(16))
RETURNS table
AS
RETURN
	SELECT I.name, I.current_stock,MU.name AS 'Measure unit', I.cost, RL.level
	FROM Ingredient AS I
	INNER JOIN Reorder_level AS RL ON RL.id = I.reorder_level_id
	INNER JOIN Measure_unit AS MU ON MU.id = I.measure_unit_id
	WHERE RL.level LIKE @order_level

SELECT * FROM dbo.IngredientsByOrderLevel('Medium');

--Ej. 3
CREATE OR ALTER FUNCTION IngredientCostToEuro()
RETURNS table
AS
RETURN
	SELECT I.name, I.current_stock,MU.name AS 'Measure unit', CAST(CAST(ROUND(I.cost / 1.16, 2) AS DECIMAL(18, 2)) AS VARCHAR(16))+ ' EUR' AS 'Cost', RL.level
	FROM Ingredient AS I
	INNER JOIN Reorder_level AS RL ON RL.id = I.reorder_level_id
	INNER JOIN Measure_unit AS MU ON MU.id = I.measure_unit_id

SELECT * FROM dbo.IngredientCostToEuro()

--Ej. 4
CREATE OR ALTER FUNCTION IngredientRestockEstimate(@Ingredient_name VARCHAR(64))
RETURNS @Result TABLE (
	RestockOptimalOrder VARCHAR(64),
	RestockCost DECIMAL(12, 2),
	NewInventoryCost DECIMAL(12, 2)
) AS
BEGIN
	DECLARE @RestockTEMP VARCHAR(64) = ''
	DECLARE @RestockCostTEMP DECIMAL(12, 2) = 0.0
	DECLARE @NewInventoryTEMP DECIMAL(12, 2) = 0.0

	IF EXISTS (SELECT 1 FROM Ingredient WHERE Ingredient.name = @Ingredient_name)
	BEGIN
	SET @RestockTEMP = CASE 
		WHEN (SELECT RL.level FROM Ingredient AS I INNER JOIN Reorder_level AS RL ON RL.id = I.reorder_level_id WHERE I.name = @Ingredient_name) = 'Low'
			THEN 'No restock needed'
		WHEN (SELECT RL.level FROM Ingredient AS I INNER JOIN Reorder_level AS RL ON RL.id = I.reorder_level_id WHERE I.name = @Ingredient_name) = 'Medium'
			THEN '50 units needed for restock'
		WHEN (SELECT RL.level FROM Ingredient AS I INNER JOIN Reorder_level AS RL ON RL.id = I.reorder_level_id WHERE I.name = @Ingredient_name) = 'High'
			THEN '100 units needed for restock'
		WHEN (SELECT RL.level FROM Ingredient AS I INNER JOIN Reorder_level AS RL ON RL.id = I.reorder_level_id WHERE I.name = @Ingredient_name) = 'Critical'
			THEN '200 units needed for restock'
		END;

	SET @RestockCostTEMP = CASE
		WHEN (SELECT RL.level FROM Ingredient AS I INNER JOIN Reorder_level AS RL ON RL.id = I.reorder_level_id WHERE I.name = @Ingredient_name) = 'Medium'
			THEN (SELECT I.cost * 50 FROM Ingredient AS I WHERE I.name = @Ingredient_name)
		WHEN (SELECT RL.level FROM Ingredient AS I INNER JOIN Reorder_level AS RL ON RL.id = I.reorder_level_id WHERE I.name = @Ingredient_name) = 'High'
			THEN (SELECT I.cost * 100 FROM Ingredient AS I WHERE I.name = @Ingredient_name)
		WHEN (SELECT RL.level FROM Ingredient AS I INNER JOIN Reorder_level AS RL ON RL.id = I.reorder_level_id WHERE I.name = @Ingredient_name) = 'Critical'
			THEN (SELECT I.cost * 200 FROM Ingredient AS I WHERE I.name = @Ingredient_name)
		END;

	SET @NewInventoryTEMP = CASE
		WHEN (SELECT RL.level FROM Ingredient AS I INNER JOIN Reorder_level AS RL ON RL.id = I.reorder_level_id WHERE I.name = @Ingredient_name) = 'Medium'
			THEN (SELECT I.cost * (50 + I.current_stock) FROM Ingredient AS I WHERE I.name = @Ingredient_name)
		WHEN (SELECT RL.level FROM Ingredient AS I INNER JOIN Reorder_level AS RL ON RL.id = I.reorder_level_id WHERE I.name = @Ingredient_name) = 'High'
			THEN (SELECT I.cost * (100 + I.current_stock) FROM Ingredient AS I WHERE I.name = @Ingredient_name)
		WHEN (SELECT RL.level FROM Ingredient AS I INNER JOIN Reorder_level AS RL ON RL.id = I.reorder_level_id WHERE I.name = @Ingredient_name) = 'Critical'
			THEN (SELECT I.cost * (200 + I.current_stock) FROM Ingredient AS I WHERE I.name = @Ingredient_name)
		END;

	END;

	ELSE
	SET @RestockTEMP = 'Ingredient not found';

	BEGIN
		INSERT @Result
		SELECT @RestockTEMP,
			@RestockCostTEMP,
			@NewInventoryTEMP
	END;
	RETURN;
END;

SELECT * FROM dbo.IngredientRestockEstimate('Sugar');

--Ej.5
CREATE OR ALTER PROCEDURE CreateInvoiceByName
	@ClientName VARCHAR(128)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Customer WHERE Customer.name = @ClientName)
	INSERT INTO Invoice (customer_id)
	(SELECT C.id FROM Customer AS C WHERE C.name = @ClientName)

	ELSE
	SELECT 'Client not found'
END;

EXEC CreateInvoiceByName @ClientName = 'Maria Garcia'

SELECT * FROM Invoice

--Ej. 6

--Trigger de insert
CREATE OR ALTER TRIGGER trg_OrderInsert
ON [Order]
AFTER INSERT
AS
BEGIN
	DECLARE @ProductCost DECIMAL(12, 2)
	SET @ProductCost = (SELECT P.sale_price FROM Product AS P WHERE P.id = (SELECT inserted.product_id FROM inserted))

	BEGIN TRY
		IF NOT EXISTS (SELECT inserted.product_id FROM inserted) AND NOT EXISTS (SELECT inserted.invoice_id FROM inserted)
			BEGIN
				RAISERROR('Invoice or product id not found in insert', 16, 1);
			END;

		UPDATE Invoice 
		SET Invoice.total = Invoice.total + (SELECT CAST((inserted.quantity * @ProductCost) AS DECIMAL(12, 2) ) FROM inserted)
		WHERE Invoice.id = (SELECT inserted.invoice_id FROM inserted)
	END TRY

	BEGIN CATCH
	THROW;
	END CATCH
END;

--Trigger de delete
CREATE OR ALTER TRIGGER trg_OrderDelete
ON [Order]
AFTER DELETE
AS
BEGIN
	DECLARE @ProductCost DECIMAL(12, 2)
	SET @ProductCost = (SELECT P.sale_price FROM Product AS P WHERE P.id = (SELECT deleted.product_id FROM deleted))

	BEGIN TRY
		IF (SELECT (I.total - (@ProductCost * (SELECT deleted.quantity FROM deleted))) FROM Invoice AS I WHERE I.id = (SELECT deleted.invoice_id FROM deleted)) < 0
			BEGIN
				RAISERROR('Total cannot be below 0', 16, 1);
			END;

		UPDATE Invoice 
		SET Invoice.total = Invoice.total - (SELECT CAST((deleted.quantity * @ProductCost) AS DECIMAL(12, 2) ) FROM deleted)
		WHERE Invoice.id = (SELECT deleted.invoice_id FROM deleted)
	END TRY

	BEGIN CATCH
	THROW;
	END CATCH
END;

--Trigger del stock en insert
CREATE OR ALTER TRIGGER trg_UpdateStockOnInsert
ON [Order]
AFTER INSERT
AS
BEGIN
	BEGIN TRANSACTION
		UPDATE Ingredient
		SET Ingredient.current_stock = Ingredient.current_stock - (R.quantity_used * INS.quantity)
		FROM Ingredient
		INNER JOIN Recipe AS R ON R.ingredient_id = Ingredient.id
		INNER JOIN inserted INS ON INS.product_id = R.product_id

		IF EXISTS (SELECT 1 FROM Ingredient WHERE Ingredient.current_stock < 0)
		BEGIN
			RAISERROR('Insufficient stock for one or more products', 16, 1)
			ROLLBACK TRANSACTION
			RETURN;
		END

		COMMIT TRANSACTION;
END;

-- Trigger del stock en delete
CREATE OR ALTER TRIGGER trg_UpdateStockOnDelete
ON [Order]
AFTER DELETE
AS
BEGIN
		UPDATE Ingredient
		SET Ingredient.current_stock = Ingredient.current_stock + (R.quantity_used * DEL.quantity)
		FROM Ingredient
		INNER JOIN Recipe AS R ON R.ingredient_id = Ingredient.id
		INNER JOIN deleted DEL ON DEL.product_id = R.product_id
END;


--Ej. 7
CREATE OR ALTER PROCEDURE CreateOrder
	@InvoiceID INT,
	@ProductID INT,
	@Quantity INT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Invoice I WHERE I.id = @InvoiceID) AND EXISTS (SELECT 1 FROM Product P WHERE P.id = @ProductID)
		INSERT INTO [Order] (product_id, invoice_id, quantity)
		SELECT @ProductID, @InvoiceID, @Quantity
	ELSE
	SELECT 'Invoice or Product not found'
END;

EXEC CreateOrder @InvoiceID = 1, @ProductID = 1, @Quantity = 4

SELECT * FROM [Order]

SELECT * FROM Invoice

SELECT * FROM Ingredient

--Ej. 8
CREATE OR ALTER PROCEDURE DeleteOrder
	@OrderID INT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM [Order] AS O WHERE O.id = @OrderID)
		DELETE FROM [Order] WHERE [Order].id = @OrderID

	ELSE
		SELECT 'Order not found'
END;

EXEC DeleteOrder @OrderID = 1
