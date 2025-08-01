
--Top 10 stores by transacted amount

SELECT
    STORE_NAME,
    SUM(AMOUNT) AS TOTAL_AMOUNT
FROM {{ ref('transaction_performance') }}
GROUP BY STORE_NAME
ORDER BY TOTAL_AMOUNT DESC
LIMIT 10