-- Crea database

CREATE DATABASE desafio3_esteban_lorca_123;

-- Crea tabla Usuarios. 
-- SELECT * FROM Usuarios;

CREATE TABLE Usuarios (
   id SERIAL PRIMARY KEY,
   email VARCHAR(100) UNIQUE NOT NULL,
   nombre VARCHAR(50) NOT NULL,
   apellido VARCHAR(50) NOT NULL,
   rol VARCHAR(20) NOT NULL
);

-- Se crean 5 usuarios.

insert into Usuarios (email, nombre, apellido, rol) values ('eatlee0@topsy.com', 'Elsbeth', 'Atlee', 'usuario');
insert into Usuarios (email, nombre, apellido, rol) values ('cphare1@last.fm', 'Caresa', 'Phare', 'administrador');
insert into Usuarios (email, nombre, apellido, rol) values ('omccarney2@ebay.co.uk', 'Oliviero', 'McCarney', 'usuario');
insert into Usuarios (email, nombre, apellido, rol) values ('arecords3@seattletimes.com', 'Al', 'Records', 'usuario');
insert into Usuarios (email, nombre, apellido, rol) values ('eflute4@prnewswire.com', 'Elton', 'Flute', 'usuario');

-- Crea tabla Posts (artículos). Se sigue el nombre según esta explicito en la guía, pero un nombre así se presta a problemas futuros; aunque quisiera llamar la tabla "posts", se siguen instrucciones como estan escritas. 
-- Se deja la columna usuario_id sin NOT NULL para efectos del ejercicio
-- SELECT * FROM "Posts (artículos)";


CREATE TABLE "Posts (artículos)" (
   id SERIAL PRIMARY KEY,
   titulo VARCHAR(200) NOT NULL,
   contenido TEXT NOT NULL,
   fecha_creacion TIMESTAMP NOT NULL,
   fecha_actualizacion TIMESTAMP NOT NULL,
   destacado BOOLEAN DEFAULT false,
   usuario_id BIGINT
);

-- Se crean 5 posts.

