-- DIO - BootCamp Ciência de Dados com Python
-- Desafio: Construindo seu Primeiro Projeto Lógico de Banco de Dados

-- Criação de Banco de Dados para E-commerce
-- show databases;

-- drop database ecommerce;
create database ecommerce;
use ecommerce;

-- TABELAS DE ENTIDADE -----------------------------------------------

-- CLIENTE 

create table clients(
	id int auto_increment primary key,
    type_person enum("PJ","PF") not null,
    address varchar(255) not null,
    contact_number varchar(45) not null,
    email varchar(45) not null,
    registration_date date,
    observation varchar(500)
);

desc clients;

-- -- CLIENTE PESSOA FÍSICA (natural person)

create table clients_np(
	client_id int primary key,
    first_name varchar(30) not null,
    middle_name varchar(30),
    last_name varchar(30) not null,
    cpf char(11) not null,
    birth_date date not null,
    constraint unique_client_cpf unique (cpf),
    constraint fk_clientnp_client foreign key (client_id) references clients(id)
);
desc clients_np;
-- -- CLIENTE PESSOA JURÍDICA (legal person)

create table clients_lp(
	client_id int primary key,
    business_name varchar(100) not null,
    fantasy_name varchar(50),
    cnpj char(11) not null,
    constraint unique_client_cnpj unique (cnpj),
    constraint fk_clientlp_client foreign key (client_id) references clients(id)
);
desc clients_lp;
-- -- CARTÃO

create table credit_cards(
	id int auto_increment primary key,
    client_id int,
    alias varchar(20),
    card_number bigint not null,
    owner_name varchar(50) not null,
    expiration date not null,
    observation varchar(500),
    constraint unique_credit_card_number unique (card_number),
    constraint fk_credit_card_client foreign key (client_id) references clients(id)
);

-- PRODUTO

create table products(
	id int auto_increment primary key,
    name_product varchar(50) not null,
    category enum('Eletrônicos', 'Moda e Acessórios',
                    'Brinquedos', 'Alimentos e Bebidas', 
                    'Casa e Decoração', 'Saúde e Beleza', 
                    'Pet Shop', 'Sem categoria')
                    default 'Sem categoria',
    kids_product bool default false,
    rating float default 0,
    size varchar(15),
    product_description varchar(300),
    cost_price float,
    seller_price float,
    registration_date date,
    observation varchar(500)
);

-- FORNECEDOR

create table suppliers(
	id int auto_increment primary key,
    business_name varchar(45) not null,
    fantasy_name varchar(45),
    cnpj char(15) not null,
    address varchar(255) not null,
    contact_number varchar(45) not null,
    email varchar(45) not null,
    registration_date date,
    observation varchar(500),
    constraint unique_supplier_cnpj unique (cnpj)
);

-- VENDEDOR

create table sellers(
	id int auto_increment primary key,
    type_person enum("PJ","PF") not null,
    address varchar(255) not null,
    contact_number varchar(45) not null,
    email varchar(45) not null,
    registration_date date,
    observation varchar(500)
);

-- -- VENDEDOR PESSOA FÍSICA

create table sellers_np(
	seller_id int primary key,
    first_name varchar(30) not null,
    middle_name varchar(30),
    last_name varchar(30) not null,
    cpf char(11) not null,
    birth_date date not null,
    constraint unique_seller_np_cpf unique (cpf),
    constraint fk_seller_np_id foreign key (seller_id) references sellers(id)
);

-- -- VENDEDOR PESSOA JURÍDICA

create table sellers_lp(
	seller_id int primary key,
    business_name varchar(100) not null,
    fantasy_name varchar(50),
    cnpj char(11) not null,
    constraint unique_sellernp_cnpj unique (cnpj),
    constraint fk_seller_lp_id foreign key (seller_id) references sellers(id)
);

-- ESTOQUE

create table stocks(
	id int auto_increment primary key,
    stock_name varchar(50),
    location varchar(255) not null
);

-- PEDIDO

create table orders(
	id int auto_increment primary key,
    client_id int not null,
    order_status enum('Em processamento', 'Confirmado',
						'Enviado', 'Entregue', 'Cancelado')
						not null
                        default 'Em processamento',
    order_description varchar(300),
    constraint fk_order_client_id foreign key (client_id) references clients(id)
);

-- -- ENTREGA

create table deliveries(
	id int auto_increment primary key,
    order_id int,
    delivery_status enum('Em processamento', 'Enviado', 'Entregue', 'Cancelado') not null,
    tracking_code varchar(20),
    send_date date,
    send_value float default 10, -- frete 10 reais
    delivery_date date,
    observation varchar(500),
    constraint fk_delivery_order_id foreign key (order_id) references orders(id)
);

-- -- PAGAMENTO

create table payments(
	id int auto_increment primary key,
    order_id int,
    payment_type enum("Boleto", "Cartão") default "Cartão",
    payment_value float not null,
	payment_date date,
	constraint fk_payment_order_id foreign key (order_id) references orders(id)

);

-- -- -- PAGAMENTO COM BOLETO

create table payment_slip(
	payment_id int,
	expiration_date date,
	constraint fk_payment_slip_payment_id foreign key (payment_id) references payments(id)
);

-- -- -- PAGAMENTO COM CARTÃO
create table payment_credit_card(
	payment_id int,
    credit_card_id int,
	installments int default 1, -- parcelas
	constraint fk_payment_credit_card_payment_id foreign key (payment_id) references payments(id),
    constraint fk_payment_credit_card_credit_card_id foreign key (credit_card_id) references credit_cards(id)
);



-- TABELAS RELACIONAIS -----------------------------------------------


-- PRODUTO_PEDIDO

create table product_order(
	order_id INT,
    product_id INT,
    quantity INT DEFAULT 1,
    status enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (order_id, product_id),
    constraint fk_product_order_order_id foreign key (order_id) references orders(id),
    constraint fk_product_order_product_id foreign key(product_id) references products(id)
);

-- ESTOQUE_PRODUTO

create table product_stock(
	stock_id int,
    product_id int,
    quantity int default 1,
    primary key (stock_id, product_id),
    constraint fk_product_stock_stock_id foreign key (stock_id) references stocks(id),
    constraint fk_product_stock_product_id foreign key (product_id) references products(id)
);

-- FORNECEDOR_FORNECE_PRODUTO

create table product_supplier(
	supplier_id int,
    product_id int,
    quantity int default 1,
    primary key (supplier_id, product_id),
    constraint fk_product_supllier_supplier_id foreign key (supplier_id) references suppliers(id),
    constraint fk_product_supllier_product_id foreign key(product_id) references products(id)
);

-- VENDEDOR_VENDE_PRODUTO

create table product_seller(
	seller_id int,
    product_id int,
    quantity int default 1,
    primary key (seller_id, product_id),
    constraint fk_product_seller_seller_id foreign key (seller_id) references sellers(id),
    constraint fk_product_seller_product_id foreign key(product_id) references products(id)
);
