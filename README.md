# Ambiente Airflow do Brasil Participativo

Neste repositório estão os códigos e instruções da instalação e configuração do ambiente Airflow utilizado pelos desenvolvedores da Plataforma Brasil Participativo.

## Contribuição

Para fazer contribuições leia esse documento: [fluxo de desenvolvimento da engenharia de dados](https://gitlab.com/lappis-unb/decidimbr/ecossistemasl/-/wikis/estrutura/Engenharia-de-Dados/Fluxo%20de%20Desenvolvimento)


## Índice

* [1. Preparação e execução do Airflow](#1-preparação-e-execução-do-airflow)
* [2. Importando Plugins e DAGs](#2-importando-plugins-e-dags)
* [3. Executando o Airflow](#3-executando-o-airflow)
* [4. Configurações finais](#4-configurações-finais)
* [5. Acessos](#5-acessos)
* [6. Instalação de pacotes, atualizações e upgrades](#6-instalação-de-pacotes-atualizações-e-upgrades)


## 1. Preparação e execução do Airflow

### 1.1. Instalar Docker CE [aqui!](https://docs.docker.com/get-docker/)

Obs.: É necessário que o `docker-compose` tenha versão mínima `1.29`
No Ubuntu `20.04`. Abra o terminal e execute:
```shell
curl https://get.docker.com/ | bash
```

### 1.2. Clonar o repositório [airflow-docker](https://gitlab.com/lappis-unb/decidimbr/airflow-docker)

```shell
git clone https://gitlab.com/lappis-unb/decidimbr/airflow-docker.git
```

### 1.3. Variáveis de configuração do Airflow

Atualizar, se desejar, variáveis de ambiente em [.env](.env).

<!-- ### 1.4. Pasta para persistencia

É preciso c

Caso deseje pré-carregar as conexões e variáveis do Airflow no seu ambiente,
sobrescreva os arquivos [airflow-connections.json](/config/airflow-connections.json)
e [airflow-variables.json](/config/airflow-variables.json).

### 1.4.1 Docker build

Execute o seguinte comando para iniciar o Docker Compose e executar os serviços definidos 
no arquivo de configuração "init.yml". Se necessário, este comando também reconstruirá as 
imagens antes de iniciar os contêineres:

```shell
docker compose -f init.yml up --build
```

Isso garante que você tenha as versões mais recentes das imagens e que os contêineres sejam inicializados com base nessas imagens atualizadas.


Caso a imagem não esteja construída ou atualizada, você pode construí-la manualmente usando um Dockerfile.
Execute o seguinte comando para construir a imagem Docker usando o Dockerfile localizado no diretório atual
e atribuir um nome e uma tag específicos à imagem:

```shell
docker build -f ./Dockerfile -t registry.gitlab.com/lappis-unb/decidimbr/servicos-de-dados/airflow-docker ..
```

Certifique-se de ajustar o caminho do Dockerfile e o nome/tag da imagem conforme necessário.

 Antes de qualquer operação, deve ser realizado o build da imagem.
```shell
docker build -f ./Dockerfile -t registry.gitlab.com/lappis-unb/decidimbr/servicos-de-dados/airflow-docker ..
```

ou execute

```shell
docker compose -f init.yml up --build
``` 

### 1.5. Inicializar banco, variáveis e conexões Airflow

Dentro da pasta clonada (na raiz do arquivo Dockerfile), executar o
comando para gerar a estrutura do banco Postgres local e carregar conexões
e variáveis do Airflow:

```shell
# de dentro da pasta clonada `airflow-docker`
docker compose -f init.yml up
# espera concluir o processo
# Crtl+C
docker compose -f init.yml down
```

Se tudo funcionar, o output do comando acima deve ser algo semelhante à
tela a seguir:

![airflow-init](/assets/img/airflow-init.gif)

> Se o docker build retornar a mensagem `error checking context:
> 'can't stat '/home/<user-linux>/.../mnt/pgdata''.`, então executar:

```shell
sudo chown -R $USER mnt
```

A conta criada possui o usuário `airflow` e a senha `airflow` conforme
configuração em [.env](.env).

Neste momento já é possível executar o Airflow. Porém ainda é necessário
clonar mais outros repositórios, tanto os que contém **plugins** do
Airflow assim como o repositório contendo as **DAGs** de fato. -->

## 2. Importando DAGs

A partir do repositório superior ao `airflow-docker` clonado em
[1.2. clonar repositório](#12-clonar-o-repositório-airflow-docker):

```shell
git clone  https://gitlab.com/lappis-unb/decidimbr/airflow-dags.git
```

## 3. Executando o Airflow

### 3.1. Iniciar serviço

```shell
# de dentro da pasta clonada `airflow-docker`
docker compose up
```

Primeira vez que rodar o `docker compose up` o output deve ser semelhante a isso:

![airflow-1st-up](/assets/img/airflow-init.gif)

Segunda em diante o output deve ser semelhante a isso:

![airflow-n-up](/assets/img/airflow-n-up.gif)

Acesse o Airflow em [http://localhost:8080/](http://localhost:8080/)

### 3.2. Interromper serviço

```shell
# de dentro da pasta clonada `airflow-docker`
# ou na tela de logs, Ctrl+C e depois
docker-compose down
```

## 5. Acessos

### 5.1. Serviços

* `Airflow UI` em [http://localhost:8080/](http://localhost:8080/)
* `Jupyter lab` em [http://localhost:8888/lab](http://localhost:8888/lab)
* `MinIO` em [http://localhost:9001](http://localhost:9001)

### 5.2. Volumes

* Os arquivos de banco ficam persistidos em `./mnt/pgdata`
* Os arquivos de log ficam persistidos em `./mnt/logs`
* Os notebooks ficam persistidos em `./mnt/notebooks`
* Os arquivos do MinIO ficam persistidos em `./mnt/minio`
* As dags devem estar em um diretório paralelo a este chamado
  **nome-da-sua-pasta-de-dags**. Ou seja o Airflow está preparado para carregar as
  dags no diretório `../nome-da-sua-pasta-de-dags`. Se você executou corretamente
  o passo [2. Importando DAGs](#2-importando-dags), este diretório já
  está devidamente criado.
* Para editar os volumes de `DAGs`, `plugins` e outros edite o [docker-compose.yml](docker-compose.yml#L20)

## 6. Instalação de pacotes, atualizações e upgrades

### 6.1. Instalação de pacotes Python

Novas bibliotecas python podem ser instaladas adicionando o nome e versão
(obrigatório) no arquivo [requirements.txt](requirements.txt).

Para aplicar as mudanças rodar o comando de atualização da imagem em
[6.3. Atualização da imagem airflow-docker](#63-atualização-da-imagem-airflow-docker).

### 6.2. Upgrade da versão do Airflow

Atualização na versão do Airflow é realizada alterando a imagem de build
em [Dockerfile](Dockerfile#L3) conforme `tags` disponíveis em [https://hub.docker.com/r/apache/airflow](https://hub.docker.com/r/apache/airflow).

Para aplicar as mudanças rodar o comando de atualização da imagem em
[6.3. Atualização da imagem airflow-docker](#63-atualização-da-imagem-airflow-docker).

### 6.3. Atualização da imagem airflow-docker

```shell
# de dentro da pasta clonada `airflow-docker`
docker build -t registry.gitlab.com/lappis-unb/decidimbr/airflow-docker:latest .
```

ou

```shell
# de dentro da pasta clonada `airflow-docker`
docker compose up --build -d
```

<!-- ### 6.4. Atualizar banco (quando necessário)

Dependendo da atualização do Airflow, será necessário atualizar os esquemas
do banco. Para descobrir:

```shell
docker compose up
```

Se der mensagem de erro relacionada a upgrade de banco, rodar:

```shell
docker compose -f init.yml up airflow-init
``` -->

---
**Have fun!**
