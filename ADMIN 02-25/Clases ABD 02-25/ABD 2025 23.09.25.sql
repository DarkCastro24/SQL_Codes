-- Administracion de bases de datos				Fecha: 25/09/2025

-- Autenticaciones: Windows y Autenticacion Mixta (SQL)

-- Se puede habilitar la autenticacion mixta 

-- Nos conectamos al SQL Server y seleccionamos el servidor 
-- Nos vamos a propiedades y seleccionamos el apartado de seguridad 
-- Marcamos donde dice Autenticacion de Windows y SQL Server 
-- Ahora a reiniciar el servidor con click derecho y restart sobre el servidor (primer elemento en el menu de la izquierda)


/*	LOGIN: ES LA CREDENCIAL DE ACCESO AL SERVIDOR */
-- Contiene el nombre de usuario y modo de autenticacion
-- UN LOGIN DA ACCESO AL SERVIDOR 
-- SE PUEDE CREAR DESDE CUALQUIER BASE DE DATOS 
-- SE GUARDA EN LA BASE DE DATOS MASTER 

/*
	CREATE LOGIN appUser ​
	WITH PASSWORD = 'AppUser2025!', ​
	CHECK_POLICY = ON, ​
	CHECK_EXPIRATION = ON;
*/

