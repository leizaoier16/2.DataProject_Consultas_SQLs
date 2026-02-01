--1: Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.
select *
from film f ;

select "film_id" , "title" , "rating" 
from "film" 
where "rating" = 'R';

--2Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
select concat(first_name , '  ',last_name) as "Nombre", actor_id 
from "actor"
where "actor_id" between 30 and 40;

--3: Obtén las películas cuyo idioma coincide con el idioma original
select*
from "language" l ;

select*
from film f 
where f.language_id = f.original_language_id ;

--4: Ordena las películas por duración de forma ascendente.
select f.film_id , f.title , f.length 
from film f 
order by length asc;

--5: Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido
select a.actor_id , a.first_name as "Nombre", a.last_name as "Apellido"
from actor a
where a.last_name = 'ALLEN';

--6:  Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.
select  f.rating , count(*) as "Total"
from film f
group by f.rating ;

--7:Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
select f.title , f.rating , f.length 
from film f 
where f.rating = 'PG-13' or f.length > 180;

--8:  Encuentra la variabilidad de lo que costaría reemplazar las películas.
select variance(f.replacement_cost ) as "Variabilidad Remplazo"
from film f ;

--9: Encuentra la mayor y menor duración de una película de nuestra BBDD.
select min(f.length ) as "Menor Duración", max(f.length ) as "Mayor Duración"
from film f;

--10:  Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
select p.rental_id  , r.rental_date , p.amount 
from rental r 
inner join payment p 
on r.rental_id  = p.rental_id 
order by r.rental_date desc
limit 1 offset 2;

select*
from rental r ;

--11: Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC17’ ni ‘G’ en cuanto a su clasificación.
select f.title as "Titulo", f.rating 
from film f 
where f.rating not in ('G','NC-17');

--12: Encuentra el promedio de duración de las películas para cadaclasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
select f.rating , round(avg(f.length ),2) as "Promedio de Duración"
from film f 
group by f.rating;

--13: Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
select f.title, f.length 
from film f 
where f.length > 180;

--14: ¿Cuánto dinero ha generado en total la empresa?
select sum(p.amount ) as "Total Ingresos"
from payment p ;

--15:  Muestra los 10 clientes con mayor valor de id.
select c.first_name as "Nombre", c.last_name as "Apellido", c.customer_id 
from customer c 
order by c.customer_id desc
limit 10;

--16: Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’
select f.title, concat(a.first_name , ' ', a.last_name ) as "Nombre Actor"
from actor a 
inner join film_actor fa 
on a.actor_id = fa.actor_id 
inner join film f 
on f.film_id = fa.film_id 
where f.title = 'EGG IGBY';

--17:  Selecciona todos los nombres de las películas únicos
select distinct f.title 
from film f;

--18:  Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.
select f.title , c."name" as "Categoría", f.length 
from category c 
inner join film_category fc 
on c.category_id = fc.category_id 
inner join film f 
on f.film_id = fc.film_id 
where c."name" = 'Comedy' and f.length > 180;

--19:  Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
select c."name" as "Categoría", avg(f.length ) as "Promedio"
from category c 
inner join film_category fc 
on c.category_id = fc.category_id 
inner join film f 
on f.film_id = fc.film_id 
group by "Categoría" 
having avg(f.length ) > 110;

/** CTE **/
with promedio_categoria as (
  select fc.category_id, AVG(f.length) AS promedio
    from film_category fc
    inner join film f
      on f.film_id = fc.film_id
    group by fc.category_id
)
select c."name" AS "Categoría", pc.promedio AS "Promedio"
from promedio_categoria pc
inner join category c
    on c.category_id = pc.category_id
where pc.promedio > 110;

--20: ¿Cuál es la media de duración del alquiler de las películas?
select avg(r.return_date - r.rental_date ) as "Promedio Duración Alquiler"
from rental r 
where r.return_date is not null;

--21: Crea una columna con el nombre y apellidos de todos los actores y actrices.
select concat(a.first_name ,' ', a.last_name ) as "Nombre y Apellido"
from actor a ;

--22: Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
select Date(r.rental_date ) as "Dia", count(*) as "Total_alquileres"
from rental r 
group by "Dia" 
order by "Total_alquileres" desc;

