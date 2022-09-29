/*Funciones*/
/*
Una funci�n tiene un nombre, retorna un par�metro de salida y opcionalmente acepta par�metros de entrada. Las funciones de SQL Server no pueden ser modificadas, las funciones definidas por el usuario si.

SQL Server ofrece varios tipos de funciones para realizar distintas operaciones. Se pueden clasificar de la siguiente manera:

1) de agregado: realizan operaciones que combinan varios valores y retornan un �nico valor. Son "count", "sum", "min" y "max".

2) escalares: toman un solo valor y retornan un �nico valor. Pueden agruparse de la siguiente manera:
*/

/*
- de configuraci�n: retornan informaci�n referida a la configuraci�n.
Ejemplo:

 select @@version;
retorna la fecha, versi�n y tipo de procesador de SQL Server.
*/
/*
- de cursores: retornan informaci�n sobre el estado de un cursor.
*/
/*
**************************************Funciones de fecha y hora******************************************* 
operan con valores "datetime" y "smalldatetime". Reciben un par�metro de tipo fecha y hora y retornan un valor de cadena, num�rico o de fecha y hora.
*/
getdate() --retorna la fecha y hora actuales. 
--Ejemplo:
select getdate();

datepart(partedefecha,fecha) --retorna la parte espec�fica de una fecha, el a�o, trimestre, d�a, hora. 
--Los valores para "partedefecha" pueden ser: year (a�o), quarter (cuarto), month (mes), day (dia), week (semana), hour (hora), minute (minuto), second (segundo) y millisecond (milisegundo). Ejemplos
--Ejemplos:
select datepart(month,getdate()); --retorna el n�mero de mes actual;
select datepart(day,getdate()); --retorna el d�a actual;
select datepart(hour,getdate()); --retorna la hora actual;

datename(partedefecha,fecha) --retorna el nombre de una parte espec�fica de una fecha. Los valores para "partedefecha" pueden ser los mismos que se explicaron anteriormente. 
--Ejemplos:
select datename(month,getdate()); --retorna el nombre del mes actual;
select datename(day,getdate());

dateadd(partedelafecha,numero,fecha) --agrega un intervalo a la fecha especificada, es decir, retorna una fecha adicionando a la fecha enviada como tercer argumento, 
--el intervalo de tiempo indicado por el primer par�metro, tantas veces como lo indica el segundo par�metro. Los valores para el primer argumento pueden ser: year (a�o), 
--quarter (cuarto), month (mes), day (dia), week (semana), hour (hora), minute (minuto), second (segundo) y millisecond (milisegundo). 
--Ejemplos:
select dateadd(day,3,'1980/11/02'); --retorna "1980/11/05", agrega 3 d�as.
select dateadd(month,3,'1980/11/02'); --retorna "1981/02/02", agrega 3 meses.
select dateadd(hour,2,'1980/11/02'); --retorna "1980/02/02 2:00:00", agrega 2 horas.
select dateadd(minute,16,'1980/11/02'); --retorna "1980/02/02 00:16:00", agrega 16 minutos.

datediff(partedelafecha,fecha1,fecha2) --calcula el intervalo de tiempo (seg�n el primer argumento) entre las 2 fechas. El resultado es un valor entero que corresponde a fecha2-fecha1. Los valores de "partedelafecha) pueden ser los mismos que se especificaron anteriormente. 
--Ejemplos:
select datediff (day,'2005/10/28','2006/10/28'); --retorna 365 (d�as).
select datediff(month,'2005/10/28','2006/11/29'); --retorna 13 (meses).

day(fecha) --retorna el d�a de la fecha especificada. 
--Ejemplo:
select day(getdate());

month(fecha) --retorna el mes de la fecha especificada. 
--Ejemplo:
select month(getdate());

year(fecha) --retorna el a�o de la fecha especificada. 
--Ejemplo:
select year(getdate());

