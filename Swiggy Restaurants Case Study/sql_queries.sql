use swiggy;

select * from swiggy;

-- HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?

select count(*) as high_rated_restaurants 
from swiggy 
where rating>4.5;

-- WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?

select city,count(distinct restaurant_name) 
as restaurant_count from swiggy
group by city
order by restaurant_count desc
limit 1;

-- RESTAURANTS HAVE THE WORD "PIZZA" IN THEIR NAME?

select distinct restaurant_name as pizza_restaurants
from swiggy 
where restaurant_name like '%Pizza%';

-- WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS?

select cuisine,count(*) as cuisine_count
from swiggy
group by cuisine
order by cuisine_count desc
limit 1;

-- WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?

select city, avg(rating) as average_rating
from swiggy group by city;

-- FIND TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE

select distinct restaurant_name,city,cost_per_person 
from swiggy 
where cuisine<>'Indian' 
order by cost_per_person desc 
limit 5;


-- TOP 5 MOST EXPENSIVE  RESTAURANTS WITH THEIR RATINGS

select distinct(restaurant_name),cost_per_person,rating
from swiggy
order by cost_per_person desc
limit 5;

-- RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE LOCATED IN DIFFERENT CITIES.


select distinct t1.restaurant_name,t1.city,t2.city 
from swiggy t1 join swiggy t2 
on t1.restaurant_name=t2.restaurant_name and
t1.city<>t2.city;


-- WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE' CATEGORY?

select restaurant_name,count(item) as no_of_items
from swiggy
where menu_category='Main Course'
group by restaurant_name 
order by  no_of_items desc
limit 1;

-- COUNT THE NUMBER  OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME.

select count(*)
from (
select distinct restaurant_name,
(count(case when veg_or_non_veg='Veg' then 1 end)*100/
count(*)) as vegetarian_percetage
from swiggy
group by restaurant_name
having vegetarian_percetage=100.00
order by restaurant_name) as t;

-- WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?

select distinct restaurant_name, count(distinct menu_category) as no_of_categories
from swiggy
group by restaurant_name
order by no_of_categories desc
limit 5;

-- WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?

select distinct restaurant_name,
(count(case when veg_or_non_veg='Non-veg' then 1 end)*100
/count(*)) as nonvegetarian_percentage
from swiggy
group by restaurant_name
order by nonvegetarian_percentage desc limit 1;
