# VBL_Analysis
An end-to-end analytics project mapping 44 real-world market events (2020–2026) to the stock price of Varun Beverages (VBL) — India's largest PepsiCo bottler — benchmarked against Dabur, Reliance, Nifty FMCG, and Nifty 50.

Full pipeline: Python → SQL → Excel → Power BI.

Component:

vbl_stock_pipeline.py	: Downloads 6+ years of price data (yfinance), builds the 44-event dataset, computes risk metrics, exports CSV / SQLite / Excel

VBL_Stock_Analysis_Notebook.ipynb	: Narrated Jupyter notebook — full analysis with charts, run top to bottom

vbl_mysql_analysis.sql : Database schema + 10 analytical queries (window functions, CTEs, ranking)

VBL_StockAnalysis_Clean.xlsx	: Formula-driven Excel workbook — live formulas, conditional formatting, pivot table

VBL_PowerBI_Ready.xlsx	: Flat data tables feeding the Power BI model

Power BI dashboard	: 9-page interactive report (see preview below)

Python   →  Data collection (yfinance), event curation, risk metrics (CAGR, drawdown, volatility),
SQL      →  MySQL database, window functions, CTEs, analytical queries,
Excel    →  Formula-driven workbook, conditional formatting, pivot analysis,
Power BI →  Star-schema model, 14 DAX measures, 9-page interactive dashboard

*How to Run This

1.Notebook:

*Open VBL_Stock_Analysis_Notebook.ipynb in Google Colab

*Runtime → Run all — it downloads its own data

2.SQL:

*Run the CREATE DATABASE / CREATE TABLE section of vbl_mysql_analysis.sql in MySQL Workbench

*Import the event/price CSVs (produced by the Python pipeline) via the Table Data Import Wizard

Run the 10 analytical queries

3.Power BI:

*Open Power BI Desktop → Get Data → Excel → VBL_PowerBI_Ready.xlsx

*Load all sheets; relationships are pre-defined on Date via a DimDate calendar spine
