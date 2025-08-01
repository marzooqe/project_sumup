{{ config(
    materialized='incremental',
    unique_key='ID'
) }}

SELECT
    TXN.ID,
    TXN.DEVICE_ID,
    DVC.STORE_ID,
    TXN.PRODUCT_SKU,
    TXN.CREATED_AT,
    TXN.HAPPENED_AT,
    TXN.AMOUNT,
    STS.ID AS STATUS_ID,
    CRD.ID AS CARD_ID
FROM {{ ref('transaction') }} AS TXN
LEFT JOIN {{ ref('dim_device') }} AS DVC ON TXN.DEVICE_ID = DVC.ID
LEFT JOIN {{ ref('dim_status') }} AS STS ON TXN.STATUS = STS.STATUS
LEFT JOIN {{ ref('dim_card_detail') }} AS CRD ON TXN.CARD_NUMBER = CRD.CARD_NUMBER

{% if is_incremental() %}
  WHERE TXN.CREATED_AT > (SELECT MAX(CREATED_AT) FROM {{ this }})
{% endif %}