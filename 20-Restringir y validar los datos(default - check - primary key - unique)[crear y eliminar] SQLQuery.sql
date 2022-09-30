/******************************restringir y validar los datos*********************************
SQL Server ofrece m�s alternativas, adem�s de las aprendidas, para restringir y validar los datos.
*/

/*restricciones.
Las restricciones (constraints) son un m�todo para mantener la integridad de los datos, asegurando que los valores ingresados sean v�lidos y que las relaciones entre las tablas se mantenga. 
Se establecen a los campos y las tablas.

Pueden definirse al crear la tabla ("create table") o agregarse a una tabla existente (empleando "alter table") y se pueden aplicar a un campo o a varios. 
Se aconseja crear las tablas y luego agregar las restricciones.

Se pueden crear, modificar y eliminar las restricciones sin eliminar la tabla y volver a crearla.

El procedimiento almacenado del sistema "sp_helpconstraint" junto al nombre de la tabla, nos muestra informaci�n acerca de las restricciones de dicha tabla.
*/

/*********************************Restricci�n default**********************************/
--La restricci�n "default" especifica un valor por defecto para un campo cuando no se inserta expl�citamente en un comando "insert".
--Anteriormente, para establecer un valor por defecto para un campo emple�bamos la cl�usula "default" al crear la tabla, por ejemplo:
create table libros(
...
autor varchar(30) default 'Desconocido',-- Cada vez que establec�amos un valor por defecto para un campo de una tabla, SQL Server creaba autom�ticamente una restricci�n "default" para ese campo de esa tabla
...
);
--Dicha restricci�n, a la cual no le d�bamos un nombre, recib�a un nombre dado por SQL Server que consiste "DF" (por default), seguido del nombre de la tabla, el nombre del campo y letras y n�meros aleatorios.

--Podemos agregar una restricci�n "default" a una tabla existente con la sintaxis b�sica siguiente
alter table NOMBRETABLA
 add constraint NOMBRECONSTRAINT
 default VALORPORDEFECTO
 for CAMPO;
--ejemplo practico
alter table libros
 add constraint DF_libros_autor
 default 'Desconocido'
 for autor;

--La restricci�n "default" acepta valores tomados de funciones del sistema, por ejemplo, podemos establecer que el valor por defecto de un campo de tipo datetime sea "getdate()".
--Podemos ver informaci�n referente a las restriciones de una tabla con el procedimiento almacenado "sp_helpcontraint":
 exec sp_helpconstraint libros;

/**********************************Restricci�n check***********************************/
--La restricci�n "check" especifica los valores que acepta un campo, evitando que se ingresen valores inapropiados.
--Un campo puede tener varias restricciones restricciones "check" y una restricci�n "check" puede incluir varios campos
--La sintaxis b�sica es la siguiente:
 alter table NOMBRETABLA
 add constraint NOMBRECONSTRAINT
 check CONDICION;

/*
Trabajamos con la tabla "libros" de una librer�a que tiene los siguientes campos: codigo, titulo, autor, editorial, preciomin (que indica el precio para los minoristas) y preciomay (que indica el precio para los mayoristas).

Los campos correspondientes a los precios (minorista y mayorista) se definen de tipo decimal(5,2), es decir, aceptan valores entre -999.99 y 999.99. Podemos controlar que no se ingresen valores negativos para dichos campos agregando una restricci�n "check":
*/
alter table libros
 add constraint CK_libros_precio_positivo
 check (preciomin>=0 and preciomay>=0);
 --Este tipo de restricci�n verifica los datos cada vez que se ejecuta una sentencia "insert" o "update", es decir, act�a en inserciones y actualizaciones.
--Las condiciones para restricciones "check" tambi�n pueden pueden incluir un patr�n o una lista de valores. Por ejemplo establecer que cierto campo conste de 4 caracteres, 2 letras y 2 d�gitos:
 ...
 check (CAMPO like '[A-Z][A-Z][0-9][0-9]');
 ...
 check (CAMPO in ('lunes','miercoles','viernes'));--O establecer que cierto campo asuma s�lo los valores que se listan:
--No se puede aplicar esta restricci�n junto con la propiedad "identity".

