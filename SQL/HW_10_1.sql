/*1. Создать процедуру для увольнения сотрудника, закрытия исторических записей в таблицах dept_emp, salaries и titles. 
Если передан несуществующий номер сотрудника, тогда показать ошибку с нужным текстом */

delimiter //

create procedure released_emp (in p_emp_no int)

begin 

if p_emp_no not in (select em.emp_no from employees as em)  THEN
SIGNAL SQLSTATE '45000' 
SET MESSAGE_TEXT ='НЕДОПУСТИМОЕ ЗНАЧЕНИЕ ДЛЯ НОМЕРА СОТРУДНИКА';
END IF;

update titles
set to_date = current_date()
where emp_no = p_emp_no;

update salaries
set to_date = current_date()
where emp_no = p_emp_no;

update dept_emp
set to_date = current_date()
where emp_no = p_emp_no;

end //


call released_emp(500000);

call released_emp(500001);

/*Error Code: 1644. НЕДОПУСТИМОЕ ЗНАЧЕНИЕ ДЛЯ НОМЕРА СОТРУДНИКА*/


