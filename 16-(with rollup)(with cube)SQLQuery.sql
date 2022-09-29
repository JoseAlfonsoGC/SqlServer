/*************************************with rollup************************************************
El operador "rollup" resume valores de grupos. representan los valores de resumen de la precedente.
*/
--Ejemplo compartacion
--Tenemos la tabla "visitantes" con los siguientes campos: nombre, edad, sexo, domicilio, ciudad, telefono, montocompra.
--Si necesitamos la cantidad de visitantes por ciudad empleamos la siguiente sentencia:
select ciudad,count(*) as cantidad
		from visitantes
		group by ciudad;--Esta consulta muestra el total de visitantes agrupados por ciudad
--pero si queremos además la cantidad total de visitantes, debemos realizar otra consulta
select count(*) as total
		from visitantes;
--Para obtener ambos resultados en una sola consulta podemos usar "with rollup" que nos devolverá ambas salidas en una sola consulta
--La consulta anterior retorna los registros agrupados por ciudad y una fila extra en la que la primera columna contiene "null" y la columna con la cantidad muestra la cantidad total.
--La cláusula "group by" permite agregar el modificador "with rollup", el cual agrega registros extras al resultado de una consulta, que muestran operaciones de resumen.
select ciudad,count(*) as cantidad
		from visitantes
		group by ciudad with rollup;

--Si agrupamos por 2 campos, "ciudad" y "sexo":
/*
La salida muestra los totales por ciudad y sexo y produce tantas filas extras como valores existen del primer campo por el que se agrupa ("ciudad" en este caso), 
mostrando los totales para cada valor, con la columna correspondiente al segundo campo por el que se agrupa ("sexo" en este ejemplo) conteniendo "null", y 1 fila extra mostrando 
el total de todos los visitantes (con las columnas correspondientes a ambos campos conteniendo "null"). Es decir, por cada agrupación, aparece una fila extra con el/ los campos que no se consideran, seteados a "null".
*/
select ciudad,sexo,count(*) as cantidad
  from visitantes
  group by ciudad,sexo
  with rollup;

--Con "rollup" se puede agrupar hasta por 10 campos.

--Es posible incluir varias funciones de agrupamiento, por ejemplo, queremos la cantidad de visitantes y la suma de sus compras agrupados por ciudad y sexo:

 select ciudad,sexo,
  count(*) as cantidad,
  sum(montocompra) as total
  from visitantes
  group by ciudad,sexo
  with rollup;
/****************************************with cube****************************************/
--"cube" genera filas de resumen de subgrupos para todas las combinaciones posibles de los valores de los campos por los que agrupamos.

select sexo,estadocivil,seccion,
  count(*) from empleados
  group by sexo,estadocivil,seccion
  with cube;
  
--retorna más filas extras además de las anteriores:
/*
- sexo y seccion (estadocivil seteado a "null"),
- estadocivil y seccion (sexo seteado a "null"),
- seccion (sexo y estadocivil seteados a "null") y
- estadocivil (sexo y seccion seteados a "null"),
*/

/*
Se pueden colocar hasta 10 campos en el "group by".

Con "cube" se puede emplear "where" y "having", pero no es compatible con "all".
*/