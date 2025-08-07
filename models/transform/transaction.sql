{{ config(
    materialized='incremental',
    unique_key='ID'
) }}

SELECT
    CAST(FLOOR(ID::NUMERIC) AS INTEGER)  AS ID,
    CAST(FLOOR(DEVICE_ID::NUMERIC) AS INTEGER)  AS DEVICE_ID,
    PRODUCT_NAME,
    PRODUCT_SKU,               --(to be clarified the source data is corrupted for 1 row)
    CATEGORY_NAME,
    AMOUNT::FLOAT,
    STATUS,
    REGEXP_REPLACE(TRIM(CARD_NUMBER), '\s+', ' ', 'g') AS CARD_NUMBER,
    CVV,
    CREATED_AT::TIMESTAMP,
    HAPPENED_AT::TIMESTAMP
FROM {{ source('staging','transactions') }} AS TXN

{% if is_incremental() %}
  WHERE TXN.CREATED_AT::TIMESTAMP > (SELECT MAX(CREATED_AT) FROM {{ this }})
{% endif %}