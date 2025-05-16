create database project;
use project;

select * from customer_churn;

# Calculate Overall Churn Rate
SELECT 
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS churn_rate_percentage
FROM customer_churn;

# Find churn rate by region/state/province.
SELECT 
    State,
    COUNT(*) AS Total_Customers,
    COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS Churned_Customers,
    ROUND(
        COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 2
    ) AS Churn_Rate_Percent
FROM Customer_Churn
GROUP BY State;

# Identify high-churn service plans or subscription types.
SELECT 
    Contract,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customer,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS churn_rate_percentage
FROM Customer_Churn
GROUP BY Contract
ORDER BY churn_rate_percentage DESC;

# Retrieve customers with long tenure but sudden churn.
SELECT customerID, tenure, Churn
FROM Customer_Churn
WHERE tenure >= 24 AND Churn = 'Yes'
ORDER BY tenure DESC;

# Find customers who contacted support frequently and still churned.
SELECT customerID, TechSupport, Churn
FROM Customer_Churn
WHERE TechSupport = 'Yes' AND Churn = 'Yes';

# Rank service plans by customer lifetime value.
SELECT 
    Contract,
    ROUND(AVG(MonthlyCharges * tenure), 2) AS avg_lifetime_value,
    COUNT(*) AS total_customers
FROM Customer_Churn
GROUP BY Contract
ORDER BY avg_lifetime_value DESC;

# Segment customers based on monthly charges and churn status.
SELECT 
    CASE 
        WHEN MonthlyCharges < 30 THEN 'Low'
        WHEN MonthlyCharges BETWEEN 30 AND 70 THEN 'Medium'
        ELSE 'High'
    END AS ChargeSegment,
    Churn,
    COUNT(*) AS customer_count
FROM Customer_Churn
GROUP BY ChargeSegment, Churn
ORDER BY ChargeSegment, Churn;