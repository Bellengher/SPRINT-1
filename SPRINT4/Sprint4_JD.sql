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



 
								#NIVEL2

	 
***CREACION DE LA TABLA***
CREATE TABLE last_card_movements AS
SELECT card_id, timestamp, declined, sum_declined
FROM (SELECT card_id, timestamp, declined,
           SUM(declined) OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS sum_declined,
           ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS row_num
    FROM transactions
) AS ranked_transactions
WHERE row_num <= 3;


SELECT * FROM last_card_movements;


# Quantes targetes estan actives?
SELECT COUNT(card_id) operating_cards 
	FROM (SELECT card_id, sum_declined 
		FROM last_card_movements 
        WHERE sum_declined = 0 GROUP BY card_id) oc 
;

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
