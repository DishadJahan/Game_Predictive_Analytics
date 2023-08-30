
CREATE TABLE Table1 (
    Name VARCHAR(50),
    Gender VARCHAR(10)
);


INSERT INTO Table1 (Name, Gender)
VALUES
    ('Sam', 'Male'),
    ('Sanju', 'Male'),
    ('Subdar', 'Male'),
    ('Sunita', 'Female'),
    ('Shivani', 'Female'),
    ('Alia', 'Female'),
    ('Vipin', 'Male'),
    ('Dishad', 'Male'),
    ('Priyanka', 'Female'),
    ('Shikha', 'Female');

Select * from Table1;
-----------------------------------------------------------------------------------------------
select t1.Name, t1.Gender
from (
    select Name, Gender,
        ROW_NUMBER() OVER (PARTITION BY Gender ORDER BY Name) as male_row,
        ROW_NUMBER() OVER (PARTITION BY Gender ORDER BY Name) as female_row
    from Table1
) as t1
order by
    case 
        when t1.Gender = 'Male' then t1.male_row
        else t1.female_row
    end,
    t1.Gender;

----------------------------------------------------------------------------------------------

SELECT Name, Gender
FROM Table1
ORDER BY ROW_NUMBER() OVER (PARTITION BY Gender ORDER BY Name), Gender;

==================================================================================================================================================
/*
Below is a list of general metrics that are needed to be covered:
• Before closure – what did revenue look like for vendor37?
	• Proportion of total revenue
	• Revenue/transactions per day through vendor37
	• Regional usage details
• What is an upper bound for revenue loss following the closure?
• Number of users expected to be affected by the closure.
• Is there a measurable revenue change because of the closure (on April 1)?
	• How about regionally?
• How does the spending (ARPU) of vendor37 users after closure compared to the spending of the users of other vendors?
• Is there any indication that vendor37 users have migrated to new vendors?
*/

Select top 5 * from [dbo].[m_mock_transaction_20190621];
Select top 5 * from [dbo].[m_mock_active_users_20190621];
Select top 5 * from [dbo].[m_vendor_map];

Select top 100 *
from [dbo].[m_mock_transaction_20190621] a
join [dbo].[m_mock_active_users_20190621] b on a.country_code = b.country_code
join [dbo].[m_vendor_map] c on a.vendor = c.vendor_id;

=================================================================================================================================================================
-- Total distinct month.

select distinct month
from [dbo].[m_mock_transaction_20190621]
order by 1;

=================================================================================================================================================================
-- Total distinct month number where vendor37 was working.

select distinct month
from [dbo].[m_mock_transaction_20190621]
where vendor = 'vendor37'
order by 1;

=================================================================================================================================================================
-- Before closure – what did revenue look like for vendor37?

Select vendor, round(sum(revenue), 2) as 'Total_Revenue'
from [dbo].[m_mock_transaction_20190621]
where vendor = 'vendor37'
and month in (1, 2, 3)
group by vendor;

-- Answer: "vendor37" = 174497.48


=================================================================================================================================================================
-- Proportion of total revenue of vendor37 for the 1st 3 months.

with cte1 as 
(Select round(sum(revenue), 2) as 'V37_Total_Revenue'
from [dbo].[m_mock_transaction_20190621]
where vendor = 'vendor37'
and month in (1, 2, 3)),

cte2 as 
(Select round(sum(revenue), 2) as 'Total_Revenue'
from [dbo].[m_mock_transaction_20190621]
where month in (1, 2, 3))

select concat(round((a.V37_Total_Revenue/b.Total_Revenue) * 100, 2), '%') as 'Proportion'
from cte1 a, cte2 b

-- Answer: Vendor37's Proportion = 0.73%

=================================================================================================================================================================
-- Proportion of total revenue of vendor37.

with cte1 as 
(Select round(sum(revenue), 2) as 'V37_Total_Revenue'
from [dbo].[m_mock_transaction_20190621]
where vendor = 'vendor37'
and month in (1, 2, 3)),

cte2 as 
(Select round(sum(revenue), 2) as 'Total_Revenue'
from [dbo].[m_mock_transaction_20190621])

select concat(round((a.V37_Total_Revenue/b.Total_Revenue) * 100, 2), '%') as 'Proportion'
from cte1 a, cte2 b

