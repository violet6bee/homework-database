with booked_hotels as (
select
		c.id_customer,
		count(distinct hotel.id_hotel) as hotel_count,
		count(b.id_booking) as booking_count
from
		customer c
join booking b on
		b.id_customer = c.id_customer
join room on
		room.id_room = b.id_room
join hotel on
		hotel.id_hotel = room.id_hotel
group by
		c.id_customer
),
spent as (
	select
		c.id_customer,
		sum(r.price * (b.check_out_date - b.check_in_date)) as total_spent
	from
		customer c
	join booking b on
		b.id_customer = c.id_customer
	join room r on
		r.id_room = b.id_room
	where (r.price * (b.check_out_date - b.check_in_date)) > 500
	group by c.id_customer
),
unique_hotels as (
	select
		c.id_customer, count(distinct r.id_hotel) as unique_hotel
	from
		customer c
	join booking b on
		b.id_customer = c.id_customer
	join room r on
		r.id_room = b.id_room
	group by
		c.id_customer
)
select
	c.id_customer,
	c."name",
	booked_hotels.booking_count as total_bookings,
	spent.total_spent,
	unique_hotels.unique_hotel
from
	customer c
join booked_hotels on
	booked_hotels.id_customer = c.id_customer
join booking b on
	b.id_customer = c.id_customer
join room r on
	r.id_room = b.id_room
join hotel h on
	h.id_hotel = r.id_hotel
join spent on spent.id_customer = c.id_customer
join unique_hotels on unique_hotels.id_customer = c.id_customer
where hotel_count > 1 and booking_count > 2
group by c.id_customer, total_bookings, unique_hotels.unique_hotel, spent.total_spent
order by spent.total_spent

