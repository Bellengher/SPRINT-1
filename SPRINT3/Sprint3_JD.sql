									#NIVEL 1


										
/*Ejercicio 1 Tu tarea es diseñar y crear una tabla llamada "credit_*card" que almacene detalles cruciales sobre las tarjetas de crédito. 
La nueva tabla debe ser capaz de identificar de manera única cada tarjeta y establecer una relación adecuada con las otras dos tablas ("transaction" y "company"). 
Después de crear la mesa será necesario que ingreses la información del documento denominado "dades_introduir_credit". 
Recuerda mostrar el diagrama y realizar una breve descripción del mismo.*/

#CREAR LA TABLA CREDIT CARD:
CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(20) PRIMARY KEY,
	iban VARCHAR(60),
	pan INT(50),
	pin INT(4),
	cvv INT(4),
	expiring_date DATE 
);

#INDEXAR TABLA CREDIT_CARD:
CREATE INDEX idx_credit_card_id ON transaction(credit_card_id);

# A LA HORA DE AGREGAR LOS DATOS A LA TABLA credit_card ME DABA ERROR POR EL FORMATO FECHA DE expiring_date ASÍ QUE LO SOLVENTE ASI:
	***PROCESO PARA CAMBIAR DE FORMATO DATE EN VISUAL STUDI CODE***
1º ABRO EL ARCHIVO EN VISUAL STUDI CODE
2º EDIT/REPLACE (USE REGULAR EXPRESSION)  !!!!
3º BUSCAR : \b\d{1,2}/\d{1,2}/\d{2}\b
4º REMPLAZAR EN TODOS : STR_TO_DATE('$0', '%m/%d/%y')

5º EDIT/REPLACE (WITHOUT REGULAR EXPRESSION) !!!!
6º BUSCAR: 'STR  Y REMPLAZAR : STR
7º BUSCAR: )')  Y REMPLAZAR :  ))

#CREAR FOREGIN KEYS PARA QUE EL MODELO DESDE LA TABLA transaction QUE ES LA TABLA DE HECHOS.
ALTER TABLE transaction						#INDICO CAMBIO EN TABLA transaction
ADD FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);	#AGREGO COMO FOREIGN KEY credit_card_id PARA QUE SE RELACIONE CON id DE LA TABLA credit_card

ALTER TABLE transaction						#INDICO CAMBIO EN TABLA transaction
ADD FOREIGN KEY (user_id) REFERENCES user(id);			#AGREGO COMO FOREIGN KEY user_id PARA QUE SE RELACIONES CON id 	DE LA TABLA user


/*Ejercicio 2
El departamento de Recursos Humanos ha identificado un error en el número de cuenta del usuario con el: credit_card_id CcU-2938. 
Se requiere actualizar la información que identifica una cuenta bancaria a nivel internacional 
(identificado como "IBAN"): TR323456312213576817699999. Recuerda mostrar que el cambio se realizó.*/

SELECT * FROM credit_card 
	WHERE id = "Ccu-2938";						#1º Visualizo los campos para ver lo que voy a cambiar
	
UPDATE credit_card SET IBAN = 'TR323456312213576817699999'
	WHERE credit_card.id = 'CcU-2938';				#2º Cambio el IBAN por el nuevo requerido
	
SELECT * FROM credit_card 
	WHERE id = "Ccu-2938";						#3º Vuelvo a revisar los campos para comprobar el cambio


/* Ejercicio 3 En la tabla "transaction" ingresa un nuevo usuario con la siguiente información:

Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
credit_card_id	CcU-9999
company_id	b-9999
user_id	9999
lat	829.999
longitude	-117.999
amount	111.11
declined	0
*/
INSERT INTO credit_card (id) VALUES ('CcU-9999');				# Hago esto porque al meter los datos en transaction me pide que credit_card.id tenga valor por ser FK
INSERT INTO company (id) VALUES ('b-9999');					# Hago esto porque al meter los datos en transaction me pide que company.id tenga valor por ser FK
INSERT INTO user (id) VALUES ('9999');						# Hago esto porque al meter los datos en transaction me pide que user.id tenga valor por ser FK
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude , amount , declined) VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD','CcU-9999','b-9999','9999','829.999','-117.999','111.11','0');
SELECT * FROM transaction WHERE id ="108B1D1D-5B23-A76C-55EF-C568E49A99DD"  ;


/* Ejercicio 4
Desde recursos humanos te solicitan eliminar la columna "pan" de la tabla credit_*card. Recuerda mostrar el cambio realizado.*/

alter table credit_card drop column pan ;				#1º Elimino la columna indicada
SELECT * from credit_card;						#2º Hago Select para comprobarlo



								#NIVEL 2

	

