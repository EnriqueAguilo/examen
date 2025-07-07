EXAMEN 2024 A:

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
