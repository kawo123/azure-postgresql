--
-- 1. Roles and Privileges
--

-- Create new role "pgadmin" and grant it "azure_pg_admin" privilege
CREATE ROLE pgadmin WITH LOGIN NOSUPERUSER INHERIT CREATEDB CREATEROLE NOREPLICATION PASSWORD '<StrongPassword!>';
GRANT azure_pg_admin TO pgadmin;
-- DROP ROLE pgadmin;

-- Create new database role "db_user" and grant it CONNECT privilege on database "db"
CREATE ROLE db_user WITH LOGIN NOSUPERUSER INHERIT CREATEDB NOCREATEROLE NOREPLICATION PASSWORD '<StrongPassword!>';
GRANT CONNECT ON DATABASE db TO db_user;
-- GRANT ALL PRIVILEGES ON DATABASE db TO db_user;
-- DROP OWNED BY db_user;
-- DROP ROLE db_user;

--
-- To validate new roles and privileges, run `\du` through psql
--


--
-- 2. Create Tables
--

CREATE TABLE dogs (
	dog_id serial PRIMARY KEY,
	name varchar(255),
	age integer NOT NULL,
	weight integer NOT NULL
);


--
-- 3. Insert/Update/Delete Rows
--

insert into dogs (name, age, weight) values
	('Rover', 3, 35),
	('Cardie', 4, 37),
	('Dunkin', 3, 39);

-- sanity check table 'dogs'
select * from dogs;

update dogs
set age = 4
where name = 'Rover';

-- sanity check table 'dogs' and note changes
select * from dogs;

delete from dogs
where dog_id = 2;

-- sanity check table 'dogs' and note deletion
select * from dogs;


--
-- 4. Select
--

select * from customer;

select film_id, title, rental_rate from film;

select distinct rental_rate from film;

--
-- 5. Filtering (Where)
--

select film_id
	, title
	, rental_rate
	, rating
from film
where rental_rate = 0.99;

select film_id
	, title
	, rental_rate
	, rating
from film
where rental_rate = 0.99
and rating = 'G';


--
-- 6. Count
--

select count(*)
from address;

-- Counting on column doesn't include NULL
select count(address2)
from address;

select count(first_name)
from customer;

select count(distinct first_name)
from customer;


--
-- 7. Order By
--

select *
from customer
order by last_name;

select *
from customer
order by last_name desc;

select *
from customer
order by last_name asc;


--
-- 8. Conditional Clause
--

select customer_id
	, first_name
	, last_name
from customer
where customer_id
between 1
and 10
order by customer_id;

select customer_id
	, first_name
	, last_name
from customer
where customer_id
not between 1
and 100
order by customer_id;

select first_name
	, last_name
from customer
where first_name
like 'A%'
order by first_name desc;

select first_name
	, last_name
from customer
where first_name
like 'Am_'
order by first_name asc;

select first_name
	, last_name
from customer
where first_name
in ('John', 'Mary', 'Tim')
order by first_name asc;


--
-- 9. Mathematical functions
--

select
	min(rental_rate) as min_rental
	, max(rental_rate) as max_rental
from film;

select *
from film
where rental_rate = (
	select max(rental_rate)
	from film
)
order by film_id;

select round(max(rental_rate))
from film;

select round(4.123947, 1);

select round(4.123947, 2);

select round(4.123947, 3);

select
	sum(amount)
	, count(amount)
	, avg(amount)
	, round(var_pop(amount), 2) rvar
	, round(stddev_pop(amount), 2) rstd
from payment;


--
-- 10. Join
--

select customer_id
	, sum(amount)
from payment
group by customer_id
order by customer_id;

select customer_id
	, sum(amount)
from payment
where customer_id
not between 1
and 10
group by customer_id
having sum(amount) > 100
order by customer_id;

select customer_id
	, sum(amount)
from payment
where customer_id
not between 1
and 10
group by customer_id
having sum(amount) > 100
order by customer_id
limit 5;

select
	f.film_id
	, f.title
	, i.inventory_id
from
	film as f
inner join
	inventory as i
on
	f.film_id = i.film_id
--where
--	i.film_id is null
;

select
	f.film_id
	, f.title
	, i.inventory_id
from
	film as f
left join
	inventory as i
on
	f.film_id = i.film_id
--where
--	i.film_id is null
;


--
-- 11. Explain/Analyze
--

explain
analyze
select *
from film;

explain
analyze
select *
from film
where rental_rate > 0.99;

--
-- 12. Index
-- Optimizes query performance by reducing need for full table scan
-- B-tree: balance tree, used for high cardinality columns
-- Bitmap: low cardinality columns, read-intensive workload, created on the fly when beneficial
--         Pro: optimizes bitwise filtering
--         Con: index update is slow
-- Hash: used for equality, comparable performance as B-tree, discouraged by PostsgreSQL communities (https://www.postgresql.org/docs/9.1/indexes-types.html)
--       Pro: index size is smaller, may fit in memory
-- PG-specific indexes: GIST, SP-GIST, GIN, BRIN
-- GIST: generalized search tree; framework for implementing custom indexes
-- SP-GIST: space-partitioned GIST; used for nonbalanced data structures
-- GIN: text indexing; faster lookup but slower build than GIST; 2-3x larger than GIST
-- BRIN: Block range indexing; used for large data sets; divides data into ordered blocks
--

create index idx_rental_customer_id on rental(customer_id);

explain
analyze
select *
from rental;

explain
analyze
select *
from rental
where customer_id > 500;

drop index idx_rental_customer_id;

--
-- 13. Partitioning
-- Large tables are difficult to query efficiently even with indexes
-- Horizontal Partitioning: split table by rows into partitions; Pro: limit scans to subset of partitions; commonly used in DW, timeseries db, etc
-- Vertical Partitioning: split columns into multiple tables; Pro: reduce I/O; commonly used in DW, data w. many attributes, etc.
-- Range Partition: parition on range (e.g. date, numeric range, alphabetical range)
-- List Partition: partiton on list of values
-- Hash Partition: partition using modulo (available on PG 11+)
--

create table iot_measurement(
	location_id int not null
	, measure_date date not null
	, temp_celsius int
	, rel_humidity_pct int
) partition by range (measure_date);

create table iot_measurement_wk1_2019
partition of iot_measurement
for values from ('2019-01-01') to ('2019-01-08');

create table iot_measurement_wk2_2019
partition of iot_measurement
for values from ('2019-01-08') to ('2019-01-15');

--
-- 14. Materialized View
-- Pre-computed queries; update to source requires update to materialized view
-- Pro: usedful when query time is more important than storage space
--

create materialized view mv_film_inventory as
select
	f.film_id
	, f.title
	, i.inventory_id
from
	film as f
inner join
	inventory as i
on
	f.film_id = i.film_id;

select * from mv_film_inventory;

refresh materialized view mv_film_inventory;

drop materialized view mv_film_inventory;
