-- Challenge
-- Write SQL queries to perform the following tasks using the Sakila database:

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
    select( select count(*)
     FROM SAKILA.inventory
     WHERE film_id= (
     select film_id
     from sakila.film
     where title='Hunchback Impossible')) as total_copies;
     
   
-- 2.List all films whose length is longer than the average length of all the films in the Sakila database.
    select title,length
    from sakila.film
    where length>(select avg(length)
    from sakila.film);
    

-- 3.Use a subquery to display all actors who appear in the film "Alone Trip".
        select first_name,last_name
        from sakila.actor
        where actor_id in(select actor_id
        from sakila.film_actor
        where film_id=(select film_id
        from sakila.film
        where title='Alone Trip'));
        
-- Bonus:

-- 4.Sales have been lagging among young families, and you want to target family movies for a promotion.
--  Identify all movies categorized as family films.
    select title
    from sakila.film
    where film_id in(select film_id
    from sakila.film_category
    where category_id =(select category_id
    from sakila.category
    where name= 'family'));
    
-- 5.Retrieve the name and email of customers from Canada using both subqueries and joins.
--  To use joins, you will need to identify the relevant tables and their primary and foreign keys.
    -- USING JOINS
    SELECT CONCAT(C.FIRST_NAME,' ',C.LAST_NAME) AS NAME, C.EMAIL
    FROM SAKILA.CUSTOMER C
    JOIN 
    SAKILA.ADDRESS A
    ON C.ADDRESS_ID=A.ADDRESS_ID
    JOIN
    SAKILA.CITY CI
    ON A.CITY_ID=CI.CITY_ID
    JOIN
    SAKILA.COUNTRY CO
    ON CO.COUNTRY_ID=CI.COUNTRY_ID
    WHERE CO.COUNTRY='CANADA';

-- USING SUBQUERIES
   SELECT CONCAT(FIRST_NAME,' ',LAST_NAME) AS NAME,EMAIL
   FROM SAKILA.CUSTOMER
   WHERE ADDRESS_ID IN(SELECT ADDRESS_ID
   FROM SAKILA.ADDRESS
   WHERE CITY_ID IN(SELECT CITY_ID
   FROM CITY
   WHERE COUNTRY_ID =(SELECT COUNTRY_ID
   FROM SAKILA.COUNTRY
   WHERE COUNTRY='CANADA')));
   
-- 6.Determine which films were starred by the most prolific actor in the Sakila database. 
-- A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT 
    f.film_id,
    f.title
FROM 
    film f
JOIN 
    film_actor fa ON f.film_id = fa.film_id
WHERE 
    fa.actor_id = (
        SELECT 
            fa.actor_id
        FROM 
            film_actor fa
        GROUP BY 
            fa.actor_id
        ORDER BY 
            COUNT(fa.film_id) DESC
        LIMIT 1
    );


-- 7.Find the films rented by the most profitable customer in the Sakila database. 
-- You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT DISTINCT 
    f.film_id,
    f.title
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    r.customer_id = (
        SELECT 
            customer_id
        FROM 
            payment
        GROUP BY 
            customer_id
        ORDER BY 
            SUM(amount) DESC
        LIMIT 1
    );

-- 8.Retrieve the client_id and the total_amount_spent of those clients who spent more than the average 
-- of the total_amount spent by each client. You can use subqueries to accomplish this.
SELECT 
    customer_id AS client_id,
    SUM(amount) AS total_amount_spent
FROM 
    payment
GROUP BY 
    customer_id
HAVING 
    SUM(amount) > (
        SELECT 
            AVG(total_spent)
        FROM (
            SELECT 
                customer_id,
                SUM(amount) AS total_spent
            FROM 
                payment
            GROUP BY 
                customer_id
        ) AS customer_totals
    );
