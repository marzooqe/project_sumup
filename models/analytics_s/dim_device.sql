SELECT
    ID,
    TYPE,
    STORE_ID
FROM {{ ref('device') }}