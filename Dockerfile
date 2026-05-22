# ── Stage 1: build pg_bigm ──────────────────────────────────────────────────
FROM postgres:18 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        postgresql-server-dev-18 \
        libicu-dev \
        git \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 https://github.com/pgbigm/pg_bigm.git /tmp/pg_bigm \
    && cd /tmp/pg_bigm \
    && make USE_PGXS=1 \
    && make USE_PGXS=1 install

# ── Stage 2: final image ─────────────────────────────────────────────────────
FROM postgres:18

COPY --from=builder \
    /usr/lib/postgresql/18/lib/pg_bigm.so \
    /usr/lib/postgresql/18/lib/

COPY --from=builder \
    /usr/share/postgresql/18/extension/pg_bigm* \
    /usr/share/postgresql/18/extension/

RUN mkdir -p /var/lib/postgresql \
    && chown -R postgres:postgres /var/lib/postgresql
