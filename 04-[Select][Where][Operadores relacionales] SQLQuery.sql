-- sintaxis basica
select * from nombre_tabla; -- es * indica que se seleccionan todos los campos

select titulo,autor from libros; -- se puede especificar el nombre de los campos que queremos ver separ�ndolos por comas


/*where*/
-- sintaxis basica

select NOMBRECAMPO1, NOMBRECAMPOn
  from NOMBRETABLA
  where CONDICION;

  select nombre, clave
  from usuarios
  where nombre='Marcelo';

--Si ning�n registro cumple la condici�n establecida con el "where", no aparecer� ning�n registro.

/*operadores relacionales*/

/*
=	igual
<>	distinto
>	mayor
<	menor
>=	mayor o igual
<=	menor o igual

Ejemplo podemos comparar valores num�ricos. Por ejemplo, queremos mostrar los t�tulos y precios de los libros cuyo precio sea mayor a 20 pesos:

 select titulo, precio
  from libros
  where precio>20;

*/
