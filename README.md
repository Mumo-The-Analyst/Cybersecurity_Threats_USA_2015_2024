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

## Data Preparation and Cleanup
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
