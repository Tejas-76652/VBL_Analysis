-- ============================================================
--  VBL STOCK EVENT ANALYSIS — 
-- ============================================================
--  PART A — DATABASE AND TABLES
-- ============================================================

CREATE DATABASE IF NOT EXISTS vbl_analysis;
USE vbl_analysis;

-- ---- Table 1: events (from events_impact.csv) ----

CREATE TABLE events (
    event_id            VARCHAR(10),
    date                DATE,
    category            VARCHAR(50),
    sub_category        VARCHAR(60),
    main_reason         VARCHAR(255),
    direction           VARCHAR(10),
    magnitude           VARCHAR(10),
    affected_tickers    VARCHAR(80),
    short_label         VARCHAR(60),
    event_date          DATE,
    nearest_trade_day   DATE,
    vbl_price_before    DECIMAL(10,2),
    vbl_price_on_event  DECIMAL(10,2),
    vbl_price_5d_after  DECIMAL(10,2),
    return_1d_pct       DECIMAL(6,2),
    return_5d_pct       DECIMAL(6,2)
);

-- ---- Table 2: stock_prices (from *_prices.csv, combined) ----

DROP TABLE IF EXISTS stock_prices;
CREATE TABLE stock_prices (
    price_date     DATE,
    close_price    DECIMAL(12,2),
    ticker_name    VARCHAR(20),
    ticker         VARCHAR(20),
    normalized     DECIMAL(10,2),
    daily_ret      DECIMAL(8,4)
);


-- ============================================================
--  PART B — ANALYTICAL QUERIES
-- ============================================================

-- ------------------------------------------------------------
-- Q1. Event count and average impact by CATEGORY
--     Shows which factor types dominated and their avg reaction.
-- ------------------------------------------------------------
SELECT
    category,
    COUNT(*)                              AS total_events,
    SUM(direction = 'Bullish')            AS bullish,
    SUM(direction = 'Bearish')            AS bearish,
    ROUND(AVG(return_5d_pct), 2)          AS avg_5d_return
FROM events
GROUP BY category
ORDER BY total_events DESC;


-- ------------------------------------------------------------
-- Q2. Top 5 BULLISH events by 5-day return
--     The catalysts that moved VBL up the most.
-- ------------------------------------------------------------
SELECT
    event_id,
    date,
    category,
    sub_category,
    return_5d_pct
FROM events
WHERE direction = 'Bullish'
ORDER BY return_5d_pct DESC
LIMIT 5;


-- ------------------------------------------------------------
-- Q3. Top 5 BEARISH events by 5-day return
--     The worst shocks for the stock.
-- ------------------------------------------------------------
SELECT
    event_id,
    date,
    category,
    sub_category,
    return_5d_pct
FROM events
WHERE direction = 'Bearish'
ORDER BY return_5d_pct ASC
LIMIT 5;


-- ------------------------------------------------------------
-- Q4. Rank events within each category by impact
-- ------------------------------------------------------------
SELECT
    category,
    event_id,
    sub_category,
    return_5d_pct,
    RANK() OVER (
        PARTITION BY category
        ORDER BY return_5d_pct DESC
    ) AS rank_in_category
FROM events
ORDER BY category, rank_in_category;


-- ------------------------------------------------------------
-- Q5. Year-over-year: events per year + net sentiment
-- ------------------------------------------------------------
SELECT
    YEAR(date)                                        AS event_year,
    COUNT(*)                                          AS total_events,
    SUM(direction = 'Bullish')                        AS bullish,
    SUM(direction = 'Bearish')                        AS bearish,
    ROUND(AVG(return_5d_pct), 2)                      AS avg_5d_return
FROM events
GROUP BY YEAR(date)
ORDER BY event_year;


-- ------------------------------------------------------------
-- Q6. Running (cumulative) event count over time
-- ------------------------------------------------------------
SELECT
    event_id,
    date,
    category,
    direction,
    COUNT(*) OVER (
        ORDER BY date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_events
FROM events
ORDER BY date;


-- ------------------------------------------------------------
-- Q7. Compare 1-day vs 5-day reaction (did the market
--     react fast or keep moving?)
-- ------------------------------------------------------------
SELECT
    event_id,
    category,
    return_1d_pct,
    return_5d_pct,
    ROUND(return_5d_pct - return_1d_pct, 2) AS follow_through,
    CASE
        WHEN ABS(return_5d_pct) > ABS(return_1d_pct)
            THEN 'Built over the week'
        ELSE 'Priced in day 1'
    END AS reaction_type
FROM events
WHERE return_1d_pct IS NOT NULL
  AND return_5d_pct IS NOT NULL
ORDER BY ABS(return_5d_pct) DESC;


-- ------------------------------------------------------------
-- Q8. VBL yearly return from the price table
-- ------------------------------------------------------------
WITH vbl_yearly AS (
    SELECT
        YEAR(price_date) AS yr,
        FIRST_VALUE(close_price) OVER (
            PARTITION BY YEAR(price_date) ORDER BY price_date
        ) AS first_close,
        LAST_VALUE(close_price) OVER (
            PARTITION BY YEAR(price_date) ORDER BY price_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS last_close
    FROM stock_prices
    WHERE ticker_name = 'VBL'
)
SELECT DISTINCT
    yr                                              AS year,
    ROUND(first_close, 2)                           AS jan_price,
    ROUND(last_close, 2)                            AS dec_price,
    ROUND((last_close - first_close) / first_close * 100, 2) AS yearly_return_pct
FROM vbl_yearly
ORDER BY yr;


-- ------------------------------------------------------------
-- Q9. Which sub-categories appear most (deepest taxonomy level)
-- ------------------------------------------------------------
SELECT
    category,
    sub_category,
    COUNT(*)                        AS occurrences,
    ROUND(AVG(return_5d_pct), 2)    AS avg_5d_return
FROM events
GROUP BY category, sub_category
ORDER BY occurrences DESC, avg_5d_return DESC;


-- ------------------------------------------------------------
-- Q10. Summary KPIs in one row 
-- ------------------------------------------------------------
SELECT
    COUNT(*)                                    AS total_events,
    SUM(direction = 'Bullish')                  AS bullish_events,
    SUM(direction = 'Bearish')                  AS bearish_events,
    ROUND(100 * SUM(direction = 'Bullish') / COUNT(*), 1) AS pct_bullish,
    ROUND(AVG(return_5d_pct), 2)                AS avg_5d_return,
    ROUND(MAX(return_5d_pct), 2)                AS biggest_gain,
    ROUND(MIN(return_5d_pct), 2)                AS biggest_drop
FROM events;
