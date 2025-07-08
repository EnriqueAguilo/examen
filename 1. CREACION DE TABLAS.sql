EXAMEN 2024 A:
-- Necesitamos conocer la garantía de nuestros productos. Para ello se propone la creación de una 
-- nueva tabla llamada Garantias. Cada producto tendrá como máximo una garantía (no todos los productos tienen garantía), 
-- y cada garantía estará relacionada con un producto. Para cada garantía necesitamos conocer la fecha de inicio de la 
-- garantía, la fecha de fin de la garantía, si tiene garantía extendida o no. 
-- Asegure que la fecha de fin de la garantía es posterior a la fecha de inicio.

CREATE OR REPLACE TABLE Garantias(
    id INT PRIMARY KEY AUTO_INCREMENT,
    productoId INT NOT NULL,
    fechaInicioGarantia DATE NOT NULL,
    fechaFinGarantia DATE NOT NULL,
    garantiaExtendida BOOLEAN DEFAULT FALSE, 

    CHECK (fechaInicioGarantia<fechaFinGarantia),
    FOREIGN KEY (productoId) REFERENCES productos(id)
);

EXAMEN 2024 B:
-- Necesitamos conocer los pagos que se realicen sobre los pedidos. Para ello se propone la creación de una nueva tabla llamada 
-- Pagos. Cada pedido podrá tener asociado varios pagos y cada pago solo corresponde con un pedido en concreto. 
-- Para cada pago necesitamos conocer la fecha de pago, la cantidad pagada (que no puede ser negativa) y si 
-- el pago ha sido revisado o no (por defecto no estará revisado).
    
CREATE OR REPLACE TABLE Pagos (
    id INT PRIMARY KEY AUTO_INCREMENT,	
    pedidoId INT NOT NULL,
    fechaPago DATE NOT NULL,
    cantidadPago DECIMAL(10,2) NOT NULL,
    pagoRevisado BOOLEAN NOT NULL DEFAULT FALSE,    
    FOREIGN KEY (pedidoId) REFERENCES pedidos(id),
    CONSTRAINT pagoMinimo CHECK (cantidadPago>=0)
    
);

EXAMEN 2024 C:
-- Necesitamos conocer la opinión de nuestros clientes sobre nuestros productos. Para ello se propone la creación de una nueva tabla llamada 
-- Valoraciones. Cada valoración versará sobre un producto y será realizada por un solo cliente. Cada producto podrá ser valorado por muchos 
-- clientes. Cada cliente podrá realizar muchas valoraciones. Un cliente no puede valorar más de una vez un mismo producto.  
-- Para cada valoración necesitamos conocer la puntuación de 1 a 5 (sólo se permiten enteros) y la fecha en que se realiza la valoración. 

CREATE OR REPLACE TABLE valoraciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    productoId INT NOT NULL,
    clienteId INT NOT NULL,
    puntuacion INT NOT NULL,
    fechaValoracion DATE NOT NULL,
    UNIQUE(clienteId, productoId),
    FOREIGN KEY (productoId) REFERENCES productos(id),
    FOREIGN KEY (clienteId) REFERENCES clientes(id)
);
