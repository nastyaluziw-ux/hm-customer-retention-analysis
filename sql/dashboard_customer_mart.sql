
CREATE OR REPLACE TABLE dashboard_customer_mart AS

SELECT
    m.customer_id,
    m.first_date,
    DATE_TRUNC('month', m.first_date)::DATE AS first_month,
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