-- Answer: Vendor37's Proportion = 0.43%

=================================================================================================================================================================
-- Revenue per day through vendor37.

Select round(sum(revenue)/(31+28+31), 2) as 'Rev_Per_Day'
from [dbo].[m_mock_transaction_20190621]
where vendor = 'vendor37';

-- Revenue per day for Vendor37 was 1938.86

=================================================================================================================================================================
-- Transactions per day through vendor37.

Select count(sku)/(31+28+31) as 'Rev_Per_Day'
from [dbo].[m_mock_transaction_20190621]
where vendor = 'vendor37';

-- Transactions per day for Vendor37 was 20

=================================================================================================================================================================
-- Regional/Country wise usage details.

Select distinct b.country_code, 
	   round(sum(b.relative_active_users), 4) as 'relative_active_users'
from [dbo].[m_mock_transaction_20190621] a
join [dbo].[m_mock_active_users_20190621] b
	on a.country_code = b.country_code
where vendor = 'vendor37'
group by b.country_code
order by relative_active_users desc;

-- Vendor37 had it's presence in a total of 41 countries.

=================================================================================================================================================================
-- Regional/Country wise usage details (Top 10).

Select distinct top 10 
		b.country_code, 
	    round(sum(b.relative_active_users), 4) as 'relative_active_users'
from [dbo].[m_mock_transaction_20190621] a
join [dbo].[m_mock_active_users_20190621] b
	on a.country_code = b.country_code
where vendor = 'vendor37'
group by b.country_code
order by relative_active_users desc;

=================================================================================================================================================================
-- Regional/Country wise usage details that used Vendor37 the least (Least 10).

Select distinct top 10 
		b.country_code, 
	    round(sum(b.relative_active_users), 4) as 'relative_active_users'
from [dbo].[m_mock_transaction_20190621] a
join [dbo].[m_mock_active_users_20190621] b
	on a.country_code = b.country_code
where vendor = 'vendor37'
group by b.country_code
order by relative_active_users asc;


=================================================================================================================================================================
-- What is an upper bound for revenue loss following the closure?

With Before_Closure_Revenue as (
	Select round(sum(revenue), 2) as 'Total_Rev_First3months'
	from [dbo].[m_mock_transaction_20190621]
	where month <= 3
), -- Total Revenue before closure was 23,890,096.87

After_Closure_Revenue as (
	Select round(sum(revenue), 2) as 'Total_Rev_Last3months'
	from [dbo].[m_mock_transaction_20190621]
	where month > 3
) -- Total Revenue after closure was 17,048,893.83

Select a.Total_Rev_First3months,
	   b.Total_Rev_Last3months,
	   a.Total_Rev_First3months - b.Total_Rev_Last3months as 'Revenue_Loss',
	   concat(round((((a.Total_Rev_First3months - b.Total_Rev_Last3months)/a.Total_Rev_First3months) * 100), 2), '%') as 'Percentage_Difference'
From Before_Closure_Revenue a, After_Closure_Revenue b;

-- There was a revenue loss of 6,841,203.04 which was a revenue drop by 28.64%

=================================================================================================================================================================
-- Number of users expected to be affected by the closure.

Select round(sum(relative_active_users), 2) as 'Total_Users'
from [dbo].[m_mock_transaction_20190621] a 
join [dbo].[m_mock_active_users_20190621] b
	on a.country_code = b.country_code
where vendor = 'vendor37';

-- Number users that would be affected are 2913 approx.

=================================================================================================================================================================
-- Number of users expected to be affected by the closure country wise.

Select distinct b.country_code,
				round(sum(relative_active_users), 2) as 'Total_Users'
from [dbo].[m_mock_transaction_20190621] a 
join [dbo].[m_mock_active_users_20190621] b
	on a.country_code = b.country_code
where vendor = 'vendor37'
group by b.country_code
order by Total_Users desc;

=================================================================================================================================================================
-- Is there a measurable revenue change because of the closure (on April 1)?

With Rev_PerDay_BeforeClosure as (
	Select round(sum(revenue)/(31+28+31), 2) as 'Rev_Per_Day'
	from [m_mock_transaction_20190621]
	where month <= 3
), -- Revenue per day before closure of vendor37 was 265445.52

