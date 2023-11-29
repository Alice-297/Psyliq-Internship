create database psyliq
use Psyliq;

select * from Diabet;

--Q1. Retrieve the Patient_id and ages of all patients.

select Patient_id, age
from Diabet;

--Q2. Select all female patients who are older than 40.

select * from Diabet
where gender = 'Female' and age >= 40


--Q3. Calculate the average BMI of patients.

select avg(bmi) as Avg_BMI
from Diabet

--Q4. List patients in descending order of blood glucose levels.

select * 
from Diabet
order by blood_glucose_level desc;

--Q5. Find patients who have hypertension and diabetes.

select *
from Diabet
where hypertension = 1 and diabetes = 1

--Q6. Determine the number of patients with heart disease.

select count(Patient_id) as Patient_id_with_heartdisease
from Diabet
where heart_disease = 1

--Q7. Group patients by smoking history and count how many smokers and nonsmokers there are.
--a)
select Patient_id,EmployeeName,gender,age,hypertension,bmi,blood_glucose_level,HbA1c_level,diabetes,smoking_history  
from Diabet
group by smoking_history,Patient_id,EmployeeName,gender,age,hypertension,bmi,blood_glucose_level,HbA1c_level,diabetes
--b)
select sum( case when smoking_history In ('current','not current','ever','former') then 1 else 0 end) as Smokers,
       sum( case when smoking_history In ('never') then 1 else 0 end) as NoSmokers
from Diabet

--Q8. Retrieve the Patient_ids of patients who have a BMI greater than the average BMI.

select Patient_id from Diabet
where bmi > (
select avg(bmi) as Avg_BMI
from Diabet )


--Q9. Find the patient with the highest HbA1c level and the patient with the lowest HbA1clevel.

select top 1 Patient_id, HbA1c_level as Highest_HbA1c_level
from Diabet
Order by HbA1c_level desc

select top 1 Patient_id, HbA1c_level as Lowest_HbA1c_level
from Diabet
Order by HbA1c_level 


--Q10. Calculate the age of patients in years (assuming the current date as of now).

select Patient_id,age, Year(Getdate())- EstimatedBirthYear as Age_In_Years 
from (
select Patient_id, age, Year(Getdate())- age as EstimatedBirthYear
from Diabet) as t

--Q11. Rank patients by blood glucose level within each gender group.

select Patient_id,gender,blood_glucose_level,
DENSE_RANK() over ( Partition by gender order by blood_glucose_level desc) as Ranked_Patients
from Diabet


--Q12. Update the smoking history of patients who are older than 50 to "Ex-smoker."

Update Diabet
Set smoking_history = 'Ex-smoker'
where age > 50 

--Q13. Insert a new patient into the database with sample data.

Insert into Diabet (EmployeeName,Patient_id,gender,age,hypertension, heart_disease,smoking_history,bmi,HbA1c_level,blood_glucose_level,diabetes)
 values ( 'John Doe', 'PT100101', 'Male', 45, 1, 0, 'current', 28, 6.3, 120, 1),
('Jane Smith', 'PT100102', 'Female', 38, 0, 1, 'Never', 31, 7.1, 140, 1),
('Alice Johnson', 'PT100103', 'Female', 35, 0, 0, 'Never', 25, 5.8, 100, 0)

--Q14. Delete all patients with heart disease from the database.

delete Diabet
where heart_disease = 1

--Q15. Find patients who have hypertension but not diabetes using the EXCEPT operator.

select *
from Diabet
where hypertension = 1 
Except
select *
from Diabet
where diabetes =1


--16. Define a unique constraint on the "patient_id" column to ensure its values are unique.

alter table Diabet
add constraint Patient_id Unique(Patient_id);

--Q17. Create a view that displays the Patient_ids, ages, and BMI of patients.

CREATE VIEW  Patient_Info as
select Patient_id, age, bmi
from Diabet

select Patient_id, age, bmi
from Patient_Info


