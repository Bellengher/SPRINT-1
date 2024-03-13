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
van ser declinades */
CREATE TABLE last_card_movements AS
WITH card_status AS (
    SELECT card_id, timestamp, declined,
           ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS row_num
    FROM transactions
)
SELECT card_id,
    CASE
        WHEN SUM(declined) <= 2 THEN 'tarjeta operativa'
        ELSE 'tarjeta no operativa'
    END AS status
FROM card_status
WHERE row_num <= 3
GROUP BY card_id
HAVING COUNT(*) = 3;

SELECT count(DISTINCT card_id) FROM last_card_movements;	

/* Quantes targetes estan actives? ***CONSIDERANDO ACTIVAS LAS TARJETAS QUE TIENEN AL MENOS 1 OPERACIÓN APROBADA EN LAS ULTIMAS 3 TRANSACCIONES
(TAMBIÉN CONSIDERO LAS QUE TIENEN MENOS DE 3 OPERACIONES EN TOTAL) */

SELECT COUNT(card_id) as 'total tarjetas operativas'
FROM last_card_movements 
WHERE status = 'tarjeta operativa';


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
