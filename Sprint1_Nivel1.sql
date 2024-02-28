
#Ejercicio 2
SELECT (company_name) AS Name, email,country FROM company
ORDER BY name;

#Ejercicio 3 
SELECT country FROM company
JOIN transaction ON company.id = transaction.company_id WHERE transaction.declined = 0 
GROUP BY country;

#Ejercicio 4 
SELECT COUNT(DISTINCT country)AS "Countries" FROM company
JOIN transaction ON company.id = transaction.company_id WHERE transaction.declined = 0;

#Ejercicio 5 
SELECT country , company_name FROM company 
WHERE company.id = "b-2354"; 

#Ejercicio 6 
SELECT company_name, AVG(amount)  FROM transaction
JOIN company ON company.id = transaction.company_id WHERE transaction.declined = 0
GROUP BY company.id
LIMIT 1;

