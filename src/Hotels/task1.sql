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
hotel_names as (
	select
		c.id_customer, STRING_AGG(distinct h.name, ', ') as hotels
	from
		customer c
	join booking b on
		b.id_customer = c.id_customer
	join room r on
		r.id_room = b.id_room
	join hotel h on
		h.id_hotel = r.id_hotel
	group by
		c.id_customer
),
avg_dates as (
	select
		c.id_customer, avg(b.check_out_date - b.check_in_date) as avg_count
	from
		customer c
	join booking b on
		b.id_customer = c.id_customer
	group by
		c.id_customer
)
select
	distinct c."name",
	c.email,
	c.phone,
	booked_hotels.booking_count,
	hotel_names.hotels,
	avg_dates.avg_count
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
join hotel_names on hotel_names.id_customer = c.id_customer
join avg_dates on avg_dates.id_customer = c.id_customer
where hotel_count > 1 and booking_count > 2
order by booking_count desc
