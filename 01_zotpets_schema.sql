-- CREATE DATABASE zot_pets;
-- \c zot_pets


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