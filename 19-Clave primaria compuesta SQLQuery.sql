/*Clave primaria compuesta
es usada cuando la clave primaria se requiere con fines de identidad unica para cada registro y puede cambiar siempre y cuando sea del mismo grupo de informacion 
ejemplo (matricula de un auto), (hora de llegada) dos columnas que en conjunto puedes ser de mas ayuda que un simple "id"*/

--solucion y ejemplo, Para establecer más de un campo como clave primaria usamos la siguiente sintaxis:

create table vehiculos(
  patente char(6) not null,
  tipo char(1),--'a'=auto, 'm'=moto
  horallegada datetime,
  horasalida datetime,
  primary key(patente,horallegada)-- Nombramos los campos que formarán parte de la clave separados por comas.
 );

--Al ingresar los registros, SQL Server controla que los valores para los campos establecidos como clave primaria no estén repetidos en la tabla; si estuviesen repetidos, muestra un mensaje y la inserción no se realiza. Lo mismo sucede si realizamos una actualización.

/*
if object_id('vehiculos') is not null
  drop table vehiculos;

create table vehiculos(
  patente char(6) not null,
  tipo char(1),--'a'=auto, 'm'=moto
  horallegada datetime,
  horasalida datetime,
  primary key(patente,horallegada)
);

go

insert into vehiculos values('AIC124','a','8:05','12:30');
insert into vehiculos values('CAA258','a','8:05',null);
insert into vehiculos values('DSE367','m','8:30','18:00');
insert into vehiculos values('FGT458','a','9:00',null);
insert into vehiculos values('AIC124','a','16:00',null);
insert into vehiculos values('LOI587','m','18:05','19:55');
*/