use trades_db;

SELECT * FROM trades;


CREATE INDEX idx_trades_symbol
ON trades(symbol(100));

CREATE INDEX idx_trades_expiry
ON trades(expiry_dt_clean);

CREATE INDEX idx_trades_exchange
ON trades(exchange_id);

CREATE TABLE trades_partitioned (
    instrument VARCHAR(20),
    symbol VARCHAR(20),
    expiry_dt DATE,
    strike_pr NUMERIC,
    option_typ VARCHAR(5),
    open NUMERIC,
    high NUMERIC,
    low NUMERIC,
    close NUMERIC,
    volume BIGINT,
    exchange_id INT
)
PARTITION BY RANGE (YEAR(expiry_dt)) (
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION pmax VALUES LESS THAN MAXVALUE
);


SELECT symbol,
AVG(close) AS avg_price,
SUM(CONTRACTS) AS total_volume
FROM trades
WHERE expiry_dt_clean='2019-08-29'
GROUP BY symbol;

EXPLAIN 
SELECT symbol,
AVG(close),
SUM(CONTRACTS)
FROM trades
WHERE expiry_dt_clean='2019-08-29'
GROUP BY symbol;
