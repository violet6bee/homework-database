select
	cars."name" as car_name,
	cars."class" as car_class,
	avg(results."position") as average_position,
	count(results.race) as race_count,
	classes.country as car_country,
	race_count.race_count
from classes
join cars on cars."class" = classes."class"
join results on results.car = cars."name"
join (
	select cars."class" as car_class, count(results.race) as race_count from classes
	join cars on cars."class" = classes."class"
	join results on results.car = cars."name"
	group by car_class
) race_count on race_count.car_class = cars.class
group by cars."name", cars."class", race_count.race_count, classes.country
having avg(results."position") = (
	select min(average_position) from (
		select cars."class" as car_class, avg(results."position") as average_position from classes
		join cars on cars."class" = classes."class"
		join results on results.car = cars."name"
		group by cars."class"
	)
)