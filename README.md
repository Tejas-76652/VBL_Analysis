# VBL Stock Event Analysis
### Did VBL create alpha, or just ride the market tide?

![Python](https://img.shields.io/badge/Python-3.10-blue)
![SQL](https://img.shields.io/badge/SQL-MySQL-orange)
![Excel](https://img.shields.io/badge/Excel-Formula--Driven-green)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow)

An end-to-end analytics project mapping **44 real-world market events** (2020–2026) to the stock price of **Varun Beverages (VBL)** — India's largest PepsiCo bottler — benchmarked against Dabur, Reliance, Nifty FMCG, and Nifty 50.

Full pipeline: **Python → SQL → Excel → Power BI**.

---

## 📊 The Question

VBL's stock delivered extraordinary returns from 2020 to 2026. This project asks whether that was genuine outperformance or just a rising market — by tagging 44 curated events (macro shocks, geopolitics, climate, demand shifts, corporate news) with a 3-level taxonomy, measuring each one's 1-day and 5-day price impact, and benchmarking the result against four comparison tickers.

## 🔍 What's Inside

| Component | Description |
|---|---|
| `vbl_stock_pipeline.py` | Downloads 6+ years of price data (yfinance), builds the 44-event dataset, computes risk metrics, exports CSV / SQLite / Excel |
| `VBL_Stock_Analysis_Notebook.ipynb` | Narrated Jupyter notebook — full analysis with charts, run top to bottom |
| `vbl_mysql_analysis.sql` | Database schema + 10 analytical queries (window functions, CTEs, ranking) |
| `VBL_StockAnalysis_Clean.xlsx` | Formula-driven Excel workbook — live formulas, conditional formatting, pivot table |
| `VBL_PowerBI_Ready.xlsx` | Flat data tables feeding the Power BI model |
| Power BI dashboard | 9-page interactive report (see preview below) |


## 🛠️ Tech Stack & What Each Tool Did

```
Python   →  Data collection (yfinance), event curation, risk metrics (CAGR, drawdown, volatility)
SQL      →  MySQL database, window functions, CTEs, analytical queries
Excel    →  Formula-driven workbook, conditional formatting, pivot analysis
Power BI →  Star-schema model, 14 DAX measures, 9-page interactive dashboard
```

## 📁 Repository Structure

```
├── python/
│   └── vbl_stock_pipeline.py
├── notebook/
│   └── VBL_Stock_Analysis_Notebook.ipynb
├── sql/
│   └── vbl_mysql_analysis.sql
├── excel/
│   ├── VBL_StockAnalysis_Clean.xlsx
│   └── VBL_PowerBI_Ready.xlsx
├── assets/
│   └── (dashboard screenshots — see below)
└── README.md
```

## 🚀 How to Run This

**Notebook (easiest way to see the full analysis):**
1. Open `VBL_Stock_Analysis_Notebook.ipynb` in Google Colab
2. Runtime → Run all — it downloads its own data, no setup needed

**SQL:**
1. Run the `CREATE DATABASE` / `CREATE TABLE` section of `vbl_mysql_analysis.sql` in MySQL Workbench
2. Import the event/price CSVs (produced by the Python pipeline) via the Table Data Import Wizard
3. Run the 10 analytical queries

**Power BI:**
1. Open Power BI Desktop → Get Data → Excel → `VBL_PowerBI_Ready.xlsx`
2. Load all sheets; relationships are pre-defined on Date via a DimDate calendar spine

Built by **Tejas Saxena**. Feedback welcome — feel free to open an issue or connect on LinkedIn.
