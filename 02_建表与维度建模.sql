-- 1. 创建并使用数据库
CREATE DATABASE IF NOT EXISTS fraud_detect;
USE fraud_detect;

-- =========================================================
-- 第一部分：事实表（存储28万条原始交易流水）
-- =========================================================
CREATE TABLE IF NOT EXISTS creditcard (
    TIME INT,
    V1 DECIMAL(10,5), V2 DECIMAL(10,5), V3 DECIMAL(10,5), V4 DECIMAL(10,5), V5 DECIMAL(10,5),
    V6 DECIMAL(10,5), V7 DECIMAL(10,5), V8 DECIMAL(10,5), V9 DECIMAL(10,5), V10 DECIMAL(10,5),
    V11 DECIMAL(10,5), V12 DECIMAL(10,5), V13 DECIMAL(10,5), V14 DECIMAL(10,5), V15 DECIMAL(10,5),
    V16 DECIMAL(10,5), V17 DECIMAL(10,5), V18 DECIMAL(10,5), V19 DECIMAL(10,5), V20 DECIMAL(10,5),
    V21 DECIMAL(10,5), V22 DECIMAL(10,5), V23 DECIMAL(10,5), V24 DECIMAL(10,5), V25 DECIMAL(10,5),
    V26 DECIMAL(10,5), V27 DECIMAL(10,5), V28 DECIMAL(10,5),
    Amount DECIMAL(10,2),  -- 金额，保留两位小数，用DECIMAL防止精度丢失
    Class INT              -- 目标变量：0为正常交易，1为欺诈交易
);

-- =========================================================
-- 第二部分：维度表（星型模型的周边小表）
-- =========================================================

-- 1. 时间维度表
CREATE TABLE IF NOT EXISTS dim_time (
    hour_id INT PRIMARY KEY,    -- 主键：0-23
    hour_desc VARCHAR(20)       -- 描述：如 '10点-11点'
);

-- 给时间维度表塞入24小时的数据（字典）
INSERT IGNORE INTO dim_time VALUES 
(0, '0点-1点'), (1, '1点-2点'), (2, '2点-3点'), (3, '3点-4点'),
(4, '4点-5点'), (5, '5点-6点'), (6, '6点-7点'), (7, '7点-8点'),
(8, '8点-9点'), (9, '9点-10点'), (10, '10点-11点'), (11, '11点-12点'),
(12, '12点-13点'), (13, '13点-14点'), (14, '14点-15点'), (15, '15点-16点'),
(16, '16点-17点'), (17, '17点-18点'), (18, '18点-19点'), (19, '19点-20点'),
(20, '20点-21点'), (21, '21点-22点'), (22, '22点-23点'), (23, '23点-24点');

-- 2. 金额维度表
CREATE TABLE IF NOT EXISTS dim_amount (
    level_id INT PRIMARY KEY,   -- 主键：1, 2, 3
    level_desc VARCHAR(20)      -- 描述：如 '小额(0-50元)'
);

-- 给金额维度表塞入分段字典（虽然我们查询时用了CASE WHEN，但表里留着作为规范）
INSERT IGNORE INTO dim_amount VALUES 
(1, '1-小额(0-50元)'), 
(2, '2-中额(50-500元)'), 
(3, '3-大额(500元以上)');