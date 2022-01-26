# Вывести все данные из таблицы employees и добавить поле зарплаты из таблицы salaries(нужна текущая ЗП).
# Отсортировать по дате приема на работу

select em.*, sl.salary
from employees as em
inner join salaries as sl
on em.emp_no = sl.emp_no
where sl.to_date > now()
order by em.hire_date;

# Вывести данные по имени,фамилии,дате приема на работу и текущую название должности.Отобразить только тех,кто пришел 1995,1996 и 1997году.
# Отсортировать по имени

select em.first_name, em.last_name, em.hire_date, tt.title
from employees as em
inner join titles as tt
on em.emp_no = tt.emp_no
where tt.to_date > now()
and (year(em.hire_date) = '1985' or year(em.hire_date) = '1996' or year(em.hire_date) = '1997')
order by em.first_name;

# Вывести данные по имени,фамилии,дате приема на работу и актуальное название департамента для каждого сотрудника.
# Исключить из выборки департамент‘Sales’.Отсортировать по названию департамента.

select em.first_name, em.last_name, em.hire_date, dp.dept_name
from employees as em
inner join dept_emp as de
on em.emp_no = de.emp_no
inner join departments as dp
on de.dept_no = dp.dept_no
where de.to_date > now()
and dp.dept_name not like 'Sales'
order by dp.dept_name;

# Отобразить текущую суммарную зарплату и количество сотрудников в разрезе названий должностей.Отсортировать по зарплате

select tt.title, sum(sl.salary) as sum_salary, count(sl.emp_no) as cnt_empl
from salaries as sl
inner join titles as tt
on sl.emp_no = tt.emp_no
where sl.to_date > now()
and tt.to_date > now()
group by tt.title
order by 2;

# Отобразить текущую суммарную зарплату и количество сотрудников в разрезе названий департамента.Отсортировать по зарплате.

select dep.dept_name, (sl.salary) as sum_salary, count(sl.emp_no) as cnt_empl
from salaries as sl
inner join dept_emp as dp
on sl.emp_no = dp.emp_no
inner join departments as dep
on dp.dept_no = dep.dept_no
where sl.to_date > now()
and dp.to_date > now()
group by dep.dept_name
order by 2;


