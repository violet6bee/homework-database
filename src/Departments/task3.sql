with recursive employee_hierarchy AS (
  select e.employeeid, e.managerid
  from employees e
  union all
  select
  	e.employeeid,
  	e.managerid
  from employees e
  join employee_hierarchy e_h on e.employeeid = e_h.managerid
),
subordinates as (
	SELECT employeeid, count(*) - 1 as total
	from employee_hierarchy
	group by employeeid
),
employee_projects as (
	select
		e.employeeid as employeeid,
		STRING_AGG(DISTINCT p.projectname, ', ') AS projects
	from employees e
	join projects p on p.departmentid = e.departmentid
	group by e.employeeid
),
employee_tasks as (
	select
		e.employeeid as employeeid,
		STRING_AGG(DISTINCT t.taskname, ', ') AS tasks,
		count(t.*) as task_num
	from employees e
	join tasks t on t.assignedto = e.employeeid
	join projects p on t.projectid = p.projectid
	group by e.employeeid
)
select
	e.employeeid as EmployeeID,
	e."name" as EmployeeName,
	e.managerid as ManagerID,
	d.departmentname as DepartmentName,
	r.rolename as RoleName,
	e_p.projects as ProjectNames,
	e_t.tasks as TaskNames,
	s.total as TotalSubordinates
from employees e
join departments d on e.departmentid = d.departmentid
join roles r on r.roleid = e.roleid
left join employee_projects e_p on e_p.employeeid = e.employeeid
left join employee_tasks e_t on e_t.employeeid = e.employeeid
left join subordinates s on s.employeeid = e.employeeid
where s.total > 0 and r.rolename = 'Менеджер'
order by e."name"