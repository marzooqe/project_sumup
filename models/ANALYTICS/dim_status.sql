SELECT DISTINCT
    MD5(STATUS) AS ID,
    STATUS
FROM {{ ref('transaction') }}