# From First Purchase to Loyal Customer

## 90-Day Cohort Retention and Second-Purchase Analysis for H&M

> **Project status:** Work in progress

## Business Problem

The Customer Retention and CRM team wants to understand which customer, channel, and first-purchase characteristics are associated with a second observed purchase within 90 days.

The analysis aims to identify customer segments with lower repeat-purchase rates and support future CRM experiments designed to improve retention.

## Primary KPI

**90-day second-purchase rate**

```text
Customers with a second observed purchase within 90 days
--------------------------------------------------------- × 100
Customers with a complete 90-day observation window
```

Customers whose first observed purchase occurred too close to the end of the dataset are excluded because they do not have a complete 90-day follow-up period.

## Dataset

The project uses the H&M Personalized Fashion Recommendations dataset:

* `transactions_train.csv`
* `customers.csv`
* `articles.csv`

The transaction dataset contains:

* 31,788,324 transaction lines
* 1,362,281 unique customers
* 104,547 unique articles
* Dates from 20 September 2018 to 22 September 2020

## Transaction Grain

Each row in the transaction dataset represents one article transaction line. It does not necessarily represent a complete order.

Because the dataset does not contain an `order_id`, exact customer orders cannot be identified. For retention analysis, an observed purchase occasion is defined as a unique combination of:

```text
customer_id + purchase date
```

Using the purchase date prevents multiple articles purchased by the same customer on the same day from being incorrectly counted as repeat purchases.

## Methodology

The current SQL workflow:

1. Audits the transaction schema, missing values, date coverage, customers, articles, and sales channels.
2. Creates one row per unique customer purchase date.
3. Orders each customer’s purchase dates using `ROW_NUMBER()`.
4. Identifies the next observed purchase using `LEAD()`.
5. Calculates the number of days between the first and second observed purchases.
6. Excludes customers without a complete 90-day follow-up period.
7. Calculates overall and monthly cohort retention.

## Preliminary Results

* Eligible customers: **1,291,147**
* Customers retained within 90 days: **607,798**
* Raw overall 90-day retention: **47.07%**
* Main comparable cohort window: **January 2019 to May 2020**
* Weighted retention in the main window: **37.17%**
* Monthly retention range in the main window: **29.78%–43.38%**

The raw overall rate is strongly influenced by the first observed cohorts. These customers may have purchased before the dataset began, so their first transaction in the dataset is not necessarily their true first purchase.

## Important Limitations

* The dataset does not include an `order_id`.
* “First purchase” means the first purchase observed in the available data, not necessarily the customer’s first-ever purchase.
* The first cohorts are affected by the beginning of the observation period.
* The final cohort is only partially represented.
* The currency and transformation applied to `price` are not documented, so it will not be interpreted as revenue in euros.
* Transaction outliers are retained because there is insufficient evidence to classify them as errors.
* Sales-channel labels will not be assumed without supporting documentation.
* Observed associations cannot be interpreted as causal effects.

## Tools

* **DuckDB and SQL:** large-scale data preparation and retention analysis
* **Python and pandas:** statistical analysis and validation
* **Tableau:** dashboard and business communication
* **Git and GitHub:** version control and project documentation

## Repository Structure

```text
sql/         SQL audit, preparation, lifecycle, cohort, and segment queries
notebooks/   Python statistical analysis
outputs/     Small aggregated results
tableau/     Dashboard preview and Tableau Public link
docs/        Data dictionary, methodology, and limitations
```

## Next Steps

* Calculate comparable 30-day, 60-day, and 90-day retention metrics.
* Audit and join the customer and article tables.
* Analyze retention by channel and first-purchase characteristics.
* Estimate uncertainty and compare customer segments statistically.
* Build the Tableau dashboard.
* Develop CRM recommendations and an A/B test proposal.

