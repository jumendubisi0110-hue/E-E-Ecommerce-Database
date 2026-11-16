## E&E E-Commerce Database Architecture Report
**Database Engine:** PostgreSQL 18  
**Scope:** Regional Hub Operations (Lagos, Abuja, Rivers)  

## 1. Executive Summary
E&E E-Commerce is a high-volume retail platform operating across multiple regional hubs in Nigeria. This portfolio establishes a robust, production-grade PostgreSQL 18 database architecture balancing strict ACID transactional guarantees for checkout processing, hybrid NoSQL document modeling (`JSONB`) for flexible product catalogs, and declarative partitioning for regional database scaling.

## 2. Core Relational Design (3NF)
The core operational backend utilizes a fully normalized third normal form (3NF) schema comprising six tables:
- **`customers` & `products`**: Master entities with strict constraints (e.g., non-negative pricing and inventory stock checks).
- **`orders` & `order_items`**: Transactional entities capturing checkouts, regional shipping details, and itemized line pricing in Nigerian Naira (NGN).
- **`payments` & `delivery_records`**: Integration tables tracking third-party payment gateways (Paystack/Flutterwave) and logistics providers (GIG Logistics, Red Star Express).

## 3. ACID Transactions & Concurrency Control
To prevent overselling and race conditions during flash sales, checkout workflows utilize explicit transactions (`BEGIN`, `COMMIT`, `ROLLBACK`) alongside pessimistic row-level locking (`SELECT ... FOR UPDATE`). Stock quantities are validated in real time, triggering automatic rollbacks if items go out of stock.

## 4. Hybrid NoSQL (`JSONB`) Catalog
To support dynamic product specifications (such as varying attributes for electronics, apparel, and home goods) without constant schema migrations, the system implements a `product_catalog_docs` table storing semi-structured metadata as PostgreSQL `JSONB` data type, indexed via high-performance GIN indexes for rapid attribute filtering.

## 5. Distributed Scaling & Regional Partitioning
Using PostgreSQL 18 declarative list partitioning, orders are automatically routed to regional child partitions (`orders_lagos`, `orders_abuja`, `orders_rivers`) based on the customer's shipping state, optimizing query performance and data localization.
