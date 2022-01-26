# Запросы
# 1.Покажите среднюю зарплату сотрудников за каждый год (средняя заработная плата среди тех, кто работал в отчетный период
# - статистика с начала до 2005 года).

select year(sl.from_date) as years, 
	   round(avg(sl.salary)) as avg_emp_sal
from salaries as sl
where year(sl.to_date) < 2006
group by year(sl.from_date)
order by 1;    
      
# 2.Покажите среднюю зарплату сотрудников по каждому отделу. 
# Примечание: принять в расчет только текущие отделы и текущую заработную плату.

select de.dept_no, 
	   round(avg(sl.salary)) as avg_emp_sal
from salaries as sl
inner join dept_emp as de
on sl.emp_no = de.emp_no
where sl.to_date >=now()
and de.to_date >= now()
group by de.dept_no
order by 1;

# 3. Покажите среднюю зарплату сотрудников по каждому отделу за каждый год. 
# Примечание: для средней зарплаты отдела X в году Y нам нужно взять среднее значение всех зарплат в году Y сотрудников,
# которые были в отделе X в году Y.

select year(sl.to_date) as years, 
       de.dept_no,
       round(avg(sl.salary)) as avg_emp_sal
from salaries as sl
inner join dept_emp as de
on sl.emp_no = de.emp_no
group by de.dept_no, year(sl.to_date)
order by 1;

# 4. Покажите для каждого года самый крупный отдел (по количеству сотрудников) в этом году и его среднюю зарплату.

select t1.*,
       first_value (t1.cnt_emp) over (partition by t1.years order by t1.cnt_emp desc) as largest_numb_emp,
       first_value (t1.dept_name) over (partition by t1.years order by t1.cnt_emp desc) as largest_department
from (select year(de.from_date) as years,
             de.dept_no, 
             dp.dept_name,
			 count(de.emp_no) as cnt_emp,
			 round(avg(sl.salary)) as avg_sal
		from dept_emp as de
		inner join salaries as sl
		on de.emp_no = sl.emp_no
        inner join departments as dp
        on de.dept_no = dp.dept_no
		group by year(de.from_date), de.dept_no) as t1
order by 1;

# 5.Покажите подробную информацию о менеджере, который дольше всех исполняет свои обязанности на данный момент

select em.emp_no, 
       em.birth_date, 
       em.first_name, 
       em.last_name, 
       em.gender, 
       em.hire_date
from employees as em
where em.emp_no =(select dm.emp_no
				  from dept_manager as dm
				  where dm.from_date = (select min(dm.from_date)
										from dept_manager as dm
										where dm.to_date >= now()));
                                        
# 6. Покажите топ-10 нынешних сотрудников компании с наибольшей разницей между их зарплатой и текущей средней зарплатой в их отделе.

with cte_avg_sal as (select round(avg(salary)) as avg_dept_sal, de.dept_no 
                     from salaries as sl 
                     inner join dept_emp as de 
                     on sl.emp_no = de.emp_no
	                 where sl.to_date >= now() 
                     and de.to_date >= now() 
                     group by de.dept_no)

select de2.dept_no,
       sl2.emp_no,
       sl2.salary,
       cte_avg_sal.avg_dept_sal,
       (sl2.salary
       -
       cte_avg_sal.avg_dept_sal) as dif_salary
from salaries as sl2
inner join dept_emp as de2
on sl2.emp_no = de2.emp_no
inner join cte_avg_sal
on de2.dept_no = cte_avg_sal.dept_no
where de2.to_date >= now()
and sl2.to_date >= now()
order by 5 desc
limit 10;

# 7. Из-за кризиса на одно подразделение на своевременную выплату зарплаты выделяется всего 500 тысяч долларов. 
# Правление решило, что низкооплачиваемые сотрудники будут первыми получать зарплату. 
# Показать список всех сотрудников, которые будут вовремя получать зарплату (обратите внимание, что мы должны платить зарплату за 
# один месяц, но в базе данных мы храним годовые суммы).

