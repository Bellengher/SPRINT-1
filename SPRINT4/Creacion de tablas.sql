CREATE DATABASE IF NOT EXISTS operations; 



#1º Creo la tabla dimensión users donde voy a unificar los 3 archivos csv de usuarios ya que después de analizarlos se observa que es viable.

CREATE TABLE IF NOT EXISTS users (
    	id INT,
    	name VARCHAR(50),
    	surname VARCHAR(100),
    	phone VARCHAR(50),
    	email VARCHAR(100),
    	birth_date VARCHAR(20),
    	country VARCHAR(50),
    	city VARCHAR(50),
    	postal_code VARCHAR(25),
    	address VARCHAR(255),
    	PRIMARY KEY(id)
);


#2º Creo la tabla companies
CREATE TABLE IF NOT EXISTS companies (
    	company_id varchar (6),
    	company_name varchar (70),
    	phone varchar (20),
    	email varchar (70),
    	country varchar (20),
    	website varchar (70),
    	PRIMARY KEY (company_id)
    );
    
    

#3º Creo la tabla credit_cards
CREATE TABLE IF NOT EXISTS credit_cards (
	id varchar(15),
	user_id int,
	iban varchar (100),
	pan varchar(50) ,
	pin int ,
	cvv int ,
	track1 varchar(250),
	track2 varchar (250),
	expiring_date varchar (12) ,
	PRIMARY KEY (id)
);


#4º Creo la tabla products
CREATE TABLE IF NOT EXISTS products (
	id int,
	product_name varchar (50) ,
	price varchar (20) ,
	colour varchar (20) ,
	weight decimal (5,2) ,
	warehouse_id varchar (10),
	PRIMARY KEY (id)
); 

#5º Creo la tabla de hechos transactions

CREATE TABLE IF NOT EXISTS transactions (
	id varchar (50) NOT NULL,
    	card_id varchar (8) NOT NULL,
    	business_id varchar (6) NOT NULL,
    	timestamp varchar (20) NOT NULL,
    	amount decimal (10,2) NOT NULL,
    	declined boolean NOT NULL,
    	product_ids varchar (10) NOT NULL, 
    	user_id int NOT NULL,
    	lat float,
    	longitude float,
    	PRIMARY KEY(id)
	FOREIGN KEY(card_id) REFERENCES credit_card(id), 
    	FOREIGN KEY(company_id) REFERENCES company(company_id),
    	FOREIGN KEY(user_id) REFERENCES user(id)
);

	❗️PARA PODER ESTABLECER LA RELACION CON LA TABLA PRODUCTS HE TENIDO QUE CREAR UNA TABLA PUENTE 
		ENTRE LAS TABLAS TRANSACTIONS Y PRODUCTS A LA QUE HE LLAMADO PRODUCT_TRANSACTION.
  	HE OPTADO POR ESTA OPCION YA QUE EN TRANSACTIONS EN EL CAMPO PRODUCTS_ID HAY MAS DE UN ID EN MUCHOS CASOS SEPARADOS POR ,

----------------------------------------------------------------------------------------------------------------------------------------------------------
/*El proceso que se ha seguido ha sido : 
1º He creado una tabla derivada de la tabla products que haga de nexo entre transactions y products a la cual he llamado product_transaction 
y en la que he dejado unicamente dos campos que considero son los que necesito ( id , product_id).*/
----------------------------------------------------------------------------------------------------------------------------------------------------------	
CREATE TABLE product_transaction (
  	id varchar(50) NOT NULL,
  	product_ids int NOT NULL,
	FOREIGN KEY(id) REFERENCES transactions(id),
    	FOREIGN KEY(product_ids) REFERENCES products(id)
);

❗️Los datos para esta tabla los he obtenido de la siguiente manera:
	1º Cargo el CSV de la tabla transactions
	2º Elimino las columnas que no voy a utilizar hasta quedarme sólo con id y products_id

3º Creo una tabla temporal para poder hacer los cambios previos.

CREATE TABLE temporal (
    id VARCHAR(50),
    product_id VARCHAR(100)
);

4º Cargo los datos con WIZARD desde el CSV que he utilizado en el paso anterior.

5º Separo los valores de product_ids separados por , en filas desde la tabla temporal a una definitiva (product_transaction)

INSERT INTO product_transaction (id, product_ids)
(SELECT id,
	SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', numbers.n), ',', -1) AS product_id
FROM temporal
JOIN (	SELECT 1 AS n 
	UNION ALL SELECT 2 
        UNION ALL SELECT 3 
        UNION ALL SELECT 4	) AS numbers 
ON CHAR_LENGTH(product_ids) - CHAR_LENGTH(REPLACE(product_ids, ',', '')) >= n - 1);

6º Finalmente elimino la tabla temporal.
