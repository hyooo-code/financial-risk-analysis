
WITH top_transactions AS (
	SELECT 
	t.hour_id,
	t.hour_desc AS '时间段',
	c.Amount AS '交易金额',
	ROW_NUMBER () OVER (PARTITION BY t.hour_desc ORDER BY c.amount DESC)
	AS rn
	FROM creditcard c
	JOIN `dim_time` t ON t.hour_id = HOUR(FROM_UNIXTIME(c.Time))
	WHERE class = 0
)
SELECT * 
FROM top_transactions 
WHERE rn <=3 
ORDER BY hour_id, rn;