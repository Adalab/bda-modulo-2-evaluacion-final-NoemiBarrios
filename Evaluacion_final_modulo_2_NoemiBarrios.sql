-- Evaluación Final Módulo 2

-- Base de Datos Sakila:

USE sakila;

/* Para este ejerccio utilizaremos la BBDD Sakila que hemos estado utilizando durante el repaso de SQL. Es
una base de datos de ejemplo que simula una tienda de alquiler de películas. Contiene tablas como film
(películas), actor (actores), customer (clientes), rental (alquileres), category (categorías), entre otras.
Estas tablas contienen información sobre películas, actores, clientes, alquileres y más, y se utilizan para
realizar consultas y análisis de datos en el contexto de una tienda de alquiler de películas. */

-- 1) Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title
FROM film;

-- 2) Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title
FROM film
WHERE rating = "PG-13";

-- 3) Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title, description
FROM film
WHERE description LIKE '%amazing%';

-- 4) Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title
FROM film
WHERE lenght > 120;

-- 5) Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame nombre_actor y contenga nombre y apellido.

SELECT CONCAT(first_name, ' ', last_name) AS nombre_actor /*Podría hacerse también sin poner el AS para el alias*/
FROM actor;

-- 6) Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT CONCAT(first_name, ' ', last_name) nombre_actor 
FROM actor
WHERE last_name LIKE '%Gibson%';

-- 7) Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT CONCAT(first_name, ' ', last_name) nombre_actor /*Podría añadir también el actor_id para comprobar que esta hecho correctamente*/
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

/*Otra forma de hacerlo:*/
SELECT CONCAT(first_name, ' ', last_name) nombre_actor, actor_id
FROM actor  
ORDER BY actor_id  
LIMIT 10    
OFFSET 10; 

-- 8) Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13".

SELECT title
FROM film
WHERE rating NOT IN ("PG-13", 'R');

-- 9) Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT rating, COUNT(title) films
FROM film
GROUP BY rating;
/*También se podría añadir un ORDER BY film o rating para que el orden se ajustara a lo que prefiramos*/

-- 10) Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) rental
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

/*Uniendo el nombre y apellido de los clientes*/
SELECT c.customer_id, CONCAT(first_name, ' ', last_name) customer_name, COUNT(r.rental_id) rental
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY customer_name;

-- 11) Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT c.name category, COUNT(r.rental_id) rental 
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY category;

-- 12) Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT rating, AVG(length) average_length
FROM film
GROUP BY rating;

-- 13) Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT CONCAT(a.first_name, ' ', a.last_name) nombre_actor
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON f.film_id = fa.film_id
WHERE f.title = 'Indian Love'
ORDER BY nombre_actor; /*Para que se ordene por orden alfabético*/

-- 14) Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title
FROM film
WHERE description LIKE '%dog%' OR description LIKE '%cat%';

/*Otra forma de hacerlo usando el REGEXP*/
SELECT title
FROM film
WHERE description REGEXP 'dog|cat' ;

-- 15) Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.

SELECT CONCAT(a.first_name, ' ', a.last_name) nombre_actor
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

-- 16) Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- 17) Encuentra el título de todas las películas que son de la misma categoría que "Family".

 SELECT f.title
 FROM film f
 JOIN film_category fc ON f.film_id = fc.film_id
 JOIN category c ON c.category_id = fc.category_id
 WHERE c.name = 'Family'
 ORDER BY f.title;

-- 18) Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT CONCAT(a.first_name, ' ', a.last_name) actor_name, COUNT(f.title) total_films
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON a.actor_id = fa.actor_id
GROUP BY actor_name
HAVING COUNT(f.title) > 10;

/*Otra forma de hacerlo solo con un JOIN y ordenado alfabéticamente*/
SELECT CONCAT(a.first_name, ' ', a.last_name) actor_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) > 10
ORDER BY actor_name;

-- 19) Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title
FROM film
WHERE rating = 'R' AND length > 120;

-- 20) Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT c.name category, AVG(f.length) average_length
FROM category c
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
GROUP BY c.name
HAVING average_length > 120
ORDER BY category;

-- 21) Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT CONCAT(a.first_name, ' ', a.last_name) actor_name, COUNT(fa.film_id) films
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY actor_name /*También se podría agrupar por a.actor_id*/
HAVING  COUNT(fa.film_id) >= 5
ORDER BY actor_name;

-- 22) Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes. Pista: Usamos DATEDIFF para calcular la diferencia entre una fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final)

SELECT DISTINCT f.title /*Para que se viera también los días de alquiler: DATEDIFF(return_date, rental_date) rental_duration*/
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IN (
    SELECT rental_id
    FROM rental
    WHERE DATEDIFF(return_date, rental_date) > 5);

-- 23) Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT CONCAT(a.first_name, ' ', a.last_name) actor_name
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film_category fc ON fa.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Horror');

-- BONUS

-- 24) Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film con subconsultas.

SELECT f.title, f.length /*Poniendo la duración para comprobar que devuelve el resultado correcto*/
FROM film f
WHERE f.length > 180 
AND f.film_id IN (
    SELECT fc.film_id
    FROM film_category fc
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Comedy');

/*También se podría hacer sin subconsulta*/
SELECT f.title, f.length 
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE c.name = 'Comedy' AND f.length > 180;

-- 25) Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos. Pista: Podemos hacer un JOIN de una tabla consigo misma, poniendole un alias diferente.

SELECT CONCAT(a1.first_name, ', ', a1.last_name) Actor_1, CONCAT(a2.first_name, ' ', a2.last_name) Actor_2, COUNT(fa1.film_id) shared_films
FROM film_actor fa1
JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
JOIN actor a1 ON fa1.actor_id = a1.actor_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id
GROUP BY Actor_1, Actor_2
HAVING shared_films > 0;


