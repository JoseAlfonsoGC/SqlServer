
/****************************************Restricciones (foreign key)*****************************************/

/*En sqlServer existen diferentes alternativas para asegurar la integridad de datos de las cuales son:
1) de los campos: default y check
2) de la tabla: primary key y unique.
3) referencial: foreign key, la analizaremos ahora. en esta ocacion se explicara uso de (foreign key)

Un campo que no es clave primaria en una tabla y sirve para enlazar sus valores con otra tabla en la cual es clave primaria se denomina clave for�nea, externa o ajena que puede ser ("primary key" o "unique" de la misma tabla o de otra).
se define un campo o varios del mismo tipo de dato.
*/
--En el ejemplo de la librer�a en que utilizamos las tablas "libros" y "editoriales" con estos campos:
libros: codigo (clave primaria), titulo, autor, codigoeditorial, precio y
editoriales: codigo (clave primaria), nombre.

--el campo "codigoeditorial" de "libros" es una clave for�nea, se emplea para enlazar la tabla "libros" con "editoriales" y es clave primaria en "editoriales" con el nombre "codigo".

--Las claves for�neas y las claves primarias deben ser del mismo tipo para poder enlazarse. Si modificamos una, debemos modificar la otra para que los valores se correspondan.

--Cuando alteramos una tabla, debemos tener cuidado con las claves for�neas. Si modificamos el tipo, longitud o atributos de una clave for�nea, �sta puede quedar inhabilitada para hacer los enlaces.

--Entonces, una clave for�nea es un campo (o varios) empleados para enlazar datos de 2 tablas, para establecer un "join" con otra tabla en la cual es clave primaria.
--sintaxis para agregar una restriccion "foreign key"
alter table NOMBRETABLA1 -- NOMBRETABLA1 referencia el nombre de la tabla a la cual le aplicamos la restricci�n,
		add constraint NOMBRERESTRICCION -- NOMBRERESTRICCION es el nombre que le damos a la misma,
		foreign key (CAMPOCLAVEFORANEA) -- - luego de "foreign key", entre par�ntesis se coloca el campo de la tabla a la que le aplicamos la restricci�n que ser� establecida como clave for�nea
		references NOMBRETABLA2 (CAMPOCLAVEPRIMARIA); -- luego de "references" indicamos el nombre de la tabla referenciada y el campo que es clave primaria en la misma, a la cual hace referencia la clave for�nea. 
												--La tabla referenciada debe tener definida una restricci�n "primary key" o "unique"; si no la tiene, aparece un mensaje de error.
--Ejemplo practico
alter table libros
		add constraint FK_libros_codigoeditorial
		foreign key (codigoeditorial) -- existe un libro con un valor de c�digo para editorial que no existe en la tabla "editoriales", la restricci�n no se agrega
		references editoriales(codigo);
--Si al ingresar un registro (un libro), no colocamos el valor para el campo clave for�nea (codigoeditorial), almacenar� "null", porque esta restricci�n permite valores nulos (a menos que se haya especificado lo contrario al definir el campo).
/*
Act�a en eliminaciones y actualizaciones. Si intentamos eliminar un registro o modificar un valor de clave primaria de una tabla si una clave for�nea hace referencia a dicho registro, SQL Server no lo permite (excepto si se permite la acci�n en cascada, tema que veremos posteriormente). Por ejemplo, si intentamos eliminar una editorial a la que se hace referencia en "libros", aparece un mensaje de error.

Esta restricci�n (a diferencia de "primary key" y "unique") no crea �ndice automaticamente.

La cantidad y tipo de datos de los campos especificados luego de "foreign key" DEBEN coincidir con la cantidad y tipo de datos de los campos de la cl�usula "references".

Esta restricci�n se puede definir dentro de la misma tabla (lo veremos m�s adelante) o entre distintas tablas.

Una tabla puede tener varias restricciones "foreign key".

No se puede eliminar una tabla referenciada en una restricci�n "foreign key", aparece un mensaje de error.

Una restriccion "foreign key" no puede modificarse, debe eliminarse y volverse a crear.

Para ver informaci�n acerca de esta restricci�n podemos ejecutar el procedimiento almacenado "sp_helpconstraint" junto al nombre de la tabla. Nos muestra el tipo, nombre, la opci�n para eliminaciones y actualizaciones, el estado (temas que veremos m�s adelante), el nombre del campo y la tabla y campo que referencia.
Tambi�n informa si la tabla es referenciada por una clave for�nea.
*/
/*******************************Restricciones foreign key en la misma tabla***********************************/
--Una mutual almacena los datos de sus afiliados en una tabla llamada "afiliados". Algunos afiliados inscriben a sus familiares. La tabla contiene un campo que hace referencia al afiliado que lo incorpor� a la mutual, del cual dependen.

