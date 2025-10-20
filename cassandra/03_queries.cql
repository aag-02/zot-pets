-- 03_queries.cql

-- 1) Species lookups (time-sorted)
SELECT name, dob
FROM pets_by_species_sorted_by_age
WHERE species = 'Dog'
ORDER BY dob DESC
LIMIT 5;

-- 2) Owner's pets by age
SELECT pet_id, name, dob
FROM pets_by_owner_sorted_by_age
WHERE owner_id = 10
ORDER BY dob ASC;

-- 3) Services by type
SELECT groomer_id, service_id, description, price
FROM services_by_type
WHERE service_type = 'Bath';

-- 4) Appointments by groomer (most recent first)
SELECT appointment_id, pet_owner_id, pet_id
FROM appointments_by_groomer
WHERE groomer_id = 139
ORDER BY appointment_datetime DESC;

-- 5) Purchases by owner in a date range 
SELECT MAX(price) AS max_price
FROM purchases_by_owner
WHERE pet_owner_id = 5
  AND purchase_date >= '2021-09-01'
  AND purchase_date <= '2025-09-30';
