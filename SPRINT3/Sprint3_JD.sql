#NIVEL 1

/*Exercicio 1 La teva tasca és dissenyar i crear una taula anomenada "credit_*card" que emmagatzemi detalls crucials sobre les targetes de crèdit. 
La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" i "company"). 
Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". 
Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.*/

#INDEXAR TABLA CREDIT_CARD:
CREATE INDEX idx_credit_card_id ON transaction(credit_card_id);

#CREAR LA TABLA CREDIT CARD:
CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(20) PRIMARY KEY,
	iban VARCHAR(60),
	pan INT(50),
	pin INT(4),
	cvv INT(4),
	expiring_date DATE 
);


/*Exercici 2
El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb el: credit_card_id CcU-2938. 
Es requereix actualitzar la informació que identifica un compte bancari a nivell internacional 
(identificat com "IBAN"): TR323456312213576817699999. Recorda mostrar que el canvi es va realitzar.*/
#'TR301950312213576817638661'
SELECT * FROM credit_card WHERE id = "Ccu-2938";												#1º Visualizo los campos para ver lo que voy a cambiar
UPDATE credit_card SET IBAN = 'TR301950312213576817638661' WHERE credit_card.id = 'CcU-2938';	#2º Cambio el IBAN por el nuevo requerido
SELECT * FROM credit_card WHERE id = "Ccu-2938";												#3º Vuelvo a revisar los campos para comprobar el cambio


/* Exercici 3 En la taula "transaction" ingressa un nou usuari amb la següent informació:

Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
credit_card_id	CcU-9999
company_id	b-9999
user_id	9999
lat	829.999
longitude	-117.999
amount	111.11
declined	0
*/
INSERT INTO credit_card (id) VALUES ('CcU-9999');			# Hago esto porque al meter los datos en transaction me pide que credit_card.id tenga valor por ser FK
INSERT INTO company (id) VALUES ('b-9999');					# Hago esto porque al meter los datos en transaction me pide que company.id tenga valor por ser FK
INSERT INTO user (id) VALUES ('9999');						# Hago esto porque al meter los datos en transaction me pide que user.id tenga valor por ser FK
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude , amount , declined) VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD','CcU-9999','b-9999','9999','829.999','-117.999','111.11','0');
SELECT * FROM transaction WHERE id ="108B1D1D-5B23-A76C-55EF-C568E49A99DD"  ;


/* Exercici 4
Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_*card. Recorda mostrar el canvi realitzat.*/

alter table credit_card drop column pan ;				#1º Elimino la columna indicada
SELECT * from credit_card;								#2º Hago Select para comprobarlo



#NIVEL2

/* Exercici 1
Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades*/

DELETE FROM transaction WHERE transaction.id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";	#1º Elimino el registro indicado
SELECT * FROM TRANSACTION;																#2º Hago SELECT y busco el id para comprobar la eliminacion. 



/* Exercici 2
 La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
 S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
 Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia. 
 Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
 Presenta la vista creada, ordenant les dades de major a menor mitjana de compra*/
 
CREATE VIEW Vista_Marketing AS											#3º Creo la visa
SELECT company_name, phone, country,media FROM company JOIN				#2º Hago JOIN con los campos requeridos de la tabla company
(SELECT company_id, ROUND(AVG(amount),2) media FROM transaction 		#1º Busco la media por compañia descartando rechazados (declined=0)
WHERE declined=0 GROUP BY company_id) d ON company.id = company_id;
SELECt * FROM Vista_Marketing;



/*Exercici 3
Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"*/
SELECT * FROM Vista_Marketing WHERE country = "Germany";	# Hago SELECT de la VISTA y filtro por Germany










