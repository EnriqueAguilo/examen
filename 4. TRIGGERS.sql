EXAMEN 2024 A:
-- Cree un trigger llamado t_asegurar_mismo_tipo_producto_en_pedidos que impida que, a partir de 
-- ahora, un mismo pedido incluya productos físicos y digitales.
DELIMITER //
CREATE OR REPLACE TRIGGER t_asegurar_mismo_tipo_producto_en_pedidos
BEFORE INSERT ON LineasPedido
FOR EACH ROW
BEGIN
    DECLARE v_tipoProductoNuevo INT;
    DECLARE v_cantidadTipoProductoOpuesto INT;

    -- Obtener el tipo de producto del nuevo producto
    SELECT p.tipoProductoId INTO v_tipoProductoNuevo
    FROM Productos p
    WHERE p.id = NEW.productoId;

    -- Contar cuántos productos de tipo distinto hay en el mismo pedido
    SELECT COUNT(*) INTO v_cantidadTipoProductoOpuesto
    FROM LineasPedido lp
    JOIN Productos p ON p.id = lp.productoId
    WHERE lp.pedidoId = NEW.pedidoId AND p.tipoProductoId != v_tipoProductoNuevo;

    -- Si hay productos de tipo distinto error
    IF v_cantidadTipoProductoOpuesto > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'En un mismo pedido no puede haber productos físicos y digitales';
    END IF;
END;
//

DELIMITER ;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
EXAMEN 2024 B:

-- Cree un trigger llamado t_limitar_importe_pedidos_de_menores que impida que, a partir de ahora, 
-- los pedidos realizados por menores superen los 500€. 

DELIMITER //
CREATE TRIGGER t_limitar_importe_pedidos_de_menores
AFTER INSERT ON lineaspedido
FOR EACH ROW
BEGIN
    DECLARE v_fechaNacimiento DATE;
    DECLARE v_importePedido DECIMAL(10,2);
    DECLARE v_clienteId INT;

    -- Obtener el cliente asociado al pedido
    SELECT p.clienteId INTO v_clienteId
    FROM pedidos p
    WHERE p.id = NEW.pedidoId;

    -- Obtener fecha de nacimiento del cliente
    SELECT c.fechaNacimiento INTO v_fechaNacimiento
    FROM clientes c
    WHERE c.id = v_clienteId;

    -- Calcular el importe total del pedido
    SELECT COALESCE(SUM(lp.unidades * lp.precio), 0) INTO v_importePedido
    FROM lineaspedido lp
    WHERE lp.pedidoId = NEW.pedidoId;

    -- Validar si el cliente es menor y el importe supera los 500€
    IF TIMESTAMPDIFF(YEAR, v_fechaNacimiento, CURDATE()) < 18 AND v_importePedido > 500 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un menor de edad no puede realizar un pedido de más de 500€';
    END IF;
END;
//
DELIMITER ;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
EXAMEN 2024 C:
--Cree un trigger llamado p_limitar_unidades_mensuales_de_productos_fisicos que, a partir de este 
--momento, impida la venta de más de 1000 unidades al mes de cualquier producto físico. 

DELIMITER //
CREATE OR REPLACE TRIGGER p_limitar_unidades_mensuales_de_productos_fisicos
BEFORE INSERT ON LineasPedido
FOR EACH ROW
BEGIN
    DECLARE v_tipoNombre VARCHAR(50);
    DECLARE v_totalUnidades INT DEFAULT 0;

    -- Obtener el tipo del producto
    SELECT tp.nombre INTO v_tipoNombre
    FROM productos p
    JOIN tiposproducto tp ON tp.id = p.tipoProductoId
    WHERE p.id = NEW.productoId;

    -- Solo si el producto es físico, calcular las unidades vendidas este mes
    IF v_tipoNombre = 'Físicos' THEN
        SELECT COALESCE(SUM(lp.unidades), 0) INTO v_totalUnidades
        FROM lineaspedido lp
        JOIN pedidos ped ON ped.id = lp.pedidoId
        WHERE lp.productoId = NEW.productoId
          AND MONTH(ped.fechaRealizacion) = MONTH(CURDATE())
          AND YEAR(ped.fechaRealizacion) = YEAR(CURDATE());

        IF v_totalUnidades + NEW.unidades > 1000 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se pueden vender más de 1000 unidades de productos físicos al mes';
        END IF;
    END IF;
END;
//
DELIMITER ;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
