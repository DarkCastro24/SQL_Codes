-- Ejercicio 2 
SELECT CONVERT(varchar,detalle_reserva.fecha,6) as 'Fecha' ,
SUM(detalle_reserva.total_reserva) 'Ganancia del dia'
FROM (
SELECT r.fecha, r.precio+ SUM(ISNULL(s.precio,0.0)) 'total_reserva'
FROM RESERVA r 
LEFT JOIN SERVICIOXRESERVA x ON r.id = x.id_reserva 
LEFT JOIN SERVICIO s ON s.id  = x.id_servicio
group by r.id, r.fecha,r.precio
) detalle_reserva
group by detalle_reserva.fecha

-- Ejercicio 3:
SELECT r.id 'id reserva', r.fecha , t.id 'Id clase', t.tipo_cabina,sub.total_reserva 'Total (sin impuesto)',
CASE
    WHEN t.id = 1 THEN sub.total_reserva + sub.total_reserva * CAST(0.07 AS FLOAT)
    WHEN t.id = 2 THEN sub.total_reserva + sub.total_reserva * CAST(0.11  AS FLOAT) 
	WHEN t.id = 3 THEN sub.total_reserva + sub.total_reserva * CAST(0.15 AS FLOAT) 
	WHEN t.id = 4 THEN sub.total_reserva + sub.total_reserva * CAST(0.20 AS FLOAT) 
END 'Total (con impuesto aplicado)'
FROM TIPO_CABINA t
INNER JOIN RESERVA r ON r.id_tipo_cabina = t.id
LEFT JOIN (
SELECT r.id, r.fecha, r.precio+ SUM(ISNULL(s.precio,0.0)) 'total_reserva'
FROM RESERVA r 
LEFT JOIN SERVICIOXRESERVA x ON r.id = x.id_reserva 
LEFT JOIN SERVICIO s ON s.id  = x.id_servicio
group by r.id, r.fecha,r.precio
) sub ON sub.id = r.id
ORDER BY r.id

