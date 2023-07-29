-- criação do banco de dados para o cenário E-commerce

create database ecommerce;
use ecommerce;

-- criar tabel cliente
create table clients(
	idClient int auto_increment primary key,
    Fname varchar(10),
    MInit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(30),
    constraint unique_cpf_client unique (CPF)
);

desc clients;

-- criar tabela produto
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(10) not null,
    classification_kids bool default false,
    category enum("Eletrônico", "Vestimenta", "Brinquedos", "Alimentos", "Móveis"),
    avaliacao float default 0,
    size varchar(10)
);

desc product;

-- para ser continuado no desafio: termine de implementar a tabela
-- e crie a conexao com as tabelas necessárias
-- reflita essa modificação no diagrama de esquema relacional
-- criar constraints relacionadas a pagamento


-- criar tabela pagamentos
create table payments(
	idClient int,
    idPayment int,
    typePayment enum('Boleto','Cartão''Dois cartões'),
    limitAvailable float,
    primary key(idClient, idPayment)
);


-- criar tabela pedido
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado', 'Confirmado','Em processamento'),
	orderDescription varchar(255),
    sendValue float default 0,
    paymentCash bool default false,
    constraint fk_orders_clients foreign key (idOrderClient) references clients(idClient)
);

desc orders;

-- criar tabela estoque
create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

desc productStorage;

-- criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    socialName varchar(255) not NULL,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_cnpj_supplier unique (CNPJ)
);

desc supplier;

-- criar tabela vendedor-terceiro
create table seller(
	idSeller int auto_increment primary key,
    socialName varchar(255) not NULL,
    AbstName varchar(255),
    CNPJ char(15) not null,
    CPF char(11),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

desc seller;

-- criar tabela produto-vendedor
create table productSeller(
	idPSeller int,
    idPProduct int,
    prodQuantity int default 1,
    primary key (idPSeller, idPProduct),
    constraint fk_productSeller_seller foreign key (idPSeller) references seller(idSeller),
    constraint fk_productSeller_product foreign key (idPProduct) references product(idProduct)
);
desc productSeller;

-- criar tabela produto-fornecedor
create table productSupplier(
	idPSupplier int,
    idPProduct int,
    prodQuantity int default 1,
    primary key (idPSupplier, idPProduct),
    constraint fk_productSupplier_supplier foreign key (idPSupplier) references supplier(idSupplier),
    constraint fk_productSupplier_product foreign key (idPProduct) references product(idProduct)
);

desc productSupplier;

-- criar tabela produto-pedido
create table productOrder(
	idPOrder int,
    idPProduct int,
    prodQuantity int default 1,
    prodStatus enum("Disponível", "Sem estoque") default "Disponível",
    primary key (idPOrder, idPProduct),
    constraint fk_productOrder_order foreign key (idPOrder) references orders(idOrder),
    constraint fk_productOrder_product foreign key (idPProduct) references product(idProduct)
);

desc productOrder;

create table storageLocation(
	idLStorage int,
    idLProduct int,
    location varchar(255) not null,
    primary key (idPOrder, idPProduct),
    constraint fk_storageLocation_storage foreign key (idLStorage) references productStorage(idProdStorage),
    constraint fk_storageLocation_product foreign key (idLProduct) references orders(idOrder)
);

desc storageLocation;

show tables;