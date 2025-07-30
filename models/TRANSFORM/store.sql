SELECT 
    ID,
    NAME,
    ADDRESS,
    CITY,
    COUNTRY,
    CREATED_AT,
    TYPOLOGY,
    CUSTOMER_ID
FROM {{ref('stores')}}