INSERT INTO "Posts (artículos)" (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES 
  ('Bienvenido a mi Blog', 'En este primer artículo, quiero darte la bienvenida a mi blog. Aquí compartiré mis pensamientos, experiencias y conocimientos contigo. Espero que disfrutes de la lectura y encuentres información interesante.', '2023-03-31', '2023-10-18', true, 2),
  ('Descubriendo Nuevos Horizontes', 'En este post, exploraré algunas ideas emocionantes y perspectivas innovadoras en el mundo actual. Acompáñame en este viaje de descubrimiento.', '2023-04-03', '2023-11-09', true, 2),
  ('Dos Veces Lotte', 'Hoy quiero compartir contigo una historia fascinante sobre un acontecimiento inusual que ocurrió dos veces en la vida de Lotte. ¡No te lo pierdas!', '2022-12-22', '2023-10-25', true, 1),
  ('Mr. Conservador: Goldwater sobre Goldwater', 'Exploraré las ideas conservadoras a través de la perspectiva única de Goldwater en este artículo. Descubre más sobre sus pensamientos y su impacto en la política.', '2023-07-02', '2023-09-02', false, 3),
  ('El Tesoro Secreto de Tarzán', 'Acompaña a Tarzán en su nueva aventura mientras descubre un tesoro secreto. ¿Qué misterios se revelarán en la selva? ¡Descúbrelo en este emocionante relato!', '2023-07-17', '2023-12-11', false, NULL);

-- Crea tabla Comentarios.
-- select * from Comentarios;

CREATE TABLE Comentarios (
   id SERIAL PRIMARY KEY,
   contenido TEXT NOT NULL,
   fecha_creacion TIMESTAMP NOT NULL,
   usuario_id BIGINT NOT NULL,
   post_id BIGINT NOT NULL
);

-- Se crean 5 comentarios.

INSERT INTO Comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES 
  ('Excelente artículo, gracias por compartir tus ideas.', '2023-11-21', 1, 1),
  ('Interesante reflexión. Estoy de acuerdo con tu punto de vista.', '2023-10-14', 2, 1),
  ('¡Increíble contenido! Me encanta cómo abordas este tema.', '2023-10-24', 3, 1),
  ('Muy buen artículo. Tu perspectiva es única y valiosa.', '2023-09-24', 1, 2),
  ('Breve pero impactante. Gracias por compartir tus pensamientos.', '2023-10-22', 2, 2);

-- *** --

-- 1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido. (Respetar estrictamente todas las indicaciones respecto a nombre de las tablas, nombres y tipos de los campos, informacion a agregar a las tablas, condiciones indicadas como agregar los datos a la tablas)
-- Hecho

-- 2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y email del usuario junto al título y contenido del post. (usar inner join o join)

SELECT Usuarios.nombre, Usuarios.email, "Posts (artículos)".titulo, "Posts (artículos)".contenido
FROM Usuarios
INNER JOIN "Posts (artículos)" ON Usuarios.id = "Posts (artículos)".usuario_id;

-- 3. Muestra el id, título y contenido de los posts de los administradores. El administrador puede ser cualquier id. (debe haber al menos un usuario con el rol de administrador)

SELECT "Posts (artículos)".id, "Posts (artículos)".titulo, "Posts (artículos)".contenido
FROM "Posts (artículos)"
JOIN Usuarios ON "Posts (artículos)".usuario_id = Usuarios.id
WHERE Usuarios.rol = 'administrador';

-- 4. Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario. Hint: Aquí hay diferencia entre utilizar inner join, left join o right join, prueba con todas y con eso determina cuál es la correcta. No da lo mismo la tabla desde la que se parte. (la solucion colocada debe ser con una de las 3 la que se considere correcta)

SELECT Usuarios.id, Usuarios.email, COUNT("Posts (artículos)".id) AS cantidad_posts
FROM Usuarios
INNER JOIN "Posts (artículos)" ON Usuarios.id = "Posts (artículos)".usuario_id
GROUP BY Usuarios.id, Usuarios.email;

-- 5. Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene un único registro y muestra solo el email. (debe mostrar email del usuario y cantidad de posts creados)

SELECT Usuarios.email, COUNT("Posts (artículos)".id) AS cantidad_posts
FROM Usuarios
INNER JOIN "Posts (artículos)" ON Usuarios.id = "Posts (artículos)".usuario_id
GROUP BY Usuarios.email
ORDER BY cantidad_posts DESC
LIMIT 1;

-- 6. Muestra la fecha del último post de cada usuario. (debe mostrar email usuario, el titulo del post y fecha de creacion) Hint: Utiliza la función de agregado MAX sobre la fecha de creación.

SELECT Usuarios.email, "Posts (artículos)".titulo, MAX("Posts (artículos)".fecha_creacion) AS fecha_ultimo_post
FROM Usuarios
LEFT JOIN "Posts (artículos)" ON Usuarios.id = "Posts (artículos)".usuario_id
GROUP BY Usuarios.email, "Posts (artículos)".titulo;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios. (debe mostrar titulo del post, contenido del post y cantidad de comentarios)

SELECT "Posts (artículos)".titulo, "Posts (artículos)".contenido, COUNT(Comentarios.id) AS cantidad_comentarios
FROM "Posts (artículos)"
LEFT JOIN Comentarios ON "Posts (artículos)".id = Comentarios.post_id
GROUP BY "Posts (artículos)".titulo, "Posts (artículos)".contenido
ORDER BY cantidad_comentarios DESC
LIMIT 1;

-- 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió. (debe mostrar solo los posts que han sido comentados)

SELECT "Posts (artículos)".titulo, "Posts (artículos)".contenido
FROM "Posts (artículos)"
LEFT JOIN Comentarios ON "Posts (artículos)".id = Comentarios.post_id

SELECT
    "Posts (artículos)".titulo AS titulo_post,
    "Posts (artículos)".contenido AS contenido_post,
    Comentarios.contenido AS contenido_comentario,
    Usuarios.email AS email_usuario
FROM
    "Posts (artículos)"
JOIN
    Comentarios ON "Posts (artículos)".id = Comentarios.post_id
JOIN
    Usuarios ON Comentarios.usuario_id = Usuarios.id;

-- 9. Muestra el contenido del último comentario de cada usuario. (debe mostrar el email del usuario, el contenido del comentario y solo los usuarios que han hecho comentarios)

SELECT
    Usuarios.email AS email_usuario,
    Comentarios.contenido AS contenido_ultimo_comentario
FROM
    Usuarios
JOIN Comentarios ON Usuarios.id = Comentarios.usuario_id
LEFT JOIN Comentarios AS com2 ON Comentarios.usuario_id = com2.usuario_id AND Comentarios.fecha_creacion < com2.fecha_creacion
WHERE
    com2.fecha_creacion IS NULL;

-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario. Hint: Recuerda el uso de Having (obligatorio uso de Having)

SELECT Usuarios.email
FROM Usuarios
LEFT JOIN Comentarios ON Usuarios.id = Comentarios.usuario_id
GROUP BY Usuarios.id, Usuarios.email
HAVING COUNT(Comentarios.id) = 0;




