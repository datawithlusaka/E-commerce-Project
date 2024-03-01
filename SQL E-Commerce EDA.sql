--Finding duplicates
Select OrderID,COUNT(OrderID)
From [Ecommerce_Data-1]
Group by OrderID
Having COUNT(OrderID) > 1;

--Removing Duplicates
Select *,
	ROW_NUMBER() over(Partition by OrderID Order By OrderID) As Duplicate_rows
	From [Ecommerce_Data-1]

With CTE As
	(Select *,
	ROW_NUMBER()Over(Partition by OrderID Order By OrderID) AS Duplicate_rows
	From [Ecommerce_Data-1])
	Delete From CTE Where Duplicate_rows >1;



	--Finding non numeric
Select *
From [Ecommerce_Data-1]
Where ISNUMERIC(UnitPrice) <> 1;

--Delete non numeric
Delete From [Ecommerce_Data-1]
Where  ISNUMERIC(UnitPrice) <>1;


--Finding Numeric
Select *
From [Ecommerce_Data-1]
Where ISNUMERIC(Country) = 1;

--Delete numeric
Delete From [Ecommerce_Data-1]
Where  ISNUMERIC(Country) =1;




Select *
From [Ecommerce_Data-1]
Where ISNUMERIC(Quantity) <> 1;

--Check Data Type is Correct in The right format
Alter Table [Ecommerce_Data-1]
Alter Column Quantity float;

Alter Table [Ecommerce_Data-1]
Alter Column UnitPrice float;




--E-COMMERCE DATA EXPLORATION
Select *
From [Ecommerce_Data-1]

--Goods Sold Per hour
Select [Hour], Count(Quantity) as Sold_goods
From [Ecommerce_Data-1]
Group by  [Hour]
Order by  [Hour] Desc;

Select OrderID,Quantity,(Select AVG(Quantity) From [Ecommerce_Data-1]) As avgquantity
From [Ecommerce_Data-1]

--Customers Per date
Select COUNT(CustomerID) as Customers,[Date]
From [Ecommerce_Data-1]
Group by [Date]
Order by [Date]

--Customers with most orders
Select top (10) CustomerID,COUNT(OrderID) as orders
From [Ecommerce_Data-1]
Group by CustomerID
Order by orders desc;

--Customers that spend the most amount.(POWER BI)
Select top(10) CustomerID,SUM(Cost) As amount_spent
From [Ecommerce_Data-1] 
Group by CustomerID
Order by amount_spent desc;

--Arrangement of the most frequent items(top 20)
Select Top (20) StockCode,COUNT(OrderID) as orders
From [Ecommerce_Data-1]
Group by StockCode
Order by orders desc;

--Most expensive purchase made by country
Select top(10) MAX(Cost) as Highest,Country
From [Ecommerce_Data-1]
Group by Country
Order by Highest Desc;

--Date With most Sales
Select Distinct [Date],SUM(Cost) as Sales
From [Ecommerce_Data-1]
Group by [Date]
Order by Sales Desc;

--Date with most Orders
Select Distinct [Date],COUNT(OrderID) as Orders
From [Ecommerce_Data-1]
Group by [Date]
Order by Orders Desc;


--Dates with least orders
Select Distinct [Date],COUNT(OrderID) as Orders
From [Ecommerce_Data-1]
Group by [Date]
Order by Orders;

--Most expensive purchase made
Select MAX(Cost) as Highest,Country
From [Ecommerce_Data-1]
Group by Country
Order by Highest Desc;

--Aggregate functions
SELECT 
	AVG(Quantity) as Avg_quantity,
	Sum(Quantity) as Total_quantity,
	COUNT(*) as row_count,
	MIN(Quantity) as min_quantity,
	Max(Quantity) as max_quantity
	From [Ecommerce_Data-1]

--Standard Deviation
Select 
	STDEV(Quantity) as Std_dev,
	VAR(QUantity) as Variance
From [Ecommerce_Data-1]

--Grouped Analysis
Select
   Country,
   AVG(Cost) as Avg_sales,STDEV(Cost) as Std_dev 
   FRom [Ecommerce_Data-1]
   Group by Country




--BREAK DOWN BY COUNTRY
--Sales by Country
Select distinct Country,SUM(Cost) as amount_spent ,COUNT(CustomerID) as Customers
From [Ecommerce_Data-1]
Group by Country
Order by amount_spent Desc;

--Goods Sold By Country
Select Country, Count(Quantity) as Sold_goods
From [Ecommerce_Data-1]
Group by  Country
Order by  Sold_goods Desc;

--Customers Per Country
Select COUNT(CustomerID)  as Customers,Country
From [Ecommerce_Data-1]
Group by Country
Order by Customers Desc;


--Country with most quantity sold
Select SUM(Quantity) as Goods,Country
From [Ecommerce_Data-1]
Group by Country
Order by Goods Desc;


Select *
From [Ecommerce_Data-1]
Where Quantity > (Select AVG(Quantity) From [Ecommerce_Data-1])

Select *
From [Ecommerce_Data-1] e
join  (Select AVG(Quantity) sal  From [Ecommerce_Data-1]) avg_quant
on e.Quantity > avg_quant.sal;

--Highest Sales In each country
Select Country,Max(Cost)
from [Ecommerce_Data-1]
Group by Country

Select e.*
From [Ecommerce_Data-1] e
inner join  (Select Country,Max(Cost) as Maxsales
			from [Ecommerce_Data-1]
			Group by Country) as d
			on e.Country =d.Country and e.Cost = d.Maxsales

---The Sales shown are the sales above the avg Sales in each Country
Select *
From [Ecommerce_Data-1] e1
Where Cost >(select AVG(Cost)
			 From [Ecommerce_Data-1] e2
			 Where e1.Country= e2.Country)


  --Finding the Country whose Sales were better than the average sales of the Other Country
Select *
From(Select Country,SUM(Cost) as TotalSales
     From [Ecommerce_Data-1]
     Group by Country) sales
join (Select AVG(TotalSales) As Avg_sales
From(Select Country,SUM(Cost) as TotalSales
     From [Ecommerce_Data-1]
     Group by Country)x)avg_sales
	 on sales.Totalsales > Avg_sales.avg_sales
	