Rev_On_April01 as (
	Select round(sum(revenue), 2) as 'Total_Rev'
	from [m_mock_transaction_20190621] 
	where month = 4 and day = 1
) -- Revenue of APRIL 01, i.e. right after the next day of closure of Vendor37 was 255652.71

Select a.Rev_Per_Day, 
	   b.Total_Rev, 
	   round(a.Rev_Per_Day - b.Total_Rev, 2) as 'Revenue_Difference',
	   concat(round((((a.Rev_Per_Day - b.Total_Rev)/a.Rev_Per_Day) * 100), 2), '%') as 'Percentage_Difference'
From Rev_PerDay_BeforeClosure a, Rev_On_April01 b;

-- We can see a Revenue drop of 9792.81 per day which is 3.69% drop from the average revenue per day before closure.

=================================================================================================================================================================
-- Measurable revenue change because of the closure (on April 1) region wise?

With Rev_PerDay_BeforeClosure as (
	Select distinct country_code,
					round(sum(revenue)/(31+28+31), 2) as 'Rev_Per_Day'
	from [m_mock_transaction_20190621]
	where month <= 3
	group by country_code
), -- Revenue per day before closure of vendor37 was 265445.52

Rev_On_April01 as (
	Select distinct country_code,
					round(sum(revenue), 2) as 'Total_Rev'
	from [m_mock_transaction_20190621] 
	where month = 4 and day = 1
	group by country_code
) -- Revenue of APRIL 01, i.e. right after the next day of closure of Vendor37 was 255652.71

Select distinct a.country_code,
				a.Rev_Per_Day, 
				b.Total_Rev, 
				round(a.Rev_Per_Day - b.Total_Rev, 2) as 'Revenue_Difference',
				concat(round((((a.Rev_Per_Day - b.Total_Rev)/a.Rev_Per_Day) * 100), 2), '%') as 'Percentage_Difference'
From Rev_PerDay_BeforeClosure a, Rev_On_April01 b;

-- We can see a Revenue drop of 9792.81 per day which is 3.69% drop from the average revenue per day before closure.

=================================================================================================================================================================
-- How does the spending (ARPU) of vendor37 users after closure compared to the spending of the users of other vendors?

with ARPU_Vendor37_AfterClosure as (
Select round(avg(revenue), 2) as 'Avg_Revenue'
from [dbo].[m_mock_transaction_20190621]
where account in (
			Select account
			from [dbo].[m_mock_transaction_20190621]
			where vendor = 'vendor37')
and month > 3
), -- ARPU of users of Vendor37 after it's closure was 65.72

ARPU_OtherVendors_AfterClosure as (
Select round(avg(revenue), 2) as 'Avg_Revenue'
from [dbo].[m_mock_transaction_20190621]
where account in (
			Select account
			from [dbo].[m_mock_transaction_20190621]
			where vendor <> 'vendor37')
and month > 3
) -- ARPU of users of other vendors after the closure of Vendor37 was 54.35

Select round(a.Avg_Revenue, 2) as ARPU_Vendor37_AfterClosure,
	   round(b.Avg_Revenue, 2) as ARPU_OtherVendors_AfterClosure,
	   round(a.Avg_Revenue - b.Avg_Revenue, 2) as 'ARPU_Difference',
	   concat(round((a.Avg_Revenue - b.Avg_Revenue)/a.Avg_Revenue * 100, 2), '%') as 'ARPU_percentage_difference'
from ARPU_Vendor37_AfterClosure a, ARPU_OtherVendors_AfterClosure b;

-- There is difference of 11.37 between the purchasing power of Vendor37's users and the users of other vendors.
-- There is a significant difference of 17.3% between the purchasing of Vendor37's users and the users of the other vendors.


=================================================================================================================================================================
-- Is there any indication that vendor37 users have migrated to new vendors?

With cte1 as (
	Select count(distinct account) as 'Total_User_Count'
	from [dbo].[m_mock_transaction_20190621]
	where vendor = 'vendor37'
), -- Total number of Users of Vendor37 was 1215.

cte2 as (
	Select count(distinct account) as 'Migrated_User_Count'
	from [dbo].[m_mock_transaction_20190621]
	where account in (
					Select distinct account
					from [dbo].[m_mock_transaction_20190621]
					where vendor = 'vendor37')
	and month > 3
) -- Total number of Vendor37's users that migrated to different vendors are 98.

