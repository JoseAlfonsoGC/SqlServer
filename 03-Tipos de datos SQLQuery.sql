--en archivos anteriores se explico la creacion de las tablas y que cada columna tiene que tener un tipo de dato para el dato a guardar

--Los tipos de datos de SQL Server se organizan en las siguientes categorías:
/*
--Numéricos exactos
bigint De -2^63 (-9.223.372.036.854.775.808) a 2^63-1 (9.223.372.036.854.775.807) (8 bytes) 
numeric MyNumericColumn NUMERIC(10,5)
bit Los valores de cadena TRUE y FALSE se pueden convertir en valores de tipo bit: TRUE se convierte en 1 y FALSE en 0.
smallint De -2^15 (-32.768) a 2^15-1 (32.767) (2 bytes)
decimal MyDecimalColumn DECIMAL(5,2)
smallmoney De - 214.748,3648 a 214.748,3647 (4 bytes)
int De -2^31 (-2.147.483.648) a 2^31-1 (2.147.483.647) (4 bytes)
tinyint De 0 a 255    (1 byte)
money De -922.337.203.685.477,5808 a 922.337.203.685.477,5807 (de -922.337.203.685.477,58
a 922.337.203.685.477,58 en el caso de Informatica. Informatica admite únicamente dos decimales, no cuatro). (8 bytes)
--Numéricos aproximados
float De - 1,79E+308 a -2,23E-308, 0 y de 2,23E-308 a 1,79E+308 (depende de lavor de n)
real - De - 3,40E + 38 a -1,18E - 38, 0 y de 1,18E - 38 a 3,40E + 38 (4 bytes)
--Fecha y hora
date (2007-05-08)
datetimeoffset (2007-05-08 12:35:29.1234567 +12:15)
datetime2 (2007-05-08 12:35:29.1234567)
smalldatetime (2007-05-08 12:35:00)
datetime (2007-05-08 12:35:29.123)
time (12:35:29. 1234567)
--Cadenas de caracteres
char "caracter" [ ( n ) ] Datos de cadena de tamaño fijo. n define el tamaño de la cadena en bytes y debe ser un valor entre 1 y 8000. 
varchar [ ( n | max ) ] Datos de cadena de tamaño variable. Utilice n para definir el tamaño de la cadena en bytes, que puede ser un valor comprendido entre 1 y 8000
text Datos no Unicode de longitud variable en la página de códigos del servidor y con una longitud máxima de cadena de 2^31-1 (2.147.483.647)
--Cadenas de caracteres Unicode
nchar - Datos de cadena de tamaño fijo. n define el tamaño de la cadena en pares de bytes y debe ser un valor entre 1 y 4000.
nvarchar - Datos de cadena de tamaño variable. n define el tamaño de la cadena en pares de bytes y puede ser un valor entre 1 y 4000 
ntext - Datos Unicode de longitud variable con una longitud máxima de cadena de 2^30 - 1 (1.073.741.823) bytes.
--Cadenas binarias
binary - binary [ (n) ] Datos binarios de longitud fija con una longitud de n bytes, donde n es un valor que oscila entre 1 y 8000. El tamaño de almacenamiento es de n bytes.
varbinary - varbinary [ (n | max) ] Datos binarios de longitud variable. n puede ser un valor de 1 a 8000. max
image - Datos binarios de longitud variable desde 0 hasta 2^31-1 (2.147.483.647) bytes.
--Otros tipos de datos
cursor - Un tipo de datos para las variables o para los parámetros de resultado de los procedimientos almacenados que contiene una referencia a un cursor. Instrucciones(DECLARE @local_variable y SET @local_variable)
rowversion - Es un tipo de datos que expone números binarios únicos generados automáticamente en una base de datos (8) bytes
hierarchyid -  es un tipo de datos del sistema de longitud variable. Use hierarchyid para representar la posición en una jerarquía.
uniqueidentifier
sql_variant - puede contener filas de tipos de datos diferentes. Por ejemplo, una columna definida como sql_variant puede almacenar valores int, binario y char.
xml
Tipos de geometry espacial - El tipo de datos espaciales planares, geometry, se implementa como un tipo de datos CLR (Common Language Runtime) en SQL Server. Este tipo representa datos en un sistema de coordenadas euclídeo (plano).
Tipos de geografía espacial - se implementa como un tipo de datos de .NET CLR (Common Language Runtime) en SQL Server. Este tipo representa los datos en un sistema de coordenadas de tierra redonda. El tipo de datos SQL Server geography almacena datos elipsoidales (globo), como coordenadas de latitud y longitud de GPS.
table
*/

if object_id('libros') is not null
  drop table libros;

 create table libros(
  titulo varchar(80),
  autor varchar(40),
  editorial varchar(30),
  precio float,
  cantidad integer
 );