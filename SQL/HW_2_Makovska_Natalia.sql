# Select the names of all departments whose department number value is not null and names have ‘a’ character on any position 
# or ‘e’ on the second place

select *
from departments as dp
where dp.dept_no is not null
and (dp.dept_name like '%a%'
or dp.dept_name like '_e%');

# Show employees who satisfy the following description:He was 45 when hired, born in October and was hired on Sunday.

select em.first_name, em.last_name, em.birth_date, em.hire_date,
       timestampdiff(YEAR,em.birth_date,em.hire_date) AS age,
       dayname(em.hire_date) as day_of_name,
       monthname(em.birth_date) as month_born
from employees as em
where timestampdiff(YEAR,em.birth_date,em.hire_date) = 45
and dayname(em.hire_date) = 'Sunday'
and monthname(em.birth_date) = 'October';

# Show the maximum annual salary in the company after 01/06/1995.

select sl.*, max(sl.salary) as maximum_sl
from salaries as sl
where STR_TO_DATE('01-06-1995', '%m-%d-%Y')
group by sl.from_date
order by max(sl.salary) desc;

# In the dept_emp table, show the quantity of employees by department (dept_no).To_date must be greater than current_date. 
# Show departments with more than 13,000 employees. Sort by quantity of employees.

select dp.dept_no, count(dp.emp_no) as quantity_of_emp
from dept_emp as dp
where to_date > now()
group by dp.dept_no
having count(dp.emp_no) >= 13000
order by count(dp.emp_no);

# Show the minimum and maximum salaries by employee.Also show the quantity of salary changes.

select sl.*, min(sl.salary) as min_sl, max(sl.salary) as max_sl, count(sl.emp_no) as quant_sl_changes
from salaries as sl
group by sl.emp_no;

# Show employees who were hired in 1985. Display the quantity of employees by day(hint: use function - dayname).

select em.emp_no, em.first_name, em.last_name, year(em.hire_date), dayname(em.hire_date) as day_of_name
from employees as em
where year(em.hire_date) = 1985;

select dayname(em.hire_date) as day_of_name, count(em.emp_no) as cnt_empl
from employees em
where year(em.hire_date) = 1985
group by dayname(em.hire_date);

