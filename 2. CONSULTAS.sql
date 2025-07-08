EXAMEN 2024 A:
-- 2.1. Devuelva el nombre del producto, nombre del tipo de producto, y precio unitario al que se 
-- vendieron los productos digitales 
SELECT p.nombre, tp.nombre,  lp.precio
FROM productos p
JOIN tiposproducto tp ON p.tipoProductoId = tp.id
JOIN lineaspedido lp ON lp.productoId = p.id
WHERE tp.nombre = 'Digitales';

-- 2.2. Consulta que devuelva el nombre del empleado, el número de pedidos de más de 500 euros 
-- gestionados en este año y el importe total de cada uno de ellos, ordenados de mayor a menor 
-- importe gestionado. Los empleados que no hayan gestionado ningún pedido, también deben 
-- aparecer. 
-- Subconsulta: pedidos válidos (>500€, este año) con su total
SELECT e.nombre AS nombre_empleado, COUNT(DISTINCT p.id) AS num_pedidos_mayores_500, COALESCE(SUM(p.total), 0) AS importe_total_gestionado
FROM Empleados e
LEFT JOIN ( SELECT p.id, p.empleadoId, SUM(lp.cantidad * lp.precioUnitario) AS total
    FROM Pedidos p
    JOIN LineasPedido lp ON lp.pedidoId = p.id
    WHERE YEAR(p.fecha) = YEAR(CURDATE())
    GROUP BY p.id, p.empleadoId
    HAVING total > 500
) p ON e.id = p.empleadoId
    
GROUP BY e.id, e.nombre
ORDER BY importe_total_gestionado DESC;


EXAMEN 2024 B:

-- 2.1. Devuelva el nombre del del empleado, la fecha de realización del pedido y el nombre del cliente 
-- de todos los pedidos realizados este mes. EJEMPLO DE COGER 2 NOMBRES DISTINTOS. IMPORTANTE.

SELECT u2.nombre AS nombreEmpleado, p.fechaRealizacion, u.nombre AS nombreCliente
FROM pedidos p
JOIN clientes c ON p.clienteId = c.id
JOIN usuarios u ON u.id = c.usuarioId
LEFT JOIN empleados e ON p.empleadoId = e.id
LEFT JOIN usuarios u2 ON u2.id = e.usuarioId
WHERE MONTH(p.fechaRealizacion) = MONTH(CURDATE());

-- 2.2. Devuelva el nombre, las unidades totales pedidas y el importe total gastado de aquellos clientes 
-- que han realizado más de 5 pedidos en el último año.

SELECT u.nombre, SUM(lp.unidades) AS unidadesPedidas, SUM(lp.precio * lp.unidades) AS importeGastado
FROM lineaspedido lp 
JOIN pedidos ped ON ped.id = lp.pedidoId
JOIN clientes c ON c.id = ped.clienteId
JOIN usuarios u ON u.id = c.usuarioId
WHERE YEAR(ped.fechaRealizacion) = YEAR(CURDATE())-1
GROUP BY u.nombre, c.id
HAVING COUNT(DISTINCT ped.id) > 5;


EXAMEN 2024 C:

-- 2.1. Devuelva el nombre del producto, el precio unitario y las unidades compradas para las 5 líneas 
-- de pedido con más unidades. 

SELECT prod.nombre, lp.precio, lp.unidades 
FROM productos prod
JOIN lineaspedido lp ON lp.productoId = prod.id
ORDER BY unidades DESC 
LIMIT 5;

-- 2.2. Devuelva el nombre del empleado, la fecha de realización del pedido, el precio total del pedido y 
-- las unidades totales del pedido para todos los pedidos que de más 7 días de antigüedad desde que 
-- se realizaron. Si un pedido no tiene asignado empleado, también debe aparecer en el listado 
-- devuelto. 

SELECT u.nombre, p.fechaRealizacion, SUM(lp.unidades* lp.precio) AS PrecioTotal, SUM(lp.unidades) AS UnidadesTotalesPedido
FROM pedidos p
LEFT JOIN empleados e ON p.empleadoId = e.id
LEFT JOIN usuarios u ON u.id = e.usuarioId
JOIN lineaspedido lp ON lp.pedidoId = p.id
WHERE TIMESTAMPDIFF(DAY,p.fechaRealizacion, CURDATE()) > 7
GROUP BY lp.pedidoId;

EXAMEN 2020:
-- 4. Cree una consulta que devuelva el nombre del grado, el nombre de la asignatura, el número de créditos de la 
-- asignatura y su tipo, para todas las asignaturas que pertenecen a todos los grados. Ordene los resultados por el nombre del grado.
SELECT d.`name`, s.`name`, s.credits, s.`type`
FROM `degrees` d
JOIN subjects s ON d.degreeId = s.degreeId
ORDER BY d.`name`;

-- 5. Cree una consulta que devuelva la nota media del grupo cuyo ID=2
SELECT AVG(gr.`value`) AS NotaMediaGrupo2
FROM `groups` g
JOIN grades gr ON gr.groupId = g.groupId
WHERE gr.groupId = 2;

-- 6. Cree una consulta que devuelva la nota media de cada grupo, ordenados por su nota media de mayor a menor.
SELECT gr.groupId, AVG(gr.`value`) AS NotasMedias
FROM `groups` g
JOIN grades gr ON gr.groupId = g.groupId
GROUP BY gr.groupId
ORDER BY NotasMedias DESC;

-- 7. Cree una consulta que devuelva la nota más alta y la nota más baja de cada grupo de Teoría de la asignatura con D=1
SELECT gr.groupId, MAX(gr.`value`) AS MaxGrade, MIN(gr.`value`) AS MinGrade  
FROM `groups` g
JOIN grades gr ON gr.groupId = g.groupId
WHERE gr.groupId = 1 AND g.activity = 'Teoria';

-- 8. Cree una consulta que devuelva el nombre y los apellidos del estudiante que ha sacado la nota más alta del grupo con ID=10
SELECT  s.firstName, s.surname
FROM `groups` g
JOIN grades gr ON gr.groupId = g.groupId
JOIN students s ON s.studentId = gr.studentId
WHERE gr.groupId = 10
ORDER BY gr.`value` DESC 							
LIMIT 1;

