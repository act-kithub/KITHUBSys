FROM python:3.12.9-slim

WORKDIR /app

# set dns
RUN echo "nameserver 8.8.8.8
nameserver 8.8.4.4" > /etc/resolv.conf

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

CMD ["/app/bot.sh"]