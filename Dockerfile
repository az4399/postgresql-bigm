FROM postgres:18

RUN apt-get update && apt-get install -y \
    build-essential \
    postgresql-server-dev-18 \
    libicu-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/pgbigm/pg_bigm.git /tmp/pg_bigm \
    && cd /tmp/pg_bigm \
    && make USE_PGXS=1 \
    && make USE_PGXS=1 install \
    && rm -rf /tmp/pg_bigm

# 修复目录权限
RUN mkdir -p /var/lib/postgresql \
    && chown -R postgres:postgres /var/lib/postgresql
