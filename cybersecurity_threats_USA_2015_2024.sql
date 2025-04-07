USE Global_Cybersecurity_Threats_2014_2015;

-- 1. Understand the Data
-- 1.1 Check table structure
SELECT 
	COLUMN_NAME, 
	DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Global_Cybersecurity_Threats_2015_2024'

-- 1.2 Preview Sample Data
SELECT TOP 10 *
FROM Global_Cybersecurity_Threats_2015_2024;

-- Data Preparation and Cleanup

--2.1 Filter by cybersecurity threats in USA and store the filtered data into a new table 'cybersecurity_threats_in_USA_2014_2025'
SELECT * INTO cybersecurity_threats_in_USA_2015_2024
FROM Global_Cybersecurity_Threats_2015_2024
WHERE Country = 'USA';

--2.2 Drop the 'country' column
ALTER TABLE cybersecurity_threats_in_USA_2015_2024
DROP COLUMN Country;

-- 2.3 Check for duplicate records and remove if necessary
SELECT Year, Attack_Type, Target_Industry, Financial_Loss_in_Million, Number_of_Affected_Users, Attack_Source, Security_Vulnerability_Type, Defense_Mechanism_Used, Incident_Resolution_Time_in_Hours, COUNT (*)
FROM cybersecurity_threats_in_USA_2015_2024
GROUP BY Year, Attack_Type, Target_Industry, Financial_Loss_in_Million, Number_of_Affected_Users, Attack_Source, Security_Vulnerability_Type, Defense_Mechanism_Used, Incident_Resolution_Time_in_Hours
HAVING COUNT(*) > 1;

--2.4 Check for missing values
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


-- 3. Basic Statistical Insights

--3.1 Count total incidents
SELECT COUNT(*) AS Total_Incidents from cybersecurity_threats_in_USA_2015_2024;

--3.2 Count of Incidents by target industry
SELECT Target_Industry, COUNT(*) AS Incident_count_by_industry
FROM cybersecurity_threats_in_USA_2015_2024
GROUP BY Target_Industry
ORDER BY Incident_count_by_industry DESC;

--3.3 Total financial loss per year
SELECT Year, ROUND(SUM(Financial_Loss_in_Million)/1000, 3) AS Total_Loss_in_Billions
FROM cybersecurity_threats_in_USA_2015_2024
GROUP BY Year
ORDER BY Total_Loss_in_Billions DESC;

--3.4 Count of Attack Type
SELECT Attack_Type, COUNT(Attack_Type) AS Count_of_Attack_Type
FROM cybersecurity_threats_in_USA_2015_2024
GROUP BY Attack_Type
ORDER BY Count_of_Attack_Type DESC;

--3.5 Top 3 industries with highest financial losses
SELECT TOP 3 Target_Industry, ROUND(SUM(Financial_Loss_in_Million)/1000, 3) AS Total_Loss_in_Billions
FROM cybersecurity_threats_in_USA_2015_2024
GROUP BY Target_Industry
ORDER BY Total_Loss_in_Billions DESC;

-- 4. Advanced analysis - Answering Questions


-- Question 1.	How have the total cybersecurity incidents and financial losses in the USA evolved from 2015 to 2024?

SELECT 
	Year, 
	COUNT(*) AS Total_Incidents, 
	ROUND(SUM(Financial_Loss_in_Million)/1000, 3) AS Total_Financial_Loss_in_Billions
FROM cybersecurity_threats_in_USA_2015_2024
GROUP BY Year
ORDER BY Year;

-- Question 2.	Which year recorded the highest number of cybersecurity incidents and financial losses, and what were the major contributing attack types?

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

SELECT *
FROM cybersecurity_threats_in_USA_2015_2024

-- Question 3.	How much financial loss does each cybersecurity incident cause on average per year, and is the cost per incident increasing over time?
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


-- Question 4.	Is there a direct correlation between the number of cybersecurity incidents and financial loss, or do some years show exceptions to this trend?
SELECT Year, 
       COUNT(*) AS Total_Incidents, 
       ROUND(SUM(Financial_Loss_in_Million)/1000, 2) AS Total_Loss_in_Billions
FROM cybersecurity_threats_in_USA_2015_2024
GROUP BY Year;


--5. Creating summary view for visualization in Power BI
CREATE VIEW USA_cybersecurity_2015_2024 AS 
SELECT *
FROM cybersecurity_threats_in_USA_2015_2024;
