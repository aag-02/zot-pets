# ZotPets (PostgreSQL Data Analysis)

## Overview
ZotPets is a relational database project built for a mock e-commerce startup that connects pet owners with groomers.  
The goal of this project was to **load, explore, and analyze data** using **PostgreSQL** through advanced SQL queries involving joins, CTEs, and window functions.

While the initial schema design (table creation and ER diagram) was provided, all data loading and analytical SQL were implemented by me.

---

## Database Description
The ZotPets schema models a real-world pet care platform:
- **Users**: Pet owners and groomers with contact information and roles  
- **Pets**: Registered pets linked to owners  
- **Services**: Grooming options (Bath, Haircut, Nail Trim)  
- **Appointments**: Booked services for pets  
- **Products & Purchases**: Items sold by groomers and purchased by owners  

The schema includes **9 relational tables**, enforcing **primary/foreign key constraints** and normalization.

---

## Key Features
### 1. Data Loading
- Loaded CSV datasets into PostgreSQL using `COPY` commands.  
- Validated relational integrity and ensured correct data types and constraints.  

### 2. Data Analysis
Wrote **10+ advanced SQL queries** to answer business questions such as:
- Count of users, pets, and appointments  
- Groomers with ratings ≥ 4.5  
- Pet owners with diverse pet species (≥ 3)  
- Appointments and services by pet  
- Groomers offering multiple service categories  
- Top-spending customers by year  

### 3. Analytical SQL Techniques
- **Multi-table joins** and aggregations  
- **Common Table Expressions (CTEs)** for modular query building  
- **Window functions** (`ROW_NUMBER`, `LAG`) for ranking and time-based comparisons  
- **Array processing** (`string_to_array`, `array_length`) to normalize multivalued attributes  

### 4. Materialized Lifetime Value (LTV)
- Created a view `PetOwnerLTV` to calculate total spending per user.  
- Added and updated a `lifetime_value` column in the `pet_owner` table via `ALTER TABLE` and `UPDATE JOIN`.  
- Verified synchronization between stored and computed values.
