/*
Esto solo se aplica cuando instale el SQL Server en su m?quina y utiliza el "SQL Server Management Studio".

"go" es un signo de finalizaci?n de un lote de sentencias SQL. No es una sentencia, es un comando.
El lote de sentencias est? compuesto por todas las sentencias antes de "go" o todas las sentencias entre dos "go".

Las sentencias no deben ocupar la misma linea en la que est? "go".

Habr? notado que no se puede ejecutar un procedimiento almacenado luego de otras sentencias a menos que se incluya "execute" (o "exec").

Por ejemplo, si tipeamos:

 select * from empleados;
 sp_helpconstraint empleados;
muestra un mensaje de error porque no puede procesar ambas sentencias como un solo lote. Para que no ocurra debemos tipear:

 select * from empleados;
 exec sp_helpconstraint empleados;
o separar los lotes con "go":

 select * from empleados;
 go
 sp_helpconstraint empleados;
Las siguientes sentencias no pueden ejecutarse en el mismo lote: create rule, create default,create view, create procedure, create trigger. Cada una de ellas necesita ejecutarse separ?ndolas con "go". Por ejemplo:

 create table....
 go
 create rule...
 go
Recuerde que si coloca "go" no debe incluir el "punto y coma" (;) al finalizar una instrucci?n.

No est? de m?s recordar que esto solo se aplica cuando instale el SQL Server en su m?quina y ejecute los comandos desde el "SQL Server Management Studio".


*/