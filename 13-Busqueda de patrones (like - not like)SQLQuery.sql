/*Busqueda de parametrones (like -no like)
--"like" se emplea con tipos de datos char, nchar, varchar, nvarchar o datetime. Si empleamos "like" con tipos de datos que no son caracteres, SQL Server convierte 

+El operador igual ("=") nos permite comparar cadenas de caracteres, pero al realizar la comparación, 
+busca coincidencias de cadenas completas, realiza una búsqueda exacta 

Imaginemos que tenemos registrados estos 2 libros:

 "El Aleph", "Borges";
 "Antologia poetica", "J.L. Borges";
 Si queremos recuperar todos los libros de "Borges" y especificamos la siguiente condición
*/
select * from libros
 where autor='Borges'; -- sólo aparecerá el primer registro, ya que la cadena "Borges" no es igual a la cadena "J.L. Borges".

/*
Esto sucede porque el operador "=" (igual), también el operador "<>" (distinto) comparan cadenas de caracteres completas. Para comparar porciones de cadenas utilizamos los operadores "like" y "not like".

Entonces, podemos comparar trozos de cadenas de caracteres para realizar consultas. Para recuperar todos los registros cuyo autor contenga la cadena "Borges" debemos usar
*/
select * from libros
  where autor like "%Borges%"; --El símbolo "%" (porcentaje) reemplaza cualquier cantidad de caracteres (incluyendo ningún caracter). Es un caracter comodín. "like" y "not like" son operadores de comparación que señalan igualdad o diferencia

 select * from libros
  where titulo like 'M%'; --Para seleccionar todos los libros que comiencen con "M":
  --Note que el símbolo "%" ya no está al comienzo, con esto indicamos que el título debe tener como primera letra la "M" y luego, cualquier cantidad de caracteres

 select * from libros
  where titulo not like 'M%';--Para seleccionar todos los libros que NO comiencen con "M":

--Así como "%" reemplaza cualquier cantidad de caracteres, el guión bajo "_" reemplaza un caracter, es otro caracter comodín. Por ejemplo, queremos ver los libros de "Lewis Carroll" pero no recordamos si se escribe "Carroll" o "Carrolt", entonces tipeamos esta condición:

 select * from libros
  where autor like "%Carrol_";

--Otro caracter comodín es [] reemplaza cualquier carácter contenido en el conjunto especificado dentro de los corchetes.

---Para seleccionar los libros cuya editorial comienza con las letras entre la "P" y la "S" usamos la siguiente sintaxis:

 select titulo,autor,editorial
  from libros
  where editorial like '[P-S]%';

--Ejemplos
/*
... like '[a-cf-i]%': busca cadenas que comiencen con a,b,c,f,g,h o i;
... like '[-acfi]%': busca cadenas que comiencen con -,a,c,f o i;
... like 'A[_]9%': busca cadenas que comiencen con 'A_9';
... like 'A[nm]%': busca cadenas que comiencen con 'An' o 'Am'.
*/
--El cuarto caracter comodín es [^] reemplaza cualquier caracter NO presente en el conjunto especificado dentro de los corchetes.
--Ejemplo
 select titulo,autor,editorial
  from libros
  where editorial like '[^PN]%'; --Para seleccionar los libros cuya editorial NO comienza con las letras "P" ni "N"

--queremos buscar todos los libros cuyo precio se encuentre entre 10.00 y 19.99
select titulo,precio from libros
  where precio like '1_.%';

/*
Queremos los libros que NO incluyen centavos en sus precios:

 select titulo,precio from libros
  where precio like '%.00';
Para búsquedas de caracteres comodines como literales, debe incluirlo dentro de corchetes, por ejemplo, si busca:

... like '%[%]%': busca cadenas que contengan el signo '%';
... like '%[_]%': busca cadenas que contengan el signo '_';
... like '%[[]%': busca cadenas que contengan el signo '[';
*/