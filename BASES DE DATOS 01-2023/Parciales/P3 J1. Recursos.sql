-- Ejercicio 1A
SELECT C.id 'id compra', SUM(TF.precio) 'subtotal funcion'
FROM COMPRA C, ENTRADA E, FUNCION F, TIPO_FUNCION TF
WHERE C.id = E.id_compra
	AND F.id = E.id_funcion
	AND TF.id = F.id_tipo
GROUP BY C.id, C.fecha, C.descuento
ORDER BY C.id ASC;


-- Ejercicio 2A
SELECT C.id 'id_compra', C.fecha 'fecha_compra', C.descuento, E.nombre 'nombre_empleado', isnull(dbo.SUBTOTAL_FUNCION(C.id),0) 'subtotal_factura'
		FROM COMPRA C
			INNER JOIN EMPLEADO E
				ON E.id = C.id_empleado
		WHERE CAST(C.fecha AS DATE) = CONVERT(DATE,'01-06-2023',103);
