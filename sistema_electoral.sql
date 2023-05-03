-- TODO: Crear una base de datos llamada "sistema_electoral" que contenga las siguientes tablas: votantes(id, nombre, apellido, dni) - partidos_politicos(id, nombre, lider, ideologia) - candidatos (id, nombre, apellido, id_partido) - votos(id, id_votante, id_candidato, fecha).

DROP DATABASE sistema_electoral;
CREATE DATABASE sistema_electoral;

CREATE TABLE votantes(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    dni VARCHAR(10) NOT NULL
);

CREATE TABLE partidos_politicos(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    lider VARCHAR(50) NOT NULL,
    ideologia VARCHAR(100) NOT NULL
);

CREATE TABLE candidatos(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    id_partido INT,
    FOREIGN KEY (id_partido) REFERENCES partidos_politicos(id)
);

CREATE TABLE votos(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_votante INT,
    id_candidato INT,
    FOREIGN KEY (id_votante) REFERENCES votantes(id),
    FOREIGN KEY (id_candidato) REFERENCES candidatos(id),
    fecha date
);

DELIMITER $$
CREATE PROCEDURE insertar_votante(nombre VARCHAR(50), apellido VARCHAR(50), dni VARCHAR(10))
BEGIN
    INSERT INTO votantes(nombre, apellido, dni)
    VALUES (nombre, apellido, dni);
END$$

CREATE PROCEDURE insertar_partido_politico(nombre VARCHAR(50), lider VARCHAR(50), ideologia VARCHAR(100))
BEGIN
    INSERT INTO partidos_politicos(nombre, lider, ideologia) 
    VALUES (nombre, lider, ideologia);
END$$

CREATE PROCEDURE insertar_candidato(nombre VARCHAR(50), apellido VARCHAR(50), id_partido INT)
BEGIN
    INSERT INTO candidatos(nombre, apellido, id_partido)
    VALUES (nombre, apellido, id_partido);
END$$

CREATE PROCEDURE insertar_voto(id_votante INT, id_candidato INT)
BEGIN
    INSERT INTO votos(id_votante, id_candidato, fecha)
    VALUES (id_votante, id_candidato, Now());
END$$

DELIMITER ;

-- TODO: Insertar algunos datos en cada tabla.

CALL insertar_votante('Helena', 'Gago', '40544837');
CALL insertar_votante('Marcela', 'Armas', '44606366');
CALL insertar_votante('Modesto', 'Espinoza', '42748443');
CALL insertar_votante('Elisabeth', 'Labrador', '46222906');
CALL insertar_votante('Santos', 'Lara Rebollo', '44248687');
CALL insertar_votante('Sebastián', 'de Narváez', '41487899');
CALL insertar_votante('Alejandro', 'Castañeda', '42545848');
CALL insertar_votante('Carlos', 'Izaguirre', '41331230');
CALL insertar_votante('Priscila', 'Pomares', '49240632');
CALL insertar_votante('Eduardo', 'Barba', '49370987');

CALL insertar_partido_politico('Partido Progresista Unido', 'Ana Sánchez', 'Socialismo Democrático');
CALL insertar_partido_politico('Alianza Nacional Conservadora', 'Juan Rodríguez', 'Conservadurismo Nacionalista');
CALL insertar_partido_politico('Partido Verde Ecologista', 'María González', 'Ecologismo y Sustentabilidad');
CALL insertar_partido_politico('Movimiento Democrático Liberal', 'Carlos Martínez', 'Liberalismo Progresista');

CALL insertar_candidato('Ana', 'Sánchez', 1);
CALL insertar_candidato('Luis', 'Ramírez', 1);
CALL insertar_candidato('Juan', 'Rodríguez', 2);
CALL insertar_candidato('Gabriela', 'Morales', 2);
CALL insertar_candidato('María', 'González', 3);
CALL insertar_candidato('Javier', 'Pérez', 3);
CALL insertar_candidato('Carlos', 'Martínez', 4);
CALL insertar_candidato('Laura', 'Torres', 4);

CALL insertar_voto(1, 1);
CALL insertar_voto(2, 2);
CALL insertar_voto(3, 3);
CALL insertar_voto(4, 4);
CALL insertar_voto(5, 5);
CALL insertar_voto(6, 7);
CALL insertar_voto(7, 7);
CALL insertar_voto(8, 3);
CALL insertar_voto(9, 1);
CALL insertar_voto(10, 1);

-- TODO: Crear una consulta que muestre todos los votantes registrados en la base de datos.

SELECT * FROM votantes;

-- TODO: Crear una consulta que muestre todos los partidos políticos registrados en la base.

SELECT * FROM partidos_politicos;

-- TODO: Crear una consulta que muestre todos los candidatos registrados en la base de datos, con su respectivo partido político.

SELECT c.nombre, c.apellido, p.nombre AS partido_politico
FROM candidatos c
JOIN partidos_politicos p ON c.id_partido = p.id;

-- TODO: Crear una consulta que muestre todos los votos registrados en la base de datos.

SELECT v.nombre AS nombre_votante, v.apellido AS apellido_votante, c.apellido AS candidato_apellido  
FROM votos
JOIN votantes v ON votos.id_votante = v.id
JOIN candidatos c ON votos.id_candidato = c.id;

