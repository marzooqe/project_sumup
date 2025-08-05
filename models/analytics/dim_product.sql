SELECT DISTINCT PRODUCT_SKU AS SKU
--    PRODUCT_NAME AS NAME,         -- Data corrupted. same sku has different product names
--    CATEGORY_NAME AS CATEGORY     -- Data corrupted. same sku has different category
FROM {{ ref('transaction') }}