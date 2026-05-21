FROM postgres:18

# 安装编译依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    postgresql-server-dev-18 \
    libicu-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# 克隆并编译 pg_bigm
RUN git clone https://github.com/pgbigm/pg_bigm.git /tmp/pg_bigm \
    && cd /tmp/pg_bigm \
    && make USE_PGXS=1 \
    && make USE_PGXS=1 install \
    && rm -rf /tmp/pg_bigm

# 预加载插件（可选，也可以在运行时 CREATE EXTENSION）
# 如果希望容器启动时自动加载，取消下面注释：
# RUN echo "shared_preload_libraries = 'pg_bigm'" >> /usr/share/postgresql/postgresql.conf.sample
