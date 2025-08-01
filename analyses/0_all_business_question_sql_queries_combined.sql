--This file holds all the analysis queries combine and with database reference instead of dbt entity reference. 
--This can be directly copied to db and executed.

--Top 10 stores by transacted amount

SELECT
    STORE_NAME,
    SUM(AMOUNT) AS TOTAL_AMOUNT
FROM SUMUP.REPORTING.TRANSACTION_PERFORMANCE
GROUP BY STORE_NAME
ORDER BY TOTAL_AMOUNT DESC
LIMIT 10;

--Top 10 products sold

SELECT
    PRODUCT_SKU,
    COUNT(*) AS TOTAL_QUANTITY,
    SUM(AMOUNT) AS TOTAL_AMOUNT
FROM SUMUP.REPORTING.TRANSACTION_PERFORMANCE
GROUP BY PRODUCT_SKU
ORDER BY TOTAL_QUANTITY DESC, TOTAL_AMOUNT DESC
LIMIT 10;

--Average transacted amount per store typology and country

SELECT
    COUNTRY,
    TYPOLOGY,
    ROUND(SUM(AMOUNT) / COUNT(DISTINCT ID), 2) AS AVG_TRANSACTED_AMOUNT
FROM SUMUP.REPORTING.TRANSACTION_PERFORMANCE
GROUP BY
    COUNTRY,
    TYPOLOGY
ORDER BY
    COUNTRY ASC,
    AVG_TRANSACTED_AMOUNT DESC;

--Percentage of transactions per device type

SELECT
    DEVICE_TYPE,
    ROUND(COUNT(DISTINCT ID) * 100.00 / (SELECT COUNT(DISTINCT ID) FROM SUMUP."REPORTING".TRANSACTION_PERFORMANCE), 2) || '%' AS PCT_TRANSACTIONS
FROM SUMUP.REPORTING.TRANSACTION_PERFORMANCE
GROUP BY DEVICE_TYPE
ORDER BY PCT_TRANSACTIONS DESC;

--Average time for a store to perform its first 5 transactions

WITH BASE_DATA AS (
    SELECT
        TP.STORE_ID,
        TP.STORE_NAME,
        TP.CREATED_AT,
        LEAD(TP.CREATED_AT) OVER (PARTITION BY TP.STORE_ID ORDER BY TP.CREATED_AT) AS NEXT_ORDER_DATE,
        RANK() OVER (PARTITION BY TP.STORE_ID ORDER BY TP.CREATED_AT) AS RANK
    FROM SUMUP.REPORTING.TRANSACTION_PERFORMANCE AS TP
    ORDER BY RANK
)
SELECT
    STORE_ID,
    STORE_NAME,
    AVG(NEXT_ORDER_DATE - CREATED_AT) AS AVG_TIME_TO_FIRST_FIVE_ORDER
FROM BASE_DATA
WHERE RANK <= 5
GROUP BY
    STORE_ID,
    STORE_NAME
ORDER BY
    AVG_TIME_TO_FIRST_FIVE_ORDER;