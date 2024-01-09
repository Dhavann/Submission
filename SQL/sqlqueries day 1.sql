select * from Departments;
select * from Employees;

-- #3rd highest emp salary
with cte as(
select concat(e.EmpFName,' ',e.EmpLName) as EmpName, d.DeptName,e.Salary,
dense_rank() over(order by salary desc) as rn 
from Departments d join employees e
on d.deptcode = e.DEPTCODE
)
select EmpName,DeptName from cte where rn=3;

-- find duplicate

select empfname,emplname,job,manager,hiredate,salary,commission,deptcode from employees
group by 1,2,3,4,5,6,7,8 having count(*)>1;

-- delete duplicate

create table newemp select empcode,empfname,emplname,job,manager,hiredate,salary,commission,deptcode
from employees;

select * from newemp;

SET SQL_SAFE_UPDATES = 0;

delete a from newemp a inner join newemp b
where a.empcode > b.empcode and a.empfname=b.empfname and a.emplname=b.emplname and a.job=b.job and a.manager=b.manager and
a.hiredate=b.hiredate and a.salary=b.salary and a.commission=b.commission and a.deptcode=b.deptcode;


-- dept name with 2nd total highest salary
with cte as(
select d.deptname,sum(e.salary) as tot from employees e join departments d 
on e.DEPTCODE=d.DEPTCODE group by 1 having sum(e.salary)
)
select deptname,tot from cte order by tot desc limit 1 offset 1;


-- deptwise highest salary with employeee name

with cte as(
select d.deptname,concat(e.EmpFName,' ',e.EmpLName) as EmpName, e.salary,
dense_rank() over(partition by d.deptname order by e.salary desc ) as rn from departments d join employees e 
on d.deptcode=e.deptcode
)
select * from cte where rn=1;