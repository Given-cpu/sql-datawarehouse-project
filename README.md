# SQL Data Warehouse Project

> A modern, end-to-end data warehouse built with SQL Server — covering ETL pipeline design, data architecture, data modeling, and advanced analytics.
> 
> *Based on the [Data with Baraa](https://youtu.be/5266en9bae0?si=U-UfkrncWi_6-bEK) SQL course series.*

---

## Table of Contents

1. [Why Data Warehousing?](#why-data-warehousing)
2. [Project Overview](#project-overview)
3. [Core Architecture](#core-architecture)
4. [Data Architecture: The Medallion Model](#-data-architecture-the-medallion-model)
5. [ETL Pipeline](#etl-pipeline)
6. [Data Modeling](#data-modeling)
7. [Data Analytics](#data-analytics)
8. [Repository Structure](#repository-structure)
9. [Tools & Technologies](#tools--technologies)

---

## Why Data Warehousing?

In the real world, a company rarely has just one database. It has a **CRM(Customer relationship management)** for customers, an **ERP(Enterprise resource planning)** for finance, a **POS(Point of Sale) system** for sales — each storing data in its own format, its own structure, with its own definition of what "a customer" or "a sale" even means.

Without a data warehouse, every analyst manually collects data from each system, cleans it themselves, and builds their own report. Three analysts, three different numbers for the same question. No shared history. No automation. No trust.

A data warehouse solves this by acting as the **single source of truth** for the entire organization:

| Problem | Solution |
|---|---|
| Data scattered across systems | Centralized, integrated storage |
| Inconsistent business definitions | Unified logic enforced at load time |
| Slow analytical queries on live systems | Read-optimized, aggregation-ready schema |
| Historical data gets overwritten | Full history preserved |
| Manual, error-prone reporting | Automated ETL pipeline |

The result: analysts stop preparing data and start **answering business questions**.

---

## Project Overview

This project simulates building a production-grade data warehouse from scratch using SQL Server. It covers all three major stages of a real data project:

```
┌─────────────────────────────────────────────────────────┐
│                     SQL Projects                        │
├──────────────────┬──────────────────┬───────────────────┤
│  Data            │  Exploratory     │  Advanced         │
│  Warehousing     │  Data Analysis   │  Data Analytics   │
│                  │  (EDA)           │                   │
│  - ETL/ELT       │  - Basic queries │  - Window funcs   │
│  - Architecture  │  - Data profiling│  - CTEs           │
│  - Integration   │  - Aggregations  │  - Subqueries     │
│  - Cleansing     │  - Subqueries    │  - Reports        │
│  - Data Modeling │                  │                   │
└──────────────────┴──────────────────┴───────────────────┘
```

---

## Core Architecture

The pipeline follows a classic **4-layer flow**:

```
  [Sources]          [ETL]          [Data Warehouse]        [BI]
─────────────    ────────────      ─────────────────    ──────────────
 ERP / CRM   →   Extract      →    Bronze (Raw)      →   Power BI
 Excel files →   Transform    →    Silver (Clean)    →   SQL Queries
 APIs        →   Load         →    Gold (Business)   →   Dashboards
```

**Each layer has a clear responsibility:**

- **Sources** — Raw operational systems. Messy, inconsistent, siloed.
- **ETL** — The engine that extracts, cleans, and loads data between layers.
- **Data Warehouse** — Structured, trusted, historical storage. Where analysts work.
- **BI Tools** — Dashboards, reports, and ad-hoc queries that answer business questions.

This separation is known as **Separation of Concerns (SOC)** — each layer does one job, and does it well. Changes in one layer don't cascade and break everything else.

---

## 🥉🥈🥇 Data Architecture: The Medallion Model

This project uses the **Medallion Architecture** (Bronze → Silver → Gold), a widely adopted pattern in modern data engineering.

| | Bronze | Silver | Gold |
|---|---|---|---|
| **Definition** | Raw, unprocessed data as-is | Cleaned & standardized | Business-ready |
| **Objective** | Traceability & debugging | Prepare for analysis | Serve reporting & analytics |
| **Object Type** | Tables | Tables | Views |
| **Load Method** | Full Load (Truncate & Insert) | Full Load (Truncate & Insert) | None |
| **Transformations** | None (as-is) | Cleaning, Standardization, Normalization, Derived Columns, Enrichment | Integration, Aggregation, Business Logic |
| **Data Modeling** | None | None | Star Schema, Flat Tables |
| **Target Audience** | Data Engineers | Data Analysts, Data Engineers | Data Analysts, Business Users |

> **Mental model:** Think of it like a kitchen.
> - **Bronze** = raw ingredients from the market (unprocessed)
> - **Silver** = prepped and portioned ingredients in containers (cleaned, standardized)
> - **Gold** = the finished dish, ready to serve (business-ready for reports)

---

## ETL Pipeline

ETL stands for **Extract → Transform → Load**. It is the engine that moves data through the layers.

### Extract
Pulling data out of source systems.

- **Types:** Full Extraction / Incremental Extraction
- **Methods:** Pull / Push
- **Techniques:** Database Querying, File Parsing, API Calls, Web Scraping, CDC (Change Data Capture), Event-Based Streaming

### Transform
Cleaning and reshaping data before it reaches the warehouse.

- **Data Cleansing:** Remove duplicates, handle missing values, fix invalid values, detect outliers, cast data types, handle unwanted spaces
- **Standardization & Normalization:** Unified formats, consistent naming
- **Derived Columns:** Calculated fields (e.g., age from birthdate, profit from revenue − cost)
- **Data Integration:** Joining data from multiple sources into one unified table
- **Data Enrichment:** Appending external data to add context
- **Business Rules & Logic:** Applying company-specific definitions

### Load
Writing the transformed data into the target layer.

| Load Method | Description | Use Case |
|---|---|---|
| **Full Load** | Truncate + re-insert everything | Bronze & Silver layers |
| **Incremental Load (Upsert)** | Insert new, update changed records | Slowly growing tables |
| **Incremental Load (Append)** | Only add new records | Event logs, transactions |
| **Incremental Load (Merge)** | Smart sync between source and target | SCD Type 2 patterns |

### Slowly Changing Dimensions (SCD)
How to handle historical changes in dimension data (e.g., a customer moves cities):

- **SCD 0** — No historization (just keep the original value)
- **SCD 1** — Overwrite (update in place, no history kept)
- **SCD 2** — Full historization (add a new row per change, keep full audit trail)

---

## Data Modeling

The Gold layer is structured using a **Star Schema** — the standard for analytical data models.

```
                  ┌─────────────┐
                  │  dim_date   │
                  └──────┬──────┘
                         │
┌──────────────┐   ┌─────┴──────┐   ┌──────────────┐
│  dim_customer│───│  fact_sales│───│  dim_product  │
└──────────────┘   └─────┬──────┘   └──────────────┘
                         │
                  ┌──────┴──────┐
                  │ dim_location│
                  └─────────────┘
```

**Two types of tables:**

- **Fact Table** — Stores measurable events (sales, orders, transactions). Contains foreign keys to all dimension tables + numeric measures (quantity, revenue, cost).
- **Dimension Tables** — Provide context for the facts (who, what, when, where). Examples: customer, product, date, location.

**Quick rule for any column you encounter:**
> *Is it numeric AND does it make sense to aggregate (SUM/AVG)?*
> - **Yes** → it's a **Measure** (sales, quantity, age)
> - **No** → it's a **Dimension** (category, country, product name, ID)

---

## Data Analytics

Once the warehouse is built, analysis follows two progressive stages:

### Stage 1 — Exploratory Data Analysis (EDA)
*Goal: Understand what's in the data before drawing conclusions.*

| Technique | What it does | SQL used |
|---|---|---|
| Database Exploration | Understand structure & content | `SELECT`, `COUNT`, `DISTINCT` |
| Dimensions Exploration | Find unique values in categorical columns | `DISTINCT [column]` |
| Date Exploration | Find time range of data | `MIN()`, `MAX()`, `DATEDIFF()` |
| Measures Exploration | Compute key metrics at a high level | `SUM()`, `AVG()`, `MAX()` |
| Magnitude | Break totals down by category | `SUM([measure]) GROUP BY [dimension]` |
| Ranking | Find top/bottom performers | `RANK()`, `ROW_NUMBER()`, `TOP N` |

### Stage 2 — Advanced Analytics
*Goal: Answer real business questions.*

| Analysis Type | Business Question | SQL Technique |
|---|---|---|
| **Change-Over-Time** | How did sales trend over 3 years? | `GROUP BY year/month`, line chart |
| **Cumulative Analysis** | What is our running total revenue? | `SUM() OVER (ORDER BY date)` — Window Function |
| **Performance Analysis** | Which regions are above/below average? | `Current − AVG() OVER()` — Window Function |
| **Part-to-Whole** | What % of total sales does each category contribute? | `SUM(x) / SUM(SUM(x)) OVER() * 100` |
| **Data Segmentation** | How many customers fall in each spending tier? | `CASE WHEN` statement |
| **Reporting** | Executive dashboard combining all of the above | CTEs + Subqueries + Views |

---

## Repository Structure

```
sql-datawarehouse-project/
│
├── datasets/                   # Raw source data files (CSV)
│   ├── crm_customers.csv
│   ├── erp_sales.csv
│   └── ...
│
├── scripts/
│   ├── bronze/                 # Load raw data as-is
│   │   └── load_bronze.sql
│   ├── silver/                 # Clean & standardize
│   │   └── load_silver.sql
│   └── gold/                   # Business-ready views
│       └── create_gold_views.sql
│
├── analytics/
│   ├── eda/                    # Exploratory queries
│   └── advanced/               # Business analytics queries
│
├── docs/
│   └── data_catalog.md         # Column definitions & business rules
│
└── README.md
```

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| **SQL Server** | Database engine & query execution |
| **SQL Server Management Studio (SSMS)** | Development environment |
| **T-SQL** | ETL scripting, transformations, analytics |
| **Git / GitHub** | Version control & portfolio showcase |
| **Draw.io / Notion** | Architecture diagrams & documentation |

---

## Learning Reference

This project is built following the [**Data with Baraa**](https://youtu.be/5266en9bae0?si=U-UfkrncWi_6-bEK) SQL Data Warehouse course series on YouTube. Highly recommended for anyone learning data engineering with SQL Server.

---

*Built for learning. Documented for review. Designed for real-world application.*