/*********************Deshabilitar restricciones (with check - nocheck)**************************/
--Es posible deshabilitar esta comprobaci�n en caso de restricciones "check".

--Podemos hacerlo cuando agregamos la restricci�n "check" a una tabla para que SQL Server acepte los valores ya almacenados que infringen la restricci�n. Para ello debemos incluir la opci�n "with nocheck" en la instrucci�n "alter table":

 alter table libros
  with nocheck
  add constraint CK_libros_precio
  check (precio>=0); 
--La restricci�n no se aplica en los datos existentes, pero si intentamos ingresar un nuevo valor que no cumpla la restricci�n, SQL Server no lo permite

--Entonces, para evitar la comprobaci�n de datos existentes al crear la restricci�n, la sintaxis b�sica es la siguiente:

 alter table TABLA
  with nocheck
  add constraint NOMBRERESTRICCION
  check (CONDICION);
 --Por defecto, si no especificamos, la opci�n es "with check".
--Tambi�n podemos deshabilitar las restricciones para agregar o actualizar datos sin comprobarla:

 alter table libros
  nocheck constraint CK_libros_precio;
--En el ejemplo anterior deshabilitamos la restricci�n "CK_libros_precio" para poder ingresar un valor negativo para "precio".

--Para habilitar una restricci�n deshabilitada se ejecuta la misma instrucci�n pero con la cl�usula "check" o "check all":

 alter table libros
  check constraint CK_libros_precio;
/******************************Restricci�n primary key*****************************************/

--hora veremos las restricciones que se aplican a las tablas, que aseguran valores �nicos para cada registro.

--Hay 2 tipos: 1) primary key y 2) unique.

--Anteriormente, para establecer una clave primaria para una tabla emple�bamos la siguiente sintaxis al crear la tabla, por ejemplo:

 create table libros(
  codigo int not null,
  titulo varchar(30),
  autor varchar(30),
  editorial varchar(20),
  primary key(codigo)
 );
--Cada vez que establec�amos la clave primaria para la tabla, SQL Server creaba autom�ticamente una restricci�n "primary key" para dicha tabla. Dicha restricci�n, a la cual no le d�bamos un nombre, recib�a un nombre dado por SQL Server que comienza con "PK" (por primary key), seguido del nombre de la tabla y una serie de letras y n�meros aleatorios.

--Podemos agregar una restricci�n "primary key" a una tabla existente con la sintaxis b�sica siguiente:

 alter table NOMBRETABLA
 add constraint NOMBRECONSTRAINT
 primary key (CAMPO,...);
--En el siguiente ejemplo definimos una restricci�n "primary key" para nuestra tabla "libros" para asegurarnos que cada libro tendr� un c�digo diferente y �nico:

 alter table libros
 add constraint PK_libros_codigo
 primary key(codigo);
/**************************************Restriccion unique**************************************/
--Se emplea cuando ya se estableci� una clave primaria (como un n�mero de legajo) pero se necesita asegurar que otros datos tambi�n sean �nicos y no se repitan (como n�mero de documento).
--impide la duplicacion de claves alternas (no primarias), es decir. especifica que dos registros no puedan tener el mismo valor en un campo.
--se permiten valores nulos. Se pueden aplicar varias restricciones de este tipo a una misma tabla, y pueden aplicarse a uno o varios campos que no sean clave primaria.
--sintaxis
alter table NOMBRETABLA
 add constraint NOMBRERESTRICCION
 unique (CAMPO);

 --es decir 
 alter table alumnos
  add constraint UQ_alumnos_documento -- para una mejor visualizacion podemos formular el nombre de la seguiente manera UQ_NOMBRETABLA_NOMBRECAMPO
  unique (documento); --Esta restricci�n permite valores nulos,

/******************************Eliminar restricciones (alter table - drop)********************/

--sintaxis
alter table NOMBRETABLA
  drop NOMBRERESTRICCION;

--Para eliminar la restricci�n "DF_libros_autor" de la tabla libros tipeamos:

 alter table libros
  drop DF_libros_autor;

--Pueden eliminarse varias restricciones con una sola instrucci�n separ�ndolas por comas.