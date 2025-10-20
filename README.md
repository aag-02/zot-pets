# ZotPets — PostgreSQL & Cassandra ETL Project

## Overview

**ZotPets** is a data engineering and analytics project built around a mock pet-care platform connecting pet owners and groomers.
The project demonstrates:

* **Relational data modeling and analysis** in **PostgreSQL**, and
* **NoSQL migration and schema design** in **Cassandra (DataStax Astra)** using an **ETL pipeline**.

---

## Architecture Summary

**PostgreSQL → CSV → Cassandra (DataStax Astra)**

* **Extract**: Exported relational data from PostgreSQL using `\copy`.
* **Transform**: Reformatted timestamps to UTC ISO-8601 and denormalized schemas for query-first access patterns.
* **Load**: Imported into Cassandra using `dsbulk`

---

## PostgreSQL Highlights

* Loaded **9 normalized relational tables** via `COPY` with full referential integrity.
* Wrote **10+ advanced SQL queries** using:

  * Multi-table **joins**
  * **CTEs** and **window functions** (`ROW_NUMBER`, `LAG`)
  * **Subqueries** and **array functions**
* Built a **PetOwnerLTV** view and **lifetime_value** column to compute and persist customer value metrics.

---

## Cassandra Highlights

* **Engineered a batch ETL pipeline** to migrate relational data into **Cassandra (DataStax Astra)** using `dsbulk`.
* Designed **query-optimized, denormalized schemas** with proper partition and clustering keys for low-latency reads:
  
