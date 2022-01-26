# 1. Отобразить информацию из таблицы сотрудников и через подзапрос добавить его текущую должность.

 select *
 from
(select em.emp_no, 
       em.birth_date, 
       em.first_name, 
       em.last_name, 
       em.gender, 
       em.hire_date,
       (select tt.title
		from titles as tt
		where tt.to_date >= now()
        and em.emp_no = tt.emp_no) as title
from employees as em) as t1;

# 2. Отобразить информацию из таблицы сотрудников, которые (exists) в прошлом были с должностью 'Engineer'.

select *
from employees as em
where exists (select tt.title
		      from titles as tt
		      where tt.to_date < now()
			  and em.emp_no = tt.emp_no
			  and tt.title = 'Engineer');


# 3. Отобразить информацию из таблицы сотрудников,у которых (in) актуальная зарплата от 50 тысяч до 75 тысяч.

select *
from employees as em
where em.emp_no in (select sl.emp_no
					from salaries as sl
					where sl.to_date >= now()
					and sl.salary between 50000 and 75000);
				
                
# 4. Создать копию таблицы employees с помощью этого SQL скрипта:create table employees_dub as select * from employees;

create table employees_dub as select * from employees;

select *
from employees_dub;

# 5 Из таблицы employees_dub удалить сотрудников которые были наняты в 1985году

delete from employees_dub
where hire_date between '1985-01-01' and '1985-12-31';


# 6 В таблице employees_dub сотруднику под номером 10008 изменить дату приема на работу на ‘1994-09-01’. 

update employees_dub
set hire_date = str_to_date('1994-09-01','%Y-%m-%d')
where emp_no = 10008;


# 7 В таблицу employees_dub добавить двух произвольных сотрудников.

insert into employees_dub (emp_no, birth_date, first_name, last_name, gender, hire_date)
values (330811, str_to_date('1990-07-28','%Y-%m-%d'), 'Nataliia', 'Makovska', 'F', str_to_date('2012-07-01','%Y-%m-%d')),
       (330827, str_to_date('1982-08-04','%Y-%m-%d'), 'Vladislav', 'Makovsky', 'M', str_to_date('2021-05-05','%Y-%m-%d'));

select *
from employees_dub
order by hire_date desc;


commit;
