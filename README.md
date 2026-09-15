# H&M Customer Retention Analysis

## What drives a second purchase within 90 days?

A customer-retention analysis using **31.8M H&M transaction lines** to understand which early customer and purchase characteristics are associated with a second observed purchase within 90 days — and how those insights could support a CRM retention strategy.

**Analysis window:** Jan 2019–May 2020  
**Primary KPI:** 90-day second-purchase rate

###  📊 Interactive Dashboard

[View the interactive Looker Studio dashboard →](https://datastudio.google.com/s/ooqWVRHK71I)

### Dashboard Preview

[📄 View the dashboard PDF →](hm_retention_dashboard.pdf)

*Static preview of the final H&M Customer Retention Dashboard.*

---

## Business Problem

The CRM / Retention team wants to understand:

> **Why do some customers make a second observed purchase within 90 days while others do not?**

The objective is to identify actionable retention signals, understand when customers are most likely to return, and translate the findings into a testable CRM recommendation.

---

## Executive Summary

| Metric | Result |
|---|---:|
| Eligible customers | **685,335** |
| 30-day repeat purchase | **21.86%** |
| 60-day repeat purchase | **30.77%** |
| 90-day repeat purchase | **37.17%** |
| Customers retained within 90 days | **254,739** |
| Median days to second purchase among retained customers | **22 days** |
| Fashion News retention gap | **+8.98 pp** |
| Multi-item first-purchase gap | **+5.25 pp** |

### Key Insight

**CRM engagement is the strongest actionable retention signal identified.**

Customers marked as subscribed to Fashion News showed **43.53% 90-day retention**, compared with **34.55%** among non-subscribed customers — an observed difference of **+8.98 percentage points**.

However, this relationship is **observational, not causal**.

For that reason, the project concludes with a randomized CRM experiment proposal rather than assuming that Fashion News subscription itself causes higher retention.

---

# Key Findings

## 1. Overall 90-Day Retention

Within the comparable Jan 2019–May 2020 analysis window:

- **685,335** customers had a complete 90-day observation window.
- **254,739** customers made a second observed purchase within 90 days.
- Overall 90-day retention was **37.17%**.

Customers without sufficient follow-up time were excluded to avoid incorrectly classifying them as non-retained.

---

## 2. Fashion News Is the Strongest CRM Signal

| Fashion News Status | 90-Day Retention |
|---|---:|
| Subscribed | **43.53%** |
| Not subscribed | **34.55%** |
| Unknown | **23.57%** |

The observed difference between subscribed and non-subscribed customers is:

**+8.98 percentage points**

The estimated 95% confidence interval for this difference is approximately:

**8.73 pp to 9.23 pp**

The relationship was also positive across all 17 monthly cohorts in the comparable analysis window.

### Important

`fashion_news_frequency` is not timestamped and customers were not randomly assigned to subscription status.

Therefore:

> **This is an association, not evidence of causality.**

---

## 3. First-Purchase Basket Is an Early Retention Signal

Customers who purchased multiple articles during their first observed purchase occasion showed higher 90-day retention.

| First-Purchase Basket | 90-Day Retention |
|---|---:|
| Multiple articles | **38.78%** |
| One article | **33.53%** |

Observed difference:

**+5.25 percentage points**

After adjusting for age, missing-age status, first-purchase channel, and first-purchase month, the association remained positive.

Adjusted predicted retention difference:

**≈ +4.40 pp**

This suggests that first-purchase basket composition may be useful as an early customer segmentation signal.

It should not be interpreted as a causal driver of retention.

---

## 4. Most Repeat Purchasing Happens Early

Cumulative repeat-purchase rates were:

| Retention Window | Repeat-Purchase Rate |
|---|---:|
| 30 days | **21.86%** |
| 60 days | **30.77%** |
| 90 days | **37.17%** |

Among customers who returned within 90 days, the median time to the second observed purchase was:

**22 days**

This suggests that the first month after the initial purchase may be especially important for CRM retention activity.

---

## 5. Cohort Timing Matters

90-day retention varies across first-purchase cohorts.

Retention declined through much of 2019 before showing signs of recovery in early 2020.

This means retention should not be evaluated only as one global number.

Customer acquisition timing and cohort effects should also be considered when comparing retention performance.

---

# Recommended CRM Experiment

The Fashion News analysis identifies a strong CRM opportunity.

However, the historical **+8.98 pp gap is observational**.

To determine whether CRM activity can actually increase repeat purchasing, I designed a randomized experiment.

## Business Question

> **Can a targeted CRM re-engagement intervention increase the 90-day repeat-purchase rate among eligible customers who are not subscribed to Fashion News?**

## Experiment Design

| Parameter | Design |
|---|---:|
| Baseline retention | **34.55%** |
| Minimum Detectable Effect | **+2 pp** |
| Significance level | **5%** |
| Statistical power | **80%** |
| Allocation | **50 / 50** |
| Test | **Two-sided** |
| Required sample per group | **8,990** |
| Total sample required | **17,980** |
| Estimated recruitment period | **~21 days** |
| Final 90-day readout | **~111 days after launch** |

The **+2 pp MDE** is a planning assumption, not an expected uplift.

The historical **+8.98 pp retention difference** is not used as the expected treatment effect because it was not generated by a randomized experiment.

---
# Methodology

The H&M dataset does not contain an `order_id`.

Each transaction row represents an article-level transaction line rather than a confirmed complete customer order.

To avoid counting several articles purchased by the same customer on the same day as separate repeat purchases, I defined an observed purchase occasion as:

```text
customer_id + purchase_date
```

This means that multiple article lines purchased by the same customer on the same date are treated as **one purchase occasion** for retention analysis.

The analytical workflow was:

1. Audited the transaction data, including date coverage, customers, articles, sales channels, missing values, and transaction-line distribution.
2. Created one row per unique customer purchase date.
3. Ordered each customer's purchase dates chronologically using SQL window functions.
4. Identified the first and second observed purchase dates.
5. Calculated the number of days between the first and second observed purchase (`days_to_second`).
6. Defined eligibility rules for complete 30-day, 60-day, and 90-day observation windows.
7. Excluded customers who entered the dataset too late to have the full required follow-up period.
8. Built monthly first-purchase cohorts to compare retention over time.
9. Created customer-level analytical tables combining retention outcomes with customer and first-purchase characteristics.
10. Compared retention across Fashion News status, first-purchase basket size, sales channel, product category, and cohort.
11. Used statistical analysis to evaluate uncertainty and determine whether the strongest associations remained after adjustment.
12. Performed power analysis for a proposed randomized CRM experiment.
13. Prepared aggregated tables for the final Looker Studio dashboard.

## Retention Definition

The primary retention metric was defined as:

```text
Customers with a second observed purchase within 90 days
--------------------------------------------------------- × 100
Customers with a complete 90-day observation window
```

This eligibility rule is important because customers who entered the dataset near the end of the observation period did not have enough time to demonstrate whether they would return within 90 days.

Including those customers as non-retained would artificially lower the retention rate.

The same eligibility logic was also applied to the 30-day and 60-day retention windows.

## Cohort Definition

Customers were grouped by the month of their first observed purchase.

For each monthly cohort, 90-day retention was calculated only among customers with a complete 90-day observation window.

The comparable cohort period used for the main analysis was:

**January 2019 to May 2020**

Earlier cohorts were excluded from the main comparison because the dataset begins in September 2018. For these customers, the first transaction observed in the dataset may not represent their true first purchase.

Later cohorts were excluded when they did not have enough follow-up time to complete the full 90-day retention window.

This approach reduces both:

- **Left-boundary bias** from customers whose purchasing history may have started before the dataset.
- **Right-censoring bias** from customers who do not have enough future observation time.

## Customer-Level Analysis

After defining the retention outcome, I combined customer information with first-purchase characteristics to create a customer-level analytical dataset.

The main variables used for segmentation included:

- Fashion News subscription status
- Number of articles in the first observed purchase
- First-purchase sales channel
- First-purchase product category
- Customer age
- First-purchase month
- 90-day retention outcome

This customer-level structure was used for descriptive comparisons, statistical analysis, adjusted modeling, and dashboard preparation.

## Fashion News Analysis

Customers were segmented using `fashion_news_frequency`.

The resulting 90-day retention rates were:

| Fashion News Status | 90-Day Retention |
|---|---:|
| Subscribed | **43.53%** |
| Not subscribed | **34.55%** |
| Unknown | **23.57%** |

The observed retention difference between subscribed and non-subscribed customers was:

**+8.98 percentage points**

The estimated 95% confidence interval was approximately:

**8.73 pp to 9.23 pp**

The subscribed vs non-subscribed gap was also positive across all 17 monthly cohorts in the comparable analysis window.

However, this result is observational.

`fashion_news_frequency` is not timestamped, and customers were not randomly assigned to subscription status.

Therefore, the result is interpreted as an **association rather than a causal effect**.

## First-Purchase Basket Analysis

Because the dataset does not contain an `order_id`, I did not reconstruct exact customer orders.

Instead, I analyzed how many unique articles appeared in the customer's first observed purchase occasion.

Customers were divided into:

- **One article**
- **Multiple articles**

Observed 90-day retention was:

| First-Purchase Basket | 90-Day Retention |
|---|---:|
| Multiple articles | **38.78%** |
| One article | **33.53%** |

The raw difference was:

**+5.25 percentage points**

To test whether this relationship remained after accounting for other customer characteristics, I used logistic regression.

The adjusted model included:

- Age
- Missing-age indicator
- First-purchase sales channel
- First-purchase month

After adjustment, the association remained positive.

Adjusted predicted retention was approximately:

- **38.51%** for customers with multiple articles
- **34.11%** for customers with one article

Adjusted difference:

**≈ +4.40 percentage points**

This suggests that first-purchase basket composition may be useful as an early segmentation signal.

It should not be interpreted as a causal driver of retention.

## Retention Timing

I also measured how quickly customers returned after their first observed purchase.

Cumulative repeat-purchase rates were:

| Retention Window | Repeat-Purchase Rate |
|---|---:|
| 30 days | **21.86%** |
| 60 days | **30.77%** |
| 90 days | **37.17%** |

Among customers who returned within 90 days, the median time to the second observed purchase was:

**22 days**

This indicates that a substantial share of repeat purchasing occurs early in the customer lifecycle.

For CRM planning, the first month after the initial purchase may therefore be an especially important intervention window.

## Statistical Analysis

The strongest observed differences were evaluated beyond simple descriptive comparisons.

The analysis included:

- Retention-rate comparisons
- Percentage-point differences
- Confidence intervals
- Cohort-level consistency checks
- Logistic regression
- Adjusted predicted probabilities
- Experiment power analysis

The purpose of the statistical analysis was not only to identify differences, but also to assess whether the strongest relationships remained meaningful after considering other factors.

Observed relationships are treated as **associations** unless they are generated by a randomized experiment.

## CRM Experiment Design

The strongest actionable CRM signal identified in the analysis was the retention difference between Fashion News subscribers and non-subscribers.

Because this difference comes from observational data, I did not interpret the historical **+8.98 pp** gap as a causal treatment effect.

Instead, I used the finding to define a testable business opportunity.

The proposed experiment asks:

> **Can a targeted CRM re-engagement intervention increase the 90-day repeat-purchase rate among eligible customers who are not subscribed to Fashion News?**

The experiment assumptions were:

| Parameter | Value |
|---|---:|
| Baseline 90-day retention | **34.55%** |
| Minimum Detectable Effect | **+2 pp** |
| Significance level | **5%** |
| Statistical power | **80%** |
| Allocation | **50 / 50** |
| Hypothesis test | **Two-sided** |

The power analysis estimated:

- **8,990 customers per group**
- **17,980 customers in total**

Based on historical eligible non-subscribed customer flow, the estimated recruitment period was approximately:

**21 days**

Because the primary metric requires a complete 90-day follow-up period, the final experiment readout would occur approximately:

**111 days after launch**

This consists of:

```text
~21 days recruitment
+
90 days follow-up for the final recruited customers
=
~111 days until final readout
```

The **+2 pp MDE** is a planning assumption used for sample-size calculation.

It is **not a predicted uplift**.

The historical **+8.98 pp Fashion News retention gap** is observational and was not used as the expected treatment effect.

## Dashboard Preparation

After completing the analytical work, I created aggregated summary tables for the final Looker Studio dashboard.

The dashboard was designed to communicate the main business story:

1. What is the overall 90-day retention rate?
2. When do customers return?
3. How does retention change across monthly cohorts?
4. Which customer characteristics are associated with higher retention?
5. Which signal is most actionable for CRM?
6. What experiment should the business run next?

The final dashboard includes:

- Eligible customers
- Overall 90-day retention
- Retained vs non-retained customers
- Fashion News retention differences
- First-purchase cohort trends
- 30-day, 60-day, and 90-day repeat-purchase rates
- First-purchase basket differences
- CRM experiment recommendation

The dashboard is available here:

### [View the Interactive H&M Customer Retention Dashboard](https://datastudio.google.com/s/ooqWVRHK71I)
