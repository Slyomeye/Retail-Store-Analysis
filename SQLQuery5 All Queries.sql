
--Removing duplicates
SELECT DISTINCT[Transaction_ID]
      ,[Customer_ID]
      ,[Category]
	  ,[Unit Price]
	  ,[No of Product]
      ,[Payment_Method]
	  ,[Total Amount]
      ,[Location]
      ,[Transaction_Date]
      ,[Discount_Applied]
  FROM [IZUCHUKWU ].[dbo].[retail_store_sales]

  --insert currency to values
  SELECT CONCAT('$',[Unit Price]) AS "Unit_Price"
       ,CONCAT('$',[Total Amount]) AS "Total_Amount"
  FROM [IZUCHUKWU ].[dbo].[retail_store_sales]

  --REPLACE null values using SQL statement.
SELECT
 COALESCE([Discount_Applied], 0) AS "Discount"
 COALESCE([Price_Per_Unit], [Total_Spent] / [Quantity]) AS "Unit Price"
 COALESCE([Quantity], 1) AS "Product"
 COALESCE([Total_Spent], [Price_Per_Unit] * COALESCE([Quantity], 1)) AS "Total Amount"
  FROM [IZUCHUKWU ].[dbo].[retail_store_sales]

  --add the columns to the  database
  ALTER [IZUCHUKWU ].[dbo].[retail_store_sales]
  ADD "Total Amount" AS COALESCE([Total_Spent], [Price_Per_Unit] * [Quantity])
  ADD "Product" AS COALESCE([Quantity], 1 
  ADD "Unit Price" AS COALESCE([Price_Per_Unit], [Total_Spent] / [Quantity]) 
    

  ALTER TABLE [IZUCHUKWU ].[dbo].[retail_store_sales]
  ADD "New Discount" AS COALESCE([Discount_Applied], 0) 

--No of Transactions
 SELECT COUNT(Transaction_ID) AS "No_of_Transactions"
  FROM  [IZUCHUKWU ].[dbo].[retail_store_sales] 

-- Total Revenue
SELECT SUM([Total Amount]) AS "Total Revenue"
  FROM [IZUCHUKWU ].[dbo].[retail_store_sales]


  -- Top Revenue Generating Product/Sales for each product
  SELECT [Category]
        ,SUM([Total Amount]) AS "Total Revenue"
 FROM [IZUCHUKWU ].[dbo].[retail_store_sales]
  GROUP BY [Category]
  ORDER BY SUM([Total Amount]) DESC

  --Product sales per month
  SELECT FORMAT([Transaction_Date],'MMMM/yy') AS "Month"
		,SUM([Quantity]) AS "Total_Units"
		,SUM([Total Amount]) AS "Total_Revenue"
	FROM  [IZUCHUKWU ].[dbo].[retail_store_sales]
	GROUP BY FORMAT([Transaction_Date],'MMMM/yy')
	ORDER BY Month, Total_Revenue DESC

  --Most Popular Payment Method
  SELECT [Payment_Method]
        ,COUNT(*) AS Transaction_count
  FROM  [IZUCHUKWU ].[dbo].[retail_store_sales]
  GROUP BY [Payment_Method]
  ORDER BY Transaction_count DESC

 
  --Customer Spending Behavior
  SELECT DISTINCT[Customer_ID]
        ,SUM([Total Amount]) AS "Customer_spending"
 FROM [IZUCHUKWU ].[dbo].[retail_store_sales]
 GROUP BY [Customer_ID]
 ORDER BY SUM([Total Amount]) DESC

 --customer retention analysis(1st purchase & Repeated purchases by customer)
 SELECT [Customer_ID]
       ,MIN([Transaction_Date]) AS "First_Purchase_date"
	   ,MAX([Transaction_Date]) AS "Last_Purchase_date"
	   ,COUNT(DISTINCT[Transaction_ID]) AS "Purchase_Count"
  FROM [IZUCHUKWU ].[dbo].[retail_store_sales]
  GROUP BY [Customer_ID]
  HAVING COUNT(DISTINCT[Transaction_ID]) > 1


  
 --Monthly Sales Trend Over time
 SELECT FORMAT([Transaction_Date], 'MMMM/yy') AS "Month"
       ,SUM([Total Amount]) AS "Monthly Sales"
	   ,SUM([Quantity]) AS "Quantity_Sold"
 FROM [IZUCHUKWU ].[dbo].[retail_store_sales]
 GROUP BY FORMAT([Transaction_Date], 'MMMM/yy')
 ORDER BY Month

 --Price trends over time
 SELECT [Category]
	   ,FORMAT([Transaction_Date], 'MMMM/yy') AS "Month"
	   ,SUM([Unit Price]) AS "Avg_Price" 
	FROM [IZUCHUKWU ].[dbo].[retail_store_sales]
	GROUP BY [Category],FORMAT([Transaction_Date], 'MMMM/yy') 
	ORDER BY Month ASC