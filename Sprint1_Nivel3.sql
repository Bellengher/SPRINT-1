#Ejercicio 1  
SELECT company_name, phone, country, SUM(amount)AS Total FROM company
JOIN transaction ON company.id = transaction.company_id WHERE transaction.declined = 0
AND amount BETWEEN 100 AND 200
GROUP BY company_name,phone,country 
ORDER BY total DESC;

#Ejercicio 2 
SELECT company_name ,timestamp FROM company
JOIN transaction ON company.id = transaction.company_id WHERE transaction.declined = 0
AND timestamp LIKE "2022-03-16%" OR timestamp LIKE "2022-02-28%" OR timestamp LIKE "2022-02-13%";







