with average_price as (
	select h.id_hotel as id_hotel, avg(r.price) as price from hotel h
	join room r on r.id_hotel = h.id_hotel
	group by h.id_hotel
),
hotel_category as (
	select
		h.id_hotel,
		case
			when a.price < 175 then 1
			when a.price < 300 then 2
			else 3
		end as category
	from hotel h
	join average_price a on a.id_hotel = h.id_hotel
),
customer_category as (
	select
		c.id_customer as id_customer,
		max(h_c.category) as category
	from customer c
	join booking b on b.id_customer = c.id_customer
	join room r on r.id_room = b.id_room
	join hotel h on h.id_hotel = r.id_hotel
	join hotel_category h_c on h_c.id_hotel = h.id_hotel
	group by c.id_customer
),
booking_hotels as (
	select c.id_customer as id_customer, STRING_AGG(DISTINCT h.name, ', ') AS hotels
	from customer c
	join booking b on b.id_customer = c.id_customer
	join room r on r.id_room = b.id_room
	join hotel h on h.id_hotel = r.id_hotel
	group by c.id_customer
)
select
	c.id_customer,
	c.name,
	case
		when c_c.category = 1 then 'Дешевый'
		when c_c.category = 2 then 'Средний'
		else 'Дорогой'
	end	as preferred_hotel_type,
	b_h.hotels
from customer c
join customer_category c_c on c_c.id_customer = c.id_customer
join booking_hotels b_h on b_h.id_customer = c.id_customer
order by c_c.category