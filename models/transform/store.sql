{{ config(
    materialized='incremental',
    unique_key='ID'
) }}

SELECT
    CAST(FLOOR(ID::NUMERIC) AS INTEGER)  AS ID,
    NAME,
    ADDRESS,
    CITY,
    COUNTRY,
    CREATED_AT,
    TYPOLOGY,
    CAST(CUSTOMER_ID AS INTEGER) AS CUSTOMER_ID    
FROM {{ source('staging','stores') }}

{% if is_incremental() %}
WHERE CAST(FLOOR(ID::NUMERIC) AS INTEGER) NOT IN (
    SELECT ID FROM {{ this }}
)
{% endif %}