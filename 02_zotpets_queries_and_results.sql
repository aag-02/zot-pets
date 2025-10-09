-- Homework Assignment #1 (HW1)

-- Name: Arya Gupta

-- 1) SQL DDL statements 

DROP SCHEMA IF EXISTS zot_pets CASCADE;


CREATE SCHEMA IF NOT EXISTS zot_pets;
SET search_path TO zot_pets;


DROP TABLE IF EXISTS "appointment_service";
DROP TABLE IF EXISTS "purchase";
DROP TABLE IF EXISTS "appointment";
DROP TABLE IF EXISTS "pet";
DROP TABLE IF EXISTS "service";
DROP TABLE IF EXISTS "product";
DROP TABLE IF EXISTS "groomer";
DROP TABLE IF EXISTS "pet_owner";
DROP TABLE IF EXISTS "user";


DROP TYPE IF EXISTS service_type_enum;


CREATE TYPE service_type_enum AS ENUM ('Bath', 'Haircut', 'Nail Trim');


CREATE TABLE "user" (
    "user_id" SERIAL PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NOT NULL UNIQUE,
    "street" VARCHAR(255),
    "city" VARCHAR(100),
    "state" VARCHAR(100),
    "join_date" DATE NOT NULL DEFAULT CURRENT_DATE
);


CREATE TABLE "pet_owner" (
    "user_id" INT PRIMARY KEY,
    "payment_info" VARCHAR(255),
    CONSTRAINT "fk_pet_owner_user"
        FOREIGN KEY("user_id")
        REFERENCES "user"("user_id")
        ON DELETE CASCADE
);


CREATE TABLE "groomer" (
    "user_id" INT PRIMARY KEY,
    "bio" TEXT,
    "certification" VARCHAR(255),
    "rating" NUMERIC(3, 2) CHECK ("rating" >= 0 AND "rating" <= 5),
    CONSTRAINT "fk_groomer_user"
        FOREIGN KEY("user_id")
        REFERENCES "user"("user_id")
        ON DELETE CASCADE
);


CREATE TABLE "pet" (
    "owner_id" INT NOT NULL,
    "pet_id" SERIAL NOT NULL, 
    "name" VARCHAR(255) NOT NULL,
    "species" VARCHAR(100),
    "breed" VARCHAR(100),
    "dob" DATE,
    "notes" TEXT,
    "photo_urls" VARCHAR(2048),
    PRIMARY KEY ("owner_id", "pet_id"),
    CONSTRAINT "fk_pet_owner"
        FOREIGN KEY("owner_id")
        REFERENCES "pet_owner"("user_id")
        ON DELETE CASCADE
);


CREATE TABLE "service" (
    "groomer_id" INT NOT NULL,
    "service_id" SERIAL NOT NULL,
    "service_type" service_type_enum NOT NULL,
    "description" TEXT,
    "price" NUMERIC(10, 2) NOT NULL CHECK ("price" >= 0),
    PRIMARY KEY ("groomer_id", "service_id"),
    CONSTRAINT "fk_service_groomer"
        FOREIGN KEY("groomer_id")
        REFERENCES "groomer"("user_id")
        ON DELETE CASCADE
);


CREATE TABLE "product" (
    "product_id" SERIAL PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    "price" NUMERIC(10, 2) NOT NULL CHECK ("price" >= 0)
);


CREATE TABLE "appointment" (
    "appointment_id" SERIAL PRIMARY KEY,
    "pet_owner_id" INT NOT NULL,
    "pet_id" INT NOT NULL,
    "appointment_datetime" TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT "fk_appointment_pet"
        FOREIGN KEY("pet_owner_id", "pet_id")
        REFERENCES "pet"("owner_id", "pet_id")
        ON DELETE CASCADE
);


CREATE TABLE "appointment_service" (
    "appointment_id" INT NOT NULL,
    "service_groomer_id" INT NOT NULL,
    "service_id" INT NOT NULL,
    PRIMARY KEY ("appointment_id", "service_groomer_id", "service_id"),
    CONSTRAINT "fk_appointment"
        FOREIGN KEY("appointment_id")
        REFERENCES "appointment"("appointment_id")
        ON DELETE CASCADE,
    CONSTRAINT "fk_service"
        FOREIGN KEY("service_groomer_id", "service_id")
        REFERENCES "service"("groomer_id", "service_id")
        ON DELETE CASCADE
);


CREATE TABLE "purchase" (
    "purchase_id" SERIAL PRIMARY KEY,
    "pet_owner_id" INT NOT NULL,
    "product_id" INT NOT NULL,
    "groomer_id" INT NOT NULL,
    "purchase_date" DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT "fk_purchase_owner"
        FOREIGN KEY("pet_owner_id")
        REFERENCES "pet_owner"("user_id")
        ON DELETE CASCADE,
    CONSTRAINT "fk_purchase_product"
        FOREIGN KEY("product_id")
        REFERENCES "product"("product_id")
        ON DELETE RESTRICT,
    CONSTRAINT "fk_purchase_groomer"
        FOREIGN KEY("groomer_id")
        REFERENCES "groomer"("user_id")
        ON DELETE SET NULL 
);

