use mavenmovies;
/*
The Situation: 
		The company's insurance policy is up for renewal and the insurance 
		company's underwriters need some updated information from us before they 
        will issue a new policy.
        
The Objective:
		Use Maven Movies Database to answer Underwriters's questions.
        
        Big 6 Select statement, logical conditions, wildcards, CASE AND COUNT Statements used
*/


/*
1.	We will need a list of [all staff members], including their [first and last names], 
[email addresses], and the [store identification] number where they work. 
*/ 
SELECT
    s.last_name,
    s.first_name,
    s.store_id,
    s.email
FROM staff s
ORDER BY 
	s.last_name;



/*
2.	We will need separate counts of inventory items held at each of your two stores. 
*/ 
-- How many items in inventory per store
SELECT 
	i.store_id,
	COUNT(i.inventory_id) AS inventory_items
FROM inventory i
GROUP BY 
	i.store_id ;

-- Checking if inventory is in Stock per store
SELECT 
	i.inventory_id,
	COUNT(CASE WHEN i.store_id = 1 THEN i.inventory_id ELSE NULL END) AS Store_1_stock,
        COUNT(CASE WHEN i.store_id = 2 THEN i.inventory_id ELSE NULL END) AS Store_2_stock
FROM inventory i
GROUP BY 
	i.inventory_id;


/*
3.	We will need a count of active customers for each of your stores. Separately, please. 
*/

SELECT 
	c.store_id,
	COUNT(c.active) AS active_customer
FROM customer c
WHERE c.active = 1
GROUP BY 
	c.store_id;







/*
4.	In order to assess the liability of a data breach, we will need you to provide a count 
of all customer email addresses stored in the database. 
*/
SELECT 
    COUNT(c.email) AS number_of_email_Addresses
FROM customer c;

-- See if any of the Email address are used more than Once
SELECT 
    c.email,
    COUNT(c.email) AS number_of_email_Addresses_used
FROM customer c
GROUP BY 
	c.email;






/*
5.	We are interested in how diverse your film offering is as a means of understanding how likely 
you are to keep customers engaged in the future. 
Please provide a count of unique film titles 
you have in inventory at each store and then provide a count of the unique categories of films you provide. 
*/
-- count of unique film titles you have in inventory at each store
-- Note to self: Distinct can be used inside Count aggregate
SELECT
	i.store_id,
	COUNT(DISTINCT i.film_id ) AS unique_films
    FROM inventory i
    GROUP BY 
	i.store_id;
		

-- count of the unique categories of films
SELECT 
	COUNT(DISTINCT name) AS unique_categories
FROM category c;




/*
6.	We would like to understand the replacement cost of your films. 
Please provide the replacement cost for the film that is least expensive to replace, 
the most expensive to replace, and the average of all films you carry. ``	
*/

SELECT
    MIN(f.replacement_cost) AS cheapest_replacement_cost,
    MAX(f.replacement_cost) AS expensive_replacement_cost,
    AVG(f.replacement_cost) AS average_replacement_cost
FROM film f;





/*
7.	We are interested in having you put payment monitoring systems and maximum payment 
processing restrictions in place in order to minimize the future risk of fraud by your staff. 
Please provide the average payment you process, as well as the maximum payment you have processed.
*/
SELECT
    MAX(pay.amount) AS Highest_payment,
    AVG(pay.amount) AS average_payment
FROM payment pay;


/*
8.	We would like to better understand what your customer base looks like. 
Please provide a list of all customer identification values, with a count of rentals 
they have made all-time, with your highest volume customers at the top of the list.
*/

SELECT
    pay.customer_id,
    COUNT(pay.rental_id) AS rentals_purchased
FROM payment pay
GROUP BY 
	pay.customer_id
ORDER BY 
	rentals_purchased DESC


