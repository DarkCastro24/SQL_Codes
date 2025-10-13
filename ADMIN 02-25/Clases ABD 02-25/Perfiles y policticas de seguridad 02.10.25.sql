-- ADMINISTRACION DE BASES DE DATOS						FECHA: 02/10/2025
-- Perfiles y politicas de seguridad?					

-- Politicas de seguridad para usuarios 
-- CHECK_POLICY = ON (aplica reglas de Windows).
-- CHECK_EXPIRATION = ON (caducidad de contrase�a).?

-- SQL Audit

-- Mecanismo de SQL Server para auditar
-- Para cumplimiento normativo, control de acceso y datos, deteccion de actividad sospechosa

/*La auditoria unicamente debe activarse para los elementos escenciales 
ya que consume muchos recursos*/

/****************
	Pasos para crear una auditoria en SSMS (nivel gr�fico)

	Abrir el Explorador de Objetos
	En SSMS, conecta tu instancia de SQL Server.

	Ir a la carpeta de Auditoria
	En el panel izquierdo:

	Expande Seguridad (Security)

	Haz clic derecho en Auditorias (Audits) ? Nueva Auditoria (New Audit)

	Configurar la Auditoria
	En la ventana emergente:

	Asigna un nombre a la auditor�a.

	Selecciona el destino donde se guardar�n los registros:

	Archivo (File): se guarda en el disco.

	Seguridad de la Aplicaci�n de Windows.

	Registro de eventos de Windows (Application o Security Log).

	Define la ruta o ubicaci�n de archivo si elegiste File.

	Opcional: configura m�ximo tama�o de archivo, rollover y retenci�n.

	Presiona Aceptar.

	! POR DEFECTO APARECE DESHABILITADO HAY QUE HABILITARLO

	Click derecho sobre Auditoria_Basica opcion Enable y habilitar 


************/

USE master?
GO?

-- Crear una auditor�a que guarda eventos en un archivo?
CREATE SERVER AUDIT AuditoriaBasica?
TO FILE (FILEPATH = 'C:\SQLAudit\Abasica', MAXSIZE = 10 MB, MAX_FILES = 5)?
WITH (ON_FAILURE = CONTINUE);?
GO?

-- Activar la auditor�a?
ALTER SERVER AUDIT AuditoriaBasica WITH (STATE = ON);?
GO

CREATE DATABASE miDB;?
USE miDB;?
GO??

CREATE TABLE Empleados (?
    Id INT PRIMARY KEY, 
	Nombre NVARCHAR(100),  
	Salario DECIMAL(10,2)?
);?
?
INSERT INTO Empleados VALUES (1, 'Ana L�pez', 1200.00);?
INSERT INTO Empleados VALUES (2, 'Carlos P�rez', 1500.00);

-- ESPECIFICACION DE AUDITORIA PARA BASE DE DATOS
-- Crear especificaci�n para registrar SELECT, INSERT y DELETE en una tabla sensible?
CREATE DATABASE AUDIT SPECIFICATION AuditoriaBasicaDB?
FOR SERVER AUDIT Auditoria_Basica?
ADD (SELECT, INSERT, DELETE ON dbo.Empleados BY PUBLIC);
GO??

-- Activar la especificaci�n?
ALTER DATABASE AUDIT SPECIFICATION AuditoriaBasicaDB?
WITH (STATE = ON);?
GO

-- Probar la configuraci�n de la auditor�a?
SELECT * FROM Empleados;?

INSERT INTO Empleados VALUES (3, 'Mar�a Torres', 2000.00);?
DELETE FROM Empleados WHERE Id = 1;?

-- Consultar los registros de auditor�a?
SELECT *?
FROM sys.fn_get_audit_file('C:\SQLAudit\Abasica\*', DEFAULT, DEFAULT);

-- IDEAS PARA EL PROYECTO: ENTREGAR EL BACKUP DE LA BASE DE DATOS Y AUDITORIA
SELECT?
  event_time,?
  action_id,?
  succeeded,?
  server_principal_name,?
  database_name,?
  schema_name, object_name,?
  statement,?
  additional_information?
FROM sys.fn_get_audit_file('C:\SQLAudit\Abasica\*', DEFAULT, DEFAULT)?
ORDER BY event_time DESC;