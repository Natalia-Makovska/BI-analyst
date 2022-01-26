# 1.  Отобразить сотрудников и напротив каждого, показать информацию о разнице текущей и первой зарплате.

select emp_no, salary, from_date, to_date, first_emp_sal, salary - first_emp_sal as dif_sal
from ( select sl.emp_no, 
			   sl.salary, 
			   sl.from_date, 
			   sl.to_date, 
			   first_value(sl.salary) over (partition by emp_no order by salary) as first_emp_sal
		from salaries as sl) as t1
where to_date >= now();


# 2.  Отобразить департаменты и сотрудников, которые получают наивысшую зарплату в своем департаменте.

select sl.emp_no,
       concat(em.first_name,' ',em.last_name) as full_name,
       sl.salary,
       dp.dept_name,
       first_value(sl.salary) over (partition by dp.dept_name order by sl.salary desc) as max_dep_salary,
       first_value(concat(em.first_name,' ',em.last_name)) over (partition by dp.dept_name order by sl.salary desc) as highest_paid_empl
from salaries as sl
inner join dept_emp as de
on sl.emp_no = de.emp_no
inner join departments as dp
on de.dept_no = dp.dept_no
inner join employees as em
on sl.emp_no = em.emp_no
where sl.to_date >= now()
and de.to_date >= now();

# 3.  Из таблицы должностей, отобразить сотрудника с его текущей должностью и предыдущей.

select emp_no, title, from_date, to_date, prev_title
from (select tt.emp_no, 
			 tt.title, 
			 tt.from_date, 
			 tt.to_date,
			 lag (tt.title) over (partition by tt.emp_no order by tt.from_date) as prev_title
       from titles as tt) as t1
where to_date >= now();

# 4.  Из таблицы должностей, посчитать интервал в днях- сколько прошло времени от первой должности до текущей.

select emp_no, title, from_date, to_date, prev_title,
       datediff(to_date, from_date) as dif_day
from (select tt.emp_no, 
	         tt.title, 
	         tt.from_date, 
			 tt.to_date,
	         lag (tt.title) over (partition by tt.emp_no order by tt.from_date) as prev_title
     from titles as tt) as t1
where to_date <=now();

# 5.  Выбрать сотрудников и отобразить их рейтинг по году принятия на работу. Выбрать последнюю строку и записать в переменную 
# со значениеми з поля emp_no. Далее выбрать по значению из переменной информацию из таблиц должностей, зарплат и департаментов. 
# “Джоинить” по значению из переменной.

select em.emp_no, 
       em.birth_date, 
       em.first_name, 
       em.last_name, 
       em.gender, 
       year(em.hire_date) as hire_year,
       dense_rank() over (partition by year(em.hire_date) order by em.emp_no) as rating
from employees as em;

with cte_emp as (select * from employees as em where em.emp_no = 499553)
select cte.emp_no,
       cte.birth_date, 
       cte.first_name, 
       cte.last_name, 
       cte.gender, 
       cte.hire_date, 
       tt.title, 
       sl.salary, 
       de.dept_no,
       dp.dept_name
from cte_emp as cte
inner join titles as tt
on cte.emp_no = tt.emp_no
inner join salaries as sl
on cte.emp_no = sl.emp_no
inner join dept_emp as de
on cte.emp_no = de.emp_no
inner join departments as dp
on de.dept_no = dp.dept_no
where sl.to_date >= now()
and de.to_date >= now();


