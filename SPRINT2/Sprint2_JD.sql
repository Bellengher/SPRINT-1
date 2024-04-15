								#NIVEL 1

#Ejercicio 1 Muestra todas las transacciones realizadas por empresas de Alemania.

SELECT * 
FROM transaction 
WHERE company_id IN          				#2º Busca las transacciones teniendo en cuenta el 1º filtro
(SELECT id FROM company WHERE country = "Germany")	#1º filtra todas las empresas de Germany
;


/*Ejercicio 2 Marketing está preparando algunos informes de cierres de gestión, 
 te piden que les pases un listado de las empresas que han realizado transacciones por una suma superior a la media de todas las transacciones.*/

SELECT * 
FROM company 
WHERE company.id In 				#3º busca * datos de las compañias que cumplan 2º filtro
	(SELECT company_id  
	FROM transaction 
	WHERE amount > 		 		#2º busca company_id sobre amount que sea mayor al 1º filtro
		(SELECT AVG(amount) 
		FROM transaction 
		WHERE declined = 0))		#1º busco la media de las ventas (declined=0 considerando solo ventas finalizadas). 
;


/*Ejercicio 3 El departamento de contabilidad perdió la información de las transacciones realizadas por una empresa, 
 pero no recuerdan su nombre, sólo recuerdan que su nombre iniciaba con la letra c. ¿Cómo les puedes ayudar? Comentalo acompañándolo de la información de las transacciones. 
⚠️ Para ayudar al departamento de mkt le haré una lista donde aparezca tanto el nombre de la compañía como la información de las transacciones*/

SELECT
	(SELECT company_name 
	FROM company 
	WHERE id = transaction.company_id) AS company_name, transaction.*	#2º Selecciono el nombre de la compañía de la tabla company
	FROM TRANSACTION 							# y todo de la tabla transaction y hago la busqueda dentro del primer filtro.
    WHERE  transaction.company_id IN 
		(SELECT id 
		FROM company 
		WHERE company_name LIKE 'c%');					#1º Hago la búsqueda de las compañías cuyo nombre comienza por c


									
#Ejercicio 4 Eliminaron del sistema a las empresas que no tienen transacciones registradas, entrega el listado de estas empresas.

SELECT id,company_name 
FROM company 				#1º busca las id y company_name de la tabla company 
WHERE NOT EXISTS			# que no existe
	(SELECT company_id 
	FROM transaction)		# en el campo company_id de la tabla transaction
;


								#NIVEL 2

/*Ejercicio 1 En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacer competencia a la compañía non institute. 
 Para ello, te piden la lista de todas las transacciones realizadas por empresas que están situadas en el mismo país que esta compañía.*/

SELECT * FROM transaction  WHERE company_id IN 						#3º muestra lista de * transaction utilizando 2º filtro
	(SELECT id FROM company WHERE country IN  					#2º busca los id de company utilizando 1º filtro
		(SELECT country FROM company WHERE company_name = "non institute")) 	#1º encuentra el country de Non Institue
 ;
 
 #Ejercicio 2  El departamento de contabilidad necesita que encuentres la empresa que ha realizado la transacción de mayor suma en la base de datos.
 
SELECT max(amount) , tabla.* FROM transaction ,					#4º selecciono el mñaximo importe de transaction y todo lo de la tabla derivada que he creado
  (SELECT * FROM company WHERE id IN 						#3º Utlizo toda le información de company que esté dentro de los filtros anteriores para crear una tabla derivada
	(SELECT company_id FROM transaction WHERE amount IN 			#2º Busco el company_id que coincida con el 1º filtro
		(SELECT MAX(amount) FROM transaction) )) as tabla		#1º Busco el MAX(amount)
 GROUP BY id
 ;
 
 
								#NIVEL 3
 
 /*Ejercicio 1 Se están estableciendo los objetivos de la empresa para el siguiente trimestre, 
  por lo que necesitan una base sólida para evaluar el rendimiento y medir el éxito en los diferentes mercados. 
  Para ello, necesitan el listado de los países cuya media de transacciones sea superior a la media general.*/

SELECT company.country, ROUND(AVG(transaction.amount), 2) AS media_pais			#1º Selecciono nombre de país y media de amount , utilizo round para dejarlo en 2 desimales.
FROM company, transaction								# de las tablas comnay,transaction
WHERE company.id = transaction.company_id						# indicando los id que mantienen las relacion.
    AND transaction.declined = 0							#2º Utilizo declined = 0 para tomar las transacciones no rechazadas.
GROUP BY company.country								#3º agrupo por nombre de país. 
HAVING media_pais > (			 						#4º utilizo Having para indicar que tome la media_pais que sea 
        SELECT AVG(amount)								# mayor a la media general del campo amount de transaction
        FROM transaction
        WHERE declined = 0								# indicando declined = 0 para que no tome las transacciones rechazadas.
    );
/*Ejercico 2 Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera,
 por lo que te piden la información sobre la cantidad de transacciones que realizan las empresas, pero el departamento de recursos humanos es exigente 
 y quiere un listado de las empresas donde especifiques si tienen más de 4 transacciones o menos.*/

SELECT company.* , tfinalizadas.conteo,				#2º Selecciono todos los campos de company y el campo conteo la tabla tfinalizadas									
       CASE 							#3º con Case hago la evaluacion respecto al conteo	
           WHEN conteo > 4 THEN "Mas de 4 transacciones"
           WHEN conteo = 4 THEN "Justo 4 transacciones"
           ELSE "Menos de 4 transacciones"
       END AS total_transacciones
FROM company , 							# de las tablas company y tfinalizadas
    (SELECT company_id, COUNT(id) AS conteo 											
     FROM transaction 
     WHERE declined = 0 													
     GROUP BY company_id) AS tfinalizadas			#1º Hago una tabla derivada llamada tfinalizadas formada por las columnas company_id y conteo y agrupo por company_id								
WHERE company.id = tfinalizadas_id				#4º Indicando la relacion entre tablas.
;