--La estructura de la tabla es la siguiente:
create table afiliados(
  numero int identity not null,
  documento char(8) not null,
  nombre varchar(30),
  afiliadotitular int,
  primary key (documento),
  unique (numero)
 );
 --En caso que un afiliado no haya sido incorporado a la mutual por otro afiliado, el campo "afiliadotitular" almacenar� "null".

 --Establecemos una restricci�n "foreign key" para asegurarnos que el n�mero de afiliado que se ingrese en el campo "afiliadotitular" exista en la tabla "afiliados":
alter table afiliados
		add constraint FK_afiliados_afiliadotitular
		foreign key (afiliadotitular)
		references afiliados (numero);

--La sintaxis es la misma, excepto que la tabla se autoreferencia.

--Luego de aplicar esta restricci�n, cada vez que se ingrese un valor en el campo "afiliadotitular", SQL Server controlar� que dicho n�mero exista en la tabla, si no existe, mostrar� un mensaje de error.

--Si intentamos eliminar un afiliado que es titular de otros afiliados, no se podr� hacer, a menos que se haya especificado la acci�n en cascada (pr�ximo tema).

/********************************************Restricciones foreign key (acciones)*******************************************/
/*
Si intentamos eliminar un registro de la tabla referenciada por una restricci�n "foreign key" cuyo valor de clave primaria existe referenciada en la tabla que tiene dicha restricci�n, 
la acci�n no se ejecuta y aparece un mensaje de error. Esto sucede porque, por defecto, para eliminaciones, la opci�n de la restricci�n "foreign key" es "no action". Lo mismo sucede si intentamos actualizar un valor de clave primaria de una tabla referenciada por una "foreign key" existente en la tabla principal.

La restricci�n "foreign key" tiene las cl�usulas "on delete" y "on update" que son opcionales.
*/
/*
- "no action": indica que si intentamos eliminar o actualizar un valor de la clave primaria de la tabla referenciada (TABLA2) que tengan referencia en la tabla principal (TABLA1), se genere un error y la acci�n no se realice; es la opci�n predeterminada.

- "cascade": indica que si eliminamos o actualizamos un valor de la clave primaria en la tabla referenciada (TABLA2), los registros coincidentes en la tabla principal (TABLA1), tambi�n se eliminen o modifiquen; es decir, 
si eliminamos o modificamos un valor de campo definido con una restricci�n "primary key" o "unique", dicho cambio se extiende al valor de clave externa de la otra tabla (integridad referencial en cascada).
*/
/*
Ejemplo
Definimos una restricci�n "foreign key" a la tabla "libros" estableciendo el campo "codigoeditorial" como clave for�nea que referencia al campo "codigo" de la tabla "editoriales". 
La tabla "editoriales" tiene como clave primaria el campo "codigo". Especificamos la acci�n en cascada para las actualizaciones y eliminaciones:
*/
--sintaxis
alter table libros
  add constraint FK_libros_codigoeditorial
  foreign key (codigoeditorial)
  references editoriales(codigo)
  on update cascade
  on delete cascade;

--si al agregar una restriccion foreign key
alter table TABLA1
		add constraint NOMBRERESTRICCION
		foreign key (CAMPOCLAVEFORANEA)
		references TABLA2(CAMPOCLAVEPRIMARIA)
		on delete OPCION
		on update OPCION;

