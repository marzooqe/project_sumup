{{ config(
    materialized='incremental',
    unique_key='ID'
) }}

SELECT
    CAST(ID AS INTEGER) AS ID,
    CAST(DEVICE_ID AS INTEGER) AS DEVICE_ID,
    PRODUCT_NAME,
    PRODUCT_SKU,               --(to be clarified the source data is corrupted for 1 row)
    CATEGORY_NAME,
    AMOUNT,
    STATUS,
    REGEXP_REPLACE(TRIM(CARD_NUMBER), '\s+', ' ', 'g') AS CARD_NUMBER,
    CVV,
    CREATED_AT,
    HAPPENED_AT
FROM {{ ref('transactions') }} AS TXN

{% if is_incremental() %}
  WHERE TXN.CREATED_AT > (SELECT MAX(CREATED_AT) FROM {{ this }})
{% endif %}