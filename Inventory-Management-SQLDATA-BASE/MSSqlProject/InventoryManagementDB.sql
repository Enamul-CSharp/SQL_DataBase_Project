USE [master]
GO
/****** Object:  Database [Inventory Management]    Script Date: 6/14/2023 4:04:53 PM ******/
CREATE DATABASE [Inventory Management]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Inventory Management', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\Inventory Management.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Inventory Management_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\Inventory Management_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Inventory Management] SET COMPATIBILITY_LEVEL = 130
GO
USE [Inventory Management]
GO
/****** Object:  Login [StoreLogin]    Script Date: 6/14/2023 4:04:53 PM ******/
CREATE LOGIN [StoreLogin] WITH PASSWORD=N'123456', DEFAULT_DATABASE=[Inventory Management], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=off
GO
ALTER AUTHORIZATION ON DATABASE::[Inventory Management] TO [DESKTOP-2BSVBTT\IDB Lab-1 PC -3]
GO
ALTER SERVER ROLE [MyServerRole] ADD MEMBER [StoreLogin]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT SERVICE\Winmgmt]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT SERVICE\SQLWriter]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [NT Service\MSSQL$SQLEXPRESS]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [DESKTOP-2BSVBTT\IDB Lab-1 PC -3]
GO
USE [Inventory Management]
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateOrderTotal]    Script Date: 6/14/2023 4:04:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CalculateOrderTotal](
  @order_id INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
  DECLARE @total DECIMAL(10, 2);

  SELECT @total = SUM(quantity * unit_price)
  FROM Order_Items
  WHERE order_id = @order_id;

  RETURN @total;
END;
GO
ALTER AUTHORIZATION ON [dbo].[CalculateOrderTotal] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 6/14/2023 4:04:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[customer_id] [int] NOT NULL,
	[customer_name] [varchar](100) NULL,
	[address] [varchar](200) NULL,
	[phone_number] [varchar](20) NULL,
	[email] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Customers] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 6/14/2023 4:04:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[order_id] [int] NOT NULL,
	[customer_id] [int] NULL,
	[order_date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Orders] TO  SCHEMA OWNER 
