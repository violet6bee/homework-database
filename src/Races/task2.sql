select
car as car_name, classes."class" as car_class,
avg(position) as average_position, count(results.race) as race_count,
classes.country as car_country
from
results
join cars on cars.name = results.car
join classes on classes."class" = cars."class"
group by car, classes."class"
order by avg(position) asc, results.car asc
limit 1