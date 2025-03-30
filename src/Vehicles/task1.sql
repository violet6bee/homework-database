select
vehicle.maker, motorcycle.model
from
motorcycle
join vehicle on vehicle.model = motorcycle.model
where horsepower > 150 and price < 20000 and motorcycle.type = 'Sport'
order by horsepower desc;