/*
pet_id:      so this is 'SERIAL' which is just an auto number. It’s paired with owner_id as a combo PK,
             so two different owners can both have pet_id=1. it's NOT NULL because every pet needs an ID.

name:        VARCHAR(255) NOT NULL. varchar(255) is solid since since it's large enough for the names. 
             there's no unique rule since tons of pets share names.

species:     VARCHAR(100), nullable.

breed:       VARCHAR(100), nullable. we keep it nullable since not every animal has/knows a breed

notes:       TEXT, nullable. This can be long free-form stuff like behavior notes which is a perfect use case for TEXT.

dob:         DATE, nullable. some owners don’t know exact birthdays, so we don’t force it. 

photo_urls:  VARCHAR(2048), nullable. This is the “cheating 1NF” column where multiple 
              URLs are comma-separated. we use a wide varchar because URLs get long.
*/


-- 2) Data Loading (COPY commands) 

\copy "user"              FROM '/Users/arya/UCI/cs224p/hw1/ZotPetsData/user.csv'                DELIMITER ',' CSV HEADER;
\copy pet_owner           FROM '/Users/arya/UCI/cs224p/hw1/ZotPetsData/pet_owner.csv'           DELIMITER ',' CSV HEADER;
\copy groomer             FROM '/Users/arya/UCI/cs224p/hw1/ZotPetsData/groomer.csv'             DELIMITER ',' CSV HEADER;
\copy pet                 FROM '/Users/arya/UCI/cs224p/hw1/ZotPetsData/pet.csv'                 DELIMITER ',' CSV HEADER;
\copy service             FROM '/Users/arya/UCI/cs224p/hw1/ZotPetsData/service.csv'             DELIMITER ',' CSV HEADER;
\copy appointment         FROM '/Users/arya/UCI/cs224p/hw1/ZotPetsData/appointment.csv'         DELIMITER ',' CSV HEADER;
\copy appointment_service FROM '/Users/arya/UCI/cs224p/hw1/ZotPetsData/appointment_service.csv' DELIMITER ',' CSV HEADER;
\copy product             FROM '/Users/arya/UCI/cs224p/hw1/ZotPetsData/product.csv'             DELIMITER ',' CSV HEADER;
\copy purchase            FROM '/Users/arya/UCI/cs224p/hw1/ZotPetsData/purchase.csv'            DELIMITER ',' CSV HEADER;

-- 3) Query Answers

-- Problem A --

/*this problem requires one query and three counts. I union all'd the labeled counts from each table
so I get a 3-row summary of users, pets, and appointments.*/

select 'user' as tbl_name, count(*) as cnt from "user"
union all
select 'pets', count(*) as cnt from pet
union all
select 'appointment', count(*) as cnt from appointment;

-- Problem B -- 
-- here i just join groomer with user to grab the name, filter rating >= 4.5, and sort best first.

select name, rating 
from groomer g
inner join "user" u on g.user_id = u.user_id
where rating >= 4.5
order by rating desc;

-- Problem C -- 

/* i need to find users who are both pet owners and groomers (so just join on same user_id in both tables).
I also ensure emails end with example.com using ilike, and then concat the address parts for a
single printable full_address */

select u.user_id, u.email, concat(u.street, ', ', u.city, ', ', u.state) as full_address
from pet_owner p
inner join groomer g on p.user_id = g.user_id
inner join "user" u on u.user_id = g.user_id
where u.email ilike '%example.com';

-- Problem D -- 

/*for pet_id=5, i list all appointment rows and the services inside each one.
 it asks for date and time separate so i split timestamp into date + time. */

select a.appointment_id,
       date(a.appointment_datetime) as appt_date,
       a.appointment_datetime::time as appt_time,
       s.service_type
from appointment a
inner join appointment_service a_s on a.appointment_id = a_s.appointment_id
inner join service s on a_s.service_groomer_id = s.groomer_id and a_s.service_id = s.service_id
where a.pet_id = 5
order by a.appointment_datetime asc;

-- Problem E -- 

/*for groomer 11, i count how many times each service_type shows up across
all their appointment_services. finally i group by service_type to get the breakdown. */

select s.service_type, count(*) as cnt
from service s
inner join appointment_service a_s on s.service_id = a_s.service_id and s.groomer_id = a_s.service_groomer_id
where groomer_id = 11
group by s.service_type;

-- Problem F -- 

/*i need to find owners who have 3+ distinct species among their pets. the distinct count of
p.species per owner does the trick, then HAVING filters for >= 3 */

select u.name, u.email, count(distinct p.species) as species_count
from "user" u
inner join pet_owner po on u.user_id = po.user_id
inner join pet p on u.user_id = p.owner_id
group by u.name, u.email
having count(distinct p.species) >= 3;

-- Problem G -- 

