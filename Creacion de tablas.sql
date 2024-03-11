#1º Creo la tabla de hechos transactions

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
);



#2º Creo la tabla users donde voy a unificar los 3 archivos csv de usuarios

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

# 3º Creo el indice de users con la tabla transactions
CREATE INDEX idx_users_id ON transactions(user_id);


#4º Creo la tabla companies
CREATE TABLE IF NOT EXISTS companies (
	company_id varchar (6),
    company_name varchar (70),
    phone varchar (20),
    email varchar (70),
    country varchar (20),
    website varchar (70),
    PRIMARY KEY (company_id)
    );
    
# 5º Creo el indice de companies con la tabla transactions
CREATE INDEX idx_companies_id ON transactions(business_id);
    

#6º Creo la tabla credit_cards
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

# 7º Creo el indice de credit_cards con la tabla transactions
CREATE INDEX idx_credit_cards_id ON transactions(card_id);

#8º Creo la tabla products
CREATE TABLE IF NOT EXISTS products (
id int,
product_name varchar (50) ,
price varchar (20) ,
colour varchar (20) ,
weight decimal (5,2) ,
warehouse_id varchar (10),
PRIMARY KEY (id)
); 

# 9º Creo el indice de credit_cards con la tabla transactions
CREATE INDEX idx_products_id ON transactions(product_ids);
SELECT * FROM transactions;

# Creo las FOREIGN KEY con respecto a la tabla de hechos (transactions)
ALTER TABLE transactions
ADD CONSTRAINT fk_card_id
FOREIGN KEY (card_id)
REFERENCES credit_cards(id);

ALTER TABLE transactions
ADD CONSTRAINT fk_business_id
FOREIGN KEY (business_id)
REFERENCES companies(company_id);

ALTER TABLE transactions
ADD CONSTRAINT fk_user_id
FOREIGN KEY (user_id)
REFERENCES users(id);

/*
ALTER TABLE transactions
ADD CONSTRAINT fk_products_id
FOREIGN KEY (product_ids)
REFERENCES products(id); */
