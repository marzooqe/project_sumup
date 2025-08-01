
--Average transacted amount per store typology and country

SELECT
    COUNTRY,
    TYPOLOGY,
    ROUND(SUM(AMOUNT) / COUNT(DISTINCT ID), 2) AS AVG_TRANSACTED_AMOUNT
FROM {{ ref('transaction_performance') }}
GROUP BY
    COUNTRY,
    TYPOLOGY
ORDER BY
    COUNTRY ASC,
    AVG_TRANSACTED_AMOUNT DESC