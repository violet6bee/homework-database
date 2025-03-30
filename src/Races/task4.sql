select
	cars."name" as car_name,
	cars."class" as car_class,
	avg_pos.average_position as average_position,
	race_count.race_count,
	classes.country as car_country
from cars
join classes on classes."class" = cars."class"
join results on results.car = cars."name"
join (
	select
		cars."name" as car_name,
		cars."class" as car_class,
		avg(results."position") as average_position
	from cars
	join classes on classes."class" = cars."class"
	join results on results.car = cars."name"
	group by car_name, car_class
) as avg_pos on avg_pos.car_name = cars."name"
join (
	select cars_average_position.car_class as car_class, min(cars_average_position.average_position) as best_average_position from (
		select
			cars."name" as car_name,
			cars."class" as car_class,
			avg(results."position") as average_position
		from cars
		join classes on classes."class" = cars."class"
		join results on results.car = cars."name"
		group by cars."class", cars."name"
		order by average_position, car_name
	) cars_average_position
	group by car_class
) best_average_position on best_average_position.best_average_position = avg_pos.average_position and cars."class" = best_average_position.car_class
join (
	select
		cars."name" as car_name,
		count(results.*) as race_count
	from cars
	join classes on classes."class" = cars."class"
	join results on results.car = cars."name"
	group by cars."name"
) race_count on race_count.car_name = cars."name"
where cars."class" in (
	select car_class from (
		select cars."class" as car_class, count(cars."name") as car_count from cars
		group by car_class
		having count(cars."name") > 1
	)
)
order by cars."class", avg_pos.average_position