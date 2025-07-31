SELECT DISTINCT
    MD5(CARD_NUMBER) AS ID,
    CARD_NUMBER,
    CVV
FROM {{ ref('transaction') }}