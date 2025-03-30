select
	cars.name as car_name,
	cars.class as car_class,
	avg(results."position") as average_position,
	count(results.race) as race_count
from
	cars
join classes on
	classes."class" = cars."class"
join results on
	results.car = cars."name"
where
	(cars.class,
	results.car) in (
	select
		c2.class,
		(
		select
			r2.car
		from
			results r2
		join cars c3 on
			r2.car = c3.name
		where
			c3.class = c2.class
		group by
			r2.car
		order by
			AVG(r2.position) asc
		limit 1) as best_car
	from
		cars c2
	group by
		c2.class
)
group by
	cars.name,
	cars."class"
order by
	avg(results."position") asc