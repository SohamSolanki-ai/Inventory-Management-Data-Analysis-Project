# Inventory Management Data Analysis (Work in Progress)

## Overview
This project focuses on analyzing **inventory, sales, and customer trends** using a structured **PostgreSQL database** and **Python for data processing**. The dataset includes information about **orders, products, warehouses, employees, and customers** to provide valuable insights into **business performance, inventory levels, and customer purchasing behavior**.

 **Power BI dashboards will be added soon! Stay tuned.**  

---

## Technologies Used
This project integrates multiple technologies for **data storage, processing, and visualization**:

## **Database: PostgreSQL**
- Used for **storing structured data** with **proper indexing and relationships**.
- Implements **foreign key constraints** for data integrity.
- Allows **complex queries** to derive insights from the dataset.

## **Data Processing: Python**
- **`pandas`**: Reads and processes CSV data.
- **`SQLAlchemy`**: Handles PostgreSQL database connections.
- **`psycopg2`**: Executes SQL queries via Python.
- **Automates data import** into PostgreSQL tables.

## 📊 **Visualization: Power BI (Coming Soon!)**
- Will be used to build **interactive dashboards** with key insights.

---

## 📁 Project Structure


**Folder Details:**
- **`data/`** → Contains all original CSV files (`Customer.csv`, `Orders.csv`, etc.).
- **`sql/`** → Contains `inventory_database.sql` (includes table creation + queries).
- **`scripts/`** → Contains `import_data.py` (Python script for loading data into PostgreSQL).
- **`powerbi/`** → Will contain Power BI dashboards (**Coming Soon**).
- **`outputs/`** → Stores downloaded SQL query results (saved as `.csv` files).

---

## Installation & Setup

## **Step 1: Clone the Repository**
```sh
git clone https://github.com/your-github-username/Inventory_Management_Project.git
cd Inventory_Management_Project

