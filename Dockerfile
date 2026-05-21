FROM python:3.11.3-alpine
ARG TARGETARCH

RUN apk add \
    openssl \
    build-base \
    openssl-dev \
    libffi-dev \
    redis \
    postgresql-client

WORKDIR /usr/src/houdini

ENV DOCKERIZE_VERSION v0.7.0
RUN ARCH=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-$ARCH-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-$ARCH-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-$ARCH-$DOCKERIZE_VERSION.tar.gz

# 1. Copia o arquivo de texto com as dependências
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# 2. Copia TODOS os arquivos do seu GitHub (incluindo o bootstrap.py da raiz)
COPY . .

# 3. Executa o bootstrap direto da raiz /usr/src/houdini
ENTRYPOINT [ "python", "./migrate.py", "-da", "dpg-d87ig3tckfvc73c2fd70-a", "-du", "banco_do_pinguim_user", "-dp", "CkflflyZq4vs7BEjLFhDYqLHHVTr7fld", "-dn", "banco_do_pinguim" ]
