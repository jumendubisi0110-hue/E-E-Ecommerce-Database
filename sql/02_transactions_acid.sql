-- ==========================================================
-- E&E E-Commerce: ACID Transactions & Concurrency Control
-- Database Engine: PostgreSQL 18
-- ==========================================================

-- SCENARIO A: Successful Transaction (Commit)
BEGIN;

-- 1. Check stock and lock the product row pessimistically
SELECT product_id, stock_quantity 
FROM products 
WHERE product_id = 1 
FOR UPDATE;

-- 2. Insert Order Header
INSERT INTO orders (customer_id, total_amount_ngn, shipping_street_address, shipping_city, shipping_state)
VALUES (1, 450000.00, '15 Admiralty Way, Lekki Phase 1', 'Lagos', 'Lagos');

-- 3. Insert Order Item
INSERT INTO order_items (order_id, product_id, quantity, unit_price_ngn)
VALUES (currval('orders_order_id_seq'), 1, 1, 450000.00);

-- 4. Deduct Stock Quantity
UPDATE products 
SET stock_quantity = stock_quantity - 1 
WHERE product_id = 1;

-- 5. Record Payment
INSERT INTO payments (order_id, amount_ngn, payment_method, payment_reference, payment_status)
VALUES (currval('orders_order_id_seq'), 450000.00, 'Paystack', 'PAY_REF_99882211', 'SUCCESS');

COMMIT;


-- SCENARIO B: Out-of-Stock Conflict (Rollback)
BEGIN;

-- Attempt to lock product with insufficient stock
SELECT product_id, stock_quantity 
FROM products 
WHERE product_id = 2 
FOR UPDATE;

-- Simulated check: If stock is 0, trigger manual rollback
-- (In application code, this condition halts execution)
ROLLBACK;
