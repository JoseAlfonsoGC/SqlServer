/**************************************************Subconsultas*********************************************
Una subconsulta (subquery) es una sentencia "select" anidada en otra sentencia "select", "insert", "update" o "delete" (o en otra subconsulta).

Las subconsultas se emplean cuando una consulta es muy compleja, entonces se la divide en varios pasos lógicos y se obtiene el resultado con una única instrucción y cuando la consulta depende de los resultados de otra consulta.

Generalmente, una subconsulta se puede reemplazar por combinaciones y estas últimas son más eficientes.

Las subconsultas se DEBEN incluir entre paréntesis.

Puede haber subconsultas dentro de subconsultas, se admiten hasta 32 niveles de anidación.
*/
/*
Se pueden emplear subconsultas:
- en lugar de una expresión, siempre que devuelvan un solo valor o una lista de valores.
- que retornen un conjunto de registros de varios campos en lugar de una tabla o para obtener el mismo resultado que una combinación (join).

Hay tres tipos básicos de subconsultas:

las que retornan un solo valor escalar que se utiliza con un operador de comparación o en lugar de una expresión.
las que retornan una lista de valores, se combinan con "in", o los operadores "any", "some" y "all".
los que testean la existencia con "exists".
Reglas a tener en cuenta al emplear subconsultas:

- la lista de selección de una subconsulta que va luego de un operador de comparación puede incluir sólo una expresión o campo (excepto si se emplea "exists" y "in").

- si el "where" de la consulta exterior incluye un campo, este debe ser compatible con el campo en la lista de selección de la subconsulta.

- no se pueden emplear subconsultas que recuperen campos de tipos text o image.

- las subconsultas luego de un operador de comparación (que no es seguido por "any" o "all") no pueden incluir cláusulas "group by" ni "having".

- "distinct" no puede usarse con subconsultas que incluyan "group by".

- no pueden emplearse las cláusulas "compute" y "compute by".

- "order by" puede emplearse solamente si se especifica "top" también.

- una vista creada con una subconsulta no puede actualizarse.

- una subconsulta puede estar anidada dentro del "where" o "having" de una consulta externa o dentro de otra subconsulta.

- si una tabla se nombra solamente en un subconsulta y no en la consulta externa, los campos no serán incluidos en la salida (en la lista de selección de la consulta externa).
*/
/*******************************************Subconsultas como expresión**************************************/
/*
Una subconsulta puede reemplazar una expresión. Dicha subconsulta debe devolver un valor escalar (o una lista de valores de un campo).

Las subconsultas que retornan un solo valor escalar se utiliza con un operador de comparación o en lugar de una expresión:
*/
select CAMPOS
		from TABLA
	where CAMPO OPERADOR (SUBCONSULTA);

select CAMPO OPERADOR (SUBCONSULTA)
		from TABLA;
/*
Si queremos saber el precio de un determinado libro y la diferencia con el precio del libro más costoso, anteriormente debíamos averiguar en una consulta el precio del libro más costoso y luego, 
en otra consulta, calcular la diferencia con el valor del libro que solicitamos. Podemos conseguirlo en una sola sentencia combinando dos consultas:
**/
select titulo,precio,
		precio-(select max(precio) from libros) as diferencia
		from libros
  where titulo='Uno';
--En el ejemplo anterior se muestra el título, el precio de un libro y la diferencia entre el precio del libro y el máximo valor de precio.

--Queremos saber el título, autor y precio del libro más costoso:
select titulo,autor, precio
		from libros
	where precio= --Note que el campo del "where" de la consulta exterior es compatible con el valor retornado por la expresión de la subconsulta.
   (select max(precio) from libros);

--Se pueden emplear en "select", "insert", "update" y "delete".

--Para actualizar un registro empleando subconsulta la sintaxis básica es la siguiente:
update TABLA set CAMPO=NUEVOVALOR
		where CAMPO= (SUBCONSULTA);
--Para eliminar registros empleando subconsulta empleamos la siguiente sintaxis básica:
delete from TABLA
		where CAMPO=(SUBCONSULTA);
--Recuerde que la lista de selección de una subconsulta que va luego de un operador de comparación puede incluir sólo una expresión o campo (excepto si se emplea "exists" o "in").

--No olvide que las subconsultas luego de un operador de comparación (que no es seguido por "any" o "all") no pueden incluir cláusulas "group by".

