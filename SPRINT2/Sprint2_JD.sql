								#NIVEL 1

#Ejercicio 1 Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT * FROM transaction WHERE company_id IN          		#2º Busca las transacciones teniendo en cuenta el 1º filtro
	(SELECT id FROM company WHERE country = "Germany")	#1º filtra todas las empresas de Germany
;


/*Ejercicio 2 Màrqueting està preparant alguns informes de tancaments de gestió, 
 et demanen que els passis un llistat de les empreses que han realitzat transaccions per una suma superior a la mitjana de totes les transaccions.*/

SELECT * FROM company WHERE company.id In 					#3º busca * datos de las compañias que cumplan 2º filtro
	(SELECT company_id  FROM transaction WHERE amount > 		 	#2º busca company_id sobre amount que sea mayor al 1º filtro
		(SELECT AVG(amount) FROM transaction WHERE declined = 0)	#1º busco la media de las ventas (declined=0 considerando solo ventas finalizadas). 
GROUP BY company_id) 								#4º agrupo por company_id
;


/*Ejercicio 3 El departament de comptabilitat va perdre la informació de les transaccions realitzades per una empresa, 
 però no recorden el seu nom, només recorden que el seu nom iniciava amb la lletra c. Com els pots ajudar? Comenta-ho acompanyant-ho de la informació de les transaccions.*/ 

SELECT
(SELECT company_name FROM company WHERE id = transaction.company_id) AS company_name, transaction.*	2º Selecciono el nombre de la compañía de la tabla company
	FROM TRANSACTION 										# y todo de la tabla transaction y hago la busqueda dentro del primer filtro.
    WHERE  transaction.company_id IN (SELECT id FROM company WHERE company_name LIKE 'c%');		1º Hago la búsqueda de las compañías cuyo nombre comienza por c

#Ejercicio 4 Van eliminar del sistema les empreses que no tenen transaccions registrades, lliura el llistat d'aquestes empreses.

SELECT company_id FROM transaction WHERE company_id NOT IN 					#3º busca las company_id que no estén en el 2º filtro
	(SELECT company_id FROM 								#2º filtra las company_id que están en el 1º filtro
		(SELECT COUNT(id) FROM transaction GROUP BY company_id) AS count_transaction) 	#1º cuenta id de transacciones y agrupa por company_id
;


								#NIVEL 2

/*Ejercicio 1 En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia non institute. 
 Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.*/

(SELECT * FROM transaction  WHERE company_id IN 					#3º muestra lista de * transaction utilizando 2º filtro
	(SELECT id FROM company WHERE country IN  					#2º busca los id de company utilizando 1º filtro
		(SELECT country FROM company WHERE company_name = "non institute"))) 	#1º encuentra el country de Non Institue
 ;
 
 #Ejercicio 2  El departament de comptabilitat necessita que trobis l'empresa que ha realitzat la transacció de major suma en la base de dades.
 
 (SELECT * FROM company WHERE id IN 				#3º Muestro toda la informacion de company utilizando el 2º filtro
	(SELECT company_id FROM transaction WHERE amount IN 	#2º Busco el company_id que coincida con el 1º filtro
		(SELECT MAX(amount) FROM transaction) ))	#1º Busco el MAX(amount)
 ;
 
 
								#NIVEL 3
 
 /*Ejercicio 1 S'estan establint els objectius de l'empresa per al següent trimestre, 
  per la qual cosa necessiten una base sòlida per a avaluar el rendiment i mesurar l'èxit en els diferents mercats. 
  Per a això, necessiten el llistat dels països la mitjana de transaccions dels quals sigui superior a la mitjana general.*/

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
/*Ejercico 2 Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi,
 per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos humans és exigent 
 i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.*/

SELECT company.* , tf.conteo,					#2º Selecciono todos los campos de company y el campo conteo la tabla tf									
       CASE 							#3º con Case hago la evaluacion respecto al conteo	
           WHEN conteo > 4 THEN "Mas de 4 transacciones"
           WHEN conteo = 4 THEN "Justo 4 transacciones"
           ELSE "Menos de 4 transacciones"
       END AS total_transacciones
FROM company , 							# de las tablas company y tf
    (SELECT company_id, COUNT(id) AS conteo 											
     FROM transaction 
     WHERE declined = 0 													
     GROUP BY company_id) AS tf					#1º Hago una tabla derivada llamada tf formada por las columnas company_id y conteo y agrupo por company_id								
WHERE company.id = tf.company_id				#4º Indicando la relacion entre tablas.
;
