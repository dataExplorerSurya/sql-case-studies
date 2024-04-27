use pizzahut;

show tables;

select * from order_details;

select * from orders;

select * from pizza_types;

select * from pizzas;

-- Calculate the total revenue generated from pizza sales.

select round(sum(order_details.quantity*pizzas.price),2) as total_revenu
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id;

-- Identify the highest-priced pizza.

select pizza_types.name , pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id =pizzas.pizza_type_id
order by pizzas.price desc
limit 1;


-- Identify the most common pizza size ordered.

select size,count(*) as order_count from order_details join pizzas on order_details.pizza_id=pizzas.pizza_id group by size;

-- List the top 5 most ordered pizza types along with their quantities.

select name,sum(quantity) as quantity_ordered
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on
order_details.pizza_id=pizzas.pizza_id 
group by name
order by quantity_ordered desc
limit 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.

select category , sum(quantity) as quantity_ordered 
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on
order_details.pizza_id=pizzas.pizza_id 
group by category;

-- Determine the distribution of orders by hour of the day.

select hour(time) as hour,count(order_id) as orders
from orders
group by hour
order by hour;

-- Join relevant tables to find the category-wise distribution of pizzas.

select category,count(name) as count 
from pizza_types
group by category;


-- Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(quantity) as avg_orders 
from(
select date, sum(quantity) as quantity
from orders join order_details
on orders.order_id=order_details.order_id
group by date) as order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.

select name,sum(price*quantity) as revenu 
from pizza_types join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id 
join order_details on order_details.pizza_id=pizzas.pizza_id 
group by name 
order by revenu desc 
limit 3;


-- Calculate the percentage contribution of each category to total revenue.

select category,round((sum(price*quantity)/(select round(sum(order_details.quantity*pizzas.price),2) as total_revenu
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id)*100),2) as percentage
from pizza_types join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id 
join order_details on order_details.pizza_id=pizzas.pizza_id 
group by category 
order by percentage desc ;

-- Analyze the cumulative revenue generated over every month.

select *, sum(revenu) over(order by month) as cum_revenu
from(
select  month(date) as month,sum(quantity*price) as revenu
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id
join orders
on orders.order_id=order_details.order_id
group by month) as r;