--23: Encuentra las películas con una duración superior al promedio.
select f.title , f.length 
from film f 
where f.length > (
  select avg(f.length)
  from film f);

--24: Averigua el número de alquileres registrados por mes
select date_trunc('month', r.rental_date)::date as mes, count(*) as "Total Alquileres"
from rental r 
group by mes
order by mes;

--25:  Encuentra el promedio, la desviación estándar y varianza del total pagado.
/** creando una tabla con las estadisticas para un posible uso futuro **/
with  estadisticas as (
    select
        AVG(amount) AS "Promedio",
        STDDEV(amount) AS "Desviación",
        VARIANCE(amount) AS "Varianza"
    from payment
)
select *
from estadisticas;

create temporary table stats as
select  AVG(amount) AS "Promedio",
        STDDEV(amount) AS "Desviación",
        VARIANCE(amount) AS "Varianza"
from payment ;

--26: ¿Qué películas se alquilan por encima del precio medio?
select f.title , p.amount 
from payment p 
inner join rental r 
on p.rental_id = r.rental_id 
inner join inventory i 
on i.inventory_id = r.inventory_id 
inner join film f 
on f.film_id = i.film_id 
where p.amount > (
   select avg(amount)
   from payment p
   )
order by p.amount  desc;

--27: Muestra el id de los actores que hayan participado en más de 40 películas.
select fa.actor_id, count(fa.film_id) as "Total Peliculas"
from film_actor fa 
group by fa.actor_id  
having count(fa.film_id) > 40
order by fa.actor_id ;

--28:  Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
select f.title as "Titulo" , count(inventory_id) as "Total Disponibles"
from film f 
left join inventory i 
  on f.film_id = i.film_id 
group by f.film_id  
order by f.title  ;

--29: Obtener los actores y el número de películas en las que ha actuado.
select concat(a.first_name , ' ', a.last_name ) as "Actor", count(f.film_id ) as "Total Peliculas"
from actor a 
inner join film_actor fa 
on a.actor_id = fa.actor_id 
inner join film f 
on f.film_id = fa.film_id 
group by a.actor_id, fa.actor_id 
order by "Actor" ;

--30: Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
select f.title as "Titulo", string_agg(a.first_name ||' '||a.last_name, ' , ' ) as "Actor"
from actor a 
inner join film_actor fa 
on a.actor_id = fa.actor_id 
left join film f 
on f.film_id = fa.film_id
group by f.title, f.film_id 
order by "Titulo", "Actor"  ;

--31: Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.

select concat(a.first_name, ' ', a.last_name) as "Actor", string_agg(f.title , ' , ') as "Titulo"
from actor a 
inner join film_actor fa 
on a.actor_id = fa.actor_id 
left join film f 
on f.film_id = fa.film_id
group by "Actor" 
order by  "Actor"  ;

--32: Obtener todas las películas que tenemos y todos los registros de alquiler.
select f.film_id , f.title as "Pelicula", r.rental_id, r.rental_date 
from film f
inner join inventory i 
on f.film_id = i.film_id 
full join rental r 
on i.inventory_id = r.inventory_id
order by "Pelicula", rental_date ;

--33: Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
with gasto_por_cliente as (
   select customer_id, sum(amount) as "Gasto Total"
   from payment p
   group by customer_id )
select c.customer_id , concat(c.first_name ,' ', c.last_name ) as "Cliente", "Gasto Total" 
from gasto_por_cliente 
inner join customer c 
on c.customer_id = gasto_por_cliente.customer_id 
order by "Gasto Total" desc
limit 5;

--34 y 35: Selecciona todos los actores cuyo primer nombre es 'Johnny', Renombra la columna “first_name” como Nombre y “last_name” comoApellido.
select a.actor_id , a.first_name as "Nombre", a.last_name as "Apellido"
from actor a 
where a.first_name = 'JOHNNY'

--36: Encuentra el ID del actor más bajo y más alto en la tabla actor.
select min(a.actor_id ) as "ID_actor_minimo", max(a.actor_id ) as "ID_actor_maximo"
from actor a ;

