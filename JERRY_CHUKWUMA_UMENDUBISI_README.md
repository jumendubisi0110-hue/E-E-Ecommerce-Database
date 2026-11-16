# E&E E-Commerce: Advanced Database Systems Portfolio

**Organization:** E&E E-Commerce (Regional Hubs: Lagos, Abuja, Rivers)  
**Database Engine:** PostgreSQL 18  
**Author:** Umendubisi Jerry Chukwuma / 301920110 

---

## Project Overview
This repository contains the validated database implementation, concurrency control mechanisms, hybrid JSONB product catalogue, and distributed regional scaling strategy for **E&E E-Commerce**, a high-volume retail platform operating across Nigeria.

## Repository Layout
- `sql/01_schema_ddl.sql`: Core 3NF relational schema (`customers`, `products`, `orders`, `order_items`, `payments`, `delivery_records`).
- `sql/02_transactions_acid.sql`: ACID compliance tests, stock checks, pessimistic row-level locking (`FOR UPDATE`), and error rollbacks.
- `sql/03_nosql_jsonb.sql`: Semi-structured product catalog utilizing `JSONB` documents, `->>` operators, and high-performance GIN indexing.
- `sql/04_distributed_partitioning.sql`: Regional declarative list partitioning across Lagos, Abuja, and Rivers hubs.
- `docs/01_er_diagram.dbml`: Complete entity relationship schema formatted for `dbdiagram.io`.
