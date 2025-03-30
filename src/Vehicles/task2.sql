select *
from
(select
vehicle.maker, vehicle.type, tmp.horsepower, tmp.engine_capacity
from vehicle
join(
select
car.horsepower, car.engine_capacity, car.price, car.model
from car
join vehicle on vehicle.model = car.model
where car.horsepower > 150 and car.engine_capacity < 3 and car.price < 35000
union
select
motorcycle.horsepower, motorcycle.engine_capacity, motorcycle.price, motorcycle.model
from motorcycle
join vehicle on vehicle.model = motorcycle.model
where motorcycle.horsepower > 150 and motorcycle.engine_capacity < 1.5
and motorcycle.price < 20000)
as tmp on tmp.model = vehicle.model
union
select
vehicle.maker, bicycle.type, null as horsepower, null as engine_capacity
from bicycle
join vehicle on vehicle.model = bicycle.model
where bicycle.gear_count > 18 and bicycle.price < 4000)
order by horsepower desc nulls last