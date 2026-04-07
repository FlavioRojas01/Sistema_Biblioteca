CREATE DATABASE Sistema_Biblioteca;
USE Sistema_Biblioteca;

/* AUTORES */
CREATE TABLE autores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(100),
    cumpleaños date
);

/* GENEROS */
CREATE TABLE generos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

/* LIBROS */
CREATE TABLE libros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    autor_id INT,
    genero_id INT,
    isbn VARCHAR(20),
    FOREIGN KEY (autor_id) REFERENCES autores(id),
    FOREIGN KEY (genero_id) REFERENCES generos(id)
);

/* USUARIOS */
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(150) UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(200),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

/* RESERVAS */
CREATE TABLE reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    patron_id INT,
    date DATE,
    email VARCHAR(150),
    FOREIGN KEY (book_id) REFERENCES libros(id),
    FOREIGN KEY (patron_id) REFERENCES usuarios(id)
);

/* DATOS */

/* AUTORES */
INSERT INTO autores (nombre, nacionalidad, cumpleaños) VALUES
('Mario Vargas Llosa', 'Peruana', '1936-03-28'),
('César Vallejo', 'Peruana', '1892-03-16'),
('José María Arguedas', 'Peruana', '1911-01-18'),
('Alfredo Bryce Echenique', 'Peruana', '1939-02-19'),
('Ricardo Palma', 'Peruana', '1833-02-07'),
('Manuel Scorza', 'Peruana', '1928-09-09'),
('Claudia Salazar Jiménez', 'Peruana', '1976-01-01');

/* GENEROS */
INSERT INTO generos (nombre) VALUES
('Novela'),
('Poesía'),
('Cuento'),
('Ensayo'),
('Drama');

/* LIBROS */
INSERT INTO libros (titulo, autor_id, genero_id, isbn) VALUES
('La ciudad y los perros', 1, 1,'978123456001'),
('La casa verde', 1, 1,'978123456002'),
('Trilce', 2, 2,'978123456003'),
('Los heraldos negros', 2, 2, '978123456004'),
('Los ríos profundos', 3, 1, '978123456005'),
('Yawar Fiesta', 3, 1, '978123456006'),
('Un mundo para Julius', 4, 1, '978123456007'),
('La amigdalitis de Tarzán', 4, 1,'978123456008'),
('Tradiciones peruanas', 5, 3,'978123456009'),
('Redoble por Rancas', 6, 1,'978123456010'),
('La sangre de la aurora', 7, 5,'978123456011');

/* USUARIOS */
INSERT INTO usuarios (nombre, apellido, correo, telefono, direccion) VALUES
('Flavio', 'Rojas', 'flavio@gmail.com', '987654321', 'Supe'),
('Mike', 'Ramirez', 'Mike@gmail.com', '912345678', 'Huacho'),
('Frank', 'Salvador', 'Frank@gmail.com', '923456789', 'Huaura'),
('Leonel', 'Padilla', 'Leonel@gmail.com', '934567890', 'Chasquitambo'),
('Johan', 'Mendoza', 'Johan@gmail.com', '945678901', 'Sayan'),
('Davida', 'Ricra', 'David@gmail.com', '956789012', 'Barranca');

/* RESERVAS */
INSERT INTO reservations (book_id, patron_id, date, email) VALUES
(1, 1, '2024-01-10', 'flavio@gmail.com'),
(2, 2, '2024-01-11', 'Mike@gmail.com'),
(3, 3, '2024-01-12', 'Frank@gmail.com'),
(4, 4, '2024-01-13', 'Leonel@gmail.com'),
(5, 5, '2024-01-14', 'Johan@gmail.com'),
(6, 6, '2024-01-15', 'David@gmail.com'),
(1, 2, '2024-01-16', 'David@gmail.com'),
(2, 3, '2024-01-17', 'Frank@gmail.com'),
(3, 1, '2024-01-18', 'flavio@gmail.com'),
(7, 4, '2024-01-19', 'Leonel@gmail.com');

/* RESPONDER LAS CONSULTAS */

/*1. Obtener todos los libros con su autor y género*/
SELECT libros.titulo, autores.nombre, generos.nombre
FROM libros
JOIN autores ON libros.autor_id = autores.id
JOIN generos ON libros.genero_id = generos.id;

