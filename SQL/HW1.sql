select*
from employees as em
where em.gender = 'F' 
and em.hire_date = '1990.01.01' or em.hire_date = '2000.01.01';

select*
from employees as em 
where (em.first_name = em.last_name)
and (em.first_name like '%ri%'or em.last_name like '%ri%')
and (em.first_name not like 'E%' or em.last_name not like 'E%');

select em.emp_no, em.first_name, em.last_name, em.gender, em.hire_date
from employees as em
where em.emp_no between 10001 and 10004;






