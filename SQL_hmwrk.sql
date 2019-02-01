Use sakila;

#1a. Display the first and last names of all actors from the table `actor`.
Select first_name, last_name
from actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
Select concat(first_name, ' ', last_name) as "Actor Name" 
from actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
Select actor_id, first_name, last_name 
from actor
where first_name="JOE";

#2b. Find all actors whose last name contain the letters `GEN`:
Select actor_id, first_name, last_name 
from actor
where last_name like '%GEN%';

#2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
Select actor_id, first_name, last_name 
from actor
where last_name like '%LI%'
order by last_name, first_name;

#2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country 
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and 
#use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
Alter table actor 
Add column description blob(30) NOT NULL;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
Alter table actor 
Drop column description;

#4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) as last_name_count 
from actor
group by last_name;


#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(*) as last_name_count 
from actor
group by last_name
order by last_name_count DESC;


#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
select last_name, first_name 
from actor
where last_name="WILLIAMS" and first_name="GROUCHO";

update actor
set first_name = 'HARPO' 
where last_name='WILLIAMS' and first_name='GROUCHO';

select last_name, first_name 
from actor
where last_name="WILLIAMS" and first_name="HARPO";

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor
set first_name = 'GROUCHO' 
where last_name='WILLIAMS' and first_name='HARPO';

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
describe address;

select * from address;

select * from staff;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select first_name, last_name, address, address.address_id
from staff 
join address
on staff.address_id= address.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select * from staff;
select * from payment;

select staff.staff_id, sum(payment.amount) as total_amount
from staff
join payment
on staff.staff_id= payment.staff_id
where payment_date between '2005-08-01' and '2005-08-31'
group by staff_id;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select * from film_actor;
select * from film;

select f.film_id, f.title, count(actor_id) as actor_count 
from  film_actor a
inner join film f
on  f.film_id=a.film_id
group by film_id;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select * from inventory;
select * from film where title='Hunchback Impossible';

select f.title, count(*) as number_of_copies #i.inventory_id, i.film_id, 
from inventory i
inner join film f
on i.film_id = f.film_id
where title='Hunchback Impossible'
group by f.title;


#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select * from payment;
select * from customer;

select p.customer_id, c.last_name, sum(amount) as total_amount
from payment p
join customer c
on p.customer_id = c.customer_id
group by customer_id
order by last_name ASC;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and 
		#Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select * from language;
select * from film;

select f.title, l.name
from film f
join language l
on l.language_id= f.language_id
where l.language_id=1 AND title like  'K%' OR 'Q&';
	
#7b. Use subqueries to display all actors who appear in the film Alone Trip.
select * from film where title = "Alone Trip";
select * from film_actor;
select * from actor;

select  f.title, a.actor_id, x.first_name, x.last_name # f.film_id,
from film_actor a
join film f
on a.film_id=f.film_id
join actor x
on a.actor_id=x.actor_id
where title = "Alone Trip";


#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select * from customer;
select * from address;
select * from country;
select * from city;

select b.country, d.first_name, d.last_name, d.email #c.address_id, a.city_id, a.city, 
from city a
join country b
on a.country_id = b.country_id
join address c
on a.city_id = c.city_id
join customer d
on c.address_id = d.address_id
where b.country="Canada";


#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select * from film;
select * from film_category;
select * from category;

select a.name, c.title #a.category_id, b.film_id, 
from category a
join film_category b 
on a.category_id = b.category_id
join film c
on b.film_id=c.film_id
where a.name="Family";


#7e. Display the most frequently rented movies in descending order.
select * from film;
select * from rental;
select * from payment;
select * from inventory;

select c.title, count(b.inventory_id) as times_rented #, b.film_id
from rental a
join inventory b 
on a.inventory_id = b.inventory_id
join film c
on b.film_id = c.film_id
group by title
order by times_rented DESC;


#7f. Write a query to display how much business, in dollars, each store brought in.
select * from store;
select * from address;
select * from payment;
select * from inventory;

select a.store_id, sum(e.amount) as total_sales#a.address_id, b.city_id, c.inventory_id, d.rental_id,
from store a
join address b
on a.address_id = b.address_id
join inventory c
on a.store_id = c.store_id
join rental d
on c.inventory_id = d.inventory_id
join payment e
on d.rental_id = e.rental_id
group by store_id;

#7g. Write a query to display for each store its store ID, city, and country.
select * from store;
select * from address;
select * from city;
select * from country;

select a.store_id, c.city, d.country #a.address_id, b.city_id, c.city, c.country_id, d.country
from store a
join address b
on a.address_id = b.address_id
join city c
on b.city_id = c.city_id
join country d
on c.country_id = d.country_id;


#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select * from category;
select * from film_category;
select * from inventory;
select * from payment;
select * from rental;

select a.name, sum(e.amount) as total_amount  #a.category_id, b.film_id, c.inventory_id, d.rental_id, 
from category a
join film_category b
on a.category_id = b.category_id
join inventory c
on b.film_id = c.film_id
join rental d
on c.inventory_id = d.inventory_id
join payment e
on d.rental_id = e.rental_id
group by name
order by total_amount DESC
limit 5;


#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view `Top_five genres_by_gross_revenue` as 
select a.name, sum(e.amount) as total_amount  #a.category_id, b.film_id, c.inventory_id, d.rental_id, 
from category a
join film_category b
on a.category_id = b.category_id
join inventory c
on b.film_id = c.film_id
join rental d
on c.inventory_id = d.inventory_id
join payment e
on d.rental_id = e.rental_id
group by name
order by total_amount DESC
limit 5;

#8b. How would you display the view that you created in 8a?
select * from `Top_five genres_by_gross_revenue`;
#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view `Top_five genres_by_gross_revenue`;