/*
- no se especifica acci�n para eliminaciones (o se especifica "no action"), y se intenta eliminar un registro de la tabla referenciada (editoriales) cuyo valor de clave primaria (codigo) existe en la tabla principal (libros), la acci�n no se realiza.

- se especifica "cascade" para eliminaciones ("on delete cascade") y elimina un registro de la tabla referenciada (editoriales) cuyo valor de clave primaria (codigo) existe en la tabla principal(libros), 
la eliminaci�n de la tabla referenciada (editoriales) se realiza y se eliminan de la tabla principal (libros) todos los registros cuyo valor coincide con el registro eliminado de la tabla referenciada (editoriales).

- no se especifica acci�n para actualizaciones (o se especifica "no action"), y se intenta modificar un valor de clave primaria (codigo) de la tabla referenciada (editoriales) que existe en el campo clave for�nea (codigoeditorial) de la tabla principal (libros), la acci�n no se realiza.

- se especifica "cascade" para actualizaciones ("on update cascade") y se modifica un valor de clave primaria (codigo) de la tabla referenciada (editoriales) que existe en la tabla principal (libros), 
SQL Server actualiza el registro de la tabla referenciada (editoriales) y todos los registros coincidentes en la tabla principal (libros).
*/
/*************************Restricciones foreign key deshabilitar y eliminar (with check - nocheck)*****************************/
--si agregamos una restriccion a una tabla, sql server los controla para asegurar que cumplen con la restriccion, es posible deshabilitar esta comprobacion.
--Podemos hacerlo al momento de agregar la restricci�n a una tabla con datos, incluyendo la opci�n "with nocheck" en la instrucci�n "alter table"; si se emplea esta opci�n, los datos no van a cumplir la restricci�n.

--Se pueden deshabilitar las restricciones "check" y "foreign key", a las dem�s se las debe eliminar.

--La sintaxis b�sica al agregar la restriccci�n "foreign key" es la siguiente:

alter table NOMBRETABLA1
		with OPCIONDECHEQUEO
		add constraint NOMBRECONSTRAINT
		foreign key (CAMPOCLAVEFORANEA)
		references NOMBRETABLA2 (CAMPOCLAVEPRIMARIA)
  on update OPCION
  on delete OPCION;

/*
La opci�n "with OPCIONDECHEQUEO" especifica si se controlan los datos existentes o no con "check" y "nocheck" respectivamente. Por defecto, si no se especifica, la opci�n es "check".

En el siguiente ejemplo agregamos una restricci�n "foreign key" que controla que todos los c�digos de editorial tengan un c�digo v�lido, es decir, dicho c�digo exista en "editoriales". 
La restricci�n no se aplica en los datos existentes pero si en los siguientes ingresos, modificaciones y actualizaciones:
*/
alter table libros
		with nocheck
		add constraint FK_libros_codigoeditorial
		foreing key (codigoeditorial)
 references editoriales(codigo);


--La comprobaci�n de restricciones se puede deshabilitar para modificar, eliminar o agregar datos a una tabla sin comprobar la restricci�n. La sintaxis general es:

 alter table NOMBRETABLA
 OPCIONDECHEQUEO constraint NOMBRERESTRICCION;
--En el siguiente ejemplo deshabilitamos la restricci�n creada anteriormente:

 alter table libros
 nocheck constraint FK_libros_codigoeditorial;
--Para habilitar una restricci�n deshabilitada se ejecuta la misma instrucci�n pero con la cl�usula "check" o "check all":

 alter table libros
  check constraint FK_libros_codigoeditorial;
--Si se emplea "check constraint all" no se coloca nombre de restricciones, habilita todas las restricciones que tiene la tabla nombrada ("check" y "foreign key").

--Para saber si una restricci�n est� habilitada o no, podemos ejecutar el procedimiento almacenado "sp_helpconstraint" y entenderemos lo que informa la columna "status_enabled".

--Entonces, las cl�usulas "check" y "nocheck" permiten habilitar o deshabilitar restricciones "foreign key" (y "check"). 
--Pueden emplearse para evitar la comprobaci�n de datos existentes al crear la restricci�n o para deshabilitar la comprobaci�n de datos al ingresar, actualizar y eliminar alg�n registro que infrinja la restricci�n.

