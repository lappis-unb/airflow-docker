# Ambiente Airflow do Brasil Participativo

Neste repositório estão os códigos e instruções da instalação e configuração do ambiente Airflow utilizado pelos desenvolvedores da Plataforma Brasil Participativo.

## Contribuição

Para fazer contribuições leia esse documento: [fluxo de desenvolvimento da engenharia de dados](https://gitlab.com/lappis-unb/decidimbr/ecossistemasl/-/wikis/estrutura/Engenharia-de-Dados/Fluxo%20de%20Desenvolvimento)

## Preparação e execução do Airflow

### 1. Instale o docker versão 1.29 ou maior. [link aqui](https://docs.docker.com/desktop/)

### 2. Clone este repositório no local de instalação.

```shell
git clone https://gitlab.com/lappis-unb/decidimbr/airflow-docker.git
```

### 3. Clone reposiório de DAGs e demais códigos utilizados pelo Airflow

> O repositório das DAGs deve ser baixado ao lado deste repositório aqui. Para isso retorne um nível de pastas e clone o repositório

```shell
cd .. && \
git clone https://gitlab.com/lappis-unb/decidimbr/airflow-dags.git
```

### 4. Start Airflow

```shell
cd airflow-docker && \
docker-compose up -d
```

Acesse o Airflow UI em [http://localhost:8080](http://localhost:8080)

* `user`: `airflow`
* `password`: `airflow`

## Volumes

* Os arquivos de banco ficam persistidos em `mnt/pgdata` e `mnt/minio`
* As dags devem estar em um diretório paralelo a este chamado **airflow-dags**.

Ou seja o Airflow está preparado para carregar as dags no diretório `../airflow-dags`. Se você executou corretamente o [passo 3 - clonar o repositório de dags](#3-clone-reposiório-de-dags-e-demais-códigos-utilizados-pelo-airflow), este diretório já está devidamente criado.

## Para desligar o ambiente Airflow

```shell
docker-compose down
```

## Para atualizar o ambiente docker

Caso você tenha realizado alterações no [docker-compose](docker-compose.yml) (ou em qualquer
dependência, por exemplo no [requirements.txt](requirements.txt)), será necessário reconstruir a imagem novamente executando o seguinte comando:

```shell
docker-compose build
```

---
**Have fun!**