--37: Cuenta cuántos actores hay en la tabla “actor”.
select count(a.actor_id ) as "Numero de actores"
from actor a ;

--38: Selecciona todos los actores y ordénalos por apellido en orden ascendente.
select a.first_name as "Nombre", a.last_name as "apellido"
from actor a 
order by a.last_name asc;

--39: Selecciona las primeras 5 películas de la tabla “film”.
SELECT *
FROM film
ORDER BY film_id
LIMIT 5;

--40: Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
select a.first_name , count(*) as "Numero de actores"
from actor a 
group by a.first_name 
order by "Numero de actores" desc ;

--41: Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select r.rental_id , c.first_name as "Nombre", c.last_name as "Apellido", r.rental_date 
from customer c 
inner join rental r 
  on c.customer_id = r.customer_id;

--42: Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
select c.customer_id,  concat(c.first_name, ' ', c.last_name) AS "cliente", r.rental_id, r.rental_date, r.return_date
from  customer c
left join rental r
    on c.customer_id = r.customer_id
order by cliente, r.rental_date;

--43: Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
SELECT
    f.film_id,
    f.title AS pelicula,
    c.category_id,
    c.name AS categoria
FROM film f
CROSS JOIN category c;

/** No aporta valor porque un CROSS JOIN genera 
 todas las combinaciones posibles entre películas y categorías, 
 incluyendo combinaciones que no existen en la realidad, lo que produce datos irrelevantes e innecesarios.
Por ejemplo podemos observar como genera filas ineccesarias y erroneas asignando todas las categorias 
posibles a una misma pelicula **/

--44: Encuentra los actores que han participado en películas de la categoría 'Action'
with peliculas_accion as(
  select fc.film_id 
  from film_category fc 
  inner join category c 
  on fc.category_id = c.category_id
  where c.name = 'Action')
select distinct a.actor_id , a.first_name as "Nombre", a.last_name as "Apellido"
from actor a 
inner join film_actor fa 
on a.actor_id = fa.actor_id 
inner join peliculas_accion 
on peliculas_accion.film_id = fa.film_id 
order by actor_id ;

--45: Encuentra todos los actores que no han participado en películas.
SELECT a.actor_id, concat( a.first_name, ' ', a.last_name) AS "actor"
FROM actor a
LEFT JOIN film_actor fa
    ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL
ORDER BY actor;

--46: Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
CREATE TEMP TABLE tmp_conteo_peliculas AS
SELECT
    a.actor_id,
    a.first_name || ' ' || a.last_name AS actor,
    COUNT(fa.film_id) AS total_peliculas
FROM actor a
LEFT JOIN film_actor fa
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

select*
from tmp_conteo_peliculas
order by total_peliculas desc;

--47: Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
CREATE VIEW actor_num_peliculas AS
SELECT
    a.first_name || ' ' || a.last_name AS actor,
    COUNT(fa.film_id) AS total_peliculas
FROM actor a
LEFT JOIN film_actor fa
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY total_peliculas desc;

--48: Calcula el número total de alquileres realizados por cada cliente.
select concat(c.first_name, ' ', c.last_name) as "cliente", count (r.rental_id) as total_alquileres
from  customer c
left join rental r
    on c.customer_id = r.customer_id
group by c.customer_id, c.first_name, c.last_name
order by total_alquileres desc;

--49: Calcula la duración total de las películas en la categoría 'Action'.
select  SUM(f.length) as  duracion_total_action
from  film f
inner  join  film_category fc
    on f.film_id = fc.film_id
inner  join  category c
    on  fc.category_id = c.category_id
where  c.name = 'Action';

--50: Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
create temp table cliente_rentas_temporal as
select c.customer_id, concat( c.first_name, ' ', c.last_name) as  cliente, count(r.rental_id) as total_alquileres
from  customer c
left join rental r
    On c.customer_id = r.customer_id
group by c.customer_id, c.first_name, c.last_name;

select*
from cliente_rentas_temporal;

--51: Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.
create temp table peliculas_alquiladas as
select f.film_id, f.title, count(r.rental_id) as total_alquileres
from film f
inner join inventory i
    on f.film_id = i.film_id
inner join rental r
    on i.inventory_id = r.inventory_id
