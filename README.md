# Walmart_Retail_Sales_Analytics

An end-to-end data analytics project that cleans, transforms, and analyzes retail transaction data from Walmart using Python, MySQL, and Power BI. The pipeline addresses retail operations, revenue patterns, product line profitability, customer behavior, and branch performance.

---

## Table of Contents
- [Project Overview](#project-overview)
- [Architecture & Workflow](#architecture--workflow)
- [Dataset Details](#dataset-details)
- [Data Cleaning & Transformation](#data-cleaning--transformation)
- [SQL Business Queries & Analysis](#sql-business-queries--analysis)
- [Power BI Dashboard](#power-bi-dashboard)
- [Tech Stack](#tech-stack)
- [Setup and Installation](#setup-and-installation)

---

## Project Overview

This project simulates a complete enterprise analytics workflow:
1. Ingest raw retail transaction data into Python.
2. Clean messy entries, remove duplicates, handle missing values, and standardize data types.
3. Feature engineer calculated metrics like total price.
4. Load normalized datasets directly into a relational database (MySQL) via SQLAlchemy.
5. Solve key business questions using optimized SQL queries and Window Functions (CTEs, `RANK()`, aggregations).
6. Build an interactive Power BI dashboard for visual reporting and operational tracking.

---

## Architecture & Workflow

Raw CSV (`Walmart.csv`)
  └─► Python ETL (Pandas, SQLAlchemy, PyMySQL)
        └─► Cleaned CSV (`Walmart_clean_data.csv`)
        └─► MySQL Database (`walmartdb.Walmart_Sales`)
              ├─► Advanced Business SQL Analysis (10 Core Problems)
              └─► Power BI Dashboard Report (`.pbix`)

---

## Dataset Details

The dataset represents Walmart store sales transactions with attributes detailing products, pricing, geography, customer ratings, and timing:

| Column Name | Type | Description |
| :--- | :--- | :--- |
| `invoice_id` | Integer | Unique identifier for each sales invoice |
| `Branch` | String | Store branch identifier (e.g., WALM003, WALM048) |
| `City` | String | City where the branch is located |
| `category` | String | Product category (e.g., Health and beauty, Electronic accessories) |
| `unit_price` | Float | Price per single unit (cleaned of currency symbols) |
| `quantity` | Integer | Number of units purchased |
| `date` | Date | Date of transaction |
| `time` | Time | Time when the transaction occurred |
| `payment_method` | String | Method used (Cash, Credit card, Ewallet) |
| `rating` | Float | Customer rating given for the transaction |
| `profit_margin` | Float | Calculated store profit margin on the sale |
| `total_price` | Float | Calculated column: `unit_price * quantity` |

---

## Data Cleaning & Transformation

Data preprocessing was performed in a Jupyter Notebook using `pandas`:

1. **Duplicate Elimination:** Detected and dropped duplicate entries, reducing initial records from 10,051 to 10,000.
2. **Handling Missing Values:** Identified and dropped 31 null values in `unit_price` and `quantity`, resulting in 9,969 clean records.
3. **Data Type Casting & Sanitization:**
   - Stripped special characters (`$`) from `unit_price` and cast to `float64`.
   - Converted `date` to datetime format (`YYYY-MM-DD`).
   - Parsed `time` format (`HH:MM:SS`).
   - Converted `quantity` from float to integer.
4. **Feature Engineering:**
   - Created `total_price` as `unit_price * quantity`.
5. **Database Export:**
   - Exported clean dataset to `Walmart_clean_data.csv`.
   - Used SQLAlchemy engine (`mysql+pymysql`) to load data into the table `Walmart_Sales` under `walmartdb`.

---

## SQL Business Queries & Analysis

The project solves 10 critical business questions using MySQL:

1. **Payment Methods Performance:** Analyzed transaction counts and total units sold per payment method.
2. **Branch Category Leaders:** Determined the highest-rated product category for each store branch using `RANK() OVER(PARTITION BY Branch ORDER BY AVG(rating) DESC)`.
3. **Peak Store Days:** Identified the busiest day of the week for every branch based on transaction volume.
4. **Volume by Payment Type:** Ranked preferred customer payment options by aggregate units purchased.
5. **City-Level Category Metrics:** Calculated minimum, maximum, and average customer review ratings across categories per city.
6. **Category Profitability:** Calculated total profit per product category using `SUM(unit_price * quantity * profit_margin)`.
7. **Branch Payment Preferences:** Identified the most common payment method per branch using Common Table Expressions (CTEs) and Window Functions.
8. **Shift/Time-of-Day Traffic:** Categorized store transactions into `Morning`, `Afternoon`, and `Evening` shifts to monitor peak operational hours.
9. **Year-Over-Year Revenue Drop:** Identified branches experiencing the highest percentage decrease in revenue between 2022 and 2023.
10. **Top Revenue Generators:** Isolated the top 5 product categories generating the highest total revenue.

---

## Power BI Dashboard

The Power BI model connects to the cleaned dataset to provide executive-level insights:
- **KPI Summary Cards:** Total Revenue, Units Sold, Average Customer Rating, and Store Profit.
- **Trend & Time Analysis:** Shifts, busiest weekdays, and monthly revenue flow.
- **Branch & City Comparisons:** Geo-spatial analysis and branch-level performance matrices.
- **Product Diagnostics:** Category profitability, profit margins, and revenue drivers.

---

## Tech Stack

- **Data Processing:** Python (Pandas, NumPy)
- **Database Connectivity:** SQLAlchemy, PyMySQL
- **Database & Querying:** MySQL Server 8.0+
- **Business Intelligence & Visualization:** Power BI Desktop
