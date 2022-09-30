/******************************restringir y validar los datos*********************************
SQL Server ofrece más alternativas, además de las aprendidas, para restringir y validar los datos.
*/

/*restricciones.
Las restricciones (constraints) son un método para mantener la integridad de los datos, asegurando que los valores ingresados sean válidos y que las relaciones entre las tablas se mantenga. 
Se establecen a los campos y las tablas.

Pueden definirse al crear la tabla ("create table") o agregarse a una tabla existente (empleando "alter table") y se pueden aplicar a un campo o a varios. 
Se aconseja crear las tablas y luego agregar las restricciones.

Se pueden crear, modificar y eliminar las restricciones sin eliminar la tabla y volver a crearla.

El procedimiento almacenado del sistema "sp_helpconstraint" junto al nombre de la tabla, nos muestra información acerca de las restricciones de dicha tabla.
*/

/*********************************Restricción default**********************************/
--La restricción "default" especifica un valor por defecto para un campo cuando no se inserta explícitamente en un comando "insert".
--Anteriormente, para establecer un valor por defecto para un campo empleábamos la cláusula "default" al crear la tabla, por ejemplo:
create table libros(
...
autor varchar(30) default 'Desconocido',-- Cada vez que establecíamos un valor por defecto para un campo de una tabla, SQL Server creaba automáticamente una restricción "default" para ese campo de esa tabla
...
);
--Dicha restricción, a la cual no le dábamos un nombre, recibía un nombre dado por SQL Server que consiste "DF" (por default), seguido del nombre de la tabla, el nombre del campo y letras y números aleatorios.

--Podemos agregar una restricción "default" a una tabla existente con la sintaxis básica siguiente
alter table NOMBRETABLA
 add constraint NOMBRECONSTRAINT
 default VALORPORDEFECTO
 for CAMPO;
--ejemplo practico
alter table libros
 add constraint DF_libros_autor
 default 'Desconocido'
 for autor;

--La restricción "default" acepta valores tomados de funciones del sistema, por ejemplo, podemos establecer que el valor por defecto de un campo de tipo datetime sea "getdate()".
--Podemos ver información referente a las restriciones de una tabla con el procedimiento almacenado "sp_helpcontraint":
 exec sp_helpconstraint libros;

/**********************************Restricción check***********************************/
--La restricción "check" especifica los valores que acepta un campo, evitando que se ingresen valores inapropiados.
--Un campo puede tener varias restricciones restricciones "check" y una restricción "check" puede incluir varios campos
--La sintaxis básica es la siguiente:
 alter table NOMBRETABLA
 add constraint NOMBRECONSTRAINT
 check CONDICION;

/*
Trabajamos con la tabla "libros" de una librería que tiene los siguientes campos: codigo, titulo, autor, editorial, preciomin (que indica el precio para los minoristas) y preciomay (que indica el precio para los mayoristas).

Los campos correspondientes a los precios (minorista y mayorista) se definen de tipo decimal(5,2), es decir, aceptan valores entre -999.99 y 999.99. Podemos controlar que no se ingresen valores negativos para dichos campos agregando una restricción "check":
*/
alter table libros
 add constraint CK_libros_precio_positivo
 check (preciomin>=0 and preciomay>=0);
 --Este tipo de restricción verifica los datos cada vez que se ejecuta una sentencia "insert" o "update", es decir, actúa en inserciones y actualizaciones.
--Las condiciones para restricciones "check" también pueden pueden incluir un patrón o una lista de valores. Por ejemplo establecer que cierto campo conste de 4 caracteres, 2 letras y 2 dígitos:
 ...
 check (CAMPO like '[A-Z][A-Z][0-9][0-9]');
 ...
 check (CAMPO in ('lunes','miercoles','viernes'));--O establecer que cierto campo asuma sólo los valores que se listan:
--No se puede aplicar esta restricción junto con la propiedad "identity".

