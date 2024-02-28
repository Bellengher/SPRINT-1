
#Ejercicio 1 
SELECT  COUNT(id) AS cantidad_duplicados
FROM company
GROUP BY id
HAVING COUNT(id) > 1;


#Ejercicio 2  
 SELECT DATE(timestamp)AS fecha, SUM(amount) AS suma FROM transaction
 GROUP BY fecha
 ORDER BY suma DESC
 LIMIT 5;
 
#Ejercicio 2 version chunga 
SELECT 
	(SELECT 
		(SELECT SUM(amount) FROM 
			(SELECT amount FROM transaction 
            ORDER BY amount DESC LIMIT 5) AS Top_cinco)) AS Suma_Top_cinco, timestamp,amount
FROM transaction
ORDER BY amount DESC
LIMIT 5 ;



#Ejercicio 3 
 SELECT DATE(timestamp)AS fecha, SUM(amount) AS suma FROM transaction
 GROUP BY fecha
 ORDER BY suma ASC
 LIMIT 5;
 
#Ejercicio 3 version chunga 
SELECT
	(SELECT 
		(SELECT SUM(amount) FROM 
			(SELECT amount FROM transaction ORDER BY amount ASC LIMIT 5) AS Flop_cinco) AS Suma_Flop_cinco) AS Suma_Flop_cinco,timestamp,amount
FROM transaction
ORDER BY amount ASC
LIMIT 5 ;

#Ejercicio 4 
SELECT  country , AVG(amount)As avg_amount FROM company
JOIN transaction ON company.id = transaction.company_id WHERE transaction.declined = 0
GROUP BY  country 
ORDER BY avg_amount DESC;










    
    


