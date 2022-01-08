
/*
    THE
OBJECTIVE
THE Use MySQL to:
Leverage your SQL skills to extract and analyze data from various tables in the Maven
Movies database to answer your potential Acquirer’s questions. Each question will require
you to write a multi-table SQL query, joining at least two tables.
*/





/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 
SELECT
	store.store_id,
    staff.first_name,
    staff.last_name,
    address.address,
    address.district,
    city.city,
    country.country
FROM store store
	INNER JOIN staff staff 
		ON store.store_id = staff.store_id
    INNER JOIN address address
		ON staff.address_id = address.address_id
    INNER JOIN city city
		ON address.city_id = city.city_id
    INNER JOIN country country
    ON city.country_id = country.country_id;

	
/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/

SELECT 
	inventory.store_id,
	inventory.inventory_id,
    film.title,
    film.rating,
    film.rental_rate,
    film.replacement_cost
FROM inventory inventory
	INNER JOIN film film
		ON inventory.film_id = film.film_id;




/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/

SELECT DISTINCT
	 inventory.store_id,
    film.rating,
    COUNT(inventory.inventory_id) AS number_of_inventory_items
FROM inventory inventory
	LEFT JOIN film film
		ON inventory.film_id = film.film_id
GROUP BY 
	film.rating, inventory.store_id;











/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 

SELECT 
	inventory.store_id,
    category.name,
    COUNT(film.title),
    SUM(film.replacement_cost),
    AVG(film.replacement_cost)
FROM inventory inventory
	LEFT JOIN film film
		ON film.film_id = inventory.film_id
	LEFT JOIN film_category film_category
		ON film.film_id = film_category.film_id
    LEFT JOIN category category
		ON film_category.category_id = category.category_id
GROUP BY 
	inventory.store_id, category.name;










/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/

SELECT Distinct
	customer.store_id,
    customer.first_name,
    customer.last_name,
    address.address,
    city.city,
    customer.active
FROM customer customer
	LEFT JOIN store store
		ON customer.store_id = store.store_id
    LEFT JOIN address address
		ON store.address_id = address.address_id
    LEFT JOIN city city
		ON address.city_id = city.city_id
    LEFT JOIN country country
    ON city.country_id = country.country_id;



/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/

SELECT
	customer.first_name,
    customer.last_name,
    COUNT(rental.rental_id) AS total_rentals,
    SUM(payment.amount)
FROM customer customer
	INNER JOIN payment payment
		ON customer.customer_id = payment.customer_id
	INNER JOIN rental
		ON payment.rental_id = rental.rental_id
GROUP BY 
	customer.customer_id
ORDER BY 
	total_rentals DESC;










    
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/

SELECT
	'advisor' as type,
    advisor.first_name,
    advisor.last_name,
    'null' as company_name
FROM advisor   

UNION

SELECT
	'investor' as type,
    first_name,
    last_name,
    company_name
FROM investor;










/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/
/*
SELECT
*
FROM actor_award award

*/
SELECT
	CASE 
		WHEN award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards' 
		WHEN award.awards IN ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony' )THEN '2 awards' 
		ELSE '1 award'
    END AS number_of_awards,
	AVG(CASE WHEN award.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film
FROM actor_award award

 GROUP BY 
	CASE 
		WHEN award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards' 
		WHEN award.awards IN ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony' )THEN '2 awards' 
		ELSE '1 award'
    END 