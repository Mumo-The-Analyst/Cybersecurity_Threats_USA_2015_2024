# Cybersecurity Threats in the USA (2015-2024): Trends, Financial Impact, and Industry Vulnerabilities

## Overview
Cybersecurity threats have become a growing concern globally, with the United States being one of the most targeted countries due to its advanced digital infrastructure and high-value data assets. From large-scale ransomware attacks to data breaches affecting millions of users, the evolving cyber threat landscape has posed significant challenges to national security, businesses, and individuals.
This study aims to analyze cybersecurity threats in the USA from 2015 to 2024 by examining trends in the number of incidents, financial losses, and key attack vectors. The analysis focuses on identifying the most common attack types, the industries most affected, and the economic impact of these threats. Additionally, the analysis investigates year-over-year changes, incident resolution times, and potential correlations between attack frequency and financial damage.

## The Questions
Below are the questions I wanted to answer in the project:
1.	How have the total cybersecurity incidents and financial losses in the USA evolved from 2015 to 2024?
2.	Which year recorded the highest number of cybersecurity incidents and financial losses, and what were the major contributing attack types?
3.	How much financial loss does each cybersecurity incident cause on average per year, and is the cost per incident increasing over time?
4.	Is there a direct correlation between the number of cybersecurity incidents and financial loss, or do some years show exceptions to this trend?

## Tools used
For my deep dive into the cybersecurity threats in the USA between 2015 and 2024, I harnessed the power of several key tools:

**-Excel:** Exploring the data.

**-SQL server:** Cleaning, testing, and analyzing the data.

**-Power BI:** Visualizing the data via interactive dashboards.

**-GitHub:** Hosting the project documentation and version control. 

## Data Preparation, Cleanup and Analysis
### Database Creation
I first created a database in SQL Server Management Studio, the “Global_Cybersecurity_Threats_2015_2024” to import the data from Excel which I downloaded from Kaggle: https://www.kaggle.com/datasets/atharvasoundankar/global-cybersecurity-threats-2015-2024.

### Step 1: Understand the Data
I examined the dataset to understand its structure

