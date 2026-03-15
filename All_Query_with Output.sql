-- 1st Query
use trades_db;
select * from trades;

select * from instruments;

describe instruments;


select i.symbol,e.exchange_name,sum(t.CHG_IN_OI) as total_oi_change
from trades t join instruments i on t.instrument_id = i.instrument_id
join exchanges e on i.exchange_id = e.exchange_id
group by i.symbol, e.exchange_name
order by total_oi_change DESC
limit 10;


--- 2nd Query

select * from trades;

SELECT i.symbol,t.timestamp_clean,t.CLOSE,
STDDEV(t.close) OVER (
        PARTITION BY i.symbol 
        ORDER BY t.timestamp_clean
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_7day_volatility
FROM trades t JOIN instruments i ON t.instrument_id = i.instrument_id
WHERE i.symbol = 'NIFTY'
ORDER BY t.timestamp_clean;

-- 3rd Query

SELECT e.exchange_name,AVG(t.SETTLE_PR) AS avg_settle_price
FROM trades t JOIN instruments i ON t.instrument_id = i.instrument_id
JOIN exchanges e ON i.exchange_id = e.exchange_id
WHERE (e.exchange_name = 'MCX' AND i.symbol = 'GOLD' AND i.instrument = 'FUTCOM') OR (e.exchange_name = 'NSE' AND i.instrument = 'FUTIDX')
GROUP BY e.exchange_name;

-- 4th Query

SELECT expiry_dt_clean, STRIKE_PR, SUM(CONTRACTS) AS implied_volume
FROM trades
GROUP BY expiry_dt_clean, STRIKE_PR
ORDER BY expiry_dt_clean, STRIKE_PR;

-- 5th Query

SELECT SYMBOL,MAX(CONTRACTS) AS max_volume
FROM trades
WHERE timestamp_clean >= (
    SELECT MAX(timestamp_clean) FROM trades
) - INTERVAL 30 DAY
GROUP BY SYMBOL;

