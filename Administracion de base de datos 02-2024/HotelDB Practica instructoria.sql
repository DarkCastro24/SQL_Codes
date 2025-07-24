-- Crear la base de datos para el hotel
CREATE DATABASE HotelDB;
USE HotelDB;

-- Crear la tabla de Clientes
CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Telefono VARCHAR(15)
);

-- Crear la tabla de Habitaciones
CREATE TABLE Habitaciones (
    HabitacionID INT PRIMARY KEY IDENTITY(1,1),
    NumeroHabitacion NVARCHAR(10) NOT NULL,
    Tipo NVARCHAR(50) NOT NULL,
    PrecioPorNoche DECIMAL(10, 2) NOT NULL
);

-- Crear la tabla de Reservas
CREATE TABLE Reservas (
    ReservaID INT PRIMARY KEY IDENTITY(1,1),
    ClienteID INT NOT NULL,
    HabitacionID INT NOT NULL,
    FechaIngreso DATE NOT NULL,
    FechaSalida DATE NOT NULL,
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID),
    FOREIGN KEY (HabitacionID) REFERENCES Habitaciones(HabitacionID)
);

-- Crear la tabla de Servicios
CREATE TABLE Servicios (
    ServicioID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Costo DECIMAL(10, 2) NOT NULL
);

-- Crear la tabla intermediaria de Facturas (contendrá los totales)
CREATE TABLE Facturas (
    FacturaID INT PRIMARY KEY IDENTITY(1,1),
    ReservaID INT NOT NULL,
    Total DECIMAL(10, 2) NOT NULL,
    FechaFactura DATE NOT NULL,
    FOREIGN KEY (ReservaID) REFERENCES Reservas(ReservaID)
);

-- Crear la tabla de DetalleFactura (relaciona servicios con la factura)
CREATE TABLE DetalleFactura (
    DetalleID INT PRIMARY KEY IDENTITY(1,1),
    FacturaID INT NOT NULL,
    ServicioID INT NOT NULL,
    Cantidad INT NOT NULL,
    SubTotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (FacturaID) REFERENCES Facturas(FacturaID),
    FOREIGN KEY (ServicioID) REFERENCES Servicios(ServicioID)
);

-- Insertar datos en la tabla Clientes
INSERT INTO Clientes (Nombre, Email, Telefono)
VALUES 
('Juan Pérez', 'juan.perez@example.com', '123-456-7890'),
('Ana Gómez', 'ana.gomez@example.com', '098-765-4321'),
('Luis Martínez', 'luis.martinez@example.com', '555-123-4567');

-- Insertar datos en la tabla Habitaciones
INSERT INTO Habitaciones (NumeroHabitacion, Tipo, PrecioPorNoche)
VALUES 
('101', 'Sencilla', 50.00),
('102', 'Doble', 75.00),
('103', 'Suite', 150.00);

-- Insertar datos en la tabla Reservas
INSERT INTO Reservas (ClienteID, HabitacionID, FechaIngreso, FechaSalida)
VALUES 
(1, 1, '2024-08-10', '2024-08-15'),
(2, 2, '2024-08-12', '2024-08-14'),
(3, 3, '2024-08-11', '2024-08-13');

-- Insertar datos en la tabla Servicios
INSERT INTO Servicios (Nombre, Costo)
VALUES 
('Desayuno', 10.00),
('Lavandería', 15.00),
('Spa', 50.00);

-- Insertar datos en la tabla Facturas
INSERT INTO Facturas (ReservaID, Total, FechaFactura)
VALUES 
(1, 300.00, '2024-08-15'),
(2, 225.00, '2024-08-14'),
(3, 200.00, '2024-08-13');

-- Insertar datos en la tabla DetalleFactura
INSERT INTO DetalleFactura (FacturaID, ServicioID, Cantidad, SubTotal)
VALUES 
(1, 1, 2, 20.00),
(1, 3, 1, 50.00),
(2, 2, 1, 15.00),
(3, 1, 3, 30.00);


-- CONSULTAS 

-- INNER JOIN: Para unir varias tablas y obtener una vista detallada de facturas.

SELECT 
    C.Nombre AS Cliente,
    H.NumeroHabitacion AS Habitacion,
    F.Total AS TotalFactura,
    S.Nombre AS Servicio,
    DF.Cantidad,
    DF.SubTotal
FROM 
    Facturas F
    INNER JOIN Reservas R ON F.ReservaID = R.ReservaID
    INNER JOIN Clientes C ON R.ClienteID = C.ClienteID
    INNER JOIN Habitaciones H ON R.HabitacionID = H.HabitacionID
    INNER JOIN DetalleFactura DF ON F.FacturaID = DF.FacturaID
    INNER JOIN Servicios S ON DF.ServicioID = S.ServicioID
ORDER BY 
    F.FechaFactura DESC;


-- Subconsulta: Para calcular el total gastado por un cliente en servicios específicos.

SELECT 
    C.Nombre,
    (SELECT SUM(DF.SubTotal) 
     FROM DetalleFactura DF
     INNER JOIN Facturas F ON DF.FacturaID = F.FacturaID
     WHERE F.ReservaID = R.ReservaID) AS TotalServicios
FROM 
    Reservas R
    INNER JOIN Clientes C ON R.ClienteID = C.ClienteID
WHERE 
    C.ClienteID = 1;

-- GROUP BY: Para agrupar datos (e.g., total gastado por cliente).

SELECT 
    C.Nombre,
    COUNT(F.FacturaID) AS NumeroDeFacturas,
    SUM(F.Total) AS TotalGastado
FROM 
    Facturas F
    INNER JOIN Reservas R ON F.ReservaID = R.ReservaID
    INNER JOIN Clientes C ON R.ClienteID = C.ClienteID
GROUP BY 
    C.Nombre
ORDER BY 
    TotalGastado DESC;

-- ORDER BY: Para ordenar los resultados por una columna específica.

SELECT 
    C.Nombre,
    H.NumeroHabitacion,
    R.FechaIngreso,
    R.FechaSalida
FROM 
    Reservas R
    INNER JOIN Clientes C ON R.ClienteID = C.ClienteID
    INNER JOIN Habitaciones H ON R.HabitacionID = H.HabitacionID
ORDER BY 
    R.FechaIngreso ASC;

-- HAVING: Para filtrar grupos basados en una condición (e.g., clientes que han gastado más de una cantidad).

SELECT 
    C.Nombre,
    SUM(F.Total) AS TotalGastado
FROM 
    Facturas F
    INNER JOIN Reservas R ON F.ReservaID = R.ReservaID
    INNER JOIN Clientes C ON R.ClienteID = C.ClienteID
GROUP BY 
    C.Nombre
HAVING 
    SUM(F.Total) > 250.00;


