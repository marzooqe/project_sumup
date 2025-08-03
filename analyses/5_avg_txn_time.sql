
--Average time for a store to perform its first 5 transactions
--The store created date is later than transaction date, also the happened date is earlier than txn created date

WITH BASE_DATA AS (
    SELECT
        TP.STORE_ID,
        TP.STORE_NAME,
        TP.TRANSACTION_CREATED_AT,
        RANK() OVER (PARTITION BY TP.STORE_ID ORDER BY TP.TRANSACTION_CREATED_AT) AS RANK
    FROM {{ ref('transaction_performance') }} AS TP
    ORDER BY RANK
)
SELECT
    STORE_ID,
    STORE_NAME,
    MAX(CASE WHEN RANK = 5 THEN TRANSACTION_CREATED_AT END) -
    MAX(CASE WHEN RANK = 1 THEN TRANSACTION_CREATED_AT END) AS AVG_TIME_TO_FIRST_5_TXN
FROM BASE_DATA
WHERE RANK <= 5
GROUP BY
    STORE_ID,
    STORE_NAME
HAVING COUNT(*) = 5
ORDER BY AVG_TIME_TO_FIRST_5_TXN