/* Ejercicio 1
Elimina de la tabla transaction el registro con ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de datos*/

DELETE FROM transaction WHERE transaction.id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";	#1º Elimino el registro indicado
	
SELECT * FROM TRANSACTION WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";		#2º Hago SELECT y busco el id para comprobar la eliminacion. 



/* Ejercicio 2
 La sección de marketing desea tener acceso a información específica para realizar análisis y estrategias efectivas. 
 Se ha solicitado crear una vista que proporcione detalles clave sobre las compañías y sus transacciones. 
 Será necesaria que crees una vista llamada VistaMarketing que contenga la siguiente información: Nombre de la compañía. 
 Teléfono de contacto. País de residencia. Promedio de compra realizado por cada compañía. 
 Presenta la vista creada, ordenando los datos de mayor a menor media de compra*/
 
CREATE VIEW Vista_Marketing AS							#3º Creo la visa
SELECT company_name, phone, country,media FROM company c JOIN			#2º Hago JOIN con los campos requeridos de la tabla company
(SELECT company_id, ROUND(AVG(amount),2) media FROM transaction 		#1º Busco la media de TODAS las transacciones agrupando por compañia 
GROUP BY company_id) d ON c.id = company_id								
ORDER BY media DESC;								#4º Ordeno por la media de mayor a menor como se pide.




/*Ejercicio 3
Filtra la vista VistaMarketing para mostrar sólo las compañías que tienen su país de residencia en "Germany"*/
	
SELECT * FROM Vista_Marketing WHERE country = "Germany";	# Hago SELECT de la VISTA y filtro por Germany



	

									#NIVEL 3


	
/* Ejercicio 1 Ejercicio 1
La semana próxima tendrás una nueva reunión con los gerentes de marketing. 
Un compañero de tu equipo realizó modificaciones en la base de datos, pero no recuerda cómo las realizó. 
Te pide que le ayudes a dejar los comandos ejecutados para obtener las siguientes modificaciones (se espera que realicen 6 cambios) */

#1º CAMBIO: EN LA TABLA COMPANY HA ELIMINADO LA COLUMNA WEBSITE
ALTER TABLE company DROP COLUMN website ;

#2º CAMBIO: HA ELIMINADO LA VIEW VISTA_MARKETING
DROP VIEW Vista_Marketing; 

#3º CAMBIO: HA ELIMINADO LA VIEW INFORMETECNICO
DROP VIEW InformeTecnico;

#4º CAMBIO: HA CAMBIADO DE NOMBRE EN LA TABLA user A LA COLUMNA email POR personal_email
ALTER TABLE user CHANGE email personal_email VARCHAR(150);

#5º CAMBIO: EN LA TABLA credit_card HA AGREGADO LA COLUMNA fecha_actual
ALTER TABLE credit_card ADD fecha_actual DATE;

#6º CAMBIO: DE LA TABLA credit_card HA ELIMINADO LA COLUMNA pan.
ALTER TABLE credit_card DROP COLUMN pan ;


/*Ejercicio 2
La empresa también te solicita crear una vista llamada "InformeTecnico" que contenga la siguiente información:

ID de la transacció
Nom de l'usuari/ària
Cognom de l'usuari/ària
IBAN de la targeta de crèdit usada.
Nom de la companyia de la transacció realitzada.
Assegura't d'incloure informació rellevant de totes dues taules i utilitza àlies per a canviar de nom columnes segons sigui necessari.
Mostra els resultats de la vista, ordena els resultats de manera descendent en funció de la variable ID de transaction.*/

CREATE VIEW InformeTecnico AS											#1º Creo la View
SELECT t.id numero_de_transaccion,u.name nombre,u.surname apellido,c.company_name empresa,cc.iban 
	FROM user u 												#2º Selecciono todos los campos requeridos
JOIN transaction t ON u.id = t.user_id										#3º JOIN de user con transaction
JOIN company c ON c.id = company_id										#4º JOIN de company con transaction	
JOIN credit_card cc ON t.credit_card_id = cc.id;								#5º JOIN de credit_card con transaction

SELECT * FROM InformeTecnico;											#6º Visualizo la VIEW





#PROBÉ LA OPCION DE HACERLO CON SUBQUERY PERO HE LEIDO QUE ES MÁS EFICIENTE HACERLO CON JOIN
SELECT t.id Numer_Transaccion,							
    (SELECT name FROM user WHERE id = t.user_id) Nombre,
    (SELECT surname FROM user WHERE id = t.user_id) Apellido,
    (SELECT company_name FROM company WHERE id = t.company_id) Empresa,
    (SELECT iban FROM credit_card WHERE id = t.credit_card_id) Codigo_IBAN
FROM transaction t;