/**********************************************Subconsultas con in******************************************
Vimos que una subconsulta puede reemplazar una expresión. Dicha subconsulta debe devolver un valor escalar o una lista de valores de un campo; 
las subconsultas que retornan una lista de valores reemplazan a una expresión en una cláusula "where" que contiene la palabra clave "in".

El resultado de una subconsulta con "in" (o "not in") es una lista. Luego que la subconsulta retorna resultados, la consulta exterior los usa.
*/
--sintaxis
...where EXPRESION in (SUBCONSULTA);

--ejemplo muestra los nombres de las editoriales que ha publicado libros de un determinado autor
select nombre
		from editoriales
		where codigo in
		(select codigoeditorial
		from libros
		where autor='Richard Bach');

--La subconsulta (consulta interna) retorna una lista de valores de un solo campo (codigo) que la consulta exterior luego emplea al recuperar los datos.
--Podemos reemplazar por un "join" la consulta anterior:
select distinct nombre
		from editoriales as e
		join libros
		on codigoeditorial=e.codigo
		where autor='Richard Bach';
/*
Una combinación (join) siempre puede ser expresada como una subconsulta; pero una subconsulta no siempre puede reemplazarse por una combinación que retorne el mismo resultado. Si es posible, 
es aconsejable emplear combinaciones en lugar de subconsultas, son más eficientes.

Se recomienda probar las subconsultas antes de incluirlas en una consulta exterior, así puede verificar que retorna lo necesario, porque a veces resulta difícil verlo en consultas anidadas.

También podemos buscar valores No coincidentes con una lista de valores que retorna una subconsulta; por ejemplo, las editoriales que no han publicado libros de un autor específico:
*/
select nombre
		from editoriales
		where codigo not in
		(select codigoeditorial
		from libros
		where autor='Richard Bach');
/*********************************************Subconsultas any - some - all*********************************
"any" y "some" son sinónimos. Chequean si alguna fila de la lista resultado de una subconsulta se encuentra el valor especificado en la condición.

El tipo de datos que se comparan deben ser compatibles.

La sintaxis básica es:

 ...VALORESCALAR OPERADORDECOMPARACION
  ANY (SUBCONSULTA);
*/
--Queremos saber los títulos de los libros de "Borges" que pertenecen a editoriales que han publicado también libros de "Richard Bach", es decir, si los libros de "Borges" coinciden con ALGUNA de las editoriales que publicó libros de "Richard Bach":
select titulo
		from libros
	where autor='Borges' and
		codigoeditorial = any
		(select e.codigo
		from editoriales as e
		join libros as l
		on codigoeditorial=e.codigo
    where l.autor='Richard Bach');
/*
La consulta interna (subconsulta) retorna una lista de valores de un solo campo (puede ejecutar la subconsulta como una consulta para probarla), 
luego, la consulta externa compara cada valor de "codigoeditorial" con cada valor de la lista devolviendo los títulos de "Borges" que coinciden.

"all" también compara un valor escalar con una serie de valores. Chequea si TODOS los valores de la lista de la consulta externa se encuentran en la lista de valores devuelta por la consulta interna.

Sintaxis:
VALORESCALAR OPERADORDECOMPARACION all (SUBCONSULTA);
*/

--otro ejemplo con un operador distinto
--Queremos saber si ALGUN precio de los libros de "Borges" es mayor a ALGUN precio de los libros de "Richard Bach":
select titulo,precio
		from libros
	where autor='Borges' and
		precio > any
		(select precio
		from libros
    where autor='Bach');--El precio de cada libro de "Borges" es comparado con cada valor de la lista de valores retornada por la subconsulta; 
						--si ALGUNO cumple la condición, es decir, es mayor a ALGUN precio de "Richard Bach", se lista.

--ejemplo usando 'all' en lugar de 'any'
select titulo,precio
		from libros
	where autor='borges' and
		precio > all
		(select precio
		from libros
	where autor='bach');