#### 1.1 Check the table structure
```sql
SELECT 
	COLUMN_NAME, 
	DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Global_Cybersecurity_Threats_2015_2024'
```
![Table Structure](https://github.com/Mumo-The-Analyst/Cybersecurity_Threats_USA_2015_2024/blob/main/assets/images/Check_table_structure.png?raw=true)

#### 1.2 Preview Sample Data
```sql
SELECT TOP 10 *
FROM Global_Cybersecurity_Threats_2015_2024;
```

### Step 2: Data Preparation and Cleanup
#### 2.1 Filter by cybersecurity incidents in USA to new data table 'cybersecurity_threats_in_USA_2015_2024'
```sql
SELECT * INTO cybersecurity_threats_in_USA_2015_2024
FROM Global_Cybersecurity_Threats_2015_2024
WHERE Country = 'USA';
```

#### 2.2 Drop the 'country' column
```sql
ALTER TABLE cybersecurity_threats_in_USA_2015_2024
DROP COLUMN Country;
```

#### 2.3 Check for duplicate records and remove if necessary
```sql 
SELECT Year, Attack_Type, Target_Industry, Financial_Loss_in_Million, Number_of_Affected_Users, Attack_Source, Security_Vulnerability_Type, Defense_Mechanism_Used, Incident_Resolution_Time_in_Hours, COUNT (*)
FROM cybersecurity_threats_in_USA_2015_2024
GROUP BY Year, Attack_Type, Target_Industry, Financial_Loss_in_Million, Number_of_Affected_Users, Attack_Source, Security_Vulnerability_Type, Defense_Mechanism_Used, Incident_Resolution_Time_in_Hours
HAVING COUNT(*) > 1;
```
- There were no duplicate values

#### 2.4 Check for missing values
```sql
SELECT *
FROM cybersecurity_threats_in_USA_2015_2024
WHERE Year IS NULL
OR Attack_Type IS NULL 
OR Target_Industry IS NULL 
OR Financial_Loss_in_Million IS NULL 
OR Number_of_Affected_Users IS NULL 
OR Attack_Source IS NULL 
OR Security_Vulnerability_Type IS NULL
OR Defense_Mechanism_Used IS NULL 
OR Incident_Resolution_Time_in_Hours IS NULL;
```
-There were no missing values

### Step 3. Basic Statistical Analysis
#### 3.1 Count of total incidents
```sql
SELECT COUNT(*) AS Total_Incidents from cybersecurity_threats_in_USA_2015_2024;
```
- There were a total of 287 cybersecurity incidents in USA between 2015 and 2024.

#### 3.2 Incident count by industry
```sql
SELECT Target_Industry, COUNT(*) AS Incident_count_by_industry
FROM cybersecurity_threats_in_USA_2015_2024
GROUP BY Target_Industry
ORDER BY Incident_count_by_industry DESC;
```
- Retail industry experienced the most cybersecurity threats incidents between 2015 and 2024, with a total of 52 incidents. It was closely followed by IT industry with 47 incidents. Healthcare had the least incidents, with a total of 33 incidents between the same time.

#### 3.3 Total financial loss per year
```sql
SELECT Year, ROUND(SUM(Financial_Loss_in_Million)/1000, 3) AS Total_Loss_in_Billions
FROM cybersecurity_threats_in_USA_2015_2024
GROUP BY Year
ORDER BY Total_Loss_in_Billions DESC;
```
- 2017 had the highest financial loss amounting to USD$ 1.834 B. 2020 and 2016 had the second and third highest financial accounting to USD$ 1.634 B and USD$1.63 B, respectively. 2024 had the least financial loss amounting to USD$ 1.118 B.

#### 3.4 Count of attack type
```sql
SELECT Attack_Type, COUNT(Attack_Type) AS Count_of_Attack_Type
FROM cybersecurity_threats_in_USA_2015_2024
GROUP BY Attack_Type
ORDER BY Count_of_Attack_Type DESC;
```
- DDoS accounted for the majority of cybersecurity threats in USA between 2015 and 2024, accounting for 60 incidents. SQL injection accounted for the least incidents with 38 attacks.

#### 3.5 Top 3 industries with highest financial losses
```sql
SELECT TOP 3 Target_Industry, ROUND(SUM(Financial_Loss_in_Million)/1000, 3) AS Total_Loss_in_Billions
FROM cybersecurity_threats_in_USA_2015_2024
GROUP BY Target_Industry
ORDER BY Total_Loss_in_Billions DESC;
```
- The retail industry had the highest financial losses at USD$ 2.762 B, the government had the second highest financial losses at USD$ 2.481 B, and the IT industry had the third highest financial losses at USD$ 2.364 B.

### Step 4. Advanced Analysis - Answering Questions

#### 1.	How have the total cybersecurity incidents and financial losses in the USA evolved from 2015 to 2024?
```sql
SELECT 
	Year, 
	COUNT(*) AS Total_Incidents, 
	ROUND(SUM(Financial_Loss_in_Million)/1000, 3) AS Total_Financial_Loss_in_Billions
FROM cybersecurity_threats_in_USA_2015_2024
GROUP BY Year
ORDER BY Year;
```
- The highest number of incidents was recorded in 2016 (34 incidents), followed closely by 2017 and 2020 (33 incidents). However, the highest financial loss occurred in 2017 (1.834 billion USD), not 2016—indicating that more incidents do not always lead to greater losses. This suggests some attacks in 2017 may have been more severe or targeted at high-value assets.
- After a relatively high period from 2015–2020, both incidents and financial losses show a downward trend from 2021 to 2024. Incidents fell from 33 (2020) to 22 (2024) while financial losses dropped from 1.634B (2020) to 1.118B (2024). This could indicate improvements in cybersecurity measures, stronger regulations, or changes in attack patterns.
- Some years (e.g., 2019) had fewer incidents (24) but resulted in relatively high losses (1.198B). Meanwhile, 2022 had 25 incidents and only 1.283B loss, which is lower per incident compared to 2017. This shows that the cost per attack is not constant and depends on the nature and target of the attack.

#### 2.	Which year recorded the highest number of cybersecurity incidents and financial losses, and what was the major contributing attack type?
```sql
-- Rank attack types per year by frequency
WITH Ranked_Attacks AS (
    SELECT 
        Year, 
        Attack_Type,
        COUNT(*) AS Attack_Type_Incidents,
        ROW_NUMBER() OVER (PARTITION BY Year ORDER BY COUNT(*) DESC) AS Rank_Attack
    FROM cybersecurity_threats_in_USA_2015_2024
    GROUP BY Year, Attack_Type
),

-- Get total yearly incidents and total financial loss
Yearly_Totals AS (
    SELECT 
        Year,
        COUNT(*) AS Total_Incidents,
        SUM(Financial_Loss_in_Million) AS Total_Financial_Loss_in_Million
    FROM cybersecurity_threats_in_USA_2015_2024
    GROUP BY Year
),

-- Join to get the top attack type per year + yearly totals
Combined AS (
    SELECT 
        R.Year,
        R.Attack_Type,
        Y.Total_Incidents,
        ROUND(Y.Total_Financial_Loss_in_Million / 1000.0, 2) AS Financial_Loss_in_Billion
    FROM Ranked_Attacks R
    INNER JOIN Yearly_Totals Y ON R.Year = Y.Year
    WHERE R.Rank_Attack = 1
)

-- Final output with YoY growth and renamed column
SELECT 
    Year,
    Attack_Type AS Major_Contributing_Attack_Type,
    Total_Incidents,
    Financial_Loss_in_Billion,

    LAG(Total_Incidents) OVER (ORDER BY Year) AS Prev_Year_Incidents,
    LAG(Financial_Loss_in_Billion) OVER (ORDER BY Year) AS Prev_Year_Loss_Billion,

    -- Incident Growth %
    FORMAT(
        (Total_Incidents - LAG(Total_Incidents) OVER (ORDER BY Year)) * 100.0 /
        NULLIF(LAG(Total_Incidents) OVER (ORDER BY Year), 0), 'N2'
    ) + '%' AS Incident_Growth_Percentage,

    -- Financial Loss Growth %
    FORMAT(
        (Financial_Loss_in_Billion - LAG(Financial_Loss_in_Billion) OVER (ORDER BY Year)) * 100.0 /
        NULLIF(LAG(Financial_Loss_in_Billion) OVER (ORDER BY Year), 0), 'N2'
    ) + '%' AS Loss_Growth_Percentage

FROM Combined
ORDER BY Year;
```
- 2016 had the highest number of incidents, accounting for 34 incidents in the USA. The major contributing attack type that year was Phishing. This suggests phishing campaigns were especially prevalent and possibly widespread across industries.
- 2017 incurred the highest financial loss at 1.83 billion USD, despite having slightly fewer incidents (33) than 2016 (34). The major contributing attack type was DDoS (Distributed Denial of Service). This implies that DDoS attacks in 2017 were especially damaging, possibly due to targeting critical infrastructure or high-value organizations.
- DDoS was the most recurring major threat. It was the top contributing attack type in 6 out of 10 years (2015, 2017, 2018, 2019, 2020). This shows that while Phishing, Ransomware, and Malware emerged in some years, DDoS attacks consistently posed the greatest threat over time. It also suggests that long-term mitigation of DDoS should remain a priority.

#### 3.	How much financial loss does each cybersecurity incident cause on average per year, and is the cost per incident increasing over time?
```sql
SELECT 
    Year,  

    -- Total number of incidents
    COUNT(*) AS Total_Incidents,

    -- Total financial loss in millions
    ROUND(SUM(Financial_Loss_in_Million)/1000, 2) AS Total_Financial_Loss_in_Billion,

    -- Average loss per incident
    ROUND(SUM(Financial_Loss_in_Million) * 1.0 / COUNT(*), 2) AS Avg_Loss_Per_Incident_in_Millions,

    -- Previous year's average loss per incident
    LAG(ROUND(SUM(Financial_Loss_in_Million) * 1.0 / COUNT(*), 2)) OVER (ORDER BY Year) AS Prev_Year_Avg_Loss,

    -- Percentage growth in average loss per incident
    FORMAT(
        (
            ROUND(SUM(Financial_Loss_in_Million) * 1.0 / COUNT(*), 2) -
            LAG(ROUND(SUM(Financial_Loss_in_Million) * 1.0 / COUNT(*), 2)) OVER (ORDER BY Year)
        ) * 100.0 /
        NULLIF(LAG(ROUND(SUM(Financial_Loss_in_Million) * 1.0 / COUNT(*), 2)) OVER (ORDER BY Year), 0),
    'N2') + '%' AS Avg_Loss_Growth_Percentage

FROM cybersecurity_threats_in_USA_2015_2024
GROUP BY Year
ORDER BY Year;
```
- Average Cost per Incident Has Fluctuated Over the Years. The average loss per incident ranged from ~47.95M (2016) to ~55.9M (2015). This indicates that the cost per incident does not increase steadily but instead fluctuates year to year, influenced by the type and scale of attacks.
- The sharpest increase occurred in 2017 which saw a 15.89% increase in average loss per incident compared to 2016. This could be due to high-impact attacks like DDoS or ransomware targeting valuable systems. Despite similar total incidents as 2016, the cost efficiency of these attacks was higher.
- The sharpest decrease in average financial loss per incident occurred in 2016, with a −14.22% drop compared to 2015. This suggests that while incidents increased in 2016, they were less costly on average, possibly due to: Less severe attack types, better containment strategies, and more frequent but low-impact breaches
- Nevertheless, there has been a declining trend in recent years. From 2021 to 2024, the growth in average cost per incident has been modest or negative, with minor fluctuations: 2021 (+6.04%), 2022 (−2.23%), 2023 (+1.58%), 2024 (−2.51%). This may suggest better response and mitigation strategies, or more frequent but less financially damaging incidents.

#### 4.	Is there a direct correlation between the number of cybersecurity incidents and financial loss, or do some years show exceptions to this trend?
```sql
SELECT Year, 
       COUNT(*) AS Total_Incidents, 
       ROUND(SUM(Financial_Loss_in_Million)/1000, 2) AS Total_Loss_in_Billions
FROM cybersecurity_threats_in_USA_2015_2024
GROUP BY Year;
```
- Overall, there is a general positive correlation since in years where the number of incidents is higher, the total financial loss also tends to be higher. E.g., 2016 (34 incidents → $1.63B loss), 2017 (33 incidents → $1.83B loss), 2020 (33 incidents → $1.63B loss). This suggests that more incidents often lead to higher cumulative losses, which aligns with expectations.
- However, some years break the trend indicating high-impact attacks. 2021 had fewer incidents (28) than 2020 (33), but still had a high financial loss ($1.47B), very close to 2020. 2023 had 29 incidents, but caused $1.51B in losses, higher than years with more incidents like 2021 and 2022.These exceptions suggest that fewer, more severe attacks (e.g., ransomware or advanced DDoS) can cause disproportionate financial impact.
- Lower incident years still poses financial risks. 2019 and 2024 had the lowest number of incidents (24 and 22), but still resulted in $1.2B and $1.12B losses respectively. This implies that even a small number of high-cost incidents can significantly impact financial loss figures.

### 5. Creating Summary View for Power BI visualization
```sql
CREATE VIEW USA_cybersecurity_2015_2024 AS 
SELECT *
FROM cybersecurity_threats_in_USA_2015_2024;
```

## Overall Insights
This project provided several general insights:

- **Trend Over Time:** From 2015 to 2024, both cybersecurity incidents and financial losses in the USA have fluctuated, with no consistent upward or downward trend, highlighting the unpredictable nature of threat landscapes.
- **Peak Year & Major Threat:** The year 2017 recorded the highest financial loss ($1.83B) and one of the highest incident counts (33), with DDoS attacks being the major contributing attack type, indicating their large-scale economic impact.
- **Cost Per Incident:** The average financial loss per incident varied yearly, peaking in 2015 at $55.9M per attack, then experiencing fluctuations. The sharpest drop occurred in 2016 (−14.22%), showing that higher incident volumes don’t always mean higher cost per attack.
- **Incidents vs. Financial Loss Correlation:** While there is a general correlation between the number of incidents and financial loss, some years (e.g., 2021, 2023) saw fewer incidents with disproportionately high financial losses, indicating the presence of fewer but more severe attacks.

## What I learned
Throughout this project, I significantly enhanced my data analysis skills by investigating cybersecurity threats in the USA from 2015 to 2024. I deepened my understanding of SQL for advanced querying and Power BI for impactful data storytelling. Here are a few specific things I learned:
- **Advanced SQL for Analytical Insights**: By writing complex SQL queries using window functions (e.g., LAG, ROUND, CONCAT) and aggregations, I learned how to extract trends, calculate year-over-year changes, and identify key contributors—like major attack types or financial patterns—at a deeper level.
- **Effective Data Visualization with Power BI**: I developed skills in transforming raw data into clear, interactive dashboards. Using charts like line graphs, scatter plots, treemaps, and bar charts, I learned how to visually communicate complex relationships between incidents and financial loss in an intuitive, decision-ready format.
- **Real-World Analytical Thinking in Cybersecurity Context**: Analyzing cybersecurity data taught me how to interpret real-world risk metrics. I learned how fewer but more severe attacks can have a disproportionate impact and how trends in attack types and losses inform strategic cybersecurity planning and response.


## Challenges I Faced
This project was not without its challenges, but it provided good learning opportunities:
- **Data Structure & Cleaning Complexity**: One key challenge was working with raw cybersecurity data that required careful filtering, transformation, and restructuring. Ensuring consistent formats (e.g., converting financial losses to billions, handling missing values, or normalizing year-over-year metrics) was essential to avoid misinterpretation. For instance, calculating growth percentages required the correct use of window functions like LAG, which was initially prone to syntax and logic errors.
- **Interpreting Exceptions in Trends**: Another challenge was interpreting years that deviated from expected patterns, such as years with fewer incidents but higher financial losses. Understanding these exceptions required me to look beyond surface-level trends and explore deeper factors, like attack type severity or cost per incident. Drawing accurate insights from such nuances demanded both technical precision and contextual reasoning.

## Conclusion
This deep dive into cybersecurity threats in the USA from 2015 to 2024 has been incredibly insightful, revealing how data can uncover patterns in digital vulnerabilities and economic impact. Through the use of SQL for in-depth querying and Power BI for visualization, I was able to analyze trends, identify high-risk periods, and evaluate the financial consequences of different attack types.

The project not only strengthened my technical skills but also highlighted the importance of critical thinking when interpreting real-world data. As cybersecurity continues to evolve, ongoing analysis will be essential for organizations to make informed decisions and strengthen their defenses. This project lays a strong foundation for future analytical work and emphasizes the growing role of data in tackling global digital challenges.