--Q18. Suggest improvements in the database schema to reduce data redundancy and improve data integrity.
/*
To reduce data redundancy and improve data integrity in a database schema, consider the following improvements:

Normalization:

Break down large tables into smaller, related tables to organize data more efficiently and reduce redundancy. Use normalization techniques (such as First Normal Form (1NF), Second Normal Form (2NF), etc.) to eliminate duplicate data.
Create separate tables for related entities and establish relationships using foreign keys.
Use of Primary and Foreign Keys:

Define primary keys for each table to ensure uniqueness and data integrity within the table.
Utilize foreign keys to establish relationships between tables and maintain referential integrity.
Avoiding Repeated Information:

Avoid storing the same information in multiple places. Instead, create a single source of truth for specific data elements and reference them using foreign keys.
Implement Constraints:

Use constraints such as NOT NULL, UNIQUE, CHECK, and FOREIGN KEY to enforce data integrity rules at the database level.
Apply constraints to ensure that only valid and consistent data can be inserted or updated in the database.
Use Views:

Create views to display specific subsets of data or join tables as needed without duplicating data physically. This can help simplify complex queries and prevent redundant storage.
Consider Denormalization for Performance:

While normalization reduces redundancy, there are cases where denormalization might be appropriate for performance optimization. Evaluate scenarios where data retrieval speed is crucial and consider denormalizing specific data elements or tables cautiously to improve query performance.
Regular Data Auditing and Maintenance:

Implement regular data auditing processes to identify and correct inconsistencies or errors in the database.
Schedule routine maintenance tasks to ensure data consistency, clean up redundant or obsolete data, and optimize database performance.
Documentation and Naming Conventions:

Maintain comprehensive documentation for the database schema, including relationships, constraints, and business rules.
Use consistent naming conventions for tables, columns, keys, and constraints to improve clarity and maintainability.
Considerations for Indexing:

Use indexing appropriately to improve query performance, but avoid excessive indexing, which can lead to increased overhead during data modifications.
Data Migration Strategy:

If restructuring the database schema, plan and execute a proper data migration strategy to ensure a smooth transition without data loss or corruption.*/



--Q19. Explain how you can optimize the performance of SQL queries on this dataset.

/*
Optimizing the performance of SQL queries on a dataset involves several strategies to enhance query execution speed and efficiency. Here are several techniques that can be applied to optimize SQL queries:

1. Indexing:
Identify Key Columns: Determine columns frequently used in WHERE, JOIN, and ORDER BY clauses. Create appropriate indexes (including composite indexes for multiple columns) to speed up data retrieval.
Avoid Over-Indexing: Be cautious not to create too many indexes, as it can impact write performance and consume additional storage.
2. Use of Proper Joins:
Use INNER Joins over OUTER Joins: INNER joins generally perform better than OUTER joins. Use the appropriate join type based on the data retrieval needs.
Avoid Cartesian Products: Ensure joins are correctly defined to prevent unintended cartesian products that can significantly increase result set size.
3. Query Optimization:
Selective Retrieval: Fetch only the necessary columns and rows by using precise SELECT statements.
**Avoid SELECT ***: Explicitly mention required column names instead of using SELECT * to reduce unnecessary data transfer.
Use WHERE Clause Wisely: Apply effective filtering conditions in the WHERE clause to reduce the number of rows fetched.
Optimize Subqueries and CTEs: Optimize complex queries with subqueries or Common Table Expressions (CTEs) to improve readability and performance.
4. Database Statistics and Analyzers:
Maintain Statistics: Regularly update statistics for tables and indexes to ensure the query optimizer has up-to-date information for making efficient execution plans.
Utilize Database Analyzers and Profilers: Use built-in tools or external profilers to identify poorly performing queries and understand execution plans.
5. Database Configuration and Settings:
Memory and Buffer Pool Configuration: Allocate sufficient memory to the database server to reduce disk I/O and utilize caching for frequently accessed data.
Tune Database Parameters: Adjust configuration parameters like buffer sizes, parallelism, and cache settings to optimize query performance.
6. Table Partitioning and Data Archiving:
Partition Large Tables: Divide large tables into smaller partitions based on certain criteria (e.g., date ranges) to improve query performance on subsets of data.
Archive Historical Data: Move old or infrequently accessed data to separate tables or archival storage to reduce the size of active tables.
7. Regular Maintenance and Optimization:
Scheduled Index Rebuilds and Defragmentation: Regularly perform index maintenance tasks to reclaim space and ensure optimal index performance.
Database Monitoring and Performance Tuning: Monitor database performance regularly and tune queries based on observed patterns or bottlenecks.
8. Hardware and Infrastructure Optimization:
Proper Hardware Allocation: Ensure that the database server has adequate resources like CPU, memory, and disk I/O to handle query loads efficiently.
Consideration of SSDs or Faster Storage: Utilize faster storage options to reduce disk latency for read-intensive operations.*/
