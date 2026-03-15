# F&O Trading Database Design

## Project Overview

This project implements a scalable database schema for storing and analyzing Futures and Options (F&O) trading data. The system is designed to efficiently store millions of rows of time-series trading data and support fast analytical queries.

The dataset includes daily trading information such as instrument, symbol, expiry date, strike price, option type, open/high/low/close prices, contract(volume), and change_in_OI.

---

## Dataset

The dataset used in this project is an F&O trading dataset sourced from Kaggle.
It contains historical trading records including:

* Instrument
* Symbol
* Expiry Date
* Strike Price
* Option Type
* Open, High, Low, Close prices
* Contract(Volume)
* Open_INT
* val_inlakh

---

## Database Design

The database schema follows **Third Normal Form (3NF)** to reduce redundancy and improve data consistency.

Main tables include:

* **Instruments** – Stores unique instrument symbols.
* **Trades** – Stores daily trading data.
* **Expiry** – Stores expiry dates and strike price combinations.
* **Exchanges** – Stores exchange identifiers.

Relationships:

* One Instrument → Many Trades
* One Exchange → Many Trades
* One Expiry → Many Trades

---

## Why Star Schema Was Avoided

A star schema is commonly used for analytics, but it was avoided here because:

* Trading systems require **high write throughput**.
* Normalized schemas reduce data duplication.
* It ensures better consistency when ingesting high-frequency trading data.

---

## Scalability

The system is designed to scale for **10M+ rows of trading data**.

Key strategies used:

* **Indexes** on symbol, expiry date, and exchange.
* **Range partitioning** on expiry dates.
* Efficient time-series query optimization.

---

## Query Optimization

To improve query performance:

Indexes created:

CREATE INDEX idx_trades_symbol ON trades(symbol);
CREATE INDEX idx_trades_expiry ON trades(expiry_dt);
CREATE INDEX idx_trades_exchange ON trades(exchange_id);

Example analytical query:

SELECT symbol,
AVG(close) AS avg_price,
SUM(volume) AS total_volume
FROM trades
WHERE expiry_dt = '2026-03-26'
GROUP BY symbol;

Query performance was analyzed using EXPLAIN.

---

## Repository Structure

project/
│
├── er_diagram
│   └── ER_Diagram.png
│
├── sql
│   ├── create_tables.sql
│   ├── indexes.sql
│   ├── partitions.sql
│   └── queries.sql
│
└── docs
└── design_reasoning.pdf

---

## Tools Used

* sql workbench
* draw.io
