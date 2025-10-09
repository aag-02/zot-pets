# ZotPets (PostgreSQL Data Analysis)

## Overview
ZotPets is a relational database project for a mock e-commerce platform connecting pet owners with groomers.  
The goal was to **load, explore, and analyze** data using **PostgreSQL** through advanced SQL techniques such as joins, CTEs, and window functions.  

While the original schema (table creation and ER diagram) was provided, **all data loading, query logic, and analysis were implemented by me** — in [`02_zotpets_queries_and_results.sql`](./02_zotpets_queries_and_results.sql).

---

## Database Description
ZotPets models a real-world pet care system with:
- **Users** (owners and groomers)
- **Pets** linked to owners
- **Services** (Bath, Haircut, Nail Trim)
- **Appointments** between owners and groomers
- **Products & Purchases** with transaction records  

The database contains **9 relational tables**, enforcing primary/foreign key constraints and normalization.

---

## Key Features

### 1. Data Loading
- Imported CSV datasets into PostgreSQL using `COPY` commands.  
- Verified referential integrity and enforced correct data types and constraints.  

### 2. Data Analysis
Developed **10+ analytical SQL queries** to answer core business questions:
- User, pet, and appointment counts  
- Groomers with top ratings (≥ 4.5)  
- Pet owners with ≥ 3 distinct species  
- Groomers offering multiple service categories  
- Yearly top-spending customers and LTV tracking  

### 3. Analytical SQL Techniques
- Multi-table **joins** and **aggregations**  
- **CTEs** for modular, readable logic  
- **Window functions** (`ROW_NUMBER`, `LAG`) for ranking and trends  
- **Array processing** (`string_to_array`, `array_length`) to handle multivalued fields  

### 4. Materialized Lifetime Value (LTV)
- Created a `PetOwnerLTV` view to compute spending per user.  
- Added and updated a `lifetime_value` column in `pet_owner` using `ALTER TABLE` and `UPDATE JOIN`.  
- Validated synchronization between calculated and stored values.

---

## Main Files
| File | Description |
|------|--------------|
| `01_zotpets_schema.sql` | Provided schema creation script (DDL) |
| `02_zotpets_queries_and_results.sql` | **Main implementation file**: data loading, 10+ analytical queries, and final LTV materialization |
| `ZotPetsData/` | CSV datasets |
| `README.md` | Project documentation |
