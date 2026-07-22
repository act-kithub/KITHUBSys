FROM python:3.15.0b4-slim

WORKDIR /app

RUN apt update && \
    apt upgrade -y && \
    apt install -y build-essential git nano curl \
    tzdata libpq-dev gcc make && \
    pip install --upgrade pip poetry

# install requirements
COPY ./discord/poetry.lock ./discord/pyproject.toml ./discord/Makefile /app/
RUN poetry config virtualenvs.create false
RUN make poetry:install

# add poetry files for symlinks
COPY ./pyproject.toml ./poetry.lock /

# bake application code into the image (dev: volume mountで上書きされる)
COPY ./discord /app
# discord/db は ../db へのsymlinkのため、実体をCOPYし直す
RUN rm -f /app/db
COPY ./db /app/db

CMD ["/app/bot.sh"]