/*SQL Server tiene 4 tipos de operadores: 1) relacionales o de comparaci�n (los vimos), 2) l�gicos (lo veremos m�s adelante, 3) aritm�ticos y 4) de concatenaci�n.
 Los operadores aritm�ticos permiten realizar c�lculos con valores num�ricos.
 Son: multiplicaci�n (*), divisi�n (/) y m�dulo (%) (el resto de dividir n�meros enteros), suma (+) y resta (-).

 Es posible obtener salidas en las cuales una columna sea el resultado de un c�lculo
*/

/*
Si queremos saber el monto total en dinero de un t�tulo podemos multiplicar el precio por la cantidad por cada t�tulo, 
pero tambi�n podemos hacer que SQL Server realice el c�lculo y lo incluya en una columna extra en la salida:
*/

select titulo, precio,cantidad,
  precio*cantidad
  from libros;

--Si queremos saber el precio de cada libro con un 10% de descuento podemos incluir en la sentencia los siguientes c�lculos:

select titulo,precio,
  precio-(precio*0.1)
  from libros;

--Para concatenar el t�tulo, el autor y la editorial de cada libro usamos el operador de concatenaci�n ("+"):
select titulo+'-'+autor+'-'+editorial
  from libros;

/*Alis*/
--permite cambiar los encabezados de las columnas.

select nombre as NombreYApellido,--Un alias puede contener hasta 128 caracteres
  domicilio,telefono
  from agenda;
