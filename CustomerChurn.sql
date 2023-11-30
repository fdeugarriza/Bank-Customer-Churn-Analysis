use [Bank Customer Churn]
select * from [Customer-Churn-Records]

**EXPLORATORY DATA ANALYSIS**
--Let's check our table first
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.Columns 
WHERE table_name = 'Customer-Churn-Records'

SELECT schema_name(tab.schema_id) AS schema_name,
    tab.NAME AS table_name, 
    col.column_id,
    col.NAME AS column_name, 
    t.NAME AS data_type,    
    col.max_length,
    col.PRECISION
FROM sys.tables AS tab
    inner join sys.columns AS col
        ON tab.object_id = col.object_id
    left join sys.types AS t
    ON col.user_type_id = t.user_type_id
ORDER BY schema_name,
    table_name, 
    column_id;

--Let's check the number of customers
SELECT COUNT (DISTINCT customerid)
FROM [Customer-Churn-Records]

--Let's look at how many countries the bank operates in
SELECT geography
FROM [Customer-Churn-Records]
GROUP BY Geography

--Now let's see how many customers we have per country
SELECT Geography, COUNT(customerid) as CustomerCount
FROM [Customer-Churn-Records]
GROUP BY Geography

--What is the average age of our customers?
SELECT AVG(Age) as AverageCustomerAge
FROM [Customer-Churn-Records] 

--What about the average age per country?
SELECT AVG(Age) as AvgCustAge, Geography 
FROM [Customer-Churn-Records]
GROUP BY Geography

--Now let's look at gender 
SELECT Gender, COUNT(gender) as GenderCount
FROM [Customer-Churn-Records]
GROUP BY Gender

--Now in percentages
SELECT Gender,
100*m_cnt/(m_cnt+f_cnt) as male_perc,
100*f_cnt/(m_cnt+f_cnt) as female_perc
from (
select Gender,
sum(case when gender = 'Male' then 1 else 0 end) as m_cnt,
sum(case when gender = 'Female' then 1 else 0 end) as f_cnt 
from [Customer-Churn-Records] group by Gender
) AS Gender_Churn

--What is the longest tenure in our bank?
SELECT MAX(Tenure) as LongTenCust FROM [Customer-Churn-Records]

--Let's double-check
SELECT CustomerId, Surname, Age, CreditScore, Tenure FROM [Customer-Churn-Records] 
ORDER BY Tenure DESC


**CUSTOMER CHURN DATA ANALYSIS**
--How many customers have had complaints?
SELECT COUNT(Customerid) as ComplaintAmount
FROM [Customer-Churn-Records]
WHERE Complain = 1 

--Let's find out how many customers have left the bank
SELECT COUNT(Customerid) as ChurnAmount
FROM [Customer-Churn-Records]
WHERE Exited = 1 

--There is almost 1:1 ratio of complaints to exits in our bank

-- What's the ratio of customer attrition then?
SELECT CAST(SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS FLOAT)/CAST(COUNT(*) AS FLOAT) 
* 100 as ChurnRate
FROM [Customer-Churn-Records]

--What's the churn rate in each country where we operate?
SELECT CAST(SUM(CASE WHEN exited = 1 THEN 1 ELSE 0 END) AS FLOAT)/CAST(COUNT(*) AS FLOAT)
* 100 as ChurnRate, Geography
FROM [Customer-Churn-Records]
GROUP BY Geography

--How many active customers with complaints have left the bank?
SELECT SUM(CASE WHEN exited = 1 AND complain = 1 AND isactivemember = 1 THEN 1 ELSE 0 END) as ExitsACTCOMPL
FROM [Customer-Churn-Records]

--How many active customers with NO complaints have left the bank?
SELECT SUM(CASE WHEN exited = 1 AND complain = 0 AND isactivemember = 1 THEN 1 ELSE 0 END) as ExitsACTNOCOMPL
FROM [Customer-Churn-Records]

--How many inactive customers with complaints have left the bank?
SELECT SUM(CASE WHEN exited = 1 AND complain = 1 AND isactivemember = 0 THEN 1 ELSE 0 END) as ExitsINACTCOMPL
FROM [Customer-Churn-Records]


--How many inactive customers with NO complaints have left the bank?
SELECT SUM(CASE WHEN exited = 1 AND complain = 0 AND isactivemember = 0 THEN 1 ELSE 0 END) as ExitsINACTNOCOMPL
FROM [Customer-Churn-Records]
 
--Let's look into card types: how many exits do we have with the various card types?
SELECT SUM(CASE WHEN exited = 1 AND Card_Type = 'DIAMOND' THEN 1 ELSE 0 END) as DIAMONDexits
FROM [Customer-Churn-Records]

SELECT SUM(CASE WHEN exited = 1 AND Card_Type = 'GOLD' THEN 1 ELSE 0 END) as GOLDDexits
FROM [Customer-Churn-Records]

SELECT SUM(CASE WHEN exited = 1 AND Card_Type = 'PLATINUM' THEN 1 ELSE 0 END) as PLATINUMexits
FROM [Customer-Churn-Records]

SELECT SUM(CASE WHEN exited = 1 AND Card_Type = 'SILVER' THEN 1 ELSE 0 END) as SILVERexits
FROM [Customer-Churn-Records]

--Now let's look into the number of products each customer who's left the bank had
SELECT SUM(CASE WHEN exited = 1 AND NumOfProducts = 1 THEN 1 ELSE 0 END) as ONEProduct
FROM [Customer-Churn-Records]

SELECT SUM(CASE WHEN exited = 1 AND NumOfProducts = 2 THEN 1 ELSE 0 END) as TWOProduct
FROM [Customer-Churn-Records]

SELECT SUM(CASE WHEN exited = 1 AND NumOfProducts = 3 THEN 1 ELSE 0 END) as THREEProduct
FROM [Customer-Churn-Records]

SELECT SUM(CASE WHEN exited = 1 AND NumOfProducts = 4 THEN 1 ELSE 0 END) as FOURProduct
FROM [Customer-Churn-Records]

