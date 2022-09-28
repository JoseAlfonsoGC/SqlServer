/*SQL Server tiene 4 tipos de operadores: 1) relacionales o de comparación (los vimos), 2) lógicos (lo veremos más adelante, 3) aritméticos y 4) de concatenación.
 Los operadores aritméticos permiten realizar cálculos con valores numéricos.
 Son: multiplicación (*), división (/) y módulo (%) (el resto de dividir números enteros), suma (+) y resta (-).

 Es posible obtener salidas en las cuales una columna sea el resultado de un cálculo
*/

/*
Si queremos saber el monto total en dinero de un título podemos multiplicar el precio por la cantidad por cada título, 
pero también podemos hacer que SQL Server realice el cálculo y lo incluya en una columna extra en la salida:
*/

select titulo, precio,cantidad,
  precio*cantidad
  from libros;

--Si queremos saber el precio de cada libro con un 10% de descuento podemos incluir en la sentencia los siguientes cálculos:

select titulo,precio,
  precio-(precio*0.1)
  from libros;

--Para concatenar el título, el autor y la editorial de cada libro usamos el operador de concatenación ("+"):
select titulo+'-'+autor+'-'+editorial
  from libros;

/*Alis*/
--permite cambiar los encabezados de las columnas.

select nombre as NombreYApellido,--Un alias puede contener hasta 128 caracteres
  domicilio,telefono
  from agenda;
