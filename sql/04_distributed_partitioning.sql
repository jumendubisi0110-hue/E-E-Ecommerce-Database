-- ==========================================================
-- E&E E-Commerce: Regional Declarative Partitioning
-- Database Engine: PostgreSQL 18
-- ==========================================================

-- Clean reset
DROP TABLE IF EXISTS orders CASCADE;

-- 1. Create Parent Partitioned Table (Partitioned by shipping_state)
CREATE TABLE orders (
    order_id INT GENERATED ALWAYS AS IDENTITY,
    customer_id INT NOT NULL,
    order_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    total_amount_ngn NUMERIC(14, 2) NOT NULL,
    shipping_state VARCHAR(100) NOT NULL,
    PRIMARY KEY (order_id, shipping_state)
) PARTITION BY LIST (shipping_state);

-- 2. Create Regional Hub Child Partitions
-- Shard 1: Lagos Regional Hub
CREATE TABLE orders_lagos PARTITION OF orders
    FOR VALUES IN ('Lagos', 'Ogun', 'Oyo');

-- Shard 2: Abuja Regional Hub (North-Central)
CREATE TABLE orders_abuja PARTITION OF orders
    FOR VALUES IN ('Abuja FCT', 'Kaduna', 'Kano');

-- Shard 3: Rivers Regional Hub (South-South)
CREATE TABLE orders_rivers PARTITION OF orders
    FOR VALUES IN ('Rivers', 'Delta', 'Edo');

-- 3. Test Insert Routing
INSERT INTO orders (customer_id, total_amount_ngn, shipping_state) 
VALUES (1, 850000.00, 'Lagos');

INSERT INTO orders (customer_id, total_amount_ngn, shipping_state) 
VALUES (2, 420000.00, 'Abuja FCT');

-- 4. Verify Shard Routing Execution
SELECT tableoid::regclass AS stored_shard, order_id, shipping_state, total_amount_ngn 
FROM orders;
