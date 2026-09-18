create database blinkitdb;
use blinkitdb;
CREATE TABLE blinkit_data (
    item_fat_content VARCHAR(20),
    item_identifier VARCHAR(20),
    item_type VARCHAR(50),
    outlet_establishment_year INT,
    outlet_identifier VARCHAR(20),
    outlet_location_type VARCHAR(20),
    outlet_size VARCHAR(20),
    outlet_type VARCHAR(30),
    item_visibility DECIMAL(10,6),
    item_weight DECIMAL(10,2),
    sales DECIMAL(10,4),
    rating DECIMAL(3,1)
);

SELECT * FROM blinkit_data;

UPDATE blinkit_data
SET Item_Fat_Content =
    CASE
        WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
        WHEN Item_Fat_Content = 'reg' THEN 'Regular'
        ELSE Item_Fat_Content
    END;

SELECT DISTINCT Item_Fat_Content
FROM blinkit_data;

##1. Total Sales
SELECT CAST(SUM(sales) / 1000000.0 AS DECIMAL(10,2)) AS Total_Sales_Million
FROM blinkit_data;

##2. Average Sales
SELECT CAST(AVG(sales) AS DECIMAL(10,2)) AS Avg_Sales
FROM blinkit_data;

##3. NUMBER OF ITEMS
SELECT COUNT(*) AS No_of_Orders
FROM blinkit_data;

##4. AVERAGE RATING
SELECT CAST(AVG(Rating) AS DECIMAL(10,1)) AS Avg_Rating
FROM blinkit_data;

##5. Total Sales by Fat Content
SELECT Item_Fat_Content,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Item_Fat_Content;

##6. Total Sales by Item Type
SELECT Item_Type,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC;

##7. Total Sales by Outlet Establishment Year
SELECT Outlet_Establishment_Year,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;

##8. Percentage of Sales by Outlet Size
SELECT
    Outlet_Size,
    CAST(SUM(sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(
        (SUM(sales) * 100.0 /
        SUM(SUM(sales)) OVER())
        AS DECIMAL(10,2)
    ) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

##9. Sales by Outlet Location
SELECT Outlet_Location_Type,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;

##10. All Metrics by Outlet Type
SELECT Outlet_Type,
       CAST(SUM(sales) AS DECIMAL(10,2)) AS Total_Sales,
       CAST(AVG(sales) AS DECIMAL(10,0)) AS Avg_Sales,
       COUNT(*) AS No_Of_Items,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
       CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;

##11. Top 10 Highest Selling Items
SELECT Item_Identifier, Item_Type,
       CAST(Sales AS DECIMAL(10,2)) AS Sales
FROM blinkit_data
ORDER BY Sales DESC
LIMIT 10;

##12. Lowest Selling Items
SELECT Item_Identifier, Item_Type,
       CAST(Sales AS DECIMAL(10,2)) AS Sales
FROM blinkit_data
ORDER BY Sales ASC
LIMIT 10;

##13. Average Sales by Outlet Size
SELECT Outlet_Size,
       CAST(AVG(Sales) AS DECIMAL(10,2)) AS Avg_Sales
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Avg_Sales DESC;

##14. Average Rating by Item Type
SELECT Item_Type,
       CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Avg_Rating DESC;

##15. Outlet Type with Highest Sales
SELECT Outlet_Type,
       CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC
LIMIT 1;

##16. Item Visibility vs Sales
SELECT Item_Identifier,
       Item_Visibility,
       CAST(Sales AS DECIMAL(10,2)) AS Sales
FROM blinkit_data
ORDER BY Item_Visibility DESC
LIMIT 20;

##17. Sales Distribution by Fat Content
SELECT Item_Fat_Content,
       COUNT(*) AS Total_Items,
       CAST(AVG(Sales) AS DECIMAL(10,2)) AS Avg_Sales
FROM blinkit_data
GROUP BY Item_Fat_Content;

##18. Oldest Outlet Performance
SELECT Outlet_Establishment_Year,
       CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year ASC
LIMIT 5;

##19. Rating Distribution
SELECT Rating,
       COUNT(*) AS Total_Items
FROM blinkit_data
GROUP BY Rating
ORDER BY Rating DESC;

##20. Sales by Location + Outlet Type
SELECT Outlet_Location_Type,
       Outlet_Type,
       CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type, Outlet_Type
ORDER BY Total_Sales DESC;

##21. Highest Rated Item in Each Category
SELECT Item_Type,
       MAX(Rating) AS Highest_Rating
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Highest_Rating DESC;

##22. Sales Performance Classification
SELECT Item_Identifier,
       Sales,
       CASE
           WHEN Sales > 200 THEN 'High Sales'
           WHEN Sales BETWEEN 100 AND 200 THEN 'Medium Sales'
           ELSE 'Low Sales'
       END AS Sales_Category
FROM blinkit_data;

##23. Top Performing Outlet in Each Location
SELECT Outlet_Location_Type,
       Outlet_Identifier,
       SUM(Sales) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type, Outlet_Identifier
ORDER BY Outlet_Location_Type, Total_Sales DESC;

##24. Correlation Check (Weight vs Sales)
SELECT Item_Weight,
       CAST(AVG(Sales) AS DECIMAL(10,2)) AS Avg_Sales
FROM blinkit_data
GROUP BY Item_Weight
ORDER BY Item_Weight;