# Game_Predictive_Analytics
I have done a General Analysis on a game called "World of WarFrame", where in dived deep in the Users purchasing pattern and power and the Vendor's performance and preferences, both regionally and over time as well.

# Tech Stakes Used:
1. Python (Jupyter Notebook)
2. SQL (SQL Server Management Studio)

# Problem Summary:
In World of Warframe, players buy various items (denoted by a sku) with real world money. These transactions can be handled by a variety of vendors. These vendors help facilitate transactions and take a cut of the revenue. 

One area of work is in the optimization of these vendors (i.e., Which vendors to present to users, and under what circumstances should these vendors be offered). The key point here being, since different vendors take different cuts, will removing high fee vendors result in partial or total migration to alternative, lower fee, vendors. On April 1st one such vendor (vendor37) was temporarily shut down due to external circumstances. The transaction data in m_mock_transaction_20190621.csv is a record of all transactions in the 3 months preceding this shutdown, and the 3 months since. We are now asked by the finance department to determine whether it is beneficial for us as a company to reopen vendor37 or if it should remain closed. Provided is all the data required to carry out analysis behind this question, and to provide an argument for or against reopening vendor37. Below you will find 2 specific focus areas to loosely structure your analysis on.


Part 1: General Analysis
The main point here is giving us (and the finance department) a general overview of the data. Isolating key metrics and presenting them in a clear way is essential. This is meant to be a basic analysis (i.e., modelling is not required). 
Below is a list of general metrics we would like to be covered:
• Before closure – what did revenue look like for vendor37?
	> Proportion of total revenue
	> Revenue/transactions per day through vendor37
	> Regional usage details
• What is an upper bound for revenue loss following the closure?
• Number of users expected to be affected by the closure.
• Is there a measurable revenue change because of the closure (on April 1)?
	> How about regionally?
• How does the spending (ARPU) of vendor37 users after closure compared to the spending of the users of other vendors?
• Is there any indication that vendor37 users have migrated to new vendors?



Part 2: Modelling
Ones I have done the basic analysis to identify whether the closure was positive or negative. The next question that arises is "what would revenue look like if vendor37 had not been closed". Using the data provided to construct a revenue model. This section is particularly open-ended. How does this model support my previous argument (or not)?

# Analysis Report:

**General Metrics**
**Proportion of Total Revenue**
Before the closure, Vendor37 contributed to approximately 0.43% of the total revenue. When compared to the first 3 month’s revenue with respect to vendor37’s revenue contribution, it was around 0.74%. This proportion gives us an idea of Vendor37's financial significance within the game ecosystem.

**Revenue per Day through Vendor37**
Before the closure, Vendor37 generated an average revenue of $1938.86 per day which contributed to 0.7% of the total revenue generated per day ($265,445.52) with all vendors combined. This metric provides insights into the daily revenue performance of Vendor37.

**Average Transactions per Day through Vendor37**
Before the closure, Vendor37 generated an average revenue of 20 per day. This metric provides insights into the daily transaction performance of Vendor37.

**Regional Usage Details**
Vendor37 had significant usage across multiple countries, with varying revenue contributions:
•	Top Countries by Usage: Country45 (950.82) Country66 (700), Country52 (605), etc.
•	Lowest Countries by Usage: Country196 (0.0006), Country119 (0.03), Country180 (0.15), etc.

**Regional Revenue Performance Details**
Vendor37 had significant Revenue contribution across multiple countries, with varying revenue contributions:
•	Top Countries by Revenue: Country66 ($10491128.76) Country45 ($9082617.73), Country16 ($2998857.82), etc.
•	Lowest Countries by Revenue: Country196 ($2337.89), Country180 ($4691.07), Country6 ($4691.07), etc.

**Upper Bound for Revenue Loss**
The upper bound for revenue loss following the closure of Vendor37 was calculated to be approximately $6,841,203.04. This scenario helps us to understand the potential impact following the closure of Vendor37.

**Affected Users**
Around 0.04% (2913 out of 6977893) of the total users were expected to be affected by the closure of Vendor37.

**Measurable Revenue Change**
Comparing the transaction revenue before and after the closure on April 1st, we observed:
•	Total Revenue before closure: $23,890,096.87
•	Total Revenue after closure: $17,048,893.83
•	Average Revenue per day before closure: $265,445.52.
•	Revenue of APRIL 01: $255,652.71
•	Average Revenue Per day drop after closure: $9792.81.
•	This indicates a significant drop of 3.69% in revenue after the closure.

**ARPU Comparison**
The Average Revenue Per User (ARPU) of Vendor37 users after closure was 65.72 which is higher than other users' ARPU which was 54.35, after the closure. This indicates that a gap of 17.3% between the spending power of the users of Vendor37 in comparison to the spending power of users of other vendors.

**User Migration**
Around 8.07% (98 out of 1215) of Vendor37 users migrated to other vendors after the closure, indicating a limited shift.

# Conclusion
Based on the analysis, it appears that reopening Vendor37 might be economically viable. While the proportion of total revenue and revenue per day through Vendor37 were notable, the closure resulted in a substantial revenue loss. Additionally, Vendor37 users still spent more in comparison to non Vendor37 users after the closure, and the user seemed to be loyal to Vendor37 due which we saw on 8% user migration. But there is a subsequent decrease as well in terms of spending power, suggesting that they found alternatives. However, the migration was relatively low, indicating that some users stuck with Vendor37's alternatives.

After running a Linear regression model on SQL and Python, using the 1st 3 month’s dataset to analyse Vendor37 revenue pattern and other vendor’s revenue patterns, and used that to test on the next 3 months (4th, 5th & 6th month) dataset, the model forecasted a revenue of $517,860,357.68 if Vendor37 was not closed. 

Overall, a cautious approach is recommended, considering the upper bound of revenue loss, forecasted revenue and the observable changes in user spending patterns.

# Linear Regression model Snapshot in SQL:

![Regression_Model_Exec](https://github.com/DishadJahan/Game_Predictive_Analytics/assets/123267703/b7455c24-e70e-4e0e-a9f9-0efcad3293ca)