select *
from	(select sl.emp_no,
			   sl.salary,
			   de.dept_no,
			   sum((sl.salary / 12)) over (partition by de.dept_no order by salary) as sal_sum
		from salaries as sl
		inner join dept_emp as de
		on sl.emp_no = de.emp_no
		where sl.to_date >= now()
		and de.to_date >= now()) as t1
where t1.sal_sum < 500000;

# Дизайн базы данных:
# 1.Разработайте базу данных для управления курсами. База данных содержит следующие сущности:
# a.students: student_no, teacher_no, course_no, student_name, email, birth_date.
# b.teachers: teacher_no, teacher_name, phone_no
# c.courses: course_no, course_name, start_date, end_date.
# ●Секционировать по годам, таблицу students по полю birth_date с помощью механизма range
# ●В таблице students сделать первичный ключ в сочетании двух полей student_no и birth_date
# ●Создать индекс по полю students.email
# ●Создать уникальный индекс по полю teachers.phone_no

create database courses;

create table students (
student_no int,
teacher_no int not null,
course_no int not null,
student_name varchar(100) not null,
email varchar (255),
birth_date date,
primary key (student_no, birth_date))
partition by range columns (birth_date) 
(partition p01 values less than ('1986-01-01'),
 partition p02 values less than ('1987-01-01'),
 partition p03 values less than ('1988-01-01'),
 partition p04 values less than ('1989-01-01'),
 partition p05 values less than ('1990-01-01'),
 partition p06 values less than ('1991-01-01'),
 partition p07 values less than ('1992-01-01'),
 partition p08 values less than ('1993-01-01'),
 partition p09 values less than ('1994-01-01'),
 partition p10 values less than ('1995-01-01'),
 partition p11 values less than ('1996-01-01'),
 partition p12 values less than ('1997-01-01'),
 partition p13 values less than ('1998-01-01'),
 partition p14 values less than ('1999-01-01'),
 partition p15 values less than ('2000-01-01'),
 partition p16 values less than ('2001-01-01'),
 partition p17 values less than ('2002-01-01'),
 partition p18 values less than('2003-01-01'),
 partition p19 values less than ('2004-01-01'),
 partition p20 values less than ('2005-01-01'), 
 partition pmax values less than (MAXVALUE) );

create index idx_email on students(email);

create table teachers (
teacher_no int not null,
teacher_name varchar(100) not null,
phone_no varchar(13));

create unique index idx_phone_no on teachers(phone_no);

create table courses (
course_no int not null,
course_name varchar (15) not null,
start_date date, 
end_date date);

# 2.На свое усмотрение добавить тестовые данные (7-10 строк) в наши три таблицы.

insert into students (student_no, teacher_no, course_no, student_name, email, birth_date)
values ( 10001, 001, 3, 'Kucherenko Oleksandr', 'kucherenko@gmail.com', str_to_date('03/11/1994','%d/%m/%Y')),
       ( 10002, 003, 1, 'Momot Tania', 'momot@gmail.com', str_to_date('08/07/1988','%d/%m/%Y')), 
	   ( 10003, 002, 2, 'Trigub Alla', 'trigub@gmail.com', str_to_date('13/08/1987','%d/%m/%Y')),
       ( 10004, 003, 1, 'Bondar Nelia', 'bondar@gmail.com', str_to_date('21/03/1982','%d/%m/%Y')),
       ( 10005, 001, 3, 'Polonska Katherina', 'polonska@gmail.com', str_to_date('25/11/1998','%d/%m/%Y')),
       ( 10006, 002, 2, 'Voitenko Mihail', 'voitenko@gmail.com', str_to_date('01/02/2003','%d/%m/%Y')),
       ( 10007, 001, 3, 'Makovskiy Daniil', 'makovskiyo@gmail.com', str_to_date('05/06/2005','%d/%m/%Y')),
       ( 10008, 003, 1, 'Rak Anna', 'rak@gmail.com', str_to_date('21/03/1989','%d/%m/%Y')),
       ( 10009, 002, 2, 'Makovska Nataliia', 'makovska@gmail.com', str_to_date('28/07/1990','%d/%m/%Y')),
       ( 10010, 001, 3, 'Petrash Diana', 'petrash@gmail.com', str_to_date('03/12/1997','%d/%m/%Y'));
       
 insert into teachers (teacher_no, teacher_name, phone_no)
 values (1, 'Stankevich Anna', '380975543130'),
        (2, 'Syshko Vladimir', '380667775533'),
        (3, 'Melnuk Mihail', '380930015345'),
		(4, 'Melnuk Nataliia', '380930015348'),
        (5, 'Makovskiy Vladislav', '380963022948'),
        (6, 'Zolotova Anna', '380970217335'),
        (7, 'Teslia Andriy', '380670226396');
       
       
