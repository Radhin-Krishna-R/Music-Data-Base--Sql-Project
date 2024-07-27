--To view all eilds in employee table
select * from employee;

--Senior most employee using Hire date
Select * from employee Order by hire_date ASC limit 1;

--countires with most sales
select invoice.billing_country,sum(invoice_line.quantity) from invoice Join invoice_line 
	ON invoice.invoice_id = invoice_line.invoice_id
    group by invoice.billing_country   
	order by sum(invoice_line.quantity) DESC

--countries generated most Revenue
select invoice.billing_country,sum(invoice_line.quantity * invoice_line.unit_price) as total_revenue from invoice Join invoice_line 
	ON invoice.invoice_id = invoice_line.invoice_id
    group by invoice.billing_country   
	order by total_revenue DESC

--Top 3 purchases
select billing_city,billing_address,customer_id,total from invoice 
	order by total DESC Limit 3


--top 20 high valued customers
select Distinct customer_id,Sum(total) from invoice
	group by customer_id
	order by Sum(total) Desc
	limit 20

--top 3 revenue generate cities
select invoice.billing_city,sum(invoice_line.quantity * invoice_line.unit_price) as total_revenue from invoice Join invoice_line 
	ON invoice.invoice_id = invoice_line.invoice_id
    group by invoice.billing_city   
	order by total_revenue DESC
	limit 3

--rock music listners name and email 
SELECT distinct email,first_name,last_name
	FROM customer JOIN invoice ON customer.customer_id = invoice.customer_id  
	JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
	WHERE track_id in(select track_id from track join genre on genre.genre_id=track.genre_id
	where genre.name Like 'Rock')
	order by email

--to find genre id of rock
select * from genre where name Like 'Rock';
--artist namewho have published mostrock songs
select artist.name,count(distinct(track.track_id)) as tracks from 
	artist join album on album.artist_id = artist.artist_id
	join track on track.album_id = album.album_id
	where track.genre_id = '1'
	group by artist.name order by tracks Desc 
	limit 10

--money customer spent on each artist
 
SELECT artist.name as Artist_name, SUM(invoice.total) AS total_spent, Max(customer.first_name) AS customer_name  -- Use MAX for customer name
FROM artist JOIN album ON album.artist_id = artist.artist_id
JOIN track ON track.album_id = album.album_id
JOIN invoice_line ON track.track_id = invoice_line.track_id
JOIN invoice ON invoice_line.invoice_id = invoice.invoice_id
JOIN customer ON customer.customer_id = invoice.customer_id
GROUP BY artist.name
ORDER BY total_spent DESC;

--popular music genre by each country

WITH genre_counts AS (
  SELECT c.country, g.name AS genre, COUNT(*) AS purchases
  FROM customer AS c JOIN invoice AS i ON c.customer_id = i.customer_id
  JOIN invoice_line AS il ON il.invoice_id = i.invoice_id
  JOIN track AS t ON t.track_id = il.track_id
  JOIN genre AS g ON t.genre_id = g.genre_id
  GROUP BY c.country, g.name)
SELECT country, MAX(genre) AS most_popular_genre 
FROM genre_counts
GROUP BY country;


--Top spender from each country 

WITH top_spenders_per_country AS (
  SELECT c.country, c.customer_id, SUM(i.total) AS total_spent  -- Use alias 'i' for invoice
  FROM customer AS cJOIN invoice AS i ON c.customer_id = i.customer_id
  GROUP BY c.country, c.customer_id ORDER BY c.country, total_spent DESC)
SELECT tspc.country, c.first_name || ' ' || c.last_name AS customer_name, tspc.total_spent
	FROM top_spenders_per_country AS tspc
	JOIN customer AS c ON tspc.customer_id = c.customer_id
	GROUP BY tspc.country, customer_name, tspc.total_spent
	HAVING tspc.total_spent = (SELECT MAX(total_spent)FROM top_spenders_per_country
    WHERE tspc.country = top_spenders_per_country.country);





	
