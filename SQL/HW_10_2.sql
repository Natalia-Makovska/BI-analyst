/*2.Создать функцию, которая выводила бы текущую зарплату по сотруднику*/

delimiter //

create function get_current_salary_emp (p_emp_no int)
returns int deterministic

begin

declare v_salary int;

select sl.salary
into v_salary
from salaries as sl
where sl.to_date >= now()
and sl.emp_no = p_emp_no;

return v_salary;

end; //

select get_current_salary_emp(10001); -- 88958


