FROM debian:bookworm AS build_env

WORKDIR /app

RUN apt-get update
RUN apt-get install -y python3-babel build-essential libxml2-dev libxslt-dev curl \
        python3 libpython3-dev python3-pip git python3-venv python3-babel

ENV PATH="/app/bin:$PATH"
RUN python3 -mvenv /app

ADD requirements.txt .
RUN pip3 install -r requirements.txt

RUN pip3 uninstall -y pip
RUN find /app -name __pycache__ -exec rm -rf -v {} +

FROM gcr.io/distroless/python3-debian12

COPY --from=build_env /app /app

EXPOSE 5000

ENV BEANCOUNT_FILE=""

ENV FAVA_HOST="0.0.0.0"
ENV PATH="/app/bin:$PATH"

ENTRYPOINT ["fava"]