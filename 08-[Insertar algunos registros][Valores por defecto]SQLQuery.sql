/*Insertar algunos campos
Hemos aprendido a ingresar registros listando todos los campos y colocando valores para todos y cada uno de ellos luego de "values".

Si ingresamos valores para todos los campos, podemos omitir la lista de nombres de los campos.
Por ejemplo, si tenemos creada la tabla "libros" con los campos "titulo", "autor" y "editorial", podemos ingresar un registro de la siguiente manera:
*/
insert into libros
  values ('Uno','Richard Bach','Planeta');

--También es posible ingresar valores para algunos campos. Ingresamos valores solamente para los campos "titulo" y "autor":
--pero solo aplica para campos que NO hayan sido declarados "not null", es decir, que permitan valores nulos (se guardará "null"); 
--si omitimos el valor para un campo "not null", la sentencia no se ejecuta. 

 insert into libros (titulo, autor)
  values ('El aleph','Borges');

  /*Valores por defecto (default)*/
  /*
  Hemos visto que si al insertar registros no se especifica un valor para un campo que admite valores nulos, se ingresa automaticamente "null" y si el campo está declarado "identity", 
  se inserta el siguiente de la secuencia. A estos valores se les denomina valores por defecto o predeterminados.

  Un valor por defecto se inserta cuando no está presente al ingresar un registro y en algunos casos en que el dato ingresado es inválido.

  Para campos de cualquier tipo no declarados "not null", es decir, que admiten valores nulos, el valor por defecto es "null". Para campos declarados "not null", 
  no existe valor por defecto, a menos que se declare explícitamente con la cláusula "default"
  */

  create table libros(
  codigo int identity,
  titulo varchar(40),
  autor varchar(30) not null default 'Desconocido', 
  editorial varchar(20),
  precio decimal(5,2),
  cantidad tinyint default 0 
 );
 /*
 Si al ingresar un nuevo registro omitimos los valores para el campo "autor" y "cantidad", Sql Server insertará los valores por defecto; el siguiente valor de la secuencia en "codigo", en "autor" colocará "Desconocido" y en cantidad "0".
 */
 --También se puede utilizar "default" para dar el valor por defecto a los campos en sentencias "insert", por ejemplo:

 insert into libros (titulo,autor,precio,cantidad)
  values ('El gato con botas',default,default,100);