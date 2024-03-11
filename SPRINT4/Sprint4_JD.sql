								#NIVEL 1
            
/* Exercici 1
Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.*/

SELECT u.*, total_transactions							#2º Indico que quiero todo de la tabla users y el conteo de las transactions 
FROM users u									# que hice en el 1º paso que juntataré haciendo una JOIN
JOIN (
    SELECT user_id, COUNT(id) AS total_transactions				#1º Busco user_id para poder agrupar el conteo de las transactions
    FROM transactions
    GROUP BY user_id
) AS conteo ON u.id = conteo.user_id						#3º Despues de indicar las KEYS para hacer la JOIN filtro con un WHERE	
WHERE total_transactions > 30;							# indicando que quiero las que sean mayor a 30 transactions


    
/* Exercici 2
Mostra la mitjana de la suma de transaccions per IBAN de les targetes de crèdit en la companyia Donec Ltd. utilitzant almenys 2 taules.*/
 SELECT * FROM transactions WHERE business_id = "b-2242";
 SELECT * FROM companies WHERE company_name = "Donec Ltd" ;   # company_id = b-2242


-------------------------------------------------------------------------------------------------------------------------------------------------------------
 
							#NIVEL2
	 
/* Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les últimes tres transaccions 
van ser declinades */
CREATE TABLE last_card_movements AS							#4º Finalmente creo la tabla
SELECT card_id, timestamp, declined,row_num						#2º Selecciono card_id, timestamp, declined y la columna row_num
FROM (SELECT card_id, timestamp, declined,						#1º Hago la subconsulta con los datos que necesito y 
           ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS row_num	# Con la funcion ROW NUMBER asigno el numero de fila a cada
    FROM transactions									# fila resultante de la consulta 
) AS ranked_transactions
WHERE row_num <= 3;									#3º row_num <=3 porque nos pide analizar las 3 ultimas transacciones
SELECt * FROM last_card_movements;


SELECT COUNT(DISTINCT card_id) FROM last_card_movements;	#TENEMOS 242 TARJETAS QUE HAN HECHO AL MENOS 1 OPERACIÓN


/* Quantes targetes estan actives? ***CONSIDERANDO ACTIVAS LAS TARJETAS QUE TIENEN AL MENOS 1 OPERACIÓN APROBADA EN LAS ULTIMAS 3 TRANSACCIONES
(TAMBIÉN CONSIDERO LAS QUE TIENEN MENOS DE 3 OPERACIONES EN TOTAL) */

SELECT COUNT(card_id) operating_cards 				#3º Hago un conteo de los id de tarjeta (poniendo un alías) de la subconsulta anterior	
	FROM (SELECT card_id, declined 				#1º Seleccciono la columna con el id de la tarjeta y la que tiene las operaciones rechazadas
		FROM last_card_movements 			# de la tabla que he creado anteriormente 
        WHERE declined = 0 GROUP BY card_id) oc 		#2º Hago el flitro para que considere las que tienen al menos una op aprobada (declined=0)
								# agrupando por el id de tarjeta
;


-------------------------------------------------------------------------------------------------------------------------------------------------------------


								#NIVEL3

									
CREATE TABLE IF NOT EXISTS product (
	id int,
	product_name varchar (50) ,
	price varchar (20) ,
	colour varchar (20) ,
	weight decimal (5,2) ,
	warehouse_id varchar (10),
	PRIMARY KEY (id)
); 
