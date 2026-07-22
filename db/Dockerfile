FROM python:3.15.0b4-slim

# set workdir
WORKDIR /app


RUN apt update && \
    apt upgrade -y && \
    apt install -y libpq-dev gcc make && \
    pip install --upgrade pip poetry

# install requirements
COPY ./db/poetry.lock ./db/pyproject.toml ./db/Makefile /app/
RUN poetry config virtualenvs.create false
RUN make poetry:install

# bake application code into the image (dev: volume mountで上書きされる)
COPY ./db /app

CMD ["/bin/bash", "-c", "alembic upgrade head"]