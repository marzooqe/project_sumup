{{ config(
    materialized='incremental',
    unique_key='ID'
) }}

SELECT
    CAST(FLOOR(ID::NUMERIC) AS INTEGER)  AS ID,
    CAST(FLOOR(TYPE::NUMERIC) AS INTEGER)  AS TYPE,
    CAST(FLOOR(STORE_ID::NUMERIC) AS INTEGER)  AS STORE_ID
FROM {{ source('staging','devices') }}

{% if is_incremental() %}
WHERE CAST(FLOOR(ID::NUMERIC) AS INTEGER) NOT IN (
    SELECT ID FROM {{ this }}
)
{% endif %}