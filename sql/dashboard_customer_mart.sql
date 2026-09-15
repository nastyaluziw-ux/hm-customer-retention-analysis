-- Customer-level analytical mart for dashboard preparation
-- Grain: one row per eligible customer
-- Population: main comparable retention analysis window
-- Combines retention outcome with first-purchase and CRM characteristics.

CREATE OR REPLACE TABLE dashboard_customer_mart AS

SELECT
    m.customer_id,
    m.first_date,

    STRFTIME(m.first_date, '%Y-%m') AS cohort_month,
    YEAR(m.first_date) * 100 + MONTH(m.first_date) AS cohort_sort,

    m.ret_90d,
    m.n_articles,

    CASE
        WHEN m.n_articles = 1 THEN 'One article'
        ELSE 'Multiple articles'
    END AS article_segment,

    m.first_channel_group,
    f.first_category_group,

    CASE
        WHEN c.fashion_news_frequency IS NULL
            THEN 'Unknown'

        WHEN UPPER(c.fashion_news_frequency) = 'NONE'
            THEN 'Not subscribed'

        WHEN c.fashion_news_frequency IN ('Regularly', 'Monthly')
            THEN 'Subscribed'

        ELSE 'Other'
    END AS news_segment,

    m.age

FROM customer_analysis_mart AS m

LEFT JOIN first_purchase_features AS f
    ON m.customer_id = f.customer_id

LEFT JOIN customers AS c
    ON m.customer_id = c.customer_id;
