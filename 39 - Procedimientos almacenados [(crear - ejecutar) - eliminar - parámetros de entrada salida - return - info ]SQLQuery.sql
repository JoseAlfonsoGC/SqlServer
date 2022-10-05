/**********************************************Procedimientos almacenados Definicion*************************************
*Los procedimientos almacenados se crean en la base de datos seleccionada, excepto los procedimientos almacenados temporales, que se crean en la base de datos "tempdb".

*Definicion**
Vimos que SQL Server ofrece dos alternativas para asegurar la integridad de datos, la integridad:

1) DECLARATIVA, mediante el uso de restricciones (constraints), valores predeterminados (defaults) y reglas (rules) y

2) PROCEDIMENTAL, mediante la implementaci�n de procedimientos almacenados y desencadenadores (triggers).


Un procedimiento almacenado es un conjunto de instrucciones a las que se les da un nombre, que se almacena en el servidor. 
Permiten encapsular tareas repetitivas.

SQL Server permite los siguientes tipos de procedimientos almacenados:

1) del sistema: est�n almacenados en la base de datos "master" y llevan el prefijo "sp_"; permiten recuperar informaci�n de las tablas del sistema y pueden ejecutarse en cualquier base de datos.

2) locales: los crea el usuario (pr�ximo tema).

3) temporales: pueden ser locales, cuyos nombres comienzan con un signo numeral (#), o globales, cuyos nombres comienzan con 2 signos numeral (##). 
Los procedimientos almacenados temporales locales est�n disponibles en la sesi�n de un solo usuario y se eliminan autom�ticamente al finalizar la sesi�n; los globales est�n disponibles en las sesiones de todos los usuarios.

4) extendidos: se implementan como bibliotecas de v�nculos din�micos (DLL, Dynamic-Link Libraries), se ejecutan fuera del entorno de SQL Server. Generalmente llevan el prefijo "xp_". No los estudiaremos.

Al crear un procedimiento almacenado, las instrucciones que contiene se analizan para verificar si son correctas sint�cticamente. 
Si no se detectan errores, SQL Server guarda el nombre del procedimiento almacenado en la tabla del sistema "sysobjects" y su contenido en la tabla del sistema "syscomments" en la base de datos activa. Si se encuentra alg�n error, no se crea.

Un procedimiento almacenados puede hacer referencia a objetos que no existen al momento de crearlo. Los objetos deben existir cuando se ejecute el procedimiento almacenado.

Ventajas:

- comparten la l�gica de la aplicaci�n con las otras aplicaciones, con lo cual el acceso y las modificaciones de los datos se hacen en un solo sitio.

- permiten realizar todas las operaciones que los usuarios necesitan evitando que tengan acceso directo a las tablas.

- reducen el tr�fico de red; en vez de enviar muchas instrucciones, los usuarios realizan operaciones enviando una �nica instrucci�n, lo cual disminuye el n�mero de solicitudes entre el cliente y el servidor.
*/

/******************************************Procedimientos almacenados (crear - ejecutar)************************/
/*
Los procedimientos almacenados pueden hacer referencia a tablas, vistas, a funciones definidas por el usuario, a otros procedimientos almacenados y a tablas temporales.

Un procedimiento almacenado pueden incluir cualquier cantidad y tipo de instrucciones, excepto:

create default, create procedure, create rule, create trigger y create view.
Se pueden crear otros objetos (por ejemplo �ndices, tablas), en tal caso deben especificar el nombre del propietario; se pueden realizar inserciones, actualizaciones, eliminaciones, etc.

Si un procedimiento almacenado crea una tabla temporal, dicha tabla s�lo existe dentro del procedimiento y desaparece al finalizar el mismo. Lo mismo sucede con las variables.

Hemos empleado varias veces procedimientos almacenados del sistema ("sp_help", "sp_helpconstraint", etc.), ahora aprenderemos a crear nuestros propios procedimientos almacenados.
*/
--Ejemplo Para crear un procedimiento almacenado empleamos la instrucci�n "create procedure".
--sintaxis
create procedure NOMBREPROCEDIMIENTO --Para diferenciar los procedimientos almacenados del sistema de los procedimientos almacenados locales use un prefijo diferente a "sp_" cuando les de el nombre.
  as INSTRUCCIONES;

--Con las siguientes instrucciones creamos un procedimiento almacenado llamado "pa_libros_limite_stock" que muestra todos los libros de los cuales hay menos de 10 disponibles:
create proc pa_libros_limite_stock
		as							--despues de 'as' las sentencias que define el procedimiento
		select *from libros
   where cantidad <=10;

