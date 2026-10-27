-- Data Cleaning
SELECT
    Campaign_ID,
    Company,
    Campaign_Type,
    Target_Audience,
    TRY_CAST(REPLACE(Duration, ' days', '') AS INT)                              AS duration_days,
    Channel_Used,
    CAST(Conversion_Rate AS FLOAT)                                               AS conversion_rate,
    TRY_CAST(REPLACE(REPLACE(Acquisition_Cost, '$', ''), ',', '') AS DECIMAL(12,2)) AS acquisition_cost,
    CAST(ROI AS FLOAT)                                                           AS roi,
    Location,
    Language,
    Clicks,
    Impressions,
    Engagement_Score                                                             AS engagement_score,
    Customer_Segment,
    TRY_CAST([Date] AS DATE)                                                     AS campaign_date
FROM marketing_campaign;
--Overall Performance

-- rows vs unique IDs
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT Campaign_ID) AS unique_ids
FROM marketing_campaign;

-- impossible rows
SELECT COUNT(*) AS bad_rows FROM Marketing_Campaign WHERE Clicks > Impressions;

-- ranges and conversion failures
SELECT MIN(roi) AS min_roi, MAX(roi) AS max_roi, AVG(roi) AS avg_roi,
       MIN(acquisition_cost) AS min_cost, MAX(acquisition_cost) AS max_cost,
       SUM(CASE WHEN acquisition_cost IS NULL OR date IS NULL THEN 1 ELSE 0 END) AS failed_conversions
FROM Marketing_Campaign;

/*Channel and campaign type*/

-- Which channel has the highest average ROI and conversion rate?

SELECT TOP 1 Channel_used,
AVG(ROI) AS Average_Roi,
AVG(Conversion_rate) AS Avg_Conversion_Rate
  FROM Marketing_Campaign
GROUP BY Channel_Used
ORDER BY Avg_Conversion_Rate DESC

-- Which channel has the lowest cost per click and cost per conversion?
 
SELECT Channel_Used,
      ROUND( SUM(acquisition_cost) / SUM(Clicks), 2)AS cost_per_click,
       ROUND(SUM(acquisition_cost) / SUM(Clicks * conversion_rate) ,2) AS cost_per_conversion
FROM Marketing_Campaign
GROUP BY Channel_Used
ORDER BY cost_per_click

-- Which campaign type (Email, Influencer, Display, Search, Social Media) performs best?

SELECT Campaign_Type,
AVG(ROI) AS avg_Roi,
AVG(Conversion_rate)AS Avg_Conversion_rate
FROM Marketing_Campaign
GROUP BY Campaign_Type
ORDER BY avg_Roi Desc
      
-- Which channel and campaign type combination gives the highest ROI?

SELECT TOP 1 Channel_used,
Campaign_type,
AVG(Roi)AS avg_Roi
FROM Marketing_Campaign
GROUP BY Channel_Used,Campaign_Type
ORDER BY avg_roi DESC

/*Audience, segment and location*/

-- Which target audience has the best conversion rate?

SELECT  Target_audience,
AVG(Conversion_rate) AS Avg_Conversion_Rate
FROM Marketing_Campaign
GROUP BY Target_Audience
ORDER BY  Avg_Conversion_Rate DESC

-- Which customer segment generates the highest ROI?

SELECT Customer_Segment,
AVG(Roi) AS avg_roi
FROM Marketing_Campaign
GROUP BY Customer_Segment
ORDER BY avg_roi DESC

-- Which city has the best ROI, and is it also the most expensive?

SELECT Location,AVG(ROI)AS Avg_roi,
SUM(Acquisition_Cost)AS Cost_of_acquisition
FROM Marketing_Campaign
GROUP BY Location
ORDER BY Avg_roi DESC

-- Does campaign language affect the engagement score?

SELECT Language, 
AVG(engagement_score *1.0 ) AS avg_engagement
FROM Marketing_Campaign
GROUP BY Language
ORDER BY avg_engagement DESC

/*Duration*/

-- Is a longer campaign (15, 30, 45, 60 days) more profitable, or does ROI stay about the same?
SELECT Duration,AVG(ROI)AS Avg_roi, AVG(conversion_rate) AS avg_conversion
FROM Marketing_Campaign
GROUP BY Duration
ORDER BY Duration

/*Time trends*/

-- What is the monthly trend of ROI, spend and conversion rate ?
SELECT DATENAME(MONTH,Date) AS Month_Name,
ROUND(AVG(ROI),4)AS Avg_Roi,
SUM(Acquisition_Cost)AS Total_Spent,
AVG(Conversion_rate)AS Monthly_Conversion_rate
FROM Marketing_Campaign
GROUP BY  DATENAME(MONTH,Date)
ORDER BY Month_Name

-- Which month and which quarter performed best?

-- Best month
SELECT TOP 1 DATENAME(MONTH,date) AS month_no, AVG(roi) AS avg_roi
FROM Marketing_Campaign
GROUP BY DATENAME(MONTH,date)
ORDER BY avg_roi DESC

-- Best quarter
SELECT TOP 1 DATEPART(QUARTER, date) AS quarter_no, AVG(roi) AS avg_roi
FROM Marketing_Campaign
GROUP BY DATEPART(QUARTER, date)
ORDER BY avg_roi DESC

-- What is the month-over-month change in ROI?
 
 WITH monthly AS (
    SELECT MONTH( date) AS month_no, AVG(roi) AS avg_roi
    FROM Marketing_Campaign
    GROUP BY MONTH(date)
)
SELECT month_no, avg_roi,
       avg_roi - LAG(avg_roi) OVER (ORDER BY month_no) AS change_from_last_month
FROM monthly
ORDER BY month_no

/*Company comparison*/

-- How do the 5 companies rank by ROI, total spend and conversion ?

SELECT TOP 5 Company,
  AVG(ROI) AS Avg_Roi,
  SUM(Acquisition_Cost) AS Total_Spent,
  AVG(Conversion_Rate) AS Conversion
FROM Marketing_Campaign
  GROUP BY Company
ORDER BY Avg_Roi DESC

-- Which company is the best performer within each channel?

 SELECT  Company,
 Channel_used,
 AVG(ROI) AS avg_roi,
 RANK()OVER(ORDER BY AVG(ROI) DESC) AS roi_rank
 FROM Marketing_Campaign
 GROUP BY Company,Channel_Used

/*Funnel and efficiency*/

-- Where is the biggest drop-off in the funnel (impressions to clicks to conversions) for each channel?

SELECT Channel_Used,
       SUM(Impressions) AS impressions,
       SUM(Clicks) AS clicks,
       SUM(Clicks * conversion_rate) AS est_conversions,
       100.0 * SUM(Clicks) / SUM(Impressions) AS click_rate_pct,
       100.0 * SUM(Clicks * conversion_rate) / SUM(Clicks) AS conversion_pct_of_clicks
FROM Marketing_Campaign
GROUP BY Channel_Used

--Which campaigns have high spend but below-average ROI (wasted budget)?

SELECT TOP 20 Campaign_ID, Company, Channel_Used, acquisition_cost, roi
FROM Marketing_Campaign
WHERE acquisition_cost > (SELECT AVG(acquisition_cost) FROM Marketing_Campaign)
  AND roi < (SELECT AVG(roi) FROM Marketing_Campaign)
ORDER BY acquisition_cost DESC