-- TODO: Crear una función que permita calcular la cantidad de votos que ha recibido un candidato determinado.

DELIMITER $$
CREATE FUNCTION calcular_votos_candidato(id_candidato INT)
RETURNS INT
BEGIN
    DECLARE cantidad_votos INT;

    SELECT COUNT(id) INTO cantidad_votos
    FROM votos 
    WHERE votos.id_candidato = id_candidato;

    RETURN cantidad_votos;
END$$

CREATE FUNCTION calcular_votos_partido_politico(id_partido INT)
RETURNS INT
BEGIN
    DECLARE cantidad_votos INT;

    SELECT COUNT(v.id) INTO cantidad_votos
    FROM votos v
    JOIN candidatos c ON v.id_candidato = c.id 
    JOIN partidos_politicos p ON c.id_partido = p.id
    WHERE p.id = id_partido;

    RETURN cantidad_votos;
END$$
DELIMITER ;

-- TODO: Crear un disparador que se active cada vez que se inserte un nuevo voto en la tabla "votos" y que actualice la cantidad de votos recibidos por el candidato correspondiente en la tabla "candidatos".

ALTER TABLE candidatos
ADD COLUMN votos_recibidos INT DEFAULT 0 NOT NULL;

DELIMITER $$
CREATE PROCEDURE actualizar_votos()
BEGIN
    UPDATE candidatos
    SET votos_recibidos = calcular_votos_candidato(id);
END$$

CREATE TRIGGER tr_actualizar_votos AFTER INSERT ON votos
FOR EACH ROW
BEGIN
    CALL actualizar_votos;
END$$
DELIMITER ;

-- TODO: Crear una consulta que muestre los resultados de una votación, indicando la cantidad de votos recibidos por cada candidato y por cada partido político.

SELECT c.nombre, c.apellido, p.nombre, calcular_votos_candidato(c.id) AS cantidad_votos
FROM candidatos c
JOIN partidos_politicos p ON c.id_partido = p.id
ORDER BY cantidad_votos DESC;

SELECT p.nombre, calcular_votos_partido_politico(p.id) AS cantidad_votos  
FROM partidos_politicos p
ORDER BY cantidad_votos DESC;

-- TODO: Crear un procedimiento almacenado que permita eliminar un votante de la tabla "votantes" y todos sus votos correspondientes en la tabla "votos".

DELIMITER $$
CREATE PROCEDURE eliminar_votante(id_votante INT)
BEGIN
    DELETE FROM votantes WHERE votantes.id = id_votante;
    DELETE FROM votos WHERE votos.id_votante = id_votante; 
END$$
DELIMITER ;

-- TODO: Crear una consulta que muestre el candidato ganador de la elección.

SELECT c.nombre, c.apellido, p.nombre, calcular_votos_candidato(c.id) AS cantidad_votos
FROM candidatos c
JOIN partidos_politicos p ON c.id_partido = p.id
ORDER BY cantidad_votos DESC
LIMIT 1;

-- TODO: Crear una consulta que muestre el partido político con más votos en la elección

SELECT p.nombre, calcular_votos_partido_politico(p.id) AS cantidad_votos  
FROM partidos_politicos p
ORDER BY cantidad_votos DESC
LIMIT 1; 

-- TODO: Crear un disparador que se active cada vez que se inserte un nuevo voto en la tabla "votos" y verifique que el votante correspondido no haya votado anteriormente en la misma elección.

DELIMITER $$
CREATE TRIGGER verificar_votante BEFORE INSERT ON votos
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM votos WHERE id_votante = NEW.id_votante) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El votante ya tiene un registro en la tabla votos';
    END IF;
END$$
DELIMITER ;

-- TODO: Crear un procedimiento almacenado que permita registrar un nuevo partido político en la tabla "partidos_politicos", con la posibilidad de agregar varios candidatos de una sola vez en la tabla "candidatos".

DELIMITER $$
CREATE PROCEDURE insertar_partido_politico_con_candidatos(nombre_partido VARCHAR(50), lider VARCHAR(50), ideologia VARCHAR(50), nombre_candidato VARCHAR(50), apellido_candidato VARCHAR(50))
BEGIN
    DECLARE id_partido INT;
    DECLARE nombre_lider VARCHAR(50);
    DECLARE apellido_lider VARCHAR(50);

    INSERT INTO partidos_politicos(nombre, lider, ideologia)
    VALUES (nombre_partido, lider, ideologia);

    SET id_partido = LAST_INSERT_ID();

    SELECT SUBSTRING_INDEX(lider, ' ', 1) INTO nombre_lider
    FROM partidos_politicos
    WHERE id = LAST_INSERT_ID();

    SELECT SUBSTRING_INDEX(lider, ' ', -1) INTO apellido_lider
    FROM partidos_politicos
    WHERE id = LAST_INSERT_ID();

    INSERT INTO candidatos(nombre, apellido, id_partido)
    VALUES (nombre_lider, apellido_lider, id_partido), 
    (nombre_candidato, apellido_candidato, id_partido);
END$$
DELIMITER ;

CALL insertar_partido_politico_con_candidatos('Partido Libertario', 'George Clinton', 'Girando hacia la libertad', 'Moon', 'Bulsara');
CALL insertar_votante('Sandra', 'Golfieri', '47867129');
CALL insertar_voto(11, 10);
