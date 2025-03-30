with recursive employee_hierarchy as (
	select e.employeeid as employeeid
	from employees e
	where e.employeeid = 1
	union all
	select e.employeeid from employees e
	join employee_hierarchy eh on e.managerid = eh.employeeid
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
),
subordinates as (
	select
		e.managerid as employeeid, count(e.employeeid) as total_subordinates
	from employees e
	group by e.managerid
)
select
	e.employeeid as EmployeeID,
	e."name" as EmployeeName,
	e.managerid as ManagerID,
	d.departmentname as DepartmentName,
	r.rolename as RoleName,
	e_p.projects as ProjectNames,
	e_t.tasks as TaskNames,
	coalesce(e_t.task_num, 0) as TotalTasks,
	coalesce(s.total_subordinates, 0) as TotalSubordinates
from employees e
join departments d on e.departmentid = d.departmentid
join roles r on r.roleid = e.roleid
left join employee_projects e_p on e_p.employeeid = e.employeeid
left join employee_tasks e_t on e_t.employeeid = e.employeeid
left join subordinates s on s.employeeid = e.employeeid
where e.employeeid in (select employeeid from employee_hierarchy)
order by e."name"