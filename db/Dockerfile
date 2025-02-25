FROM python:3.12.9-slim

# set workdir
WORKDIR /app

# set dns
RUN echo "nameserver 8.8.8.8
nameserver 8.8.4.4" > /etc/resolv.conf

RUN apt update && \
    apt upgrade -y && \
    apt install -y libpq-dev gcc make && \
    pip install --upgrade pip poetry

# install requirements
COPY ./db/poetry.lock ./db/pyproject.toml ./db/Makefile /app/
RUN poetry config virtualenvs.create false
RUN make poetry:install

CMD ["/bin/bash", "-c", "alembic upgrade head"]