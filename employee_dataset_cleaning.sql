-- DATA CLEANING 
-- Dataset source: https://www.kaggle.com/datasets/desolution01/messy-employee-dataset

SELECT *
FROM employee_dataset;

-- 1. Create a staging table to perform data cleaning

CREATE TABLE employee_dataset_staging
LIKE employee_dataset;

INSERT employee_dataset_staging
SELECT *
FROM employee_dataset;

-- 2. Standarize data

SELECT *
FROM employee_dataset_staging;

-- 2.1 'Employee_ID' column

SELECT Employee_ID,
       COUNT(*) AS count_duplicates
FROM employee_dataset_staging
GROUP BY Employee_ID
HAVING COUNT(*) > 1;

-- 2.2 'First Name' column

SELECT DISTINCT First_Name
FROM employee_dataset_staging;

-- 2.3 'Last Name' column

SELECT DISTINCT Last_Name
FROM employee_dataset_staging;

-- 2.4 'Age' column

SELECT DISTINCT Age
FROM employee_dataset_staging;

UPDATE employee_dataset_staging
SET Age = NULL
WHERE Age = '';

ALTER TABLE employee_dataset_staging
MODIFY COLUMN Age INT;

-- 2.5 'Department_Region' column

SELECT DISTINCT Department_Region
FROM employee_dataset_staging;

ALTER TABLE employee_dataset_staging
ADD COLUMN Department VARCHAR(100) AFTER Age,
ADD COLUMN Region VARCHAR(100) AFTER Department;

UPDATE employee_dataset_staging
SET
	Department = SUBSTRING_INDEX(Department_Region, '-', 1),
    Region = SUBSTRING_INDEX(Department_Region, '-', -1);

ALTER TABLE employee_dataset_staging
DROP COLUMN Department_Region;

-- 2.6 'Status' column

SELECT DISTINCT `Status`
FROM employee_dataset_staging;

-- 2.7 'Join_Date' column

SELECT DISTINCT Join_Date
FROM employee_dataset_staging;

SELECT Join_Date
FROM employee_dataset_staging
WHERE Join_Date IS NULL;

ALTER TABLE employee_dataset_staging
ADD COLUMN Join_Date_Converted DATE;

UPDATE employee_dataset_staging
SET Join_Date_Converted = Join_Date;

ALTER TABLE employee_dataset_staging
DROP COLUMN Join_Date;

ALTER TABLE employee_dataset_staging
CHANGE COLUMN Join_Date_Converted Join_Date DATE
AFTER `Status`;

-- 2.8 'Salary' column

SELECT DISTINCT Salary
FROM employee_dataset_staging;

-- 2.9 'Email' column

SELECT DISTINCT Email
FROM employee_dataset_staging;

-- 2.10 'Phone' column

SELECT DISTINCT Phone
FROM employee_dataset_staging;

-- 2.11 'Performance_Score' column

SELECT DISTINCT Performance_Score
FROM employee_dataset_staging;

-- 2.11 'Remote_Work' column

SELECT DISTINCT Remote_Work
FROM employee_dataset_staging;

-- 3. Check for duplicates

SELECT *
FROM employee_dataset_staging;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY First_Name, Last_Name, Age, Email
ORDER BY Join_Date) AS `row_number`
FROM employee_dataset_staging;

WITH duplicated_CTE AS(
	SELECT Employee_ID,
    ROW_NUMBER() OVER(
		PARTITION BY First_Name, Last_Name, Age, Email
		ORDER BY Join_Date) AS `row_number`
	FROM employee_dataset_staging
)
DELETE FROM employee_dataset_staging
WHERE Employee_ID IN (
	SELECT Employee_ID
    FROM duplicated_CTE
    WHERE `row_number` > 1
);

-- 4. Final visualization 
SELECT *
FROM employee_dataset_staging;




