													#NIVEL 1

#Ejercicio 1 Mostra totes les transaccions realitzades per empreses d'Alemanya.

(SELECT * FROM transaction WHERE company_id IN          	#2º Busca las transacciones teniendo en cuenta el 1º filtro
	(SELECT id FROM company WHERE country = "Germany")) 	#1º filtra todas las empresas de Germany
;


#Ejercicio 2 Màrqueting està preparant alguns informes de tancaments de gestió, 
#et demanen que els passis un llistat de les empreses que han realitzat transaccions per una suma superior a la mitjana de totes les transaccions.

(SELECT * FROM company WHERE company.id In 						 #3º busca * datos de las compañias que cumplan 2º filtro
	(SELECT company_id  FROM transaction WHERE amount > 		 #2º busca company_id sobre amount que sea mayor al 1º filtro
		(SELECT AVG(amount) FROM transaction WHERE declined = 0) #1º busco la media de las ventas (declined=0 considerando solo ventas finalizadas). 
GROUP BY company_id)) ;											 #4º agrupo por company_id



#Ejercicio 3 El departament de comptabilitat va perdre la informació de les transaccions realitzades per una empresa, 
#però no recorden el seu nom, només recorden que el seu nom iniciava amb la lletra c. Com els pots ajudar? Comenta-ho acompanyant-ho de la informació de les transaccions. 
 
(SELECT * FROM transaction WHERE company_id IN 
	(SELECT id FROM company WHERE company_name LIKE "c%")) ;
    
    






#jercicio 4 Van eliminar del sistema les empreses que no tenen transaccions registrades, lliura el llistat d'aquestes empreses.

SELECT company_id FROM transaction WHERE company_id NOT IN 				#3º busca las company_id que no estén en el 2º filtro
	(SELECT company_id FROM 											#2º filtra las company_id que están en el 1º filtro
		(SELECT COUNT(id) FROM transaction GROUP BY company_id) AS CT) 	#1º cuenta id de trnasacciones y agrupa por compañias
;

																	#NIVEL 2

#Ejercicio 1 En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia non institute. 
#Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.

(SELECT * FROM transaction  WHERE company_id IN 								#3º muestra lista de * transaction utilizando 2º filtro
	(SELECT id FROM company WHERE country IN  									#2º busca los id de company utilizando 1º filtro
		(SELECT country FROM company WHERE company_name = "non institute"))) 	#1º encuentra el country de Non Institue
 ;
 
 #Ejercicio 2  El departament de comptabilitat necessita que trobis l'empresa que ha realitzat la transacció de major suma en la base de dades.
 SELECT * FROM company ;
 (SELECT MAX(amount) FROM transaction)
 ;




