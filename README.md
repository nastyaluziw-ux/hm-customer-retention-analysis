H&M Customer Retention Analysis
What drives a second purchase within 90 days?
A customer-retention portfolio project using 31.8M H&M transaction lines to understand which early customer and purchase characteristics are associated with a second observed purchase within 90 days — and how those findings could inform a CRM experiment.

Analysis window: Jan 2019–May 2020
Primary KPI: 90-day second-purchase rate

View the interactive Looker Studio dashboard · Notebook · SQL

Business Question
The CRM / Retention team wants to understand:

Why do some customers make a second observed purchase within 90 days while others do not?

The goal is to identify actionable retention signals, distinguish association from causality, and translate the analysis into a testable CRM recommendation.

Executive Summary
Metric	Result
Eligible customers	685,335
30-day repeat purchase	21.86%
60-day repeat purchase	30.77%
90-day repeat purchase	37.17%
Retained within 90 days	254,739
Median days to second purchase among retained customers	22 days
Fashion News retention gap	+8.98 pp
Multi-item first-purchase gap	+5.25 pp
Main takeaway
CRM engagement is the strongest actionable retention signal identified. Customers marked as subscribed to Fashion News had 43.53% 90-day retention compared with 34.55% among non-subscribed customers — an observed difference of +8.98 percentage points.

This relationship is observational, not causal, so the project concludes with a randomized CRM experiment design rather than claiming that subscription itself causes higher retention.

Key Findings
1. 90-day retention baseline
Among customers with a complete 90-day observation window in the comparable Jan 2019–May 2020 cohort period:

685,335 customers were eligible.

254,739 made a second observed purchase within 90 days.

Overall 90-day repeat-purchase rate: 37.17%.

The comparable window excludes early cohorts affected by the dataset start boundary and later cohorts without a complete 90-day follow-up period.

2. Fashion News is the strongest actionable CRM signal
Fashion News status	90-day retention
Subscribed	43.53%
Not subscribed	34.55%
Unknown	23.57%
The subscribed vs non-subscribed gap is +8.98 pp with a 95% confidence interval of approximately 8.73 to 9.23 pp.

The gap is also positive across all 17 monthly cohorts in the comparable analysis window. However, fashion_news_frequency is not timestamped and subscription was not randomized, so this finding must be treated as an association.

3. First-purchase basket is an early retention signal
Customers whose first observed purchase contained multiple articles showed higher 90-day retention:

Multiple articles: 38.78%

One article: 33.53%

Raw difference: +5.25 pp

After adjustment for age, missing-age status, first-purchase channel, and first-purchase month, the association remained positive, with an adjusted predicted difference of approximately +4.40 pp.

This supports using first-purchase basket composition as an early segmentation signal, not as a causal driver.

4. Most repeat purchasing happens early
Cumulative repeat-purchase rates increase from:

21.86% within 30 days

30.77% within 60 days

37.17% within 90 days

Among customers who do return within 90 days, the median time to second purchase is 22 days, suggesting that the first month is especially important for retention activity.

5. Cohort timing matters
Monthly 90-day retention declined through much of 2019 and showed signs of recovery in early 2020. This means retention comparisons should account for acquisition / first-purchase timing rather than pooling all customers without cohort context.

Recommended CRM Experiment
The historical Fashion News gap is useful for identifying a testable opportunity, but it does not prove causal impact.

Business question
Can a targeted CRM re-engagement intervention increase the 90-day repeat-purchase rate among eligible customers who are not subscribed to Fashion News?

Experiment design
Parameter	Design
Baseline 90-day retention	34.55%
Minimum detectable effect	+2 pp
Significance level	5%
Statistical power	80%
Allocation	50 / 50
Test	Two-sided
Required sample per group	8,990
Total required sample	17,980
Estimated recruitment	~21 days
Final 90-day readout	~111 days after launch
The +2 pp value is a planning MDE, not an expected uplift. The historical +8.98 pp difference is observational and is not used as a causal treatment-effect assumption.

Methodology
The dataset does not contain an order_id, so a transaction row cannot be treated as a complete customer order. To avoid counting multiple articles bought on the same day as separate repeat purchases, the analysis defines a purchase occasion as:

customer_id + purchase_date
The workflow then:

Audits transaction coverage, customers, articles, channels, and missing values.

Creates one row per unique customer purchase date.

Orders purchase dates within each customer.

Identifies the first and second observed purchase dates.

Calculates days_to_second.

Applies complete 30/60/90-day observation-window eligibility rules.

Builds monthly cohorts and customer-level analysis marts.

Joins customer and first-purchase characteristics.

Compares retention across CRM, basket, channel, category, and cohort segments.

Uses statistical modeling to check whether key associations remain after adjustment.

Performs power analysis for the proposed CRM experiment.

Builds a portfolio dashboard in Looker Studio.

Dataset
H&M Personalized Fashion Recommendations dataset:

transactions_train.csv

customers.csv

articles.csv

Transaction coverage:

31,788,324 transaction lines

1,362,281 unique customers

104,547 unique articles

20 Sep 2018 – 22 Sep 2020

Important grain assumption
Each transaction row represents an article line, not a confirmed order. Because there is no order_id, the project does not claim to reconstruct exact baskets or orders beyond same-day observed purchase occasions.

Technical Stack
SQL / DuckDB — large-scale preparation, lifecycle logic, cohort analysis, and dashboard marts

Python — pandas, statistical analysis, logistic regression, confidence intervals, and power analysis

Looker Studio — interactive business dashboard and storytelling

Git / GitHub — version control and project documentation

Repository Structure
hm-customer-retention-analysis/
├── README.md
├── notebooks/
│   └── 01_retention_data_preparation.ipynb
└── sql/
    ├── dashboard_customer_mart.sql
    └── retention_velocity_30_60_90d.sql
Main files
notebooks/01_retention_data_preparation.ipynb — end-to-end analysis, validation, statistics, and experiment design

sql/retention_velocity_30_60_90d.sql — 30/60/90-day repeat-purchase metrics

sql/dashboard_customer_mart.sql — customer-level mart used to prepare dashboard outputs

Limitations
“First purchase” means the first purchase observed in the dataset, not necessarily the customer's true first-ever H&M purchase.

The dataset does not include an order_id.

fashion_news_frequency is not timestamped, so subscription status at the exact first-purchase moment cannot be confirmed.

Observed segment differences cannot be interpreted as causal treatment effects.

The price field is normalized / undocumented, so the project does not interpret it as EUR revenue or use it for CLV calculations.

Very early cohorts are affected by left-boundary bias; late cohorts may not have enough follow-up time.

Experiment duration is estimated from historical eligible-customer flow and should be recalculated using current production traffic before launch.

Dashboard
The interactive dashboard summarizes the retention baseline, cohort trend, Fashion News association, first-purchase basket signal, return timing, and proposed CRM experiment.
https://datastudio.google.com/s/ooqWVRHK71I
Business Recommendation
Prioritize a randomized CRM re-engagement test among eligible non-subscribed customers.

The analysis suggests that CRM engagement is strongly associated with higher repeat purchase, but only an experiment can determine whether a targeted intervention creates incremental retention. If the test produces a meaningful uplift, the strategy can then be evaluated for broader rollout and further segmentation.
