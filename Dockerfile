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

# 1. Instala as dependências primeiro (bom para o cache)
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# 2. ESSA LINHA ADICIONADA COPIA TODOS OS ARQUIVOS DO SEU GITHUB PARA O CONTÊINER
COPY . .

# 3. Garante que o Python vai rodar de dentro da pasta correta
WORKDIR /usr/src/houdini/houdini

ENTRYPOINT [ "python", "./bootstrap.py" ]
