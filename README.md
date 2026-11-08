# zomato-food-delivery-daatset-sql-analysis
An end-to-end SQL data analysis project using PostgreSQL to explore food delivery operations, customer behavior, restaurant performance, sales trends, and rider efficiency through real-world business queries.
# 🍔 Food Delivery Data Analysis | PostgreSQL

## 📌 Project Overview

This project focuses on analyzing a food delivery platform's operations using **PostgreSQL**. It explores business-related questions involving customer behavior, restaurant performance, order trends, revenue generation, and delivery efficiency.

The objective is to apply SQL concepts to real-world business scenarios and extract meaningful insights that can support data-driven decision-making.

## 🗄️ Database Schema

The database consists of five interconnected tables:

| Table | Description |
|---|---|
| `customers` | Stores customer information and registration dates |
| `restaurants` | Contains restaurant details, locations, and opening hours |
| `riders` | Stores delivery rider information |
| `orders` | Contains order details, amounts, dates, and statuses |
| `deliveries` | Tracks delivery status, delivery time, and assigned riders |

### Database Relationships

- Each customer can place multiple orders.
- Each restaurant can receive multiple orders.
- Each order is associated with a customer and a restaurant.
- Each delivery is associated with an order and a rider.

## 🛠️ Tech Stack

- **Database:** PostgreSQL
- **Language:** SQL
- **Tools:** pgAdmin / PostgreSQL

## 📊 Business Problems & SQL Analysis

The project covers the following analytical problems:

### 1. Customer Analysis
- Calculate Customer Lifetime Value (CLV).
- Identify high-spending customers.
- Calculate Average Order Value (AOV).
- Segment customers based on spending.
- Identify customers who ordered in 2023 but not in 2024.
- Analyze customer ordering frequency.

### 2. Restaurant Analysis
- Rank restaurants by total revenue within each city.
- Identify the most popular dishes in each city.
- Calculate restaurant cancellation rates across different years.
- Analyze monthly restaurant order growth.
- Identify peak ordering periods.

### 3. Order & Sales Analysis
- Identify popular ordering time slots.
- Analyze monthly sales trends.
- Compare current and previous month's revenue using `LAG()`.
- Track popular food items and seasonal demand.
- Rank cities based on total revenue.
- Identify orders that were placed but not delivered.

### 4. Rider Performance Analysis
- Calculate average delivery time for each rider.
- Evaluate rider delivery efficiency.
- Categorize riders based on delivery-time ratings.
- Calculate monthly rider earnings (8% of order value).
- Identify riders with the highest and lowest average delivery times.

## 💡 SQL Concepts Practiced

This project demonstrates practical implementation of:

- Database creation and table relationships
- Primary Keys and Foreign Keys
- INNER JOIN, LEFT JOIN and RIGHT JOIN
- Aggregate Functions (`SUM`, `AVG`, `COUNT`, `MIN`, `MAX`)
- GROUP BY and HAVING
- Subqueries and Common Table Expressions (CTEs)
- Window Functions (`RANK`, `LAG`)
- Conditional Statements (`CASE WHEN`)
- Date and Time Functions (`EXTRACT`, `DATE_TRUNC`)
- INTERVAL and EPOCH calculations
- Data segmentation and ranking

## 📁 Project Structure

```text
food-delivery-sql-analysis/
│
├── database/
│   └── schema.sql
│
├── queries/
│   └── analysis.sql
│
└── README.md
```

## 🚀 How to Run

1. Clone this repository:

   ```bash
   git clone https://github.com/YOUR_USERNAME/food-delivery-sql-analysis.git
   ```

2. Open PostgreSQL using pgAdmin or your preferred SQL editor.

3. Create a database for the project.

4. Execute `database/schema.sql` to create the tables.

5. Import the dataset into the respective tables.

6. Execute the analytical queries from `queries/analysis.sql`.

## 🎯 Project Objective

The primary goal is to strengthen SQL problem-solving skills by translating business requirements into analytical queries.

Through this project, I explored how relational databases and SQL can be used to understand business performance, identify operational patterns, and generate actionable insights.

---

**Built with PostgreSQL | SQL Data Analysis Project**