--Podemos eliminar una restricci�n "foreign key" con "alter table". La sintaxis b�sica es la misma que para cualquier otra restricci�n:

 alter table TABLA
  drop constraint NOMBRERESTRICCION;--Eliminamos la restricci�n de "libros":

 alter table libros
  drop constraint FK_libros_codigoeditorial; --No se puede eliminar una tabla si una restricci�n "foreign key" hace referencia a ella.

--Cuando eliminamos una tabla que tiene una restricci�n "foreign key", la restricci�n tambi�n se elimina.
/*******************************************Restricciones foreign key (informaci�n)*******************************************/
--El procedimiento almacenado "sp_helpconstraint" devuelve las siguientes columnas

/*
- constraint_type: tipo de restricci�n. Si es una restricci�n de campo (default o check) indica sobre qu� campo fue establecida. Si es de tabla (primary key o unique) indica el tipo de �ndice creado. Si es una "foreign key" lo indica.

- constraint_name: nombre de la restricci�n.

- delete_action: solamente es aplicable para restricciones de tipo "foreign key". Indica si la acci�n de eliminaci�n act�a, no act�a o es en cascada. Indica "n/a" en cualquier restricci�n para la que no se aplique; "No Action" si no act�a y "Cascade" si es en cascada.

- update_action: s�lo es aplicable para restricciones de tipo "foreign key". Indica si la acci�n de actualizaci�n es: No Action, Cascade, or n/a. Indica "n/a" en cualquier restricci�n para la que no se aplique.

- status_enabled: solamente es aplicable para restricciones de tipo "check" y "foreign key". Indica si est� habilitada (Enabled) o no (Disabled). Indica "n/a" en cualquier restricci�n para la que no se aplique.

- status_for_replication: solamente es aplicable para restricciones de tipo "check" y "foreign key". Indica "n/a" en cualquier restricci�n para la que no se aplique.

- constraint_keys: Si es una restricci�n "default" muestra la condici�n de chequeo; si es una restricci�n "default", el valor por defecto; si es una "primary key", "unique" o "foreign key" muestra el/ los campos a los que se aplicaron la restricci�n. En caso de valores predeterminados y reglas, el texto que lo define.

*/

/**************************************************Restricciones al crear la tabla*********************************************/
--En el siguiente ejemplo creamos la tabla "libros" con varias restricciones:
create table libros(
		codigo int identity,
		titulo varchar(40),
		codigoautor int not null,
		codigoeditorial tinyint not null,
		precio decimal(5,2)
	constraint DF_precio default (0),
	constraint PK_libros_codigo
	primary key clustered (codigo),
	constraint UQ_libros_tituloautor
    unique (titulo,codigoautor),
	constraint FK_libros_editorial
	foreign key (codigoeditorial)
	references editoriales(codigo)
	on update cascade,
	constraint FK_libros_autores
	foreign key (codigoautor)
	references autores(codigo)
	on update cascade,
	constraint CK_precio_positivo check (precio>=0)
);
/*
En el ejemplo anterior creamos:

- una restricci�n "default" para el campo "precio" (restricci�n a nivel de campo);

- una restricci�n "primary key" con �ndice agrupado para el campo "codigo" (a nivel de tabla);

- una restricci�n "unique" con �ndice no agrupado (por defecto) para los campos "titulo" y "codigoautor" (a nivel de tabla);

- una restricci�n "foreign key" para establecer el campo "codigoeditorial" como clave externa que haga referencia al campo "codigo" de "editoriales y permita actualizaciones en cascada y no eliminaciones (por defecto "no action");

- una restricci�n "foreign key" para establecer el campo "codigoautor" como clave externa que haga referencia al campo "codigo" de "autores" y permita actualizaciones en cascada y no eliminaciones;

- una restricci�n "check" para el campo "precio" que no admita valores negativos;

Si definimos una restricci�n "foreign key" al crear una tabla, la tabla referenciada debe existir.
*/