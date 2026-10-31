# Walmart Retail Sales Analytics

A beginner-friendly, end-to-end data analytics project on Walmart retail sales. I cleaned the raw data with Python, stored it in MySQL, answered 10 business questions with SQL, and built a Power BI dashboard to show the results.

---

## Table of Contents
- [Project Overview](#project-overview)
- [Workflow](#workflow)
- [Dataset Details](#dataset-details)
- [Data Cleaning](#data-cleaning)
- [SQL Business Questions](#sql-business-questions)
- [Power BI Dashboard](#power-bi-dashboard)
- [Tech Stack](#tech-stack)
- [Setup and Installation](#setup-and-installation)
- [Key Insights](#key-insights)

---

## Project Overview

The goal is to understand how a retail business is doing: what sells, when it sells, where it sells, and how much profit it makes.

1. Load the raw sales data into Python.
2. Clean it: remove duplicates, drop missing values, and fix data types.
3. Add a `total_price` column (`unit_price * quantity`).
4. Load the clean data into a MySQL table.
5. Answer 10 business questions with SQL (CTEs, window functions, aggregations).
6. Show the results in a Power BI dashboard.

---

## Workflow

```
Walmart.csv (raw data)
  └─► Python cleaning (Pandas, SQLAlchemy, PyMySQL)
        ├─► Walmart_clean_data.csv
        └─► MySQL table: walmartdb.Walmart_Sales
              ├─► SQL analysis (10 business questions)
              └─► Power BI dashboard (.pbix)
```

---

## Dataset Details

The data has Walmart store transactions with product, price, location, rating and time details.

| Column | Type | Description |
| :--- | :--- | :--- |
| `invoice_id` | Integer | Unique ID of each sale |
| `Branch` | Text | Store branch code (e.g. WALM003) |
| `City` | Text | City of the branch |
| `category` | Text | Product category (e.g. Health and beauty) |
| `unit_price` | Decimal | Price of one unit, in dollars |
| `quantity` | Integer | Number of units bought |
| `date` | Date | Date of the sale |
| `time` | Time | Time of the sale |
| `payment_method` | Text | Cash, Credit card or Ewallet |
| `rating` | Decimal | Customer rating (3 to 10) |
| `profit_margin` | Decimal | Share of the sale that is profit (e.g. 0.48 = 48%) |
| `total_price` | Decimal | Added in Python: `unit_price * quantity` |

There are about 10,000 sales, 100 branches, 98 cities and 6 categories. The data runs from 2019 to 2023.

---

## Data Cleaning

Cleaning was done in a Jupyter Notebook (`Python_Code.ipynb`) using Pandas.

1. **Removed duplicates:** 51 duplicate rows were dropped (10,051 to 10,000 rows).
2. **Removed missing values:** 31 rows had no `unit_price` or `quantity`, so they were dropped (10,000 to 9,969 rows).
3. **Fixed data types:**
   - Removed the `$` sign from `unit_price` and changed it to a decimal number.
   - Converted `date` to a proper date. The raw dates are in day-month-year format, so the format is given explicitly: `pd.to_datetime(df['date'], format='%d-%m-%Y')`.
   - Converted `time` to a time value.
   - Changed `quantity` from decimal to whole number.
4. **Added a new column:** `total_price = unit_price * quantity`.
5. **Saved the result:** wrote `Walmart_clean_data.csv` and loaded the data into the MySQL table `Walmart_Sales`.

---

## SQL Business Questions

The full script is in `SQL_Script.sql`. It answers 10 questions:

1. **Top categories by units sold:** which 3 categories sell the most units.
2. **Best category in each branch:** the category with the highest revenue in every branch.
3. **Top 5 branches:** the 5 branches with the highest revenue, with their profit.
4. **Category profit and revenue share:** revenue, profit, profit margin and revenue share (%) of each category.
5. **Payment method comparison:** orders, revenue and average order value for each payment method.
6. **Busiest time slots:** orders grouped into 2-hour slots to find the rush hours.
7. **Well-rated branches:** branches with a rating above the overall average and at least 50 orders.
8. **Top 3 cities each year:** the 3 cities with the highest revenue in every year.
9. **Month-over-month growth:** how revenue goes up or down each month, in percent.
10. **Best day of the week:** which weekday brings in the most revenue.

---

## Power BI Dashboard

The dashboard (`Walmart_Retail_Sales_Analytics_Dashboard.pbix`) is a one-page **Executive Sales Dashboard** built on the cleaned data.

**Filters:** Date, Branch, City, Category, Payment Method and Time Period. Picking a value in any of them filters the whole page.

**Summary cards:** Total Revenue ($1.21M), Total Transactions (9,969), Total Quantity (23,483), Total Profit ($476.14K) and Average Rating (5.83). Each card also shows the change compared with the previous period.

**Charts:**
- **Monthly Sales Trend:** revenue month by month.
- **Total Sales by Category:** which product categories earn the most.
- **Total Sales by Payment Method:** the share of credit card, e-wallet and cash.
- **Total Sales by Time Period:** Morning (6 AM to 12 PM), Afternoon (12 PM to 5 PM), Evening (5 PM to 9 PM) and Night (after 9 PM).
- **Top 10 Cities by Total Sales:** the strongest cities.
- **Top 10 Branches by Total Sales and Profit:** sales and profit side by side for the best branches.
- **Category vs Profitability:** how each category's sales compare with its profit.

---

## Key Insights

**The big picture**
- Total revenue is about **$1.21 million** from **9,969 orders**, with an average order of about **$121**.
- Estimated profit is about **$476K**, a margin of roughly **39%**.

**What sells**
- **Fashion accessories** and **Home and lifestyle** bring in about **81%** of all revenue (around $489K each). The other four categories are much smaller.
- The small categories (Food and beverages, Sports and travel, Health and beauty) have big baskets, around **$305 to $315** per order, compared with about **$108** for the two big ones. They sell less often, but customers buy more at once.
- Profit margin is almost the same in every category (about 39% to 40%), so the categories that sell the most also earn the most profit.

**When it sells**
- About **64% of orders** are placed between **3 PM and 9 PM**. Orders roughly triple from 2 PM to 3 PM.
- In the dashboard's time periods, **Afternoon ($462K)** and **Evening ($467K)** each bring in about 38% of revenue, together about **77%**. Morning is about 21%, and Night only about 2%.
- **November and December** make up about **half of all orders** and **41% of revenue**. August to October is busier than normal, and January to July is quiet.
- **Saturday** is the best day ($185K) and **Monday** the weakest ($155K). The gap is real but modest.
- Yearly revenue is steady, around **$217K to $233K** per year from 2020 to 2023. The 2019 data only covers January to March.

**How customers pay**
- **Credit card and e-wallet** make up about **78%** of revenue.
- **Cash** is only about 22% of revenue, but cash orders are bigger on average ($144 compared with about $115 to $118).

**Branches and ratings**
- Branch revenue ranges from about **$5K to $25.7K**. The top branch is **WALM009 (Plano)**.
- The average rating is about **5.8 out of 10**. Ratings do not change much with price, margin or category.

**What the business could do**
- Plan staff and stock for the 3 PM to 9 PM rush and for November and December.
- Push the high-basket categories (Food, Sports, Health) with offers, since each sale is worth more.
- Study the best branches and share what they do well with the weaker ones.

## Tech Stack

- **Python:** Pandas for cleaning
- **Jupyter Notebook:** step-by-step code
- **SQLAlchemy and PyMySQL:** connecting Python to MySQL
- **MySQL 8.0+:** storing the data and running the SQL queries
- **Power BI Desktop:** dashboard and charts

---

## Setup and Installation

1. **Clone the repository**
   ```
   git clone https://github.com/imranshaik93769-wq/Walmart_Retail_Sales_Analytics.git
   cd Walmart_Retail_Sales_Analytics
   ```
2. **Install the Python libraries**
   ```
   pip install pandas pymysql sqlalchemy jupyter
   ```
3. **Create the database in MySQL**
   ```sql
   CREATE DATABASE walmartdb;
   ```
4. **Run the notebook.** Open `Python_Code.ipynb`, put your own MySQL username and password in the connection line, and run all cells. This cleans the data and loads the `Walmart_Sales` table.
   Do not save your real password in the notebook. Read it from an environment variable instead.
5. **Run the SQL queries.** Open `SQL_Script.sql` in MySQL Workbench and run the queries one by one.
6. **Open the dashboard.** Open the `.pbix` file in Power BI Desktop and refresh the data if needed.