/*********************Deshabilitar restricciones (with check - nocheck)**************************/
--Es posible deshabilitar esta comprobación en caso de restricciones "check".

--Podemos hacerlo cuando agregamos la restricción "check" a una tabla para que SQL Server acepte los valores ya almacenados que infringen la restricción. Para ello debemos incluir la opción "with nocheck" en la instrucción "alter table":

 alter table libros
  with nocheck
  add constraint CK_libros_precio
  check (precio>=0); 
--La restricción no se aplica en los datos existentes, pero si intentamos ingresar un nuevo valor que no cumpla la restricción, SQL Server no lo permite

--Entonces, para evitar la comprobación de datos existentes al crear la restricción, la sintaxis básica es la siguiente:

 alter table TABLA
  with nocheck
  add constraint NOMBRERESTRICCION
  check (CONDICION);
 --Por defecto, si no especificamos, la opción es "with check".
--También podemos deshabilitar las restricciones para agregar o actualizar datos sin comprobarla:

 alter table libros
  nocheck constraint CK_libros_precio;
--En el ejemplo anterior deshabilitamos la restricción "CK_libros_precio" para poder ingresar un valor negativo para "precio".

--Para habilitar una restricción deshabilitada se ejecuta la misma instrucción pero con la cláusula "check" o "check all":

 alter table libros
  check constraint CK_libros_precio;
/******************************Restricción primary key*****************************************/

--hora veremos las restricciones que se aplican a las tablas, que aseguran valores únicos para cada registro.

--Hay 2 tipos: 1) primary key y 2) unique.

--Anteriormente, para establecer una clave primaria para una tabla empleábamos la siguiente sintaxis al crear la tabla, por ejemplo:

 create table libros(
  codigo int not null,
  titulo varchar(30),
  autor varchar(30),
  editorial varchar(20),
  primary key(codigo)
 );
--Cada vez que establecíamos la clave primaria para la tabla, SQL Server creaba automáticamente una restricción "primary key" para dicha tabla. Dicha restricción, a la cual no le dábamos un nombre, recibía un nombre dado por SQL Server que comienza con "PK" (por primary key), seguido del nombre de la tabla y una serie de letras y números aleatorios.

--Podemos agregar una restricción "primary key" a una tabla existente con la sintaxis básica siguiente:

 alter table NOMBRETABLA
 add constraint NOMBRECONSTRAINT
 primary key (CAMPO,...);
--En el siguiente ejemplo definimos una restricción "primary key" para nuestra tabla "libros" para asegurarnos que cada libro tendrá un código diferente y único:

 alter table libros
 add constraint PK_libros_codigo
 primary key(codigo);
/**************************************Restriccion unique**************************************/
--Se emplea cuando ya se estableció una clave primaria (como un número de legajo) pero se necesita asegurar que otros datos también sean únicos y no se repitan (como número de documento).
--impide la duplicacion de claves alternas (no primarias), es decir. especifica que dos registros no puedan tener el mismo valor en un campo.
--se permiten valores nulos. Se pueden aplicar varias restricciones de este tipo a una misma tabla, y pueden aplicarse a uno o varios campos que no sean clave primaria.
--sintaxis
alter table NOMBRETABLA
 add constraint NOMBRERESTRICCION
 unique (CAMPO);

 --es decir 
 alter table alumnos
  add constraint UQ_alumnos_documento -- para una mejor visualizacion podemos formular el nombre de la seguiente manera UQ_NOMBRETABLA_NOMBRECAMPO
  unique (documento); --Esta restricción permite valores nulos,

/******************************Eliminar restricciones (alter table - drop)********************/

--sintaxis
alter table NOMBRETABLA
  drop NOMBRERESTRICCION;

--Para eliminar la restricción "DF_libros_autor" de la tabla libros tipeamos:

 alter table libros
  drop DF_libros_autor;

--Pueden eliminarse varias restricciones con una sola instrucción separándolas por comas.