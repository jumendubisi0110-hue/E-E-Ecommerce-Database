-- ==========================================================
-- E&E E-Commerce: Hybrid NoSQL JSONB Catalog
-- Database Engine: PostgreSQL 18
-- ==========================================================

-- 1. Create JSONB Product Catalog Table
CREATE TABLE IF NOT EXISTS product_catalog_docs (
    document_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sku VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(100) NOT NULL,
    document_data JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 2. Create High-Performance GIN Index for Flexible Attribute Searching
CREATE INDEX idx_gin_product_metadata ON product_catalog_docs USING gin (document_data);

-- 3. Insert Sample Semi-Structured Product Documents
INSERT INTO product_catalog_docs (sku, category, document_data) VALUES
('ELEC-LAP-001', 'Electronics', '{
    "brand": "HP",
    "model": "Pavilion 15",
    "processor": "Intel Core i7",
    "ram_gb": 16,
    "storage": "512GB SSD",
    "warranty_months": 12,
    "features": ["Backlit Keyboard", "Fingerprint Reader", "Windows 11"]
}'),
('ELEC-PHN-002', 'Mobile Phones', '{
    "brand": "Samsung",
    "model": "Galaxy S24",
    "storage": "256GB",
    "color": "Phantom Black",
    "screen_size_inches": 6.2,
    "5g_supported": true
}');

-- 4. Query JSONB Attributes Using Arrow Operators
-- Query: Find all products with 16GB RAM or greater
SELECT sku, document_data->>'brand' AS brand, document_data->>'model' AS model
FROM product_catalog_docs
WHERE (document_data->>'ram_gb')::int >= 16;

-- 5. Query Nested JSONB Array (Find products with Backlit Keyboard feature)
SELECT sku, document_data->>'brand' AS brand
FROM product_catalog_docs
WHERE document_data->'features' @> '"Backlit Keyboard"';
