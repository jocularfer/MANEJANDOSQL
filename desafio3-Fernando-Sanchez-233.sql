/*Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo
pedido.*/
CREATE TABLE Usuarios (id serial, rol varchar(50),
					   nombre varchar (30), apellido varchar(40),
					  email varchar (70));
					  
INSERT INTO Usuarios (rol,nombre,apellido,email)
VALUES ('administrador','Luis','Sanchez','ls@gmail.com'),
('usuario','Daniel','Sanchez','ds@gmail.com'),
('usuario','Sandra','Munoz','sm@gmail.com'),
('usuario','Daniel','Romero','dr@gmail.com'),
('usuario','Katya','Napoles','kn@gmail.com');

CREATE TABLE Posts (id serial, fecha_creacion timestamp,
				   fecha_actualizacion timestamp,
				   destacado boolean, usuario_id bigint,
				   titulo varchar (70), contenido text);

INSERT INTO Posts (fecha_creacion,fecha_actualizacion,destacado,
				  usuario_id,titulo,contenido)
VALUES ('2020-05-18','2021-05-18','FALSE',1,'Comida Mexicana','La comida mexicana es basta y rica ....'),
('2020-03-22','2021-03-22','TRUE',1,'Cultura Mexicana','La cultura mexicana es extensa y se divide por regiones ....'),
('2021-08-10','2022-08-10','FALSE',2,'Comida Chilena','La comida chilena es basta y rica como los completos....'),
('2022-02-05','2023-02-05','TRUE',3,'Cultura Chilena','La cultura chilena es hermosa y bastante apreciada ....'),
('2022-01-08','2023-01-08','FALSE',NULL,'Comida Mexicana','La comida mexicana es basta y rica ....');

CREATE TABLE Comentarios (id serial, fecha_creacion timestamp,
				   usuario_id bigint, contenido text, 
					post_id bigint);

INSERT INTO Comentarios (fecha_creacion,usuario_id,contenido,post_id)
VALUES ('2023-01-01',1,'Me parece que falta actualizar contenido',1),
('2022-03-21',2,'Me parece que falta simplificar cobntenido',1),
('2023-01-12',3,'Me parece que falta poner las nuevas creaciones culinarias',1),
('2023-04-11',1,'Me parece que hay culturas que no se mencionan',2),
('2023-05-17',2,'Me parece que falta actualizar contenido',2);

/*Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas.
nombre e email del usuario junto al título y contenido del post.*/
SELECT U.nombre,U.email,Po.titulo,Po.contenido
FROM Usuarios AS U
INNER JOIN Posts AS Po
ON U.id=Po.usuario_id;

/*Muestra el id, título y contenido de los posts de los administradores. El
administrador puede ser cualquier id.*/
SELECT Po.id,Po.titulo,Po.contenido
FROM Usuarios AS U
INNER JOIN Posts AS Po
ON U.id=Po.usuario_id
WHERE U.rol='administrador';

/*Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id
e email del usuario junto con la cantidad de posts de cada usuario.*/
SELECT U.id AS Numero_usuario,U.email, COUNT(Po.usuario_id) AS Cantidad_post
FROM Usuarios AS U
LEFT JOIN Posts AS Po
ON U.id=Po.usuario_id
GROUP BY U.id,U.email;

/*Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene
un único registro y muestra solo el email.*/
SELECT U.email, COUNT(Po.usuario_id) AS Cantidad_post
FROM Usuarios AS U
INNER JOIN Posts AS Po
ON U.id=Po.usuario_id
GROUP BY U.email
HAVING COUNT(Po.usuario_id)=(SELECT MAX(Cantidad_post) FROM (SELECT COUNT(usuario_id) AS Cantidad_post FROM Posts GROUP BY usuario_id) AS subquery);

/*Muestra la fecha del último post de cada usuario.*/
SELECT U.nombre, MAX(Po.fecha_creacion) AS ultimo_post
FROM Usuarios AS U
INNER JOIN Posts AS Po
ON U.id=Po.usuario_id
GROUP BY U.nombre;

/* Muestra el título y contenido del post (artículo) con más comentarios.*/
SELECT Po.titulo,Po.contenido, COUNT(Co.post_id) AS Cantidad_comentarios
FROM Posts AS Po
INNER JOIN Comentarios AS Co
ON Po.id=Co.post_id
GROUP BY Po.titulo,Po.contenido
HAVING COUNT(Co.post_id)=(SELECT MAX(Cantidad_comentarios) 
						  FROM (SELECT COUNT(post_id) AS Cantidad_comentarios 
								FROM Comentarios GROUP BY post_id) AS subquery);

/*Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
de cada comentario asociado a los posts mostrados, junto con el email del usuario
que lo escribió.*/
SELECT Po.titulo,Po.contenido, Co.contenido, U.email
FROM Posts AS Po
INNER JOIN Comentarios AS Co
ON Po.id=Co.post_id
INNER JOIN Usuarios AS U
ON U.id=Co.usuario_id;

/*Muestra el contenido del último comentario de cada usuario.*/
SELECT U.nombre, U.apellido, Co.contenido AS ultimo_comentario
FROM Usuarios U
INNER JOIN Comentarios Co ON U.id = Co.usuario_id
WHERE Co.fecha_creacion = (
  SELECT MAX(fecha_creacion)
  FROM Comentarios
  WHERE usuario_id = U.id
);

/*Muestra los emails de los usuarios que no han escrito ningún comentario.*/
SELECT U.email
FROM Usuarios AS U
LEFT JOIN Comentarios AS Co ON U.id = Co.usuario_id
GROUP BY U.email
HAVING COUNT(Co.id) = 0;