--+++++++++++Se pueden emplear estas funciones enviando como argumento el nombre de un campo de tipo datetime o smalldatetime++++++++++
/*
****************************************matem�ticas********************************************* 
realizan operaciones num�ricas, geom�tricas y trigonom�tricas. Las funciones matem�ticas realizan operaciones con expresiones num�ricas y retornan un resultado, operan con tipos de datos num�ricos.
*/
abs(x) --retorna el valor absoluto del argumento "x". 
--Ejemplo:
select abs(-20); --retorna 20.

ceiling(x) --redondea hacia arriba el argumento "x". 
--Ejemplo:
select ceiling(12.34); --retorna 13.

floor(x) --redondea hacia abajo el argumento "x". 
--Ejemplo:
select floor(12.34); --retorna 12

% --devuelve el resto de una divisi�n. 
--Ejemplos
select 10%3; --retorna 1.

select 10%2; --retorna 0.

power(x,y) --retorna el valor de "x" elevado a la "y" potencia. 
--Ejemplo:
select power(2,3); --retorna 8.

round(numero,longitud)  --retorna un n�mero redondeado a la longitud especificada. "longitud" debe ser tinyint, smallint o int. 
--Si "longitud" es positivo, el n�mero de decimales es redondeado seg�n "longitud"; si es negativo, el n�mero es redondeado desde la parte entera seg�n el valor de "longitud". 
--Ejemplos
select round(123.456,1); --retorna "123.400", es decir, redondea desde el primer decimal.

select round(123.456,2); --retorna "123.460", es decir, redondea desde el segundo decimal.

select round(123.456,-1); --retorna "120.000", es decir, redondea desde el primer valor entero (hacia la izquierda).

select round(123.456,-2); --retorna "100.000", es decir, redondea desde el segundo valor entero (hacia la izquierda).

sign(x) --si el argumento es un valor positivo devuelve 1;-1 si es negativo y si es 0, 0.

square(x): --retorna el cuadrado del argumento. 
--Ejemplo:
select square(3); --retorna 9.

srqt(x) --devuelve la raiz cuadrada del valor enviado como argumento.

--++++++++++++++++++++++SQL Server dispone de funciones trigonom�tricas que retornan radianes.+++++++++++++++

--+++++++Se pueden emplear estas funciones enviando como argumento el nombre de un campo de tipo num�rico+++++

/*
- de metadatos: informan sobre las bases de datos y los objetos.

- de seguridad: devuelven informaci�n referente a usuarios y funciones.
*/
/*
***************************************Funciones de cadena**************************************
operan con valores "char", "varchar", "nchar", "nvarchar", "binary" y "varbinary" y devuelven un valor de cadena o num�rico.
*/
substring(cadena,inicio,longitud)--evuelve una parte de la cadena especificada como primer argumento, empezando desde la posici�n especificada por el segundo argumento y de tantos caracteres de longitud como indica el tercer argumento
--ejemplo substring
select substring('Buenas tardes',8,6);--retorna "tardes".
str(numero,longitud,cantidaddecimales);--convierte n�meros a caracteres; el primer par�metro indica el valor num�rico a convertir, el segundo la longitud del resultado (debe ser mayor o igual a la parte entera del n�mero m�s el signo si lo tuviese) y el tercero, 
--la cantidad de decimales. El segundo y tercer argumento son opcionales y deben ser positivos

--Ejemplo str: se convierte el valor num�rico "123.456" a cadena, especificando 7 de longitud y 3 decimales:

select str(123.456,7,3);

select str(-123.456,7,3);
--retorna '-123.46';

stuff(cadena1,inicio,cantidad,cadena2)--inserta la cadena enviada como cuarto argumento, en la posici�n indicada en el segundo argumento, reemplazando la cantidad de caracteres indicada por el tercer argumento en la cadena que es primer par�metro. 
									  --Stuff significa rellenar en ingl�s. Ejemplo:
--ejemplo de stuff
select stuff('abcde',3,2,'opqrs');