/*
El precio de cada libro de "Borges" es comparado con cada valor de la lista de valores retornada por la subconsulta; 
si cumple la condición, es decir, si es mayor a TODOS los precios de "Richard Bach" (o al mayor), se lista.

Emplear "= any" es lo mismo que emplear "in".

Emplear "<> all" es lo mismo que emplear "not in".

Recuerde que solamente las subconsultas luego de un operador de comparación al cual es seguido por "any" o "all") pueden incluir cláusulas "group by".
*/
/******************************************Subconsultas correlacionadas**************************************/
--ejemplo
/*Un almacén almacena la información de sus ventas en una tabla llamada "facturas" en la cual guarda el número de factura, la fecha y el nombre del cliente 
y una tabla denominada "detalles" en la cual se almacenan los distintos items correspondientes a cada factura: el nombre del artículo, el precio (unitario) y la cantidad.

-Se necesita una lista de todas las facturas que incluya el número, la fecha, el cliente, la cantidad de artículos comprados y el total:*/
select f.*,
  (select count(d.numeroitem)
    from Detalles as d
    where f.numero=d.numerofactura) as cantidad,
  (select sum(d.preciounitario*cantidad)
    from Detalles as d
    where f.numero=d.numerofactura) as total
from facturas as f;
/*
El segundo "select" retorna una lista de valores de una sola columna con la cantidad de items por factura (el número de factura lo toma del "select" exterior); 
el tercer "select" retorna una lista de valores de una sola columna con el total por factura (el número de factura lo toma del "select" exterior); el primer "select" (externo) devuelve todos los datos de cada factura.

A este tipo de subconsulta se la denomina consulta correlacionada. La consulta interna se evalúa tantas veces como registros tiene la consulta externa, 
se realiza la subconsulta para cada registro de la consulta externa. El campo de la tabla dentro de la subconsulta (f.numero) se compara con el campo de la tabla externa.

En este caso, específicamente, la consulta externa pasa un valor de "numero" a la consulta interna. La consulta interna toma ese valor y determina si existe en "detalles", si existe, 
la consulta interna devuelve la suma. El proceso se repite para el registro de la consulta externa, la consulta externa pasa otro "numero" a la consulta interna y SQL Server repite la evaluacion.
*/
/******************************************Subconsulta - Exists y Not Exists*************************************
Los operadores "exists" y "not exists" se emplean para determinar si hay o no datos en una lista de valores.
*/
/*
Estos operadores pueden emplearse con subconsultas correlacionadas para restringir el resultado de una consulta exterior a los registros que cumplen la subconsulta (consulta interior). 
Estos operadores retornan "true" (si las subconsultas retornan registros) o "false" (si las subconsultas no retornan registros).

Cuando se coloca en una subconsulta el operador "exists", SQL Server analiza si hay datos que coinciden con la subconsulta, 
no se devuelve ningún registro, es como un test de existencia; SQL Server termina la recuperación de registros cuando por lo menos un registro cumple la condición "where" de la subconsulta.
*/
--sintaxis
... where exists (SUBCONSULTA);

--En este ejemplo se usa una subconsulta correlacionada con un operador "exists" en la cláusula "where" para devolver una lista de clientes que compraron el artículo "lapiz":
select cliente,numero
	from facturas as f
	where exists
    (select * from Detalles as d
    where f.numero=d.numerofactura
    and d.articulo='lapiz');
--Puede obtener el mismo resultado empleando una combinación.

--Podemos buscar los clientes que no han adquirido el artículo "lapiz" empleando "not exists":
select cliente,numero
	from facturas as f
	where not exists
	(select * from Detalles as d
    where f.numero=d.numerofactura
    and d.articulo='lapiz');

/*****************************************Subconsulta simil autocombinación*********************************
Algunas sentencias en las cuales la consulta interna y la externa emplean la misma tabla pueden reemplazarse por una autocombinación.
*/
--Por ejemplo, queremos una lista de los libros que han sido publicados por distintas editoriales.
select distinct l1.titulo
  from libros as l1
  where l1.titulo in
  (select l2.titulo
    from libros as l2 
    where l1.editorial <> l2.editorial);
--En el ejemplo anterior empleamos una subconsulta correlacionada y las consultas interna y externa emplean la misma tabla. 
--La subconsulta devuelve una lista de valores por ello se emplea "in" y sustituye una expresión en una cláusula "where".

--el siguiente 'join' se obtiene el mismo resultado 
select distinct l1.titulo
  from libros as l1
  join libros as l2
  on l1.titulo=l2.titulo and
  l1.autor=l2.autor 
  where l1.editorial<>l2.editorial;

--Otro ejemplo: Buscamos todos los libros que tienen el mismo precio que "El aleph" empleando subconsulta:
select titulo
		from libros
	where titulo<>'El aleph' and
		precio =
		(select precio
		from libros
	where titulo='El aleph');
