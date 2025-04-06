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
![Table Structure][https://github.com/Mumo-The-Analyst/Cybersecurity_Threats_USA_2015_2024/blob/main/assets/images/Check_table_structure.png?raw=true]

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

#### 4.	Is there a direct correlation between the number of cybersecurity incidents and financial loss, or do some years show exceptions to this trend?
```sql
SELECT Year, 
       COUNT(*) AS Total_Incidents, 
       ROUND(SUM(Financial_Loss_in_Million)/1000, 2) AS Total_Loss_in_Billions
FROM cybersecurity_threats_in_USA_2015_2024
GROUP BY Year;
```
### 5. Creating Summary View for Power BI visualization
```sql
CREATE VIEW USA_cybersecurity_2015_2024 AS 
SELECT *
FROM cybersecurity_threats_in_USA_2015_2024;
```

## What I learned
## Insights
## Challenges I Faced
## Conclusion
