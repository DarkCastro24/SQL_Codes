/*
	Herramientas para solucionar problemas de rendimiento en SQL Server			Fecha: 30/10/2025

	Los problemas de rendimiento generan perdidas monetarias $$

	Metodologia del diagnostico 
	Observar Que pasa
	Medir Cuanto esta pasando 
	Analizar Porque esta pasando 
	Actuar Como lo solucionamos

	Un sintoma puede ser que el servidor este lento y cual es la accion que hacemos agregar mas ram

	Diagnostico correcto: El servidor esta lento, Wait Stats muestran PAGEIOLATCH_SH, causa raiz disco duro lento y sin indices

	Waits mas comunes (top 5)

	PAGEIOLATCH_SH / PAGEIOLATCH_EX
	Esperando leer/escribir paginas de disco }
	Causa: Disco lento HDD, Memoria insuficiente, Queries sin indices
	*Agregar indices, Aumentar memoria, Disco mas rapido SSD
*/

-- Caja negra de rendimiento de consultas introducida en SQL Server 2016.
ALTER DATABASE Northwnd
SET QUERY_STORE = ON (​
  OPERATION_MODE = READ_WRITE,​
  MAX_STORAGE_SIZE_MB = 1024,​
  QUERY_CAPTURE_MODE = AUTO​
);

/*
	Despues agrega las windows functions que pidio en clase
*/
