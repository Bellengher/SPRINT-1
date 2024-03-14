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

SELECT * FROM companies WHERE company_name = "Donec Ltd" ;  					# company_id = 'b-2242'
SELECT * FROM transactions WHERE business_id = "b-2242";					#card_id = 'CcU-2973'
SELECT * from credit_cards WHERE id = "CcU-2973";						#iban = 'PT87806228135092429456346'
SELECT ROUND(AVG(amount),2) FROM transactions WHERE card_id = 'CcU-2973' AND declined = 0 ;	#Aquí solo tengo en cuenta las transacciones aprobadas.
SELECT ROUND(AVG(amount),2) FROM transactions WHERE card_id = 'CcU-2973'  ;					#Aquí incluyo las aprobadas y rechazadas.


 -------------------------------------------------------------------------------------------------------------------------------------------------------------

									
								#NIVEL2
									
/* Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les últimes tres transaccions 
van ser declinades ( Solo tomo en cuenta aquellas tarjetas que tienen como mininmo 3 transaccciones hechas)*/


CREATE TABLE last_card_movements AS				   #1º Creo la tabla last_card_movements
WITH card_status AS (						   #2º Defino una CTE llamada card_status 
SELECT card_id, timestamp, declined,				   #selecciono las columnas card_id, timestamp, y declined de la tabla transactions.  
ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC)   #con la función ROW NUMBER asigno un número de fila a cada transacción dentro de cada card_id,
		AS row_num					   #ordenando las transacciones por timestamp en orden descendente.
    FROM transactions
)
SELECT card_id,  						#3º Selecciono card_id de la CTE card_status
CASE 								#utilizo CASE para calcular el estado de la tarjeta 
	WHEN SUM(declined) <= 2 THEN 'tarjeta operativa'	#basándome en la suma total de (declined) donde indico que la suma del campo declined sea <= 2
	ELSE 'tarjeta no operativa'				#de ser así 'tarjeta operativa' de lo contrario 'tarjeta no operativa'
END AS status
FROM card_status						#desde la CTE card_status
WHERE row_num <= 3						#todo esto considerando que la row_num <=3 para que tome las 3 últimas transacciones
GROUP BY card_id						#agrupando por card_id
HAVING COUNT(*) = 3						#y con HAVING hago que cuente todas las filas de cada card_id y que esta sea =3 para asegurar
;								#que la tarjeta tiene 3 transacciones 


# Quantes targetes estan actives? ***CONSIDERANDO ACTIVAS LAS TARJETAS QUE TIENEN AL MENOS 1 OPERACIÓN APROBADA EN LAS ULTIMAS 3 TRANSACCIONES

SELECT COUNT(card_id) as 'total tarjetas operativas'			# Hago un COUNT de los card_id de la tabla que he creado (last_card_movements) 
FROM last_card_movements 						#para ver cuantos encuentra.....
WHERE status = 'tarjeta operativa';					#filtrando solo las que el campo status sea = 'tarjeta operativa'


-------------------------------------------------------------------------------------------------------------------------------------------------------------


								#NIVEL3
/*Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada, 
tenint en compte que des de transaction tens product_ids.*/


 CREATE TABLE product_transaction  (			# Despues de haber manipulado la tabla products creo una tabla nexo entre products y product_transaction
  id varchar (50) NOT NULL,				# A la que llamo product_transaction con solo los dos campos necesarios para manrtener la relacion con 
  product_ids int NOT NULL				# las tablas products y transactions.
) ;

/* Genera la següent consulta:
Necessitem conèixer el nombre de vegades que s'ha venut cada producte.*/

SELECT product_ids producto, COUNT(row_num) total_vendido FROM			#2º La query que está por encima muestra el produc_ids 'producto' y hace un contreo de la row_num
 (SELECT product_ids ,								#1º Hago una subquery selecttionando product_ids don una funcion 
           ROW_NUMBER() OVER (PARTITION BY product_ids ) AS row_num		# ROW NUMBER para que vaya generando un conteo de las filas por cada product_ids
    FROM product_transaction) dd
GROUP BY product_ids								#3º Agrupo el resultado por el campo product_ids
ORDER BY producto ASC								#4º Y lo ordeno para que sea mas visual
 ;

