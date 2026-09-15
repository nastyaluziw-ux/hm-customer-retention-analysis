-- Aggregated source for the final Looker Studio dashboard
-- Grain: one row per analysis segment
-- Source tables: dashboard_customer_mart and customer_lifecycle
-- Retention rates are stored as proportions (0–1) for dashboard formatting.

CREATE OR REPLACE TABLE dashboard_summary AS

-- Overall KPI
SELECT
    'Overall' AS analysis_type,
    'Overall' AS segment,
    1 AS sort_order,
    COUNT(*) AS customers,
    SUM(ret_90d) AS retained_90d,
    AVG(ret_90d) AS retention_90d,
    8.98 AS crm_gap_pp,
    2.00 AS ab_mde_pp,
    17980 AS ab_sample_total,
    21 AS recruitment_days,
    111 AS final_readout_days
FROM dashboard_customer_mart


UNION ALL

-- Monthly first-purchase cohorts
SELECT
    'Cohort' AS analysis_type,
    cohort_month AS segment,
    cohort_sort AS sort_order,
    COUNT(*) AS customers,
    SUM(ret_90d) AS retained_90d,
    AVG(ret_90d) AS retention_90d,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
FROM dashboard_customer_mart
GROUP BY cohort_month, cohort_sort


UNION ALL

-- Fashion News status
SELECT
    'Fashion News' AS analysis_type,
    news_segment AS segment,
    CASE
        WHEN news_segment = 'Subscribed' THEN 1
        WHEN news_segment = 'Not subscribed' THEN 2
        ELSE 3
    END AS sort_order,
    COUNT(*) AS customers,
    SUM(ret_90d) AS retained_90d,
    AVG(ret_90d) AS retention_90d,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
FROM dashboard_customer_mart
GROUP BY news_segment


UNION ALL

-- First-purchase basket
SELECT
    'Basket' AS analysis_type,
    article_segment AS segment,
    CASE
        WHEN article_segment = 'Multiple articles' THEN 1
        ELSE 2
    END AS sort_order,
    COUNT(*) AS customers,
    SUM(ret_90d) AS retained_90d,
    AVG(ret_90d) AS retention_90d,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
FROM dashboard_customer_mart
GROUP BY article_segment


UNION ALL

-- First-purchase channel
SELECT
    'Channel' AS analysis_type,
    first_channel_group AS segment,
    1 AS sort_order,
    COUNT(*) AS customers,
    SUM(ret_90d) AS retained_90d,
    AVG(ret_90d) AS retention_90d,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
FROM dashboard_customer_mart
GROUP BY first_channel_group


UNION ALL

-- First-purchase product category
SELECT
    'Category' AS analysis_type,
    first_category_group AS segment,
    1 AS sort_order,
    COUNT(*) AS customers,
    SUM(ret_90d) AS retained_90d,
    AVG(ret_90d) AS retention_90d,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
FROM dashboard_customer_mart
GROUP BY first_category_group


UNION ALL

-- Retained vs non-retained customers
SELECT
    'Retention Status' AS analysis_type,
    'Retained' AS segment,
    1 AS sort_order,
    SUM(ret_90d) AS customers,
    SUM(ret_90d) AS retained_90d,
    AVG(ret_90d) AS retention_90d,
    NULL AS crm_gap_pp,
    NULL AS ab_mde_pp,
    NULL AS ab_sample_total,
    NULL AS recruitment_days,
    NULL AS final_readout_days
FROM dashboard_customer_mart

UNION ALL

SELECT
    'Retention Status',
    'Not retained',
    2,
    COUNT(*) - SUM(ret_90d),
    0,
    1 - AVG(ret_90d),
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
FROM dashboard_customer_mart



-- 30-day repeat purchase
SELECT
    'Retention Window',
    '30 days',
    30,
    COUNT(*),
    SUM(
        CASE
            WHEN days_to_second <= 30 THEN 1
            ELSE 0
        END
    ),
    AVG(
        CASE
            WHEN days_to_second <= 30 THEN 1.0
            ELSE 0.0
        END
    ),
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
FROM customer_lifecycle
WHERE eligible_90d = 1
  AND first_date >= DATE '2019-01-01'
  AND first_date < DATE '2020-06-01'


UNION ALL

-- 60-day repeat purchase
SELECT
    'Retention Window',
    '60 days',
    60,
    COUNT(*),
    SUM(
        CASE
            WHEN days_to_second <= 60 THEN 1
            ELSE 0
        END
    ),
    AVG(
        CASE
            WHEN days_to_second <= 60 THEN 1.0
            ELSE 0.0
        END
    ),
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
FROM customer_lifecycle
WHERE eligible_90d = 1
  AND first_date >= DATE '2019-01-01'
  AND first_date < DATE '2020-06-01'


UNION ALL

-- 90-day repeat purchase
SELECT
    'Retention Window',
    '90 days',
    90,
    COUNT(*),
    SUM(ret_90d),
    AVG(ret_90d),
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
FROM customer_lifecycle
WHERE eligible_90d = 1
  AND first_date >= DATE '2019-01-01'
  AND first_date < DATE '2020-06-01';
