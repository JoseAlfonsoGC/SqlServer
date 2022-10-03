/*
Las combinaciones no sólo se utilizan con la sentencia "select", también podemos emplearlas con "update" y "delete".

Podemos emplear "update" o "delete" con "join" para actualizar o eliminar registros de una tabla consultando otras tablas.
*/
--En el siguiente ejemplo aumentamos en un 10% los precios de los libros de cierta editorial, necesitamos un "join" para localizar los registros de la editorial "Planeta" en la tabla "libros":
update libros set precio=precio+(precio*0.1)
		from libros 
		join editoriales as e
		on codigoeditorial=e.codigo
	where nombre='Planeta';

--Eliminamos todos los libros de editorial "Emece":
delete libros
		from libros
		join editoriales
		on codigoeditorial = editoriales.codigo
  where editoriales.nombre='Emece';