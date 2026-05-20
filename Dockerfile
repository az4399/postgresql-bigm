# 完美对齐你的 PostgreSQL 18 大版本
FROM postgres:18

# 更新源并安装 pg_bigm 插件，最后清理缓存保持镜像精简
RUN apt-get update && \
    apt-get install -y postgresql-18-pg-bigm && \
    rm -rf /var/lib/apt/lists/*
