/*Revisa el tipo de relación y crea el modelo correspondiente. Respeta las claves
primarias, foráneas y tipos de datos. */
CREATE TABLE peliculas(
id serial primary key,
nombre varchar(255),
anno int
);
CREATE TABLE tags(
id serial primary key,
tag varchar(32)
);
CREATE TABLE relacion(
id serial primary key,
peli_id int,
tag_id int,
FOREIGN KEY("peli_id")
	REFERENCES peliculas("id"),
FOREIGN KEY("tag_id")
	REFERENCES tags("id"
);
/* Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, la
segunda película debe tener 2 tags asociados.*/
INSERT INTO peliculas(nombre,anno)
VALUES ('matrix',2000),('tornado',2001),
('el dorado', 2004),('toy story', 2006),
('fortune',2010);
INSERT INTO tags(tag)
VALUES ('mejor pelicula'),('mejor trama'),
('maxima duracion'),('tiene secuela'),('no tiene secuela');
INSERT INTO relacion(peli_id,tag_id)
VALUES (1,1),(1,2),(1,3),(2,4),(2,5);
/* Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
mostrar 0.*/
SELECT p.nombre,COUNT(r.tag_id)
FROM peliculas as p
LEFT JOIN relacion as r
ON p.id=r.peli_id
GROUP BY p.nombre;
/* Crea las tablas correspondientes respetando los nombres, tipos, claves primarias y
foráneas y tipos de datos.*/
CREATE TABLE preguntas(
id serial primary key,
pregunta varchar(255),
respuesta_correcta varchar
);
CREATE TABLE usuarios(
id serial primary key,
nombre varchar(255),
edad int
);
CREATE TABLE respuestas(
id serial primary key,
respuesta varchar(255),
usuario_id int,
pregunta_id int,
FOREIGN KEY("usuario_id")
	REFERENCES usuarios("id"),
FOREIGN KEY("pregunta_id")
	REFERENCES preguntas("id")
);
/*Agrega 5 usuarios y 5 preguntas.*/
INSERT INTO preguntas(pregunta,respuesta_correcta)
VALUES ('La oración: “Yo limpio a Puerto Rico” es una proposición','cierto'),
(' La negación de: Yo me despierto en la mañana y doy gracias a
Dios es: Yo no me levanto en las mañanas y no doy gracias a
Dios.','falso'),('La proposición: “Que todo lo que respire alabe a Dios” es una
disyunción.','falso'),('La negación de “Todo lo que necesitas es amor” es “Algo que
necesitas no es amor.”','cierto'),
('Un teorema es una una proposición que se puede probar que es cierta','cierto');

INSERT INTO usuarios(nombre,edad)
VALUES ('Luis',22),('Daniel',21),('Sandra',20),('Iker',23),('Cris',24);

INSERT INTO respuestas(respuesta,usuario_id,pregunta_id)
VALUES ('cierto',1,1),('cierto',2,1),('falso',1,2),('cierto',1,3),('falso',1,4),
('falso',1,5),('falso',3,1),('falso',4,1),('falso',5,1),('cierto',2,2),('cierto',3,2),
('cierto',4,2),('cierto',5,2)
/*Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
pregunta).*/
SELECT u.nombre, COUNT(p.respuesta_correcta) as respuestas_correctas
FROM usuarios as u
LEFT JOIN respuestas as r
ON u.id = r.usuario_id
LEFT JOIN preguntas as p 
ON r.pregunta_id = p.id  AND r.respuesta=p.respuesta_correcta
GROUP BY u.nombre;
/*Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron
correctamente. */
SELECT p.id as pregunta, COUNT(r.id) as respuestas_correctas
FROM preguntas as p
LEFT JOIN respuestas as r
ON p.id = r.pregunta_id
WHERE p.respuesta_correcta=r.respuesta
GROUP BY p.id ;
/*Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la
implementación borrando el primer usuario. */
ALTER TABLE respuestas DROP CONSTRAINT respuestas_usuario_id_fkey,
ADD CONSTRAINT respuestas_usuario_id_fkey
FOREIGN KEY ("usuario_id") REFERENCES usuarios("id") ON DELETE CASCADE;

DELETE FROM usuarios WHERE id = 1;
/*Crea una restricción que impida insertar usuarios menores de 18 años en la base de
datos. */
ALTER TABLE usuarios 
ADD CHECK (edad>=18);
/*Altera la tabla existente de usuarios agregando el campo email. Debe tener la
restricción de ser único.*/
ALTER TABLE usuarios
ADD COLUMN email varchar(100) UNIQUE;