GO
/****** Object:  View [dbo].[OrderDetails]    Script Date: 6/14/2023 4:04:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[OrderDetails] AS
SELECT o.order_id, o.order_date, c.customer_name, c.address, c.phone_number, c.email
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;
GO
ALTER AUTHORIZATION ON [dbo].[OrderDetails] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 6/14/2023 4:04:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[category_id] [int] NOT NULL,
	[category_name] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Categories] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Order_Items]    Script Date: 6/14/2023 4:04:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order_Items](
	[order_item_id] [int] NOT NULL,
	[order_id] [int] NULL,
	[product_id] [int] NULL,
	[quantity] [int] NULL,
	[unit_price] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[order_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Order_Items] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Products]    Script Date: 6/14/2023 4:04:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[product_id] [int] NOT NULL,
	[product_name] [varchar](100) NULL,
	[category_id] [int] NULL,
	[unit_price] [decimal](10, 2) NULL,
	[quantity_in_stock] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Products] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Suppliers]    Script Date: 6/14/2023 4:04:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Suppliers](
	[supplier_id] [int] NOT NULL,
	[supplier_name] [varchar](100) NULL,
	[contact_person] [varchar](100) NULL,
	[phone_number] [varchar](20) NULL,
	[email] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[supplier_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Suppliers] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Warehouses]    Script Date: 6/14/2023 4:04:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Warehouses](
	[warehouse_id] [int] NOT NULL,
	[warehouse_name] [varchar](100) NULL,
	[location] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[warehouse_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Warehouses] TO  SCHEMA OWNER 
GO
INSERT [dbo].[Categories] ([category_id], [category_name]) VALUES (1, N'Electronics')
GO
INSERT [dbo].[Categories] ([category_id], [category_name]) VALUES (2, N'Clothing')
GO
INSERT [dbo].[Categories] ([category_id], [category_name]) VALUES (3, N'Books')
GO
INSERT [dbo].[Categories] ([category_id], [category_name]) VALUES (4, N'Furniture')
GO
INSERT [dbo].[Categories] ([category_id], [category_name]) VALUES (5, N'Appliances')
GO
INSERT [dbo].[Categories] ([category_id], [category_name]) VALUES (6, N'Beauty')
GO
INSERT [dbo].[Categories] ([category_id], [category_name]) VALUES (7, N'Groceries')
GO
INSERT [dbo].[Customers] ([customer_id], [customer_name], [address], [phone_number], [email]) VALUES (1, N'John Smith', N'123 ABC Road, Dhaka', N'+880111111111', N'john@example.com')
GO
INSERT [dbo].[Customers] ([customer_id], [customer_name], [address], [phone_number], [email]) VALUES (2, N'Jane Doe', N'456 XYZ Street, Chittagong', N'+880222222222', N'jane@example.com')
GO
INSERT [dbo].[Customers] ([customer_id], [customer_name], [address], [phone_number], [email]) VALUES (3, N'Ahmed Khan', N'789 PQR Lane, Sylhet', N'+880333333333', N'ahmed@example.com')
GO
INSERT [dbo].[Customers] ([customer_id], [customer_name], [address], [phone_number], [email]) VALUES (4, N'Farah Rahman', N'321 MNO Road, Khulna', N'+880444444444', N'farah@example.com')
GO
INSERT [dbo].[Customers] ([customer_id], [customer_name], [address], [phone_number], [email]) VALUES (5, N'Ali Ahmed', N'654 RST Street, Rajshahi', N'+880555555555', N'ali@example.com')
GO
INSERT [dbo].[Customers] ([customer_id], [customer_name], [address], [phone_number], [email]) VALUES (6, N'Tasnim Hossain', N'987 UVW Avenue, Barisal', N'+880666666666', N'tasnim@example.com')
GO
INSERT [dbo].[Customers] ([customer_id], [customer_name], [address], [phone_number], [email]) VALUES (7, N'Rahim Hasan', N'852 XYZ Lane, Rangpur', N'+880777777777', N'rahim@example.com')
GO
INSERT [dbo].[Order_Items] ([order_item_id], [order_id], [product_id], [quantity], [unit_price]) VALUES (1, 1, 1, 2, CAST(50000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[Order_Items] ([order_item_id], [order_id], [product_id], [quantity], [unit_price]) VALUES (2, 1, 2, 3, CAST(500.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[Order_Items] ([order_item_id], [order_id], [product_id], [quantity], [unit_price]) VALUES (3, 2, 3, 1, CAST(300.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[Order_Items] ([order_item_id], [order_id], [product_id], [quantity], [unit_price]) VALUES (4, 3, 4, 1, CAST(15000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[Order_Items] ([order_item_id], [order_id], [product_id], [quantity], [unit_price]) VALUES (5, 4, 5, 1, CAST(40000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[Order_Items] ([order_item_id], [order_id], [product_id], [quantity], [unit_price]) VALUES (6, 5, 6, 2, CAST(200.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[Order_Items] ([order_item_id], [order_id], [product_id], [quantity], [unit_price]) VALUES (7, 6, 7, 5, CAST(50.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[Order_Items] ([order_item_id], [order_id], [product_id], [quantity], [unit_price]) VALUES (8, 7, 8, 3, CAST(30000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[Orders] ([order_id], [customer_id], [order_date]) VALUES (1, 1, CAST(N'2023-06-01' AS Date))
GO
INSERT [dbo].[Orders] ([order_id], [customer_id], [order_date]) VALUES (2, 2, CAST(N'2023-06-05' AS Date))
GO
INSERT [dbo].[Orders] ([order_id], [customer_id], [order_date]) VALUES (3, 3, CAST(N'2023-06-07' AS Date))
GO
INSERT [dbo].[Orders] ([order_id], [customer_id], [order_date]) VALUES (4, 4, CAST(N'2023-06-10' AS Date))
GO
INSERT [dbo].[Orders] ([order_id], [customer_id], [order_date]) VALUES (5, 5, CAST(N'2023-06-12' AS Date))
GO
INSERT [dbo].[Orders] ([order_id], [customer_id], [order_date]) VALUES (6, 6, CAST(N'2023-06-15' AS Date))
GO
INSERT [dbo].[Orders] ([order_id], [customer_id], [order_date]) VALUES (7, 7, CAST(N'2023-06-18' AS Date))
GO
INSERT [dbo].[Products] ([product_id], [product_name], [category_id], [unit_price], [quantity_in_stock]) VALUES (1, N'Laptop', 1, CAST(50000.00 AS Decimal(10, 2)), 9)
GO
INSERT [dbo].[Products] ([product_id], [product_name], [category_id], [unit_price], [quantity_in_stock]) VALUES (2, N'T-Shirt', 2, CAST(500.00 AS Decimal(10, 2)), 20)
GO
INSERT [dbo].[Products] ([product_id], [product_name], [category_id], [unit_price], [quantity_in_stock]) VALUES (3, N'Novel', 3, CAST(300.00 AS Decimal(10, 2)), 15)
GO
INSERT [dbo].[Products] ([product_id], [product_name], [category_id], [unit_price], [quantity_in_stock]) VALUES (4, N'Sofa', 4, CAST(15000.00 AS Decimal(10, 2)), 5)
GO
INSERT [dbo].[Products] ([product_id], [product_name], [category_id], [unit_price], [quantity_in_stock]) VALUES (5, N'Refrigerator', 5, CAST(40000.00 AS Decimal(10, 2)), 8)
GO
INSERT [dbo].[Products] ([product_id], [product_name], [category_id], [unit_price], [quantity_in_stock]) VALUES (6, N'Lipstick', 6, CAST(200.00 AS Decimal(10, 2)), 30)
GO
INSERT [dbo].[Products] ([product_id], [product_name], [category_id], [unit_price], [quantity_in_stock]) VALUES (7, N'Rice', 7, CAST(50.00 AS Decimal(10, 2)), 100)
GO
INSERT [dbo].[Products] ([product_id], [product_name], [category_id], [unit_price], [quantity_in_stock]) VALUES (8, N'Mobile Phone', 1, CAST(30000.00 AS Decimal(10, 2)), 12)
GO
INSERT [dbo].[Suppliers] ([supplier_id], [supplier_name], [contact_person], [phone_number], [email]) VALUES (1, N'ABC Electronics', N'John Doe', N'+880123456789', N'john@abc.com')
GO
INSERT [dbo].[Suppliers] ([supplier_id], [supplier_name], [contact_person], [phone_number], [email]) VALUES (2, N'XYZ Clothing', N'Jane Smith', N'+880987654321', N'jane@xyz.com')
GO
INSERT [dbo].[Suppliers] ([supplier_id], [supplier_name], [contact_person], [phone_number], [email]) VALUES (3, N'Book House', N'David Johnson', N'+880555555555', N'david@bookhouse.com')
GO
INSERT [dbo].[Suppliers] ([supplier_id], [supplier_name], [contact_person], [phone_number], [email]) VALUES (4, N'Furniture World', N'Sarah Thompson', N'+880666666666', N'sarah@furnitureworld.com')
GO
INSERT [dbo].[Suppliers] ([supplier_id], [supplier_name], [contact_person], [phone_number], [email]) VALUES (5, N'Appliance Center', N'Michael Brown', N'+880777777777', N'michael@appliancecenter.com')
GO
INSERT [dbo].[Suppliers] ([supplier_id], [supplier_name], [contact_person], [phone_number], [email]) VALUES (6, N'Beauty Hub', N'Emily Wilson', N'+880888888888', N'emily@beautyhub.com')
GO
INSERT [dbo].[Suppliers] ([supplier_id], [supplier_name], [contact_person], [phone_number], [email]) VALUES (7, N'Super Mart', N'Robert Davis', N'+880999999999', N'robert@supermart.com')
GO
INSERT [dbo].[Warehouses] ([warehouse_id], [warehouse_name], [location]) VALUES (1, N'Central Warehouse', N'Dhaka')
GO
INSERT [dbo].[Warehouses] ([warehouse_id], [warehouse_name], [location]) VALUES (2, N'Regional Warehouse', N'Chittagong')
GO
INSERT [dbo].[Warehouses] ([warehouse_id], [warehouse_name], [location]) VALUES (3, N'Branch Warehouse', N'Sylhet')
GO
INSERT [dbo].[Warehouses] ([warehouse_id], [warehouse_name], [location]) VALUES (4, N'Branch Warehouse', N'Khulna')
GO
INSERT [dbo].[Warehouses] ([warehouse_id], [warehouse_name], [location]) VALUES (5, N'Branch Warehouse', N'Rajshahi')
GO
INSERT [dbo].[Warehouses] ([warehouse_id], [warehouse_name], [location]) VALUES (6, N'Branch Warehouse', N'Barisal')
GO
INSERT [dbo].[Warehouses] ([warehouse_id], [warehouse_name], [location]) VALUES (7, N'Branch Warehouse', N'Rangpur')
GO
ALTER TABLE [dbo].[Order_Items]  WITH CHECK ADD FOREIGN KEY([order_id])
REFERENCES [dbo].[Orders] ([order_id])
GO
ALTER TABLE [dbo].[Order_Items]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[Products] ([product_id])
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([customer_id])
REFERENCES [dbo].[Customers] ([customer_id])
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD FOREIGN KEY([category_id])
REFERENCES [dbo].[Categories] ([category_id])
GO
