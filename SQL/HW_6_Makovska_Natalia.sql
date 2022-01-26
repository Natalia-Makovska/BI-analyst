# 1. Создать таблицу client с полями:
# •  clnt_no ( AUTO_INCREMENT первичный ключ)
# •  cnlt_name (нельзя null значения)
# •  clnt_tel (нельзя null значения)
# •  clnt_region_no

create table client(
					clnt_no int auto_increment primary key,
					cnlt_name VARCHAR(50) not null,
					clnt_tel int not null,
					clnt_region_no int);
                    
# 2. Создать таблицу sales с полями:
# • clnt_no  (внешний ключ на таблицу client поле c lnt_no; режим RESTRICT для update и delete)
# • product_no (нельзя null значения)
# • date_act (по умолчанию текущая дата)

create table sales (
                    clnt_no int,
                    product_no int not null,
                    date_act date,
                    foreign key (clnt_no)
                    references client (clnt_no)
                    on update restrict on delete restrict);
        
# 3.Добавить 5 клиентов (тестовые данные на свое усмотрение)в таблицу client.

insert into client (cnlt_name, clnt_tel, clnt_region_no)
values ('Paul', 0973319617, 01001),
       ('Katherina', 0501110341, 01008),
       ('Helen', 0632210034, 01010),
       ('Nataliia', 0952826961, 01011),
       ('Yanina', 0665556789, 01013);

# 4. Добавить по 2 продажи для каждого сотрудника (тестовые данные на свое усмотрение ) в таблицу sales.
insert into sales (clnt_no, product_no, date_act)
values (1, 112, current_date()),
	   (1, 113, current_date()),
       (2, 221, current_date()),
       (2, 117, current_date()),
       (3, 551, current_date()),
       (3, 553, current_date()),
       (4, 116, current_date()),
       (4, 112, current_date()),
       (5, 553, current_date()),
       (5, 113, current_date());
       
# 5. Из таблицы client, попробовать удалить клиента с clnt_no=1и увидеть ожидаемую ошибку. 
# Ошибку зафиксировать в виде комментария через/* ошибка */.

delete from client
where clnt_no = 1;

/*Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`tempdb`.`sales`, CONSTRAINT `sales_ibfk_1` 
FOREIGN KEY (`clnt_no`) REFERENCES `client` (`clnt_no`) ON DELETE RESTRICT ON UPDATE RESTRICT)*/

# 6. Удалить из sales клиента по clnt_no=1, после чего повторить удаление из client по clnt_no=1 (ошибки в таком порядке не должно быть)

delete from sales
where clnt_no = 1;

delete from client
where clnt_no = 1;

# 7. Из таблицы client удалить столбец clnt_region_no

alter table client drop column clnt_region_no;

#8. В таблице client переименовать поле clnt_tel в clnt_phone.

alter table client rename column clnt_tel to clnt_phone;

#9. Удалить данные в таблице departments_dup с помощью DDL оператора truncate.

truncate table employees.departments_dup;

