
								#NIVEL 1
                                                                
#Ejercicio 2 Realitza la següent consulta: Has d'obtenir el nom, email i país de cada companyia, ordena les dades en funció del nom de les companyies.

SELECT (company_name) AS Name, email,country FROM company		#1º Selecciono los datos requeridos de la tabla company
ORDER BY name;								#2º Los ordeno por name

#Ejercicio 3 Des de la secció de màrqueting et sol·liciten que els passis un llistat dels països que estan fent compres.
									
SELECT country FROM company								#1º Selecciono el country de la tabla company
JOIN transaction ON company.id = transaction.company_id 				#2º Hago Join con tabla transaction por P y F KEY
WHERE transaction.declined = 0 								#3º declined = 0 porque solo tomo en cuenta transacciones no rechazadas
GROUP BY country;									#4º Agrupo por country

#Ejercicio 4 Des de màrqueting també volen saber des de quants països es realitzen les compres.
									
SELECT COUNT(DISTINCT country)AS "Countries" FROM company				#1º Conteo distintivo de country de la tabla company
JOIN transaction ON company.id = transaction.company_id					#2º Hago JOIN con tabla transaction por P y F KEY
WHERE transaction.declined = 0;		 						#3º declined = 0 porque solo tomo en cuenta transacciones no rechazadas


#Ejercicio 5 El teu cap identifica un error amb la companyia que té id 'b-2354'. Per tant, et sol·licita que li indiquis el país i nom de companyia d'aquest id
									
SELECT country , company_name FROM company 		#1º Selecciono country y company_name de la tabla company		
WHERE company.id = "b-2354"; 				#2º Filtro para que company.id sea el que nos indica el ejercicio


#Ejercicio 6 A més, el teu cap et sol·licita que indiquis quina és la companyia amb major despesa mitjana?
									
SELECT company_name, AVG(amount) AS promedio  FROM transaction		#1º Selecciono company_name y hago promedio de amount de la tabla transaction
JOIN company ON company.id = transaction.company_id 			#2º Hago JOIN con tabla company por P y F KEY
WHERE transaction.declined = 0						#3º declined = 0 porque solo tomo en cuenta transacciones no rechazadas
GROUP BY company.id							#4º Agrupo por company.id
ORDER BY promedio DESC							#5º Ordeno por promedio decendente para que el mayor quede arrida de la columna			
LIMIT 1;								#6º Limit 1 porque piden la mayor




							#NIVEL 2

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


								

								#NIVEL 3
								

#Ejercicio 1  Presenta el nom, telèfon i país de les companyies, juntament amb la quantitat total gastada, 
#d'aquelles que van realitzar transaccions amb una despesa compresa entre 100 i 200 euros. Ordena els resultats de major a menor quantitat gastada.
SELECT company_name, phone, country, SUM(amount)AS Total FROM company
JOIN transaction ON company.id = transaction.company_id WHERE transaction.declined = 0
AND amount BETWEEN 100 AND 200 # aqui pongo el filtro para que cuente los gastos comprendidos entre 100 y 200. 
GROUP BY company_name,phone,country 
ORDER BY total DESC;

#Ejercicio 2 Indica el nom de les companyies que van fer compres el 16 de març del 2022, 28 de febrer del 2022 i 13 de febrer del 2022.
SELECT company_name ,timestamp FROM company
JOIN transaction ON company.id = transaction.company_id WHERE transaction.declined = 0
AND timestamp LIKE "2022-03-16%" OR timestamp LIKE "2022-02-28%" OR timestamp LIKE "2022-02-13%";

















    
    