--Para ejecutar el procedimiento almacenado creado anteriormente tipeamos:
exec pa_libros_limite_stock;  --"execute" (o "exec"

--Cuando realizamos un ejercicio nuevo, siempre realizamos las mismas tareas: eliminamos la tabla si existe, la creamos y luego ingresamos algunos registros. 
--Podemos crear un procedimiento almacenado que contenga todas estas instrucciones:
create procedure pa_crear_libros
	as
	if object_id('libros')is not null
	drop table libros;
	create table libros(
			codigo int identity,
			titulo varchar(40),
			autor varchar(30),
			editorial varchar(20),
			precio decimal(5,2),
		primary key(codigo)
		);
  insert into libros values('Uno','Richard Bach','Planeta',15);
  insert into libros values('Ilusiones','Richard Bach','Planeta',18);
  insert into libros values('El aleph','Borges','Emece',25);
  insert into libros values('Aprenda PHP','Mario Molina','Nuevo siglo',45);
  insert into libros values('Matematica estas ahi','Paenza','Nuevo siglo',12);
  insert into libros values('Java en 10 minutos','Mario Molina','Paidos',35);

--Y luego lo ejecutamos cada vez que comenzamos un nuevo ejercicio y as� evitamos tipear tantas sentencias:
exec pa_crear_libros;

/***************************************Procedimientos almacenados (eliminar)********************************/
--Los procedimientos almacenados se eliminan con "drop procedure". Sintaxis:
drop procedure NOMBREPROCEDIMIENTO;

--Eliminamos el procedimiento almacenado llamado "pa_libros_autor":
drop procedure pa_libros_autor;

--eliminar un procedimiento almacenado sin que salga el mensaje de error en caso que no exista
if object_id('NOMBREPROCEDIMIENTO') is not null
  drop procedure NOMBREPROCEDIMIENTO;
--'o'
if object_id('pa_libros_autor') is not null
		drop procedure pa_libros_autor --"drop procedure" puede abreviarse con "drop proc"
	else 
		select 'No existe el procedimiento "pa_libros_autor"';
/*
Se recomienda ejecutar el procedimiento almacenado del sistema "sp_depends" para ver si alg�n objeto depende del procedimiento que deseamos eliminar.

Podemos eliminar una tabla de la cual dependa un procedimiento, SQL Server lo permite, pero luego, al ejecutar el procedimiento, 
aparecer� un mensaje de error porque la tabla referenciada no existe.
*/

/********************************Procedimientos almacenados (par�metros de entrada)*************************
Los procedimientos almacenados pueden recibir y devolver informaci�n; para ello se emplean par�metros, de entrada y salida, respectivamente.

-Veamos los primeros. Los par�metros de entrada posibilitan pasar informaci�n a un procedimiento.
Para que un procedimiento almacenado admita par�metros de entrada se deben declarar variables como par�metros al crearlo. La sintaxis es:

 create proc NOMBREPROCEDIMIENTO
  @NOMBREPARAMETRO TIPO =VALORPORDEFECTO
  as SENTENCIAS; 

-Los par�metros se definen luego del nombre del procedimiento, comenzando el nombre con un signo arroba (@). Los par�metros son locales al procedimiento, 
es decir, existen solamente dentro del mismo. Pueden declararse varios par�metros por procedimiento, se separan por comas.

-Cuando el procedimiento es ejecutado, deben explicitarse valores para cada uno de los par�metros (en el orden que fueron definidos), a menos que se haya definido un valor por defecto, 
en tal caso, pueden omitirse. Pueden ser de cualquier tipo de dato (excepto cursor).

-Luego de definir un par�metro y su tipo, opcionalmente, se puede especificar un valor por defecto; tal valor es el que asume el procedimiento al ser ejecutado si no recibe par�metros. 
Si no se coloca valor por defecto, un procedimiento definido con par�metros no puede ejecutarse sin valores para ellos. El valor por defecto puede ser "null" o una constante, tambi�n puede incluir comodines si el procedimiento emplea "like".
*/
--Ejemplo 01 creamos un procedimiento que recibe el nombre de un autor como par�metro para mostrar todos los libros del autor solicitado:
create procedure pa_libros_autor
		@autor varchar(30) 
		as
		select titulo, editorial,precio
		from libros
   where autor= @autor;

exec pa_libros_autor 'Borges'; --"execute" (o "exec") seguido del nombre del procedimiento y un valor para el par�metro:

--Ejemplo 02 creamos un procedimiento que recibe 2 par�metros, el nombre de un autor y el de una editorial:
create procedure pa_libros_autor_editorial
		@autor varchar(30),
		@editorial varchar(20) 
		as
		select titulo, precio
		from libros
   where autor= @autor and
		 editorial=@editorial;

exec pa_libros_autor_editorial 'Richard Bach','Planeta'; --"execute" (o "exec") seguido del nombre del procedimiento y los valores para los par�metros separados por comas:
--sintaxis opcional
exec pa_libros_autor_editorial @editorial='Planeta', @autor='Richard Bach'; --su orden puede alterarse

--No es posible ejecutar un procedimiento-a sin valores si es que los requiere, pero si que podemos hacer que funciones 
--se puede definir valores por defecto para cada par�metro:
create procedure pa_libros_autor_editorial2
	@autor varchar(30)='Richard Bach',
	@editorial varchar(20)='Planeta' --si se tienes valores por defecto y se quiere referir a un campo se usa: exec pa_libros_autor_editorial2 @editorial='Paidos';
	as
		select titulo, autor,editorial,precio
		from libros
   where autor= @autor and
			    editorial=@editorial;

--Podemos emplear patrones de b�squeda en la consulta que define el procedimiento almacenado y utilizar comodines como valores por defecto:
create proc pa_libros_autor_editorial3
	@autor varchar(30) = '%',
	@editorial varchar(30) = '%'
	as 
		select titulo,autor,editorial,precio
		from libros
	where autor like @autor and
					 editorial like @editorial;

/***********************************Procedimientos almacenados (par�metros de salida)***************************
Para que un procedimiento almacenado devuelva un valor se debe declarar una variable con la palabra clave "output" al crear el procedimiento
*/
create procedure NOMBREPROCEDIMIENTO
	@PARAMETROENTRADA TIPO =VALORPORDEFECTO,
	@PARAMETROSALIDA TIPO=VALORPORDEFECTO output --Los par�metros de salida pueden ser de cualquier tipo de datos, excepto text, ntext e image.
	as 
	SENTENCIAS
	select @PARAMETROSALIDA=SENTENCIAS;

--Ejemplo 01 creamos un procedimiento almacenado al cual le enviamos 2 n�meros y retorna el promedio:
  create procedure pa_promedio
		@n1 decimal(4,2),
		@n2 decimal(4,2),
		@resultado decimal(4,2) output
		as 
  select @resultado=(@n1+@n2)/2;

--ejecucion
 declare @variable decimal(4,2)
	execute pa_promedio 5,6, @variable output --Al ejecutarlo tambi�n debe emplearse "output":
	select @variable;
--Declaramos una variable para guardar el valor devuelto por el procedimiento; ejecutamos el procedimiento envi�ndole 2 valores y mostramos el resultado.

--La instrucci�n que realiza la llamada al procedimiento debe contener un nombre de variable para almacenar el valor retornado.

--Ejemplo 02 creamos un procedimiento almacenado que muestre los t�tulos, editorial y precio de los libros de un determinado autor 
--(enviado como par�metro de entrada) y nos retorne la suma y el promedio de los precios de todos los libros del autor enviado:
create procedure pa_autor_sumaypromedio
	@autor varchar(30)='%',
	@suma decimal(6,2) output,
	@promedio decimal(6,2) output
	as 
		select titulo,editorial,precio
		from libros
		where autor like @autor
		select @suma=sum(precio)
		from libros
		where autor like @autor
		select @promedio=avg(precio)
		from libros
		where autor like @autor;

--Ejecutamos el procedimiento y vemos el contenido de las variables en las que almacenamos los par�metros de salida del procedimiento:
declare @s decimal(6,2), @p decimal(6,2)
		execute pa_autor_sumaypromedio 'Richard Bach', @s output, @p output
			select @s as total, @p as promedio;
/***************************************Procedimientos almacenados (return)**********************************
La instrucci�n "return" sale de una consulta o procedimiento y todas las instrucciones posteriores no son ejecutadas.
*/
--Ejemplo 01 creamos un procedimiento que muestre todos los libros de un autor determinado que se ingresa como par�metro. 
--Si no se ingresa un valor, o se ingresa "null", se muestra un mensaje y se sale del procedimiento:
 create procedure pa_libros_autor --Un procedimiento puede retornar un valor de estado para indicar si se ha ejecutado correctamente o no.
	@autor varchar(30)=null
		as 
		if @autor is null --Si al ejecutar el procedimiento enviamos el valor "null" o no pasamos valor, con lo cual toma el valor por defecto "null", se muestra un mensaje y se sale;
		begin 
		select 'Debe indicar un autor'
		return --"return" puede retornar un valor entero.
		end;
		select titulo from  libros where autor = @autor; --en caso contrario, ejecuta la consulta luego del "else".

--Ejemplo 02 creamos un procedimiento almacenado que ingresa registros en la tabla "libros". Los par�metros correspondientes al t�tulo y autor DEBEN ingresarse con un valor distinto de "null", 
--os dem�s son opcionales. El procedimiento retorna "1" si la inserci�n se realiza, es decir, si se ingresan valores para t�tulo y autor y "0", en caso que t�tulo o autor sean nulos:
create procedure pa_libros_ingreso
	@titulo varchar(40)=null,
	@autor varchar(30)=null,
	@editorial varchar(20)=null,
	@precio decimal(5,2)=null
	as 
		if (@titulo is null) or (@autor is null)
		return 0
		else 
		begin
		insert into libros values (@titulo,@autor,@editorial,@precio)
  return 1
end;
--Para ver el resultado, debemos declarar una variable en la cual se almacene el valor devuelto por el procedimiento; luego, ejecutar el procedimiento asign�ndole el valor devuelto a la variable, 
--finalmente mostramos el contenido de la variable:
declare @retorno int
	exec @retorno=pa_libros_ingreso 'Alicia en el pais...','Lewis Carroll'
	select 'Ingreso realizado=1' = @retorno
	exec @retorno=pa_libros_ingreso
 select 'Ingreso realizado=1' = @retorno;
--Tambi�n podr�amos emplear un "if" para controlar el valor de la variable de retorno:
declare @retorno int;
 exec @retorno=pa_libros_ingreso 'El gato con botas','An�nimo'
 if @retorno=1 select 'Registro ingresado'
 else select 'Registro no ingresado porque faltan datos';

/**************************************Procedimientos almacenados (informaci�n)*****************************
Los procedimientos almacenados son objetos, as� que para obtener informaci�n de ellos pueden usarse los siguientes procedimientos almacenados del sistema y las siguientes tablas:
*/
/*
- "sp_help": sin par�metros nos muestra todos los objetos de la base de datos seleccionada, incluidos los procedimientos. En la columna "Object_type" aparece "stored procedure" si es un procedimiento almacenado. 
Si le enviamos como argumento el nombre de un procedimiento, obtenemos la fecha de creaci�n e informaci�n sobre sus par�metros.

- "sp_helptext": seguido del nombre de un procedimiento almacenado nos muestra el texto que define el procedimiento, excepto si ha sido encriptado.

- "sp_stored_procedures": muestra todos los procedimientos almacenados, los propietarios, etc. Este procedimiento almacenado puede recibir 3 par�metros: @sp_name (nombre, nvarchar, admite comodines para b�squeda de patrones), 
@sp_owner (propietario, nvarchar, admite comodines) y @qualifier (nombre de la base de datos). Por ejemplo, podemos ver todos los procedimientos almacenados creados por nosotros con esta sentencia:
 exec sp_stored_procedures @sp_name='pa_%';

- "sp_depends": seguido del nombre de un objeto, nos devuelve 2 resultados: 1) nombre, tipo, campos, etc. de los objetos de los cuales depende el objeto enviado y 2) nombre y tipo de los objetos que dependen del objeto nombrado. Por ejemplo, 
ejecutamos "sp_depends" seguido del nombre de un procedimiento:
exec sp_depends pa_autor_promedio;

aparecen las tablas (y dem�s objetos) de las cuales depende el procedimiento, es decir, las tablas referenciadas en el mismo. Podemos ejecutar el procedimiento seguido del nombre de una tabla:
exec sp_depends libros;

aparecen los procedimientos (y dem�s objetos) que dependen de ella.

- La tabla del sistema "sysobjects": muestra nombre y varios datos de todos los objetos de la base de datos actual. La columna "xtype" indica el tipo de objeto. Si es un procedimiento almacenado, muestra "P". Ejemplo:
select * from sysobjects;

Si queremos ver todos los procedimientos almacenados creados por nosotros, podemos tipear:
select *from sysobjects
  where xtype='P' and-- tipo procedimiento
  name like 'pa%';--b�squeda con comod�n
*/