len(cadena)--retorna la longitud de la cadena enviada como argumento. "len" viene de length, que significa longitud en ingl�s.
--ejemplo
select len('Hola');--devuelve 4.

char(x)--retorna un caracter en c�digo ASCII del entero enviado como argumento
--ejemplo
select char(65);--retorna "A".

left(cadena,longitud)--retorna la cantidad (longitud) de caracteres de la cadena comenzando desde la izquierda, primer caracter
--ejemplo
select left('buenos dias',8);--retorna "buenos d".

right(cadena,longitud)--retorna la cantidad (longitud) de caracteres de la cadena comenzando desde la derecha, �ltimo caracter
--ejemplo
select right('buenos dias',8);--retorna "nos dias"

lower(cadena) --retornan la cadena con todos los caracteres en min�sculas. lower significa reducir en ingl�s. 
--Ejemplo
select lower('HOLA ESTUDIAnte');--retorna "hola estudiante".

upper(cadena) --retornan la cadena con todos los caracteres en may�sculas. 
--Ejemplo
select upper('HOLA ESTUDIAnte');

ltrim(cadena) --retorna la cadena con los espacios de la izquierda eliminados. Trim significa recortar. 
--Ejemplo:
select ltrim('     Hola     ');--retorna "Hola ".

rtrim(cadena) --retorna la cadena con los espacios de la derecha eliminados. 
--Ejemplo:
select rtrim('   Hola   ');--retorna " Hola".

replace(cadena,cadenareemplazo,cadenareemplazar) --retorna la cadena con todas las ocurrencias de la subcadena reemplazo por la subcadena a reemplazar. 
--Ejemplo:
select replace('xxx.sqlserverya.com','x','w');--retorna "www.sqlserverya.com'.

reverse(cadena) --devuelve la cadena invirtiendo el order de los caracteres. 
--Ejemplo:
 select reverse('Hola');--retorna "aloH".

patindex(patron,cadena) --devuelve la posici�n de comienzo (de la primera ocurrencia) del patr�n especificado en la cadena enviada como segundo argumento. Si no la encuentra retorna 0
--Ejemplo
select patindex('%Luis%', 'Jorge Luis Borges');--retorna 7.
select patindex('%or%', 'Jorge Luis Borges');--retorna 2.
select patindex('%ar%', 'Jorge Luis Borges');--retorna 0.

charindex(subcadena,cadena,inicio) --devuelve la posici�n donde comienza la subcadena en la cadena, comenzando la b�squeda desde la posici�n indicada por "inicio". Si el tercer argumento no se coloca, 
--la b�squeda se inicia desde 0. Si no la encuentra, retorna 0
--Ejemplos
select charindex('or','Jorge Luis Borges',5); --retorna 13.
select charindex('or','Jorge Luis Borges'); --retorna 2.
select charindex('or','Jorge Luis Borges',14); --retorna 0.
select charindex('or', 'Jorge Luis Borges');--retorna 0.

replicate(cadena,cantidad) --repite una cadena la cantidad de veces especificada. 
--Ejemplo:
select replicate ('Hola',3); --retorna "HolaHolaHola";

space(cantidad) --retorna una cadena de espacios de longitud indicada por "cantidad", que debe ser un valor positivo. 
--Ejemplo:
select 'Hola'+space(1)+'que tal'; --retorna "Hola que tal".

--++++++++++++++++++++++Se pueden emplear estas funciones enviando como argumento el nombre de un campo de tipo caracter.+++++++++++++++++++++++
/*
- del sistema: informan sobre opciones, objetos y configuraciones del sistema. Ejemplo:

 select user_name();
- estad�sticas del sistema: retornan informaci�n referente al rendimiento del sistema.

- texto e imagen: realizan operaciones con valor de entrada de tipo text o image y retornan informaci�n referente al mismo.

3) de conjuntos de filas: retornan conjuntos de registros.

Se pueden emplear las funciones del sistema en cualquier lugar en el que se permita una expresi�n en una sentencia "select".
*/