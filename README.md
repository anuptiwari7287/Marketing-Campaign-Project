# Marketing Campaign Performance Analysis (SQL)

An end-to-end SQL analysis of **200,000 marketing campaigns** run by five companies across six channels in 2021.
The project answers 16 business questions on channel efficiency, audience targeting, campaign duration, seasonality, company comparison and funnel drop-off, using T-SQL (SQL Server).

## Repository structure

```
marketing-campaign-sql-analysis/
├── data/
│   └── marketing_campaign_dataset.xlsx     # raw dataset (200,000 rows x 16 columns)
├── sql/
│   └── marketing_campaign_analysis.sql     # cleaning view + all analysis queries
├── .gitignore
├── LICENSE
└── README.md
```

## Dataset

| Column | Description |
|---|---|
| Campaign_ID | Unique campaign identifier (1 to 200,000) |
| Company | One of 5 companies (Alpha Innovations, DataTech Solutions, Innovate Industries, NexGen Systems, TechCorp) |
| Campaign_Type | Email, Influencer, Display, Search, Social Media |
| Target_Audience | Men 18-24, Men 25-34, Women 25-34, Women 35-44, All Ages |
| Duration | 15, 30, 45 or 60 days (stored as text, e.g. `30 days`) |
| Channel_Used | Email, Facebook, Google Ads, Instagram, Website, YouTube |
| Conversion_Rate | Share of clicks that converted (0.01 to 0.15) |
| Acquisition_Cost | Campaign spend, 5,000 to 20,000 |
| ROI | Return on investment, 2.0 to 8.0 |
| Location | Chicago, Houston, Los Angeles, Miami, New York |
| Language | English, French, German, Mandarin, Spanish |
| Clicks / Impressions | Funnel volumes |
| Engagement_Score | 1 to 10 |
| Customer_Segment | Fashionistas, Foodies, Health & Wellness, Outdoor Adventurers, Tech Enthusiasts |
| Date | Campaign date, 2021-01-01 to 2021-12-31 |

Data quality checks: 200,000 rows with 200,000 unique IDs, no missing values, and no rows where clicks exceed impressions.

## How to run

1. Load `data/marketing_campaign_dataset.xlsx` into SQL Server as a table named `Marketing_Campaign`
   (SQL Server Management Studio: *Tasks > Import Flat File / Import Data*, or the Import and Export Wizard).
   Keep `Acquisition_Cost` numeric and `Duration` as text.
2. Open `sql/marketing_campaign_analysis.sql` and run it section by section.
   Section 0 creates `vw_marketing_campaign_clean`, which several later queries use.

## Questions answered

| # | Question | Section |
|---|---|---|
| Q1 | Which channel has the highest average ROI and conversion rate? | Channel and campaign type |
| Q2 | Which channel has the lowest cost per click and cost per conversion? | Channel and campaign type |
| Q3 | Which campaign type performs best? | Channel and campaign type |
| Q4 | Which channel + campaign type combination gives the highest ROI? | Channel and campaign type |
| Q5 | Which target audience converts best? | Audience, segment, location |
| Q6 | Which customer segment generates the highest ROI? | Audience, segment, location |
| Q7 | Which city has the best ROI, and is it also the most expensive? | Audience, segment, location |
| Q8 | Does campaign language affect engagement? | Audience, segment, location |
| Q9 | Are longer campaigns more profitable? | Duration |
| Q10-Q12 | Monthly trend, best month and quarter, month-over-month ROI change | Time trends |
| Q13-Q14 | Company ranking and best company within each channel | Company comparison |
| Q15 | Funnel drop-off by channel | Funnel and efficiency |
| Q16 | High-spend, below-average-ROI campaigns (wasted budget) | Funnel and efficiency |

## Key findings

| Area | Result |
|---|---|
| Best channel by ROI | Facebook (about 5.019) |
| Cheapest channel | Website: lowest cost per click (about 22.62) and per conversion (about 281.92) |
| Best campaign type | Influencer (about 5.011) |
| Best channel + type | Facebook + Search (about 5.033) |
| Best customer segment | Foodies (about 5.004) |
| Best city | Miami (about 5.012); it also has the highest total spend (about 504M) |
| Best duration | 30 days (about 5.009) |
| Best month / quarter | September (about 5.029) / Q4 (about 5.006) |
| Weakest month | July (about 4.983) |
| Best company | TechCorp (about 5.007) |
| Funnel | About 10% of impressions click and about 8% of clicks convert, in every channel |
| Wasted budget | 49,858 campaigns (about 25%) spend above average but return below-average ROI |

### Important caveat

Every dimension lands within about 0.05 of an average ROI of 5.0, and conversion rate sits at about 8% everywhere.
These gaps are tiny, so the rankings above should be read as "which is marginally ahead" rather than evidence of a real performance difference.
The dataset looks synthetic (uniformly distributed values), so the main value of this project is the query design and workflow rather than the business conclusions.

## Skills demonstrated

Data cleaning with `TRY_CAST` / `REPLACE`, reusable views, aggregation, CTEs, window functions (`RANK() OVER (PARTITION BY ...)`, `LAG`), date functions, subqueries, and funnel metrics.

## License

Released under the MIT License. See `LICENSE`.