insert into courses (course_no, course_name, start_date, end_date)
values (1, 'BI_1', str_to_date('14/05/2021','%d/%m/%Y'), str_to_date('30/10/2021','%d/%m/%Y')),
       (2, 'BI_2', str_to_date('24/06/2021','%d/%m/%Y'), str_to_date('29/11/2021','%d/%m/%Y')),
       (3, 'BI_3', str_to_date('01/07/2021','%d/%m/%Y'), str_to_date('30/12/2021','%d/%m/%Y')),
       (4, 'BI_4', str_to_date('01/08/2021','%d/%m/%Y'), str_to_date('31/01/2022','%d/%m/%Y')),
       (5, 'BI_5', str_to_date('15/09/2021','%d/%m/%Y'), str_to_date('28/02/2022','%d/%m/%Y')),
       (6, 'BI_6', str_to_date('15/10/2021','%d/%m/%Y'), str_to_date('15/03/2022','%d/%m/%Y')),
       (7, 'BI_7', str_to_date('01/12/2021','%d/%m/%Y'), str_to_date('05/05/2022','%d/%m/%Y'));
       
# 3.Отобразить данные за любой год из таблицы students и зафиксировать в виду комментария план выполнения запроса, 
# где будет видно что запрос будет выполняться по конкретной секции.

explain
select *
from students 
where birth_date between '1998-01-01' and '1998-12-31';

/*# id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered,  Extra
    '1', 'SIMPLE', 'students', 'p14',   'ALL', NULL,         NULL, NULL,   NULL, '1', '100.00', 'Using where'*/

# 4.Отобразить данные учителя, по любому одному номеру телефона и зафиксировать план выполнения запроса, 
# где будет видно, что запрос будет выполняться по индексу, а не методом ALL. 
# Далее индекс из поля teachers.phone_no сделать невидимым и зафиксировать план выполнения запроса,
# где ожидаемый результат -метод ALL. В итоге индекс оставить в статусе -видимый. 

explain
select *
from teachers 
where phone_no = '380975543130';

/*# id, select_type, table,  partitions, type, possible_keys,     key,      key_len, ref,   rows, filtered, Extra
   '1', 'SIMPLE',   'teachers', NULL,  'const','idx_phone_no','idx_phone_no', '55', 'const', '1', '100.00', NULL*/
   
alter table teachers
alter index idx_phone_no invisible;

/*# id, select_type, table,  partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
    '1', 'SIMPLE', 'teachers',  NULL,    'ALL',    NULL,      NULL, NULL,   NULL, '7', '14.29', 'Using where'*/
 
alter table teachers
alter index idx_phone_no visible;

# 5.Специально сделаем 3 дубляжа в таблице students (добавим еще 3 одинаковые строки).

insert into students (student_no, teacher_no, course_no, student_name, email, birth_date)
select  10011, 003, 1, 'Doloban Irina', 'dolobani@gmail.com', str_to_date('06/06/1988','%d/%m/%Y')
union
select  10012, 003, 1, 'Doloban Irina', 'dolobani@gmail.com', str_to_date('06/06/1988','%d/%m/%Y')
union
select  10013, 003, 1, 'Doloban Irina', 'dolobani@gmail.com', str_to_date('06/06/1988','%d/%m/%Y');

# 6.Написать запрос, который выводит строки с дубляжами

select *
from students as st2
where st2.email = (	select t1.email
					from ( select  count(st.student_no) as cnt_stud_no, 
								   st.student_name, 
								   st.email
							from students st
							group by st.email
							having count(student_no) >1) as t1);

