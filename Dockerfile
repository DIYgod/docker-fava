FROM python:bookworm AS build_env

WORKDIR /app

ENV PATH="/app/bin:$PATH"
RUN python3 -mvenv /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    bison flex meson ninja-build build-essential pkg-config \
    && rm -rf /var/lib/apt/lists/*

ADD requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

FROM python:slim

COPY --from=build_env /app /app

EXPOSE 5000

ENV BEANCOUNT_FILE=""

ENV FAVA_HOST="0.0.0.0"
ENV PATH="/app/bin:$PATH"

ENTRYPOINT ["fava"]