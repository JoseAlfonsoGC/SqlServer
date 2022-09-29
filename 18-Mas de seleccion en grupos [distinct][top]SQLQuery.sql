/*Registros duplicados *****************(distinct)*************/

--sintaxis
select distinct autor from libros;

--Tambi�n podemos usar group by:
select autor from libros
group by autor;

--posibles consultas
select distinct autor from libros
  where autor is not null; --Si s�lo queremos la lista de autores conocidos, es decir, no queremos incluir "null" en la lista

select count(distinct autor) --Para contar los distintos autores, sin considerar el valor "null"
  from libros; 

select count(autor) --Note que si contamos los autores sin "distinct", no incluir� los valores "null" pero si los repetidos
  from libros;

--Tambi�n puede utilizarse con "group by" para contar los diferentes autores por editorial:
 select editorial, count(distinct autor)
  from libros
  group by editorial;

/*obtener s�lo una cantidad limitada de registros 
*********************************top**************************
(los primeros n registros de una consulta)*/

--Con la siguiente consulta obtenemos todos los datos de los primeros 2 libros de la tabla:
 select top 2 * from libros;

--Se puede combinar con "order by":
 select top 3 titulo,autor 
  from libros
  order by autor;