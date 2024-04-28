use oyo;

select * from city_hotels;

select * from oyo_bookings;

-- change columns to date type

UPDATE oyo_bookings
SET date_of_booking = STR_TO_DATE(date_of_booking, '%d-%m-%Y');

ALTER TABLE oyo_bookings
MODIFY COLUMN date_of_booking DATE NULL DEFAULT NULL;

UPDATE oyo_bookings
SET check_in = STR_TO_DATE(check_in, '%d-%m-%Y');

ALTER TABLE oyo_bookings
MODIFY COLUMN check_in DATE NULL DEFAULT NULL;

UPDATE oyo_bookings
SET check_out = STR_TO_DATE(check_out, '%d-%m-%Y');

ALTER TABLE oyo_bookings
MODIFY COLUMN check_out DATE NULL DEFAULT NULL;

-- How many bookings have been made in total?

select count(*) from oyo_bookings;

-- How many hotels are their in different cities

select City,count(*) as number_of_hotels from city_hotels group by City;

-- What is the distribution of booking statuses?

select status,count(*) from oyo_bookings group by status;

-- Top 5 hotels which has  highest number of bookings?

select City,count(*) as total_bookings 
from oyo_bookings join city_hotels 
on city_hotels.hotel_id=oyo_bookings.hotel_id 
group by City 
order by total_bookings desc limit 5;


-- On which days of the week do most check-ins occur?

select dayname(check_in) as week_day ,count(*) as checkin_count
from oyo_bookings 
group by week_day
ORDER BY FIELD(week_day, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');

--  What is the average discount percentage offered on bookings?

SELECT AVG(discount / amount * 100) AS avg_discount_percentage FROM oyo_bookings WHERE discount > 0;

-- Top 5 Loyalty customers

SELECT customer_id, COUNT(*) AS booking_count FROM oyo_bookings where status='Stayed' GROUP BY customer_id order by booking_count desc limit 5;

-- top 5 longest stayed customers

select customer_id,DATEDIFF(check_out, check_in) AS days_stay from oyo_bookings where status='Stayed'  order by days_stay desc limit 5;


-- Monthly wise booking count

select month(date_of_booking) as months,count(*) as total_bookings 
from oyo_bookings 
group by months;

-- Calculate the cancellation rate by cities
SELECT 
    ch.City, 
    COUNT(*) AS total_bookings,
    SUM(CASE WHEN ob.status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_bookings,
    (SUM(CASE WHEN ob.status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS cancellation_rate
FROM  oyo_bookings ob
JOIN  city_hotels ch ON ob.hotel_id = ch.Hotel_id
GROUP BY ch.City;

-- Revenue collected by each city

SELECT ch.City, 
    SUM(CASE 
            WHEN ob.discount >= ob.amount THEN 0  -- If discount is greater than or equal to the total amount, no revenue
            ELSE ob.no_of_rooms * (ob.amount - ob.discount)
        END) AS revenue
FROM oyo_bookings ob
JOIN city_hotels ch ON ob.hotel_id = ch.Hotel_id
where status='Stayed'
GROUP BY ch.City;

-- Revenue genrated till now

SELECT SUM(revenue) AS total_revenue_generated
FROM (
    SELECT 
        ch.City, 
        SUM(CASE 
                WHEN ob.discount >= ob.amount THEN 0  -- If discount is greater than or equal to the total amount, no revenue
                ELSE ob.no_of_rooms * (ob.amount - ob.discount)
            END) AS revenue
    FROM 
        oyo_bookings ob
    JOIN 
        city_hotels ch ON ob.hotel_id = ch.Hotel_id
    WHERE 
        status = 'Stayed'
    GROUP BY 
        ch.City
) AS revenue_by_city;