/*this one was a bit tricky but by using set-like logic using conditional SUMs, i 
required bath > 0 AND haircut > 0 AND Nail Trim = 0.
finally i just grouped by groomer so each row represented one groomer. */

select s.groomer_id, u.email
from service s
inner join appointment_service a_s on s.groomer_id = a_s.service_groomer_id and s.service_id  = a_s.service_id
inner join "user" u on u.user_id = s.groomer_id
group by s.groomer_id, u.email
having 
  sum(case when s.service_type = 'Bath' then 1 else 0 end) > 0 and
  sum(case when s.service_type = 'Nail Trim' then 1 else 0 end) = 0 and
  sum(case when s.service_type = 'Haircut' then 1 else 0 end) > 0
order by s.groomer_id asc;

-- Problem H -- 

/*here i simply split the URL string using string_to_array, then used
array_length() to count elements. finally i just ordered by the count and grabbed top 10. */

select pet_id, name, array_length(string_to_array(photo_urls, ','), 1) as num_photos
from pet
order by num_photos desc
limit 10;

-- Problem I -- 

/* this problem was quite complex so i broke it down into many steps
1) first i aggregate yearly product spend per owner using a CTE
2) second, i aggregate yearly service spend per owner using a CTE
3) full outer join to merge the two CTE's above 
4) i use a window function (row_number) to to find the top spender.
5) i then use LAG (partitioned by user) to grab last year’s total
finally, i just join to user for name/email and show only the rank 1 rows. */

with product_spend as 
(select extract(year from pu.purchase_date) as year, pu.pet_owner_id as user_id, sum(pr.price) as total_product_spending
from "purchase" pu
inner join product pr on pu.product_id = pr.product_id
group by pu.pet_owner_id, extract(year from pu.purchase_date)
),

service_spend as 
(select extract(year from a.appointment_datetime) as year, a.pet_owner_id as user_id, sum(s.price) as total_service_spending
from appointment a
inner join appointment_service a_s on a.appointment_id = a_s.appointment_id
inner join service s on s.groomer_id = a_s.service_groomer_id and s.service_id = a_s.service_id
group by a.pet_owner_id, extract(year from appointment_datetime)
),

product_and_service as 
(select
    coalesce(ps.year, ss.year) as year,
    coalesce(ps.user_id, ss.user_id) as user_id,
    coalesce(ps.total_product_spending, 0) as total_product_spending,
    coalesce(ss.total_service_spending, 0) as total_service_spending,
    coalesce(ps.total_product_spending, 0) + coalesce(ss.total_service_spending, 0) as total_spending
from product_spend ps
full outer join service_spend ss on ps.user_id = ss.user_id and ps.year = ss.year
),

spend_ordered as 
(select *, row_number() over (partition by year order by total_spending desc) as spend_rank,
    case 
    when lag(year) over (partition by user_id order by year) = year - 1
    then lag(total_spending) over (partition by user_id order by year)
    else 0 
    end as previous_year_total_spending
from product_and_service
)

select so.year, so.user_id, u.name, u.email, 
       so.total_product_spending, so.total_service_spending,
       so.total_spending, so.previous_year_total_spending
from spend_ordered so
inner join "user" u on u.user_id = so.user_id
where so.spend_rank = 1
order by so.year;

-- Problem J -- 
-- Table alteration DDL:

/* 1) here i use the same code as in part i) to create a view PetOwnerLTV which computes total per owner,
2) i then alter and update the pet_owner table to add lifetime_value column, and then update using the view to fill in values*/

create or replace view PetOwnerLTV as
with product_spend as 
(select pu.pet_owner_id as user_id, sum(pr.price) as total_product_spending
from purchase pu
inner join product pr on pu.product_id = pr.product_id
group by pu.pet_owner_id
),

service_spend as 
(select a.pet_owner_id as user_id, sum(s.price) as total_service_spending
from appointment a
inner join appointment_service a_s on a.appointment_id = a_s.appointment_id
inner join service s on s.groomer_id = a_s.service_groomer_id and s.service_id = a_s.service_id
group by a.pet_owner_id
)

select po.user_id,
       coalesce(ps.total_product_spending, 0)
     + coalesce(ss.total_service_spending, 0) as calculated_ltv
from pet_owner po
left join product_spend ps on po.user_id = ps.user_id
left join service_spend ss on po.user_id = ss.user_id;

-- Table update query:

alter table pet_owner add column if not exists lifetime_value numeric(10,2) not null default 0.00;

update pet_owner po
set lifetime_value = v.calculated_ltv
from PetOwnerLTV v
where v.user_id = po.user_id;

-- Change verification query:

/*here i just make sure the materialized lifetime_value should exactly equal
the calculated_ltv from the view. */

select po.user_id, u.name, po.lifetime_value, ltv.calculated_ltv
from pet_owner po
inner join "user" u on po.user_id = u.user_id
inner join PetOwnerLTV ltv on po.user_id = ltv.user_id
order by po.lifetime_value desc
limit 10;