--La subconsulta retorna un solo valor.

--Buscamos los libros cuyo precio supere el precio promedio de los libros por editorial:
select l1.titulo,l1.editorial,l1.precio
		from libros as l1
	where l1.precio >
		(select avg(l2.precio) 
		from libros as l2
    where l1.editorial= l2.editorial);
--Por cada valor de l1, se evalúa la subconsulta, si el precio es mayor que el promedio.

/*****************************************Subconsulta en lugar de una tabla********************************
Se pueden emplear subconsultas que retornen un conjunto de registros de varios campos en lugar de una tabla.

Se la denomina tabla derivada y se coloca en la cláusula "from" para que la use un "select" externo.*/

--La tabla derivada debe ir entre paréntesis y tener un alias para poder referenciarla. La sintaxis básica es la siguiente:
select ALIASdeTABLADERIVADA.CAMPO
		from (TABLADERIVADA) as ALIAS;
--La tabla derivada es una subsonsulta.

--Podemos probar la consulta que retorna la tabla derivada y luego agregar el "select" externo:
select f.*,
		(select sum(d.precio*cantidad)
		from Detalles as d
  where f.numero=d.numerofactura) as total
		from facturas as f;
--La consulta anterior contiene una subconsulta correlacionada; retorna todos los datos de "facturas" y el monto total por factura de "detalles". 
--Esta consulta retorna varios registros y varios campos y será la tabla derivada que emplearemos en la siguiente consulta
select td.numero,c.nombre,td.total
		from clientes as c
		join (select f.*,
		(select sum(d.precio*cantidad)
		from Detalles as d
    where f.numero=d.numerofactura) as total
	from facturas as f) as td
	on td.codigocliente=c.codigo;
/*
La consulta anterior retorna, de la tabla derivada (referenciada con "td") el número de factura y el monto total, y de la tabla "clientes", 
el nombre del cliente. Note que este "join" no emplea 2 tablas, sino una tabla propiamente dicha y una tabla derivada, que es en realidad una subconsulta.
*/

/*****************************************Subconsulta (update - delete)*************************************/
--sintaxis
update TABLA set CAMPO=NUEVOVALOR
		where CAMPO= (SUBCONSULTA);
--ejemplo actualizamos el precio de todos los libros de editorial "Emece":
update libros set precio=precio+(precio*0.1)
		where codigoeditorial=
		(select codigo
		from editoriales
		where nombre='Emece');

--La subconsulta retorna un único valor. También podemos hacerlo con un join.

--La sintaxis básica para realizar eliminaciones con subconsulta es la siguiente:
delete from TABLA
	where CAMPO in (SUBCONSULTA);

--Eliminamos todos los libros de las editoriales que tiene publicados libros de "Juan Perez":
delete from libros
		where codigoeditorial in
		(select e.codigo
		from editoriales as e
		join libros
		on codigoeditorial=e.codigo
		where autor='Juan Perez');

--La subconsulta es una combinación que retorna una lista de valores que la consulta externa emplea al seleccionar los registros para la eliminación.
/*****************************************Subconsulta (insert)**********************************************/
--Se puede ingresar registros en una tabla empleando un "select".

--sintaxis
insert into TABLAENQUESEINGRESA (CAMPOSTABLA1)
	select (CAMPOSTABLACONSULTADA)
	from TABLACONSULTADA;

--Un profesor almacena las notas de sus alumnos en una tabla llamada "alumnos". Tiene otra tabla llamada "aprobados", con algunos campos iguales a la tabla "alumnos" pero en ella solamente almacenará los alumnos que han aprobado el ciclo.
--Ingresamos registros en la tabla "aprobados" seleccionando registros de la tabla "alumnos":
insert into aprobados (documento,nota)
	select (documento,nota)
	from alumnos;
--Entonces, se puede insertar registros en una tabla con la salida devuelta por una consulta a otra tabla; 
--para ello escribimos la consulta y le anteponemos "insert into" junto al nombre de la tabla en la cual ingresaremos los registros y los campos que se cargarán (si se ingresan todos los campos no es necesario listarlos).

--La cantidad de columnas devueltas en la consulta debe ser la misma que la cantidad de campos a cargar en el "insert".

--Se pueden insertar valores en una tabla con el resultado de una consulta que incluya cualquier tipo de "join".
