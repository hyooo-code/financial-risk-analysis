USE fraud_detect;

-- 1. 查看数据总量
SELECT COUNT(*) FROM creditcard;

-- 2. 探查欺诈样本比例（极度不平衡）
SELECT 
    CASE Class WHEN 1 THEN '欺诈交易' ELSE '正常交易' END AS 交易类型,
    COUNT(*) AS 交易笔数,
    ROUND(SUM(Amount), 2) AS 总涉及金额
FROM creditcard
GROUP BY Class;

