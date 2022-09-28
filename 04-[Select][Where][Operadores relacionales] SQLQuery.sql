-- sintaxis basica
select * from nombre_tabla; -- es * indica que se seleccionan todos los campos

select titulo,autor from libros; -- se puede especificar el nombre de los campos que queremos ver separándolos por comas


/*where*/
-- sintaxis basica

select NOMBRECAMPO1, NOMBRECAMPOn
  from NOMBRETABLA
  where CONDICION;

  select nombre, clave
  from usuarios
  where nombre='Marcelo';

--Si ningún registro cumple la condición establecida con el "where", no aparecerá ningún registro.

/*operadores relacionales*/

/*
=	igual
<>	distinto
>	mayor
<	menor
>=	mayor o igual
<=	menor o igual

Ejemplo podemos comparar valores numéricos. Por ejemplo, queremos mostrar los títulos y precios de los libros cuyo precio sea mayor a 20 pesos:

 select titulo, precio
  from libros
  where precio>20;

*/
