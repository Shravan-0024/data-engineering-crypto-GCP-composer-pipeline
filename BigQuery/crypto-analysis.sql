SELECT * FROM `bitcoin-airlfow-orchestration.crypto_db.tbl_crypto`;

SELECT timestamp, current_price
FROM `bitcoin-airlfow-orchestration.crypto_db.tbl_crypto`
WHERE id = 'ripple'
ORDER BY timestamp;

SELECT name, market_cap
FROM `bitcoin-airlfow-orchestration.crypto_db.tbl_crypto`
WHERE timestamp = (SELECT MAX(timestamp) FROM `bitcoin-airlfow-orchestration.crypto_db.tbl_crypto`)
ORDER BY market_cap DESC
LIMIT 5;

WITH eth_prices AS (
  SELECT current_price, timestamp
  FROM `bitcoin-airlfow-orchestration.crypto_db.tbl_crypto`
  WHERE id = 'ethereum'
  ORDER BY timestamp DESC
  LIMIT 2
)
SELECT
  ROUND(100 * (MAX(current_price) - MIN(current_price)) / MIN(current_price), 2) AS percent_change
FROM eth_prices;

WITH top_coins AS (
  SELECT id
  FROM `bitcoin-airlfow-orchestration.crypto_db.tbl_crypto`
  WHERE timestamp = (SELECT MAX(timestamp) FROM `bitcoin-airlfow-orchestration.crypto_db.tbl_crypto`)
  ORDER BY market_cap DESC
  LIMIT 5
)
SELECT id, STDDEV(current_price) AS price_volatility
FROM `bitcoin-airlfow-orchestration.crypto_db.tbl_crypto`
WHERE id IN (SELECT id FROM top_coins)
GROUP BY id;
