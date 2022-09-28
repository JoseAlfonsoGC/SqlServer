/*Clave primaria*/
create table NOMBRETABLA(
  CAMPOn1 TIPO --en automatico el campo es "not null" y no puedo existir uno valor identico en la columna de la tabla
  CAMPOn2 TIPO
  primary key (CAMPOn1)--Una clave primaria es un campo (o varios) que identifica un solo registro (fila) en una tabla. Para un valor del campo clave existe solamente un registro.
 );

/*Valores null (is null)*/
/*
"null" significa "dato desconocido" o "valor inexistente". No es lo mismo que un valor "0", una cadena vacía o una cadena literal "null".
Por ejemplo, en nuestra tabla de libros, podemos tener valores nulos en el campo 
"precio" porque es posible que para algunos libros no le hayamos establecido el precio para la venta.
*/

create table libros(
  titulo varchar(30) not null,--En contraposición, tenemos campos que no pueden estar vacíos jamás.
  autor varchar(20) not null,
  editorial varchar(15) not null,
  precio float null
 );
 --el insert quedaria de l siguiente manera
 insert into libros (titulo,autor,editorial,precio)
 values('El aleph','Borges','Emece',null);--Note que el valor "null" no es una cadena de caracteres, no se coloca entre comillas

 /*Identity*/
 /*
 Un campo entero puede tener un atributo extra "identity". Los valores de un campo con este atributo genera valores secuenciales que se inician en 1 y se incrementan en 1 automáticamente.
 
 --La función "ident_seed()" retorna el valor de inicio del campo "identity" de la tabla que nombramos:
			select ident_seed('libros');
 --La función "ident_incr()" retorna el valor de incremento del campo "identity" de la tabla nombrada:
			select ident_incr('libros');
--Hemos visto que en un campo declarado "identity" no puede ingresarse explícitamente un valor.
Para permitir ingresar un valor en un campo de identidad se debe activar la opción "identity_insert":
			set identity_insert libros on;
			set identity_insert libros off;
 */

 create table libros(
  codigo int identity(1,1),--Sólo puede haber un campo "identity" por tabla. (1,1) se puede iniciar y seguir la secuencia segun lo requiera el desarrollador ejemplo (1,2) la secuencia ir de 2 en 2 iniciando del 1
						   -- el campo definido como identity no es editable y menos se puede insertar  "por defecto", pero se puede ejecutar (set identity_insert libros on;) si se requiere
						   --cuidado con lo ultimo porque udentity permite que se repitan los registros de una columna
  titulo varchar(40) not null,
  autor varchar(30),
  editorial varchar(15),
  precio float
 );