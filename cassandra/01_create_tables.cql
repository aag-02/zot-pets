-- 01_create_tables.cql

-- Base tables
create table "user" (
    user_id int primary key,
    name text,
    email text,
    street text,
    city text,
    state text,
    join_date date
    
    );

create table pet (
    owner_id int,
    pet_id int,
    name text,
    species text,
    breed text,
    dob date,
    notes text,
    photo_urls text,
    primary key ((owner_id), pet_id)

    );

create table appointment (
    appointment_id int primary key,
    pet_owner_id int,
    pet_id int,
    appointment_datetime timestamp
    
    );

-- Query tables (denormalized, query-driven)

-- Look up pets by species
create table pets_by_species (
    species text,
    owner_id int,
    pet_id int,
    name text,
    breed text,
    dob date,
    notes text,
    photo_urls text,
    primary key (species, owner_id, pet_id)
);

-- Look up MOST RECENT pets by species (time-sorted reads)
create table pets_by_species_sorted_by_age (
    species text,
    dob date,
    owner_id int,
    pet_id int,
    name text,
    breed text,
    notes text,
    photo_urls text,
    primary key ((species), dob, owner_id, pet_id)
    ) with clustering order by (dob desc);

-- Look up an owner's pets by age (oldest/newest first)

create table pets_by_owner_sorted_by_age (
    owner_id int,
    dob date,
    pet_id int,
    name text,
    species text,
    breed text,
    primary key ((owner_id), dob, pet_id)
);

-- List services by type
create table services_by_type (
    service_type text,
    groomer_id int,
    service_id int,
    description text,
    price decimal,
    primary key ((service_type), groomer_id, service_id)
);

-- Look up appointments by groomer, most recent first
create table appointments_by_groomer (
    groomer_id int,
    appointment_datetime timestamp,
    appointment_id int,
    pet_owner_id int,
    pet_id int,
    primary key ((groomer_id), appointment_datetime, appointment_id)
    ) with clustering order by (appointment_datetime desc);

-- Look up purchases by owner over time

create table purchases_by_owner (
    pet_owner_id int,
    purchase_date date,
    purchase_id int,
    product_id int,
    groomer_id int,
    price decimal,
    primary key ((pet_owner_id), purchase_date, purchase_id)
    );
