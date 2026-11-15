-- 1. 多表串联：结合时间维度表，看哪个时段欺诈最多
SELECT 
    t.hour_desc AS '时间段',
    COUNT(c.class) AS '欺诈笔数',
    ROUND(SUM(c.Amount), 2) AS '欺诈总金额'
FROM creditcard c
RIGHT JOIN dim_time t ON HOUR(FROM_UNIXTIME(c.Time)) = t.hour_id  -- 串联时间维度，把交易表里的时间和字典表里的时间对上号
# FROM_UNIXTIME函数将时间戳转化成标准时间
AND c.Class = 1 #只选择欺诈交易
GROUP BY t.hour_desc, t.hour_id
ORDER BY t.hour_id ASC;
# ORDER BY 欺诈笔数 DESC;

-- 2. 多表串联（模拟）：结合金额分段，看诈骗犯的金额习惯
-- （因为原始表没有金额ID，这里用 CASE WHEN 现场生成，效果等同于 JOIN）
SELECT 
    CASE 
        WHEN c.Amount <= 50 THEN '1-小额(0-50元)'
        WHEN c.Amount <= 500 THEN '2-中额(50-500元)'
        ELSE '3-大额(500元以上)' 
    END AS '金额区间',
    COUNT(*) AS '笔数',
    ROUND(AVG(c.Amount), 2) AS '平均单笔金额'
FROM creditcard c
WHERE c.Class = 1
GROUP BY 金额区间
ORDER BY 金额区间;