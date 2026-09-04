-- Retention velocity: 30, 60 and 90 days
-- Grain: one summary row for the main comparable customer population
-- Population: customers with a full 90-day observation window whose first
-- observed purchase occurred between January 2019 and May 2020
-- Metrics: cumulative second-purchase rates and median days to second purchase
-- among customers retained within 90 days

WITH main_population AS (
SELECT
    days_to_second,
    customer_id,
    first_date,
    ret_90d,
    CASE
      WHEN days_to_second <= 30 THEN 1
      ELSE 0
    END AS ret_30d,
    CASE
      WHEN days_to_second <= 60 THEN 1
      ELSE 0
    END AS ret_60d
FROM customer_lifecycle
WHERE eligible_90d= 1
AND first_date >= DATE '2019-01-01'
AND first_date < DATE '2020-06-01'
)
SELECT
    COUNT(*) AS eligible_customers,
    SUM(ret_30d) AS retained_30d,
    ROUND(AVG(ret_30d)*100.0,2) AS ret_30d_pct,
    SUM(ret_60d) AS retained_60d,
    ROUND(AVG(ret_60d) * 100.0,2) AS ret_60d_pct,
    SUM(ret_90d) AS retained_90d,
    ROUND(AVG(ret_90d)* 100.0,2) AS ret_90d_pct,
    MEDIAN(
       CASE
         WHEN ret_90d =1 THEN days_to_second
         ELSE NULL
         END) AS median_days_to_second
FROM main_population;