/*2. Listar los libros que nunca han sido reservados*/
SELECT libros.titulo
FROM libros
LEFT JOIN reservations ON libros.id = reservations.book_id
WHERE reservations.id IS NULL;

/*3. Mostrar los nombres de los usuarios que han hecho al menos una reserva*/
SELECT DISTINCT usuarios.nombre, usuarios.apellido
FROM usuarios
JOIN reservations ON usuarios.id = reservations.patron_id;

/*4. Contar cuántos libros hay por género*/
SELECT generos.nombre, COUNT(libros.id)
FROM generos
LEFT JOIN libros ON generos.id = libros.genero_id
GROUP BY generos.nombre;

/*5. Obtener el número total de reservas por libro*/
SELECT libros.titulo, COUNT(reservations.id)
FROM libros
LEFT JOIN reservations ON libros.id = reservations.book_id
GROUP BY libros.titulo;

/*6. Listar los autores que tienen más de 3 libros registrados*/
SELECT autores.nombre, COUNT(libros.id)
FROM autores
JOIN libros ON autores.id = libros.autor_id
GROUP BY autores.nombre
HAVING COUNT(libros.id) > 3;

/*7. Mostrar los libros reservados en una fecha específica*/
SELECT libros.titulo, reservations.date
FROM reservations
JOIN libros ON reservations.book_id = libros.id
WHERE reservations.date = '2024-01-15';

/*8. Obtener los usuarios que han reservado más de 5 libros*/
SELECT usuarios.nombre, usuarios.apellido, COUNT(reservations.id)
FROM usuarios
JOIN reservations ON usuarios.id = reservations.patron_id
GROUP BY usuarios.id, usuarios.nombre, usuarios.apellido
HAVING COUNT(reservations.id) > 5;

/*9. Listar libros junto con el número de veces que han sido reservados (incluir los que tienen 0)*/
SELECT libros.titulo, COUNT(reservations.id)
FROM libros
LEFT JOIN reservations ON libros.id = reservations.book_id
GROUP BY libros.id, libros.titulo;

/*10. Obtener el género con más libros registrados*/
SELECT generos.nombre, COUNT(libros.id)
FROM generos
JOIN libros ON generos.id = libros.genero_id
GROUP BY generos.nombre
ORDER BY COUNT(libros.id) DESC
LIMIT 1;

/*11. Obtener el libro más reservado*/
SELECT libros.titulo, COUNT(reservations.id)
FROM libros
JOIN reservations ON libros.id = reservations.book_id
GROUP BY libros.titulo
ORDER BY COUNT(reservations.id) DESC
LIMIT 1;

/*12. Listar los 3 autores con más reservas acumuladas en sus libros*/
SELECT autores.nombre, COUNT(reservations.id)
FROM autores
JOIN libros ON autores.id = libros.autor_id
JOIN reservations ON libros.id = reservations.book_id
GROUP BY autores.nombre
ORDER BY COUNT(reservations.id) DESC
LIMIT 3;

/*13. Mostrar los usuarios que nunca han hecho una reserva*/
SELECT usuarios.nombre, usuarios.apellido
FROM usuarios
LEFT JOIN reservations ON usuarios.id = reservations.patron_id
WHERE reservations.id IS NULL;

/*14. Obtener los libros cuya cantidad de reservas es mayor al promedio*/
SELECT libros.titulo, COUNT(reservations.id)
FROM libros
LEFT JOIN reservations ON libros.id = reservations.book_id
GROUP BY libros.id, libros.titulo
HAVING COUNT(reservations.id) > (
    SELECT AVG(total_reservas)
    FROM (
        SELECT COUNT(reservations.id) AS total_reservas
        FROM libros
        LEFT JOIN reservations ON libros.id = reservations.book_id
        GROUP BY libros.id
    ) AS subconsulta
);

/*15. Listar autores cuyos libros pertenecen a más de un género distinto*/
SELECT autores.nombre
FROM autores
JOIN libros ON autores.id = libros.autor_id
GROUP BY autores.id, autores.nombre
HAVING COUNT(DISTINCT libros.genero_id) > 1;
