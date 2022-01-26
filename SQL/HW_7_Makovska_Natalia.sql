# 1.  В схеме tempdb создать секционированную таблицу dept_emp, секционировать по полю from_date. 
# Взять DDL код (из “Table inspector”) по созданию таблицы dept_emp их схемы employees. 
# Убрать из DDL кода упоминанию про KEY и CONSTRAINT и добавить код для секционирования по полю from_date с 1985 года до 2004.

CREATE TABLE dept_emp (
  emp_no int NOT NULL,
  dept_no char(4) NOT NULL,
  from_date date NOT NULL,
  to_date date NOT NULL) 
  ENGINE=InnoDB 
  partition by range columns(from_date)
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
 partition p18 values less than ('2003-01-01'), 
 partition p19 values less than ('2004-01-01'),
 partition p20 values less than ('2005-01-01'));

# 2.  Создать индекс на таблицу tempdb.dept_emp по полю dept_no.

create index idx_dept_no on dept_emp(dept_no);

# 3.  По таблице tempdb.dept_emp отобрать данные только за 1990 год.

insert into tempdb.dept_emp
select *
from employees.dept_emp;

commit;

select *
from tempdb.dept_emp as tde
where tde.from_date between '1990-01-01' and '1990-12-31'
order by 3;

# 4.  На основе предыдущего задания, через explain убедиться что сканирование данных идет только по одной секции. 
# зафиксировать в виде комментария через/* вывод из explain */.

explain
select *
from tempdb.dept_emp as tde
where tde.from_date between '1990-01-01' and '1990-12-31'
order by 3;

/* id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
   1      SIMPLE    tde	     p06	   ALL	    			                   20963	11.11	Using where; Using filesort*/

# 5.  Загрузить свой любой CSV файл в схему tempdb (задание не обязательное).

create table exp_budget
(begining_of_period date,
periodicity varchar(50) not null,
budget_code int not null,
amount int,
curreny varchar (10));

select *
from tempdb.exp_budget;

alter table exp_budget rename column curreny to currency;




