with average_position as (
	select c."class"  as car_class, c."name" as car_name, avg(r."position") as average_position from cars c
	join results r ON r.car = c."name"
	group by car_class, car_name
),
car_race_count as (
	select c."name" as car_name, count(r.*) as race_count from cars c
	join results r on r.car = c."name"
	group by car_name
),
class_race_count as (
	select c."class" as car_class, count(r.*) as race_count from cars c
	join results r on r.car = c."name"
	group by car_class
)
select
	a.car_name,
	a.car_class,
	a.average_position,
	c_r.race_count as race_count,
	cl.country as car_country,
	cl_r.race_count as total_races
from cars c
join average_position a on a.car_name = c."name"
join classes cl on c."class" = cl."class"
join results r on r.car = c."name"
join car_race_count c_r on c_r.car_name = c."name"
join class_race_count cl_r on cl_r.car_class = c."class"
where a.average_position > 3
order by total_races desc