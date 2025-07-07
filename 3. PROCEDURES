EXAMEN 2024 A:

DELIMITER //
CREATE OR REPLACE PROCEDURE actualizar_precio_producto(
    IN p_productoId INT,
    IN p_nuevoPrecio DECIMAL(10, 2)
)
BEGIN
  DECLARE v_precioActual DECIMAL(10,2);

  -- Manejo de errores: rollback ante cualquier excepción
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
      ROLLBACK;
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en la actualización del precio.';
  END;

  -- Iniciar transacción
  START TRANSACTION;

  -- Obtener precio actual
  SELECT precio INTO v_precioActual
  FROM productos
  WHERE id = p_productoId;

  -- Verificar reducción mayor al 50%
  IF p_nuevoPrecio < v_precioActual * 0.5 THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' 
      SET MESSAGE_TEXT = 'No se permite rebajar el precio más del 50%.';
  END IF;

  -- Actualizar el precio del producto
  UPDATE productos 
  SET precio = p_nuevoPrecio 
  WHERE id = p_productoId;

  -- Actualizar precio en líneas de pedido NO enviadas
  UPDATE lineaspedido lp
  JOIN pedidos p ON lp.pedidoId = p.id
  SET lp.precio = p_nuevoPrecio
  WHERE lp.productoId = p_productoId AND p.fechaEnvio IS NULL;

  -- Confirmar transacción
  COMMIT;
END //
DELIMITER ;


EXAMEN 2024 B:

-- Cree un procedimiento que permita crear un nuevo producto con posibilidad de que sea para regalo. 
-- Si el producto está destinado a regalo se creará un pedido con ese producto y costes 0€ para el 
-- cliente más antiguo. 

DELIMITER //
CREATE PROCEDURE insertar_producto_y_regalos(
    IN p_nombre VARCHAR(255),
    IN p_descripcion VARCHAR(255),
    IN p_precio DECIMAL(10,2),
    IN p_tipoProductoId INT,
    IN p_esParaRegalo BOOLEAN
)
-- incluya su solución a continuación
BEGIN 
	DECLARE v_productoId INT;
	DECLARE v_pedidoId INT;
	DECLARE v_clienteMasAntiguo INT;
	
	
	-- Manejo de errores
  	DECLARE EXIT HANDLER FOR SQLEXCEPTION
  	BEGIN
      ROLLBACK;
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al registrar el nuevo producto';
  	END;

  	-- Iniciar transacción
  	START TRANSACTION;
  	
	-- Cliente más antiguo
	SELECT c.id INTO v_clienteMasAntiguo
	FROM pedidos p3
	JOIN clientes c  ON c.id = p3.clienteId 
	ORDER BY p3.fechaRealizacion ASC 
	LIMIT 1;
	
  	IF p_esParaRegalo = TRUE THEN
  		IF p_precio > 50 THEN 
  			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite crear un producto para regalo de más de 50€.';
  		END IF;
	END IF;
	
	INSERT INTO productos(nombre, descripción, precio, tipoProductoId)
	VALUES (p_nombre, p_descripción, p_precio, p_tipoProductoId);
	
	SET v_productoId = LAST_INSERT_ID();
	
	IF p_esParaRegalo = TRUE THEN
  		INSERT INTO pedidos(fechaRealizacion, fechaEnvio, direccionEntrega, comentarios, clienteId)
		VALUES (CURDATE(),CURDATE(),'direccion si','regalito', v_clienteMasAntiguo);
		
		SET v_pedidoId = LAST_INSERT_ID();
		
		INSERT INTO lineaspedido(pedidoId, productoId,unidades, precio)
		VALUES (v_pedidoId, v_productoId, 1, 0);
		
	END IF;
	
	-- Confirmar transacción
  COMMIT;
END//
-- fin de su solución
DELIMITER ;

EXAMEN 2024 C:

DELIMITER //
CREATE OR REPLACE PROCEDURE bonificar_pedido_retrasado(IN p_pedidoId INT)
BEGIN
		DECLARE v_empleadoACargoPedido INT;
		
		-- Manejo de errores
	  DECLARE EXIT HANDLER FOR SQLEXCEPTION
	  BEGIN
	      ROLLBACK;
	      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en la bonificacion';
	  END;
	
	  -- Iniciar transacción
	  START TRANSACTION;
	  
	  -- Consigo el empleado a cargo del pedido
	  SELECT p.empleadoId INTO v_empleadoACargoPedido
	  FROM pedidos p
	  WHERE p.id = p_pedidoId;
	  
	  -- Compruebo si hay gestor
	  IF v_empleadoACargoPedido IS NULL THEN
	  		ROLLBACK;
      	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pedido no tiene gestor.';
   	END IF; 
  		
	   UPDATE pedidos SET empleadoId=2 WHERE id = p_pedidoId;
	   UPDATE lineaspedido SET precio= precio * 0.8 WHERE pedidoId = p_pedidoId;

		-- Confirmar transacción
  		COMMIT;

END //
DELIMITER ;
