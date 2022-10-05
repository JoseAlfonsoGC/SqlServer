/*****************************************Procedimientos almacenados (encriptado)***************************
Dijimos que SQL Server guarda el nombre del procedimiento almacenado en la tabla del sistema "sysobjects" y su contenido en la tabla "syscomments".

Si no quiere que los usuarios puedan leer el contenido del procedimiento podemos indicarle a SQL Server que codifique la entrada a la tabla "syscomments" 
que contiene el texto. Para ello, debemos colocar la opción "with encryption" al crear el procedimiento:

 create procedure NOMBREPROCEDIMIENTO
  PARAMETROS
  with encryption
  as INSTRUCCIONES;
*/
--Ejemplo creamos el procedimiento almacenado "pa_libros_autor" con la opción de encriptado:
create procedure pa_libros_autor
	@autor varchar(30)=null
	with encryption
	as
	select *from libros
    where autor=@autor;
--Si ejecutamos el procedimiento almacenado del sistema "sp_helptext" para ver su contenido, no aparece.

/*****************************************Procedimientos almacenados (modificar)***************************
Los procedimientos almacenados pueden modificarse, por necesidad de los usuarios o por cambios en la estructura de las tablas que referencia.

Un procedimiento almacenado existente puede modificarse con "alter procedure". Sintaxis:

 alter procedure NOMBREPROCEDIMIENTO
  @PARAMETRO TIPO = VALORPREDETERMINADO
  as SENTENCIAS;
*/
--Ejemplo modificamos el procedimiento almacenado "pa_libros_autor" para que muestre, además del título, la editorial y precio:
alter procedure pa_libros_autor
	@autor varchar(30)=null
	as 
		if @autor is null
		begin 
		select 'Debe indicar un autor'
		return
		end
		else
		select titulo,editorial,precio
			from  libros
   where autor = @autor;
--Si quiere modificar un procedimiento que se creó con la opción "with encryption" y quiere conservarla, debe incluirla al alterarlo.
/*****************************************Procedimientos almacenados (insertar)****************************/
--Podemos ingresar datos en una tabla con el resultado devuelto por un procedimiento almacenado.

--La instrucción siguiente crea el procedimiento "pa_ofertas", que ingresa libros en la tabla "ofertas":
create proc pa_ofertas
		as 
		select titulo,autor,editorial,precio
		from libros
  where precio<50;

--La siguiente instrucción ingresa en la tabla "ofertas" el resultado del procedimiento "pa_ofertas":
insert into ofertas exec pa_ofertas;
--Las tablas deben existir y los tipos de datos deben coincidir.
/*****************************************Procedimientos almacenados (anidados)***************************
Un procedimiento almacenado puede llamar a otro procedimiento almacenado. El procedimiento que es invocado por otro debe existir cuando creamos el procedimiento que lo llama. 
Es decir, si un procedimiento A llama a otro procedimiento B, B debe existir al crear A.

Los procedimientos almacenados pueden anidarse hasta 32 niveles.
*/
--Ejemplo 01 creamos un procedimiento almacenado que reciba 2 números enteros y nos retorne el producto de los mismos:
create procedure pa_multiplicar
	@numero1 int,
	@numero2 int,
	@producto int output
	as
	select @producto=@numero1*@numero2;

--Ejemplo 02 creamos otro procedimiento que nos retorne el factorial de un número, tal procedimiento llamará al procedimiento "pa_multiplicar":
create procedure pa_factorial
	@numero int
	as
	declare @resultado int
	declare @num int
	set @resultado=1 
	set @num=@numero 
	while (@num>1)
	begin
		exec pa_multiplicar @resultado,@num, @resultado output
		set @num=@num-1
	end
		select rtrim(convert(char,@numero))+'!='+convert(char,@resultado);
 
--Cuando un procedimiento (A) llama a otro (B), el segundo (B) tiene acceso a todos los objetos que cree el primero (A).
/*****************************************Procedimientos Almacenados (recompilar)****************************
-La compilación es un proceso que consiste en analizar el procedimiento almacenado y crear un plan de ejecución. 
se realiza la primera vez que se ejecuta un procedimiento almacenado o si el procedimiento almacenado se debe volver a compilar (recompilación).

-SQL Server recompila automáticamente un procedimiento almacenado si se realiza algún cambio en la estructura de una tabla (o vista) 
referenciada en el procedimiento (alter table y alter view) y cuando se modifican las claves (insert o delete) de una tabla referenciada.

-Un procedimiento almacenado puede recompilarse explícitamente. En general se recomienda no hacerlo excepto si se agrega un índice a una tabla referenciada 
por el procedimiento o si los datos han variado mucho desde la última compilación.
*/
--SQL Server ofrece tres métodos para recompilar explícitamente un procedimiento almacenado:
--1) Se puede indicar, al crear el procedimiento, que SQL Server no guarde en la caché un plan de ejecución para el procedimiento sino que lo compile cada vez que se ejecute.
--Sintaxis
create procedure NOMBREPROCEDIMIENTO
	PARAMETROS
	with recompile
	as
	SENTENCIAS;
--2) Podemos especificar "with recompile" al momento de ejecutarlo:
exec NOMBREPROCEDIMIENTO with recompile;

--3) Podemos ejecutar el procedimiento almacenado del sistema "sp_recompile". Este procedimiento vuelve a compilar el procedimiento almacenado (o desencadenador) que se especifica. La sintaxis es:
exec sp_recompile NOMBREOBJETO;

--El parámetro enviado debe ser el nombre de un procedimiento, de un desencadenador, de una tabla o de una vista. Si es el nombre de una tabla o vista, 
--todos los procedimientos almacenados que usan tal tabla (o vista) se vuelven a compilar.
/*****************************************Procedimientos Almacenados (con join)****************************
--Hasta ahora, hemos creado procedimientos que incluyen una sola tabla o pocas instrucciones para aprender la sintaxis, 
pero la funcionalidad de un procedimiento consiste básicamente en que contengan muchas instrucciones o instrucciones complejas y 
así evitar tipear repetidamente dichas instrucciones; además si no queremos que el usuario conozca la estructura de las tablas involucradas, 
los procedimientos permiten el acceso a ellas.

--Podemos crear procedimientos que incluyan combinaciones (join), subconsultas, varias instrucciones y llamadas a otros procedimientos.

--Podemos crear todos los procedimientos que necesitemos para que realicen todas las operaciones y consultas.
*/--en el siguiente archivo se explica el funcionamiento de los join en procedimientos almacenados