group by f.film_id, f.title
having count(r.rental_id) >= 10;

select*
from peliculas_alquiladas;

--52:Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
with alquileres_no_devueltos as (
    select r.inventory_id, r.customer_id
    from rental r
    where  r.return_date is null
),
cliente_objetivo as (
    select customer_id
    from customer
    where first_name = 'Tammy'
      and last_name = 'Sanders'
)
select distinct f.title
from alquileres_no_devueltos a
inner join cliente_objetivo c
    on a.customer_id = c.customer_id
inner join inventory i
    on a.inventory_id = i.inventory_id
inner join film f
    on i.film_id = f.film_id
order by f.title;

--53: Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.

select  distinct 
    a.first_name,
    a.last_name
from  actor a
inner  join  film_actor fa
    on  a.actor_id = fa.actor_id
inner  join  film_category fc
    on  fa.film_id = fc.film_id
inner  join  category c
    on  fc.category_id = c.category_id
where  c.name = 'Sci-Fi'
order  by  a.last_name, a.first_name;

--54: Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
with primera_fecha as (
    select min(r.rental_date) as fecha
    from film f
    inner join inventory i
        on f.film_id = i.film_id
    inner join rental r
        on i.inventory_id = r.inventory_id
    where f.title = 'Spartacus Cheaper'
)
select distinct
    a.first_name,
    a.last_name
from actor a
inner join film_actor fa
    on a.actor_id = fa.actor_id
inner join inventory i
    on fa.film_id = i.film_id
inner join rental r
    on i.inventory_id = r.inventory_id
inner join primera_fecha pf
    on r.rental_date > pf.fecha
order by a.last_name, a.first_name;

--55:  Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
select
    a.first_name,
    a.last_name
from actor a
where not exists (
    select 1
    from film_actor fa
    inner join film_category fc
        on fa.film_id = fc.film_id
    inner join category c
        on fc.category_id = c.category_id
    where fa.actor_id = a.actor_id and c.name = 'music'
)
order by a.last_name, a.first_name;

--56: Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
select distinct
    f.title
from film f
inner join inventory i
    on f.film_id = i.film_id
inner join rental r
    on i.inventory_id = r.inventory_id
where r.return_date is not null
  and r.return_date - r.rental_date > interval '8 days'
order by f.title;

--57: Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’
select distinct
    f.title
from film f
inner join film_category fc
    on f.film_id = fc.film_id
inner join category c
    on fc.category_id = c.category_id
where c.category_id = (
    select category_id
    from category
    where name = 'Animation'
)
order by f.title;

--58: Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.
select f.title
from film f
where f.length = (
    select length
    from film
    where title = 'DANCING FEVER'
)
order by f.title;

--59: Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
select c.first_name, c.last_name
from customer c
inner join rental r
    on c.customer_id = r.customer_id
inner join inventory i
    on r.inventory_id = i.inventory_id
inner join film f
    on i.film_id = f.film_id
group by c.customer_id, c.first_name, c.last_name
having count(distinct f.film_id) >= 7
order by c.last_name, c.first_name;

--60: Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres

select c.name, count(r.rental_id) as "total_alquileres"
from category c
inner join film_category fc
    on c.category_id = fc.category_id
inner join inventory i
    on fc.film_id = i.film_id
inner join rental r
    on i.inventory_id = r.inventory_id
group by c.category_id, c.name
order by total_alquileres desc;

--61: Encuentra el número de películas por categoría estrenadas en 2006.

select c.name, count(f.film_id) as "total_peliculas_2006"
from category c
inner join film_category fc
    on c.category_id = fc.category_id
inner join film f
    on fc.film_id = f.film_id
where f.release_year = '2006'
group by c.category_id, c.name
order by total_peliculas_2006 desc;

--62: Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos
select s.first_name, s.last_name, st.store_id, st.address_id 
from staff s
cross join store st
order by s.last_name, s.first_name, st.store_id;

--63:  Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
select
    c.customer_id,
    c.first_name,
    c.last_name,
    count(r.rental_id) as "total_alquileres"
from customer c
inner join rental r
    on c.customer_id = r.customer_id
group by c.customer_id, c.first_name, c.last_name
order by total_alquileres desc;
