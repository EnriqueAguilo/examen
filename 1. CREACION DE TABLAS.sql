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

EXAMEN 2020:
-- Añada el requisito de información Beca. Una beca es una ayuda económica que recibe un estudiante para realizar 
-- sus estudios en un año académico particular. Sus atributos son: el estudiante beneficiario de la beca, la cuantía 
-- de la beca, el año académico, la fecha de inicio y la duración en meses. Hay que tener en cuenta las siguientes restricciones:
-- Un estudiante sólo puede ser beneficiario de una beca para un año académico, pero puede tener varias si son en distintos 
-- cursos académicos. La cuantía de la beca no puede ser inferior a 500€ ni superior a 2500€.
-- Todos los atributos son obligatorios salvo la fecha de inicio y la duración
CREATE OR REPLACE TABLE Beca (
    id INT PRIMARY KEY AUTO_INCREMENT,
    studentId INT NOT NULL,
    anyoBeca YEAR NOT NULL,
    cuantiaBeca INT NOT NULL,
    fechaInicio DATE,
    mesesDuracion INT,
    UNIQUE(studentId, anyoBeca),
    CONSTRAINT cuantiaRestriccion CHECK (cuantiaBeca >=500 AND cuantiaBeca <=2500),    
    FOREIGN KEY (studentId) REFERENCES students(studentId)
);

