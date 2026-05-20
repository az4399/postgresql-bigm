FROM postgres:18

# 1. 安装编译所需的临时工具（装完会删掉，保持镜像轻量）
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    postgresql-server-dev-18 \
    libicu-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. 从 GitHub 拉取最新的 pg_bigm 源码并直接编译安装
RUN git clone --depth 1 https://github.com/pgbigm/pg_bigm.git /tmp/pg_bigm && \
    cd /tmp/pg_bigm && \
    make USE_PGXS=1 && \
    make USE_PGXS=1 install && \
    rm -rf /tmp/pg_bigm

# 3. 卸载编译工具，只保留运行时环境，极致精简镜像体积
RUN apt-get purge -y --auto-remove \
    build-essential \
    git \
    postgresql-server-dev-18 \
    libicu-dev \
    ca-certificates
