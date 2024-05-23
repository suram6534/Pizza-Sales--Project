use Pizza
-- Key Performance Indicators

-- Total number of orders placed
SELECT COUNT(order_id) AS Total_orders
FROM     order_details

-- Total revenue generated from pizza sales
SELECT ROUND(SUM(order_details.quantity * pizzas.price), 2) AS Total_revenue
FROM     order_details INNER JOIN
                  pizzas ON order_details.pizza_id = pizzas.pizza_id

--  Most common pizza size ordered
SELECT TOP (1) pizzas.size, COUNT(order_details.order_details_id) AS no_of_orders
FROM     pizzas INNER JOIN
                  order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY no_of_orders DESC

--  Highest priced pizza
SELECT TOP (1) pizza_types.name, pizzas.price
FROM     pizza_types INNER JOIN
                  pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price

--  Top five pizzas ordered along with their quantities
SELECT TOP (5) pizza_types.name, SUM(order_details.quantity) AS quantity_on_order
FROM     pizza_types INNER JOIN
                  pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id INNER JOIN
                  order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity_on_order DESC;

-- Average number of pizzas ordered per day
SELECT AVG(quantity) AS avg_pizzas_per_day
FROM     (SELECT orders.date, SUM(order_details.quantity) AS quantity
                  FROM      orders INNER JOIN
                                    order_details ON orders.order_id = order_details.order_id
                  GROUP BY orders.date) AS order_quantity

-- Based on revenue top 3 most ordered pizza types
SELECT TOP (3) pizza_types.name, SUM(order_details.quantity * pizzas.price) AS revenue
FROM     pizza_types INNER JOIN
                  pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id INNER JOIN
                  order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC

--Cummulative revenue generated over time
SELECT sales.date, SUM(sales.revenue) over(ORDER BY sales.date) AS cummulative_revenue
FROM   (SELECT orders.date, SUM(order_details.quantity*pizzas.price) AS revenue
        FROM     order_details INNER JOIN
                       pizzas ON order_details.pizza_id = pizzas.pizza_id INNER JOIN
                       orders ON orders.order_id = order_details.order_id
GROUP BY orders.date) AS sales;


--Percentage contribution of each Pizza type to total revenue
SELECT pizza_types.name, ROUND(SUM(pizzas.price * order_details.quantity) /
                      (SELECT SUM(pizzas.price * order_details.quantity) AS total_sales
                       FROM      pizzas INNER JOIN
                                         order_details ON pizzas.pizza_id = order_details.pizza_id) * 100, 2) AS percentage
FROM     pizzas INNER JOIN
                  order_details ON pizzas.pizza_id = order_details.pizza_id INNER JOIN
                  pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.name
ORDER BY percentage DESC
