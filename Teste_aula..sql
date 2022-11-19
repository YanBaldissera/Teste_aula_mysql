create database teste;
use teste;



#1
create table Produto(Cod_barras int auto_increment,
					Descricao text,
                    Preço float,
                    Estoque int,
                    primary key (Cod_barras)
                    );
                    
create table Funcionário(ID int auto_increment,
						Nome varchar(255),
                        Salário decimal(10,2),
                        TotalVendas decimal(10,2),
                        primary key(ID)
                        );
                        
create table Venda(ID_venda int auto_increment,
				  Produto int,
                  Vendedor int,
                  Valor decimal(10,2),
                  primary key(ID_venda),
                  foreign key (Produto) references Produto(Cod_barras),
                  foreign key (Vendedor) references Funcionário(ID)
                  );
                  
#2

select Descricao, Preço from Produto;


#3

create view Nome_vendas as select Nome, TotalVendas from Funcionário;

select * from Nome_vendas;

#4

DELIMITER $$

create function Estoque(_cod int) returns varchar(50)

deterministic

begin

declare _estoque int;

select Estoque from Produto where _cod = Cod_barras into _estoque;

if _estoque = 0 then
	return "Em falta";
else
	return "Ok";
end if;

end$$

DELIMITER ;

select Estoque(2);

insert into Produto(Descricao, Preço,  Estoque)
values
('bananas', '3.50','0'),
('maças', '4.50', '10');

select * from Produto;

insert into Funcionário(Nome, Salário, TotalVendas)
values
('Yan', '5000', '15');


insert into venda(Produto, Vendedor, Valor)
values
('2', '1', '9.00');


#5

DELIMITER $$

create procedure _vendas(_cod_b int, ID_func int, comprados int)

begin
 
 declare _preco float;
 select Preço from Produto where Cod_barras = _cod_b into _preco;
 
 insert into Venda(Produto, Vendedor, Valor)
 values
 (_cod_b, ID_func, _preco * comprados);

end$$

DELIMITER ;

drop procedure _vendas;

call _vendas(2, 1, 3);

select * from Venda;


#6 

DELIMITER $$

create trigger tr_venda after insert
on Venda
for each row

begin
update Funcionário set TotalVendas = TotalVendas + new.Valor;


end$$

DELIMITER ;

select * from Funcionário;

drop trigger tr_venda;


#7

DELIMITER $$

create trigger tr_venda after insert
on Venda
for each row


begin

declare quantidade int;
declare _preco_ float;
select Preço from Produto where new.Produto = Cod_barras into _preco_;
set quantidade = new.Valor / _preco_;

update Funcionário set TotalVendas = TotalVendas + new.Valor;
update Produto set Estoque = Estoque - quantidade where new.Produto = Cod_barras;

end$$

DELIMITER ;

drop trigger tr_venda;

select * from Funcionário;
select * from Produto;
