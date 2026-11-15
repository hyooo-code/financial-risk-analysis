import pandas as pd
from sqlalchemy import create_engine, text

# 1. 读取你的 CSV 文件（路径里的斜杠用 / 或者 \\）
CSV_PATH = 'D:/edge/archive/creditcard.csv'
df = pd.read_csv(CSV_PATH)
print(f"读取 CSV 完成：共 {len(df)} 行，{df.shape[1]} 列")

# 2. 连接数据库（root 后面是本机 MySQL 密码）
engine = create_engine(
    'mysql+pymysql://root:******@localhost:3306/fraud_detect?charset=utf8mb4'
)

# 3. 分批写入 creditcard 表（if_exists='append' 追加，不会清空已有数据）
TABLE_NAME = 'creditcard'
df.to_sql(
    TABLE_NAME,
    con=engine,
    if_exists='append',
    index=False,
    chunksize=5000,   # 每 5000 行一批，避免一次性占用过多内存
)

# 4. 导入后核对表里的总行数
with engine.connect() as conn:
    total = conn.execute(text(f"SELECT COUNT(*) FROM {TABLE_NAME}")).scalar()

print(f"导入完成！本次写入 {len(df)} 条，表 {TABLE_NAME} 当前共 {total} 条数据")
