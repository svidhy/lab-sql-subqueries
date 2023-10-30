Use sakila;

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT * FROM inventory;
SELECT * FROM film;

SELECT COUNT(*) AS num_of_copies
FROM inventory
WHERE film_id IN(
	SELECT film_id
	FROM film
	WHERE title = "Hunchback Impossible"
);

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
-- Average Length is 115.xx
SELECT *
FROM film
WHERE length >(
	SELECT AVG(length)
	FROM film
);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT * FROM film;
Select * from film_actor;
Select * from actor;

SELECT actor_id, first_name, last_name
FROM actor
where actor_id IN(
	SELECT actor_id 
	FROM film_actor 
	WHERE film_id IN(
		SELECT film_id
		FROM film
		WHERE title = "Alone Trip")
);

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
-- SELECT * FROM film_category where category_id = 8; Returns 69 rows

SELECT * from film;
SELECT * from film_category;
SELECT * from category;

SELECT *
FROM film
WHERE film_id in(
	SELECT film_id 
	FROM film_category 
	WHERE category_id IN(
		SELECT category_id
		FROM category
		WHERE name = "Family")
);

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT * FROM customer;
SELECT * from address;
SELECT * FROM country;
SELECT * FROM city;

SELECT first_name, last_name, email 
FROM customer
WHERE address_id IN(
	SELECT address_id
	FROM address
	JOIN city USING(city_id)
	JOIN country USING(country_id) WHERE country='Canada'
);

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT * FROM film;
SELECT * FROM film_actor;
SELECT * FROM film;

SELECT film_id, title
FROM film
WHERE film_id IN(
	SELECT film_id
	FROM film_actor
	WHERE actor_id =(
		SELECT actor_id
		FROM film_actor
		GROUP BY actor_id
		ORDER BY count(film_id) DESC
		LIMIT 1
	)
);

-- 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer,
-- i.e., the customer who has made the largest sum of payments.

-- Getting the customer_id who rents the most using the payment table
-- Then, joining the rental and inventory table to get the film_id of the films that customer_id has rented. Then the first query will get the title information

SELECT * FROM film;
SELECT * FROM payment;
SELECT * from rental;
SELECT * from inventory;

SELECT film_id, title
FROM film
WHERE film_id IN(
	SELECT film_id
    FROM rental
    JOIN inventory USING (inventory_id)
    WHERE customer_id = (
		SELECT customer_id
		FROM payment
		GROUP BY customer_id
		ORDER BY SUM(amount) DESC
LIMIT 1
    )
);

-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
-- You can use subqueries to accomplish this.

-- Tried to get the average of total_amount spent by each client instead of just the average of it all and I think I used too much math
-- If the math is correct, then the average is 112.53



SELECT customer_id, SUM(amount) as total_amount
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
	SELECT AVG(amount) as average_amount
    FROM(
		SELECT SUM(amount) as amount
		FROM payment
		GROUP BY customer_id
    ) as sub1
)
; 

-- To get the average amount spent by each client:
SELECT AVG(amount) as average_amount
    FROM(
		SELECT SUM(amount) as amount
		FROM payment
		GROUP BY customer_id
    ) as sub1