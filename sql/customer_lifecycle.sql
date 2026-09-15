-- Customer lifecycle and 90-day retention
-- Grain: one row per customer
-- Purchase definition: one unique purchase date per customer
-- Customers without a complete 90-day observation window are excluded
-- from the 90-day retention denominator.

CREATE OR REPLACE TABLE customer_purchase_dates AS

SELECT DISTINCT
    customer_id,
    t_dat
FROM transactions;


CREATE OR REPLACE TABLE customer_lifecycle AS

WITH sequenced_purchases AS (

    SELECT
        customer_id,
        t_dat,

        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY t_dat
        ) AS purchase_number,

        LEAD(t_dat) OVER (
            PARTITION BY customer_id
            ORDER BY t_dat
        ) AS next_purchase_date

    FROM customer_purchase_dates
)

SELECT
    customer_id,

    t_dat AS first_date,

    next_purchase_date AS second_date,

    DATE_DIFF(
        'day',
        t_dat,
        next_purchase_date
    ) AS days_to_second,

    CASE
        WHEN t_dat <= DATE '2020-06-24' THEN 1
        ELSE 0
    END AS eligible_90d,

    CASE
        WHEN t_dat > DATE '2020-06-24' THEN NULL

        WHEN next_purchase_date IS NOT NULL
             AND DATE_DIFF(
                 'day',
                 t_dat,
                 next_purchase_date
             ) <= 90
        THEN 1

        ELSE 0
    END AS ret_90d

FROM sequenced_purchases

WHERE purchase_number = 1;