Select Total_User_Count,
	   Migrated_User_Count,
	   concat(round((98.0/1215) * 100, 2), '%') as 'Migrated_User_Percentage'
from cte1 a, cte2 b;

-- We can see an 8.07% of users migrated to different vedors after the closure of Vendor37.

=================================================================================================================================================================
-- Building the linear regression model

WITH RegressionData AS (
    SELECT t.month,
		   t.day,
           t.vendor,
           t.country_code,
           t.revenue,
           v.fee_percentage,
           a.relative_active_users
    FROM m_mock_transaction_20190621 t
    LEFT JOIN m_vendor_map v ON t.vendor = v.vendor_id
    LEFT JOIN m_mock_active_users_20190621 a ON t.country_code = a.country_code
              AND t.month = a.month
              AND t.day = a.day
    WHERE t.month <= 3
        AND t.vendor <> 'Vendor37'  -- Exclude Vendor37 for training
),
RegressionModel AS (
    SELECT fee_percentage,
           relative_active_users,
           AVG(revenue) AS avg_revenue
    FROM RegressionData
    GROUP BY fee_percentage, relative_active_users
)
SELECT t.month,
       t.day,
       t.country_code,
       v.fee_percentage,
       a.relative_active_users,
       COALESCE(rm.avg_revenue, 0) AS forecasted_revenue
FROM (
    SELECT DISTINCT
        month,
        day,
        country_code
    FROM m_mock_transaction_20190621
    WHERE month >= 4  -- Forecast for months 4 to 6
) t
CROSS JOIN m_vendor_map v
CROSS JOIN m_mock_active_users_20190621 a
LEFT JOIN RegressionModel rm ON v.fee_percentage = rm.fee_percentage
    AND a.relative_active_users = rm.relative_active_users;


=================================================================================================================================================================
-- Building the linear regression model
-- Create a temporary table to join transaction and user data

CREATE TABLE RevenueForecast AS
SELECT t.month,
       t.day,
       t.sku,
       t.account,
       t.vendor,
       t.country_code,
       COALESCE(v.fee_percentage, 0) AS fee_percentage,
       a.relative_active_users,
       t.revenue
FROM m_mock_transaction_20190621 t
LEFT JOIN m_vendor_map v 
	ON t.vendor = v.vendor_id
JOIN m_mock_active_users_20190621 a 
	ON t.country_code = a.country_code AND t.month = a.month AND t.day = a.day;

-- Perform linear regression to predict revenue
SELECT month,
       sku,
       account,
       vendor,
       country_code,
       fee_percentage,
       relative_active_users,
       revenue,
       COALESCE(LINEAR_REGRESSION(revenue, ARRAY[relative_active_users, fee_percentage]), revenue) AS forecasted_revenue
FROM RevenueForecast
WHERE month >= 4 AND month <= 6;









WITH RegressionData AS (
    SELECT t.vendor,
           t.country_code,
           t.revenue,
           v.fee_percentage,
           a.relative_active_users
    FROM m_mock_transaction_20190621 t
    JOIN m_vendor_map v 
		ON t.vendor = v.vendor_id
    JOIN m_mock_active_users_20190621 a 
		ON t.country_code = a.country_code
    WHERE t.month <= 3
    --AND t.vendor <> 'Vendor37'  -- Exclude Vendor37 for training
),
RegressionModel AS (
    SELECT country_code,
		   vendor,
           fee_percentage,
           relative_active_users,
           AVG(revenue) AS 'avg_revenue'
    FROM RegressionData
    GROUP BY country_code, vendor, fee_percentage, relative_active_users
)
SELECT t.country_code,
       v.fee_percentage,
       a.relative_active_users,
       COALESCE(rm.avg_revenue, 0) AS 'forecasted_revenue'
FROM (
    SELECT DISTINCT country_code
    FROM m_mock_transaction_20190621
    WHERE month > 3  -- Forecast for months 4 to 6
) t
CROSS JOIN m_vendor_map v
CROSS JOIN m_mock_active_users_20190621 a
LEFT JOIN RegressionModel rm 
	ON v.vendor_id = rm.vendor
    AND a.country_code = rm.country_code;