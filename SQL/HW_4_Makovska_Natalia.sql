# 1.Показать для каждого сотрудника его текущую зарплату и текущую зарплату текущего руководителя.

select sl.emp_no as employees, sl.salary as current_salary, 
	   de.dept_no as departments, dm.emp_no as manager, 
       sal.salary as current_manag_salary
from salaries as sl
inner join dept_emp as de
on sl.emp_no = de.emp_no
inner join dept_manager as dm
on de.dept_no = dm.dept_no
inner join salaries as sal
on sal.emp_no = dm.emp_no
where sl.to_date >= now()
and de.to_date >= now()
and dm.to_date >= now()
and sal.to_date >= now();

# 2.Показать всех сотрудников, которые в настоящее время зарабатывают больше,чем их руководители

select sl.emp_no as employees, sl.salary as current_salary, 
	   de.dept_no as departments, dm.emp_no as manager, 
       sal.salary as current_manag_salary
from salaries as sl
inner join dept_emp as de
on sl.emp_no = de.emp_no
inner join dept_manager as dm
on de.dept_no = dm.dept_no
inner join salaries as sal
on sal.emp_no = dm.emp_no
where sl.to_date >= now()
and de.to_date >= now()
and dm.to_date >= now()
and sal.to_date >= now()
and sl.salary > sal.salary
order by 2 desc ;

# 3. Из таблицы dept_manager первым запросом выбрать данные по актуальным менеджерам департаментов и сделать свой столбец “checks” 
#    со значением ‘actual’.Вторым запросом из этой же таблицы dept_manager выбрать НЕ актуальных менеджеров департаментов
#    и сделать свой столбец “checks”со значением ‘old’.Объединить результат двух запросов через union

Select dm.*, 'actual' as checks
from dept_manager as dm
where dm.to_date >= now()

union

Select dm.*, 'old' as checks
from dept_manager as dm
where dm.to_date < now()
;

# 4. К результату всех строк таблицы departments, добавить еще две строки со значениями “d010”, “d011” для dept_no 
#    и “Data Base”,“Help Desk” для dept_name.

select *
from departments as dp

union

select 'd010', 'Data Base'

union

select 'd011', 'Help Desk';

# 5. Найти emp_no актуального менеджера из департамента ‘d003’, далее через подзапрос из таблицы сотрудников вывести по нему информацию.

select *
from employees as em
where em.emp_no = ( select dm.emp_no
					from dept_manager as dm
					where dm.dept_no = 'd003' 
					and dm.to_date >=now());

# 6. Найти максимальную дату приема на работу, далее через подзапрос из таблицы сотрудников вывести по этой дате информацию по сотрудникам.

select *
from employees as em
where em. hire_date = ( select max(em.hire_date) as max_hire_date
                        from employees as em);
								




