
#Ejercicio 1 El teu cap està redactant un informe de tancament de l'any i et sol·licita que li enviïs informació rellevant per al document. 
#Per a això et sol·licita verificar si en la base de dades existeixen companyies amb identificadors (aneu) duplicats.
SELECT  COUNT(id) AS cantidad_duplicados
FROM company
GROUP BY id
HAVING COUNT(id) > 1; #Utilizo HAVING para que me diga del COUNT(id) cuales son mayores a 1 , es decir si hubiera duplicados. 


#Ejercicio 2  En quin dia es van realitzar les cinc vendes més costoses? Mostra la data de la transacció i la sumatòria de la quantitat de diners.
 SELECT DATE(timestamp)AS fecha, SUM(amount) AS suma FROM transaction # Utilizo DATE(timestamp) para que solo tome la fecha y no la hora de la operacion. 
 WHERE declined = 0 
 GROUP BY fecha
 ORDER BY suma DESC
 LIMIT 5;


#Ejercicio 2 version chunga (Había entendido que tenía que buscar las 5 ventas más altas y luego sumarlas)
SELECT 
	(SELECT 
		(SELECT SUM(amount) FROM 
			(SELECT amount FROM transaction 
            ORDER BY amount DESC LIMIT 5) AS Top_cinco)) AS Suma_Top_cinco, timestamp,amount
FROM transaction
WHERE declined = 0 
ORDER BY amount DESC
LIMIT 5 ;



#Ejercicio 3 En quin dia es van realitzar les cinc vendes de menor valor? Mostra la data de la transacció i la sumatòria de la quantitat de diners.
 SELECT DATE(timestamp)AS fecha, SUM(amount) AS suma FROM transaction # Utilizo DATE(timestamp) para que solo tome la fecha y no la hora de la operacion. 
 WHERE declined = 0 
 GROUP BY fecha
 ORDER BY suma ASC
 LIMIT 5;
 
#Ejercicio 3 version chunga (Había entendido que debía buscar las 5 ventas más bajas y luego sumarlas)
SELECT
		(SELECT SUM(amount) FROM 
			(SELECT amount FROM transaction ORDER BY amount ASC LIMIT 5) AS Flop_cinco) AS Suma_Flop_cinco,timestamp,amount
FROM transaction
WHERE declined = 0 
ORDER BY amount ASC
LIMIT 5 ;


#Ejercicio 4  Quina és la mitjana de despesa per país? Presenta els resultats ordenats de major a menor mitjà.
SELECT  country , AVG(amount)As avg_amount FROM company
JOIN transaction ON company.id = transaction.company_id WHERE transaction.declined = 0
GROUP BY  country 
ORDER BY avg_amount DESC;










    
    


