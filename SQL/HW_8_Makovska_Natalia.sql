#  1.  В схеме employees, в таблице employees добавить новый столбец - lang_no (int).

alter table employees add column lang_no int;

# 2.  Обновить столбец lang_no значением "1" для всех у кого год прихода на работу 1985 и 1988. 
# Остальным значение сотрудникам обновить значение"2".

update employees set lang_no = case
                              when year(hire_date) = 1985 then 1
                              when year(hire_date) = 1988 then 1
                              else 2 end;
                              
select *
from employees as em;

# 3.  В схеме tempdb, создать новую таблицу languageс двумя полями lang_no (int) и lang_name (varchar(3)).

create table languages (
						lang_no int,
						lang_name varchar (3));

# 4.  Добавить в таблицу tempdb.language две строки:1 - ukr, 2 - rus.

 insert into languages (lang_no, lang_name)
 values (1, 'ukr'), 
        (2, 'rus');
	
# 5. Связать таблицы из схемы employees и tempdb чтобы показать всю информацию из таблицы employees и один столбец lang_name 
# из таблицы language (столбцы lang_no не отображать).

select em.emp_no, em.birth_date, 
	   em.first_name, em.last_name, 
       em.gender, em.hire_date, lg.lang_name
from employees.employees as em
inner join tempdb.languages as lg
on em.lang_no = lg.lang_no;


# 6.  На основе запроса из 5-го задания, создать вью employees_lang.

create view employees_lang as
select em.emp_no, em.birth_date, 
	   em.first_name, em.last_name, 
       em.gender, em.hire_date, lg.lang_name
from employees.employees as em
inner join tempdb.languages as lg
on em.lang_no = lg.lang_no;

# 7.  Через вью employees_lang вывести количество сотрудников в разрезе языка.

select count(emp_no) as cnt_emp, lang_name
from employees_lang
group by lang_name;

