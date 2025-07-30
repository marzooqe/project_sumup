SELECT 
    ID,
    DEVICE_ID,
    PRODUCT_NAME,
    PRODUCT_SKU,
    CATEGORY_NAME,
    AMOUNT,
    STATUS,
    CARD_NUMBER,
    CVV,
    CREATED_AT,
    HAPPENED_AT
FROM {{ref('